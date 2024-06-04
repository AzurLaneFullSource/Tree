local var0 = class("GuildThemePage", import("...base.GuildBasePage"))

function var0.getTargetUI(arg0)
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "GuildThemeBlueUI4Mellow", "GuildThemeRedUI4Mellow"
	else
		return "GuildThemeBlueUI", "GuildThemeRedUI"
	end
end

function var0.OnLoaded(arg0)
	arg0.top = arg0:findTF("top")
	arg0.chatBtn = arg0:findTF("chat_bg")
	arg0.chatBtnTip = arg0.chatBtn:Find("tip")
	arg0.chatBtnTipCnt = arg0.chatBtn:Find("tip/Text"):GetComponent(typeof(Text))
	arg0.chatPanel = arg0:findTF("chat_frame")
	arg0.chatCloseBtn = arg0.chatPanel:Find("close")
	arg0.bottomPanel = arg0:findTF("bottom")
	arg0.battleEvent = arg0:findTF("bottom/battle_event")
	arg0.battleEventTip = arg0.battleEvent:Find("tip")
	arg0.battleEventTipCnt = arg0.battleEventTip:Find("Text"):GetComponent(typeof(Text))
	arg0.battleReport = arg0:findTF("bottom/battle_report")
	arg0.battleReportTip = arg0.battleReport:Find("tip")
	arg0.battleReportCnt = arg0.battleReportTip:Find("Text"):GetComponent(typeof(Text))
	arg0.shopBtn = arg0:findTF("bottom/battle_shop")
	arg0.nameTxt = arg0:findTF("top/name/Text"):GetComponent(typeof(Text))
	arg0.modifyBtn = arg0:findTF("top/name")
	arg0.levelImg = arg0:findTF("top/level/Text"):GetComponent(typeof(Text))
	arg0.factionTxt = arg0:findTF("top/policy/label"):GetComponent(typeof(Text))
	arg0.policyTxt = arg0:findTF("top/policy/Text"):GetComponent(typeof(Text))
	arg0.idTxt = arg0:findTF("top/id/Text"):GetComponent(typeof(Text))
	arg0.numberTxt = arg0:findTF("top/id/number"):GetComponent(typeof(Text))
	arg0.expImg = arg0:findTF("top/exp/bar")
	arg0.levelTxt = arg0:findTF("top/exp/lv/Text"):GetComponent(typeof(Text))

	local var0 = 300

	arg0.topPanelWidth = arg0.top.rect.height
	arg0.bottomPanelWidth = -165
	arg0.chatPanelWidth = arg0.chatPanel.rect.width + var0
	arg0.chatBtnWidth = arg0.chatBtn.rect.width + var0

	setAnchoredPosition(arg0.chatPanel, {
		x = arg0.chatPanelWidth
	})
	setAnchoredPosition(arg0.chatBtn, {
		x = 0
	})

	arg0.modifyPage = GuildModifitonPage.New(arg0._tf, arg0.event)
	arg0.chatBubbles = {}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.battleEvent, function()
		local var0 = arg0.contextData.toggles[GuildMainScene.TOGGLE_TAG[6]]

		triggerToggle(var0, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.battleReport, function()
		arg0:emit(GuildMainMediator.OPEN_EVENT_REPORT)
	end, SFX_PANEL)
	onButton(arg0, arg0.shopBtn, function()
		arg0:emit(GuildMainMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.chatBtn, function()
		arg0:InitChatWindow()
		arg0:ShowOrHideChatWindow(true)
	end, SFX_PANEL)
	onButton(arg0, arg0.chatCloseBtn, function()
		getProxy(GuildProxy):ClearNewChatMsgCnt()
		arg0:UpdateChatBtn()
		arg0:ShowOrHideChatWindow(false)
	end, SFX_PANEL)
	onButton(arg0, arg0.modifyBtn, function()
		arg0.modifyPage:ExecuteAction("Show", arg0.guildVO, arg0.playerVO)
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0:UpdateData(arg1, arg2, arg3)
	arg0:UpdateMainInfo()
	arg0:UpdateChatBtn()
	arg0:UpdateBattleBtn()
	arg0:Show()
end

function var0.ResUISettings(arg0)
	return {
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0.UpdateData(arg0, arg1, arg2, arg3)
	arg0:UpdateGuild(arg1)

	arg0.playerVO = arg2
	arg0.chatMsgs = arg3
	arg0.isAdmin = arg1:IsAdministrator()
end

function var0.UpdateGuild(arg0, arg1)
	arg0.guildVO = arg1
end

function var0.RefreshReportBtn(arg0)
	arg0:UpdateBattleBtn()
end

function var0.UpdateBattleBtn(arg0)
	local var0 = getProxy(GuildProxy):GetReports()

	setActive(arg0.battleEvent, arg0.guildVO:GetActiveEvent() ~= nil)
	setActive(arg0.battleEventTip, false)

	local var1 = arg0.guildVO:getMemberById(arg0.playerVO.id)
	local var2 = _.select(_.values(var0), function(arg0)
		return arg0:CanSubmit()
	end)
	local var3 = #var2 > 0 and not var1:IsRecruit()

	setActive(arg0.battleReport, var3)
	setActive(arg0.battleReportTip, var3)

	if var3 then
		arg0.battleReportCnt.text = #var2
	end
end

function var0.UpdateChatBtn(arg0)
	local var0 = getProxy(GuildProxy):GetNewChatMsgCnt()
	local var1 = var0 > 0

	setActive(arg0.chatBtnTip, var1)

	if var1 then
		arg0.chatBtnTipCnt.text = var0
	end
end

function var0.InitChatWindow(arg0)
	if arg0.isInitChatWindow then
		return
	end

	arg0.isInitChatWindow = true
	arg0.noticeTxt = arg0.chatPanel:Find("log/notice/InputField"):GetComponent(typeof(InputField))
	arg0.noticeMask = arg0.chatPanel:Find("log/notice/mask")
	arg0.noticeScrollTxt = arg0.chatPanel:Find("log/notice/mask/label"):GetComponent(typeof(ScrollText))
	arg0.logContent = arg0.chatPanel:Find("log/content/viewport/list")
	arg0.prefabPublic = arg0:getTpl("tpl", arg0.logContent)
	arg0.chatRect = arg0.chatPanel:Find("bottom/list")
	arg0.chatContent = arg0.chatPanel:Find("bottom/list/content")
	arg0.prefabOthers = arg0.chatPanel:Find("bottom/list/popo_other")
	arg0.prefabSelf = arg0.chatPanel:Find("bottom/list/popo_self")
	arg0.prefabWorldboss = arg0.chatPanel:Find("bottom/list/popo_worldboss")
	arg0.sendBtn = arg0.chatPanel:Find("bottom/bottom/send")
	arg0.msgInput = arg0.chatPanel:Find("bottom/bottom/input"):GetComponent(typeof(InputField))
	arg0.emojiBtn = arg0.chatPanel:Find("bottom/bottom/emoji")
	arg0.newMsgTip = arg0.chatPanel:Find("bottom/bottom/tip")

	onButton(arg0, arg0.sendBtn, function()
		local var0 = arg0.msgInput.text

		if wordVer(var0) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("playerinfo_mask_word"))

			return
		end

		if var0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_msg_is_null"))

			return
		end

		if arg0.chatTimer and pg.TimeMgr.GetInstance():GetServerTime() - arg0.chatTimer < 5 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dont_send_message_frequently"))

			return
		end

		arg0.chatTimer = pg.TimeMgr.GetInstance():GetServerTime()

		arg0:emit(GuildMainMediator.SEND_MSG, var0)

		arg0.msgInput.text = ""
	end, SFX_PANEL)
	onButton(arg0, arg0.emojiBtn, function()
		local var0 = arg0.emojiBtn.position

		arg0:emit(GuildMainMediator.OPEN_EMOJI, Vector3(var0.x, var0.y, 0), function(arg0)
			arg0:emit(GuildMainMediator.SEND_MSG, string.gsub(ChatConst.EmojiCode, "code", arg0))
		end)
	end, SFX_PANEL)
	GetOrAddComponent(arg0.chatRect, typeof(EventTriggerListener)):AddDragEndFunc(function(arg0, arg1)
		if GetComponent(arg0.chatRect, typeof(ScrollRect)).normalizedPosition.y <= 0.1 then
			arg0:ClearChatTip()
		end
	end)
	arg0:UpdateChatWindow()

	if arg0.isAdmin then
		onInputEndEdit(arg0, arg0.noticeTxt.gameObject, function()
			local var0 = arg0.guildVO:GetAnnounce() or ""
			local var1 = getInputText(arg0.noticeTxt.gameObject)

			if var1 == "" or var1 == var0 then
				return
			end

			if wordVer(var1) > 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("playerinfo_mask_word"))
				setInputText(arg0.noticeTxt.gameObject, "")

				return
			end

			arg0.noticeScrollTxt:SetText(var1)
			arg0:emit(GuildMainMediator.MODIFY, 5, 0, var1)
			setInputText(arg0.noticeTxt.gameObject, "")
		end)
	end

	setButtonEnabled(arg0.noticeMask, arg0.isAdmin)
end

function var0.UpdateChatWindow(arg0)
	local var0 = arg0.guildVO

	arg0:UpdateNotice()

	local var1 = var0.logInfo

	arg0:UpdateAllLog(var1)

	local var2 = arg0.chatMsgs

	arg0:UpdateAllChat(var2)
end

function var0.UpdateNotice(arg0)
	local var0 = arg0.guildVO:GetAnnounce()
	local var1 = (not var0 or var0 == "") and i18n("guild_not_exist_notifycation") or var0

	arg0.noticeScrollTxt:SetText(var1)
end

function var0.UpdateAllLog(arg0, arg1)
	removeAllChildren(arg0.logContent)

	for iter0, iter1 in ipairs(arg1) do
		arg0:AppendLog(iter1)
	end
end

function var0.AppendLog(arg0, arg1, arg2)
	if not arg0.isInitChatWindow then
		return
	end

	if arg0.logContent.childCount >= 200 then
		arg0:emit(GuildMainMediator.ON_REBUILD_LOG_ALL)
	else
		local var0 = cloneTplTo(arg0.prefabPublic, arg0.logContent)

		if arg2 then
			var0:SetAsFirstSibling()
		end

		local var1 = var0:Find("text"):GetComponent("RichText")
		local var2 = var0:Find("time"):GetComponent(typeof(Text))
		local var3, var4 = arg1:getConent()

		if arg1.cmd == GuildLogInfo.CMD_TYPE_GET_SHIP then
			ChatProxy.InjectPublic(var1, var3, true)
		else
			var1.text = var3
		end

		var2.text = var4
	end
end

function var0.UpdateAllChat(arg0, arg1)
	local var0 = arg1 or {}

	removeAllChildren(arg0.chatContent)

	local var1 = {}

	arg0.index = math.max(1, #var0 - GuildConst.CHAT_LOG_MAX_COUNT)

	for iter0 = arg0.index, #var0 do
		table.insert(var1, function(arg0)
			arg0:Append(var0[iter0], -1, true)
			arg0()
		end)
	end

	seriesAsync(var1, function()
		Timer.New(function()
			if not IsNil(arg0.chatContent) then
				scrollToBottom(arg0.chatContent.parent)
			end
		end, 0.5, 1):Start()
	end)
end

function var0.Append(arg0, arg1, arg2, arg3)
	arg0:UpdateChatBtn()

	if not arg0.isInitChatWindow then
		return
	end

	if arg0.chatContent.childCount >= GuildConst.CHAT_LOG_MAX_COUNT * 2 then
		arg0:emit(GuildMainMediator.REBUILD_ALL)
	elseif arg1.id and arg1.id == 4 then
		arg0:AddWorldBossMsg(arg1, arg2, arg3)
	else
		arg0:AppendWorld(arg1, arg2, arg3)
	end
end

function var0.ShowChatTip(arg0)
	setActive(arg0.newMsgTip, true)
end

function var0.ClearChatTip(arg0)
	setActive(arg0.newMsgTip, false)
end

function var0.AddWorldBossMsg(arg0, arg1, arg2, arg3)
	local var0 = Clone(arg1)
	local var1 = var0.player

	if not arg3 then
		arg0:ShowChatTip()
	end

	local var2 = cloneTplTo(arg0.prefabWorldboss, arg0.chatContent)
	local var3 = ChatBubbleWorldBoss.New(var2)

	if arg2 >= 0 then
		var3.tf:SetSiblingIndex(arg2)
	end

	var3:update(var0)
	table.insert(arg0.chatBubbles, var3)
end

function var0.AppendWorld(arg0, arg1, arg2, arg3)
	local var0 = Clone(arg1)
	local var1 = var0.player
	local var2 = arg0.prefabOthers

	if var1.id == arg0.playerVO.id then
		var2 = arg0.prefabSelf
		var0.player = setmetatable(Clone(arg0.playerVO), {
			__index = var0.player
		})
	elseif not arg3 then
		arg0:ShowChatTip()
	end

	local var3 = cloneTplTo(var2, arg0.chatContent)
	local var4 = GuildChatBubble.New(var3)

	if arg2 >= 0 then
		var4.tf:SetSiblingIndex(arg2)
	end

	var0.isSelf = var1.id == arg0.playerVO.id

	var4:update(var0)

	if not arg3 and var0.isSelf then
		onNextTick(function()
			scrollToBottom(arg0.chatContent.parent)
		end)
	end

	table.insert(arg0.chatBubbles, var4)
end

function var0.UpdateMainInfo(arg0)
	local var0 = arg0.guildVO

	arg0.nameTxt.text = var0:getName()
	arg0.factionTxt.text = var0:getFactionName()
	arg0.policyTxt.text = var0:getPolicyName()
	arg0.idTxt.text = "ID:" .. var0.id
	arg0.numberTxt.text = var0.memberCount .. "/" .. var0:getMaxMember()

	setFillAmount(arg0.expImg, var0.exp / math.max(var0:getLevelMaxExp(), 1))

	arg0.levelTxt.text = var0.level <= 9 and "0" .. var0.level or var0.level

	local var1 = ""
	local var2 = ""
	local var3 = math.floor(var0.level / 10)

	for iter0 = 1, var3 do
		var2 = var2 .. ":"
	end

	local var4 = var0.level % 10
	local var5 = var2 .. (var4 == 0 and "" or var4)

	arg0.levelImg.text = var5

	if arg0.isInitChatWindow then
		arg0:UpdateNotice()
	end
end

function var0.ShowOrHideChatWindow(arg0, arg1)
	if LeanTween.isTweening(go(arg0.chatPanel)) then
		return
	end

	local var0
	local var1
	local var2
	local var3

	if not arg1 then
		var0, var1 = 0, arg0.chatPanelWidth
		var2, var3 = arg0.chatBtnWidth, 0
	else
		var0, var1 = arg0.chatPanelWidth, 0
		var2, var3 = 0, arg0.chatBtnWidth
	end

	arg0.isShowChatWindow = arg1

	local function var4()
		if arg1 then
			setParent(arg0.chatPanel, pg.UIMgr:GetInstance().OverlayMain, true)

			local var0 = arg0.chatPanel.localPosition

			arg0.chatPanel.localPosition = Vector3(var0.x, var0.y, 0)

			pg.UIMgr.GetInstance():OverlayPanelPB(arg0.chatPanel, {
				pbList = {
					arg0.chatPanel
				}
			})

			arg0.chatPanelAnchoredPositionX = arg0.chatPanel.anchoredPosition.x
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0.chatPanel, arg0._tf)
		end
	end

	LeanTween.value(go(arg0.chatPanel), var0, var1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.chatPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(var4))
	LeanTween.value(go(arg0.chatBtn), var2, var3, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.chatBtn, {
			x = arg0
		})
	end))
end

function var0.EnterOrExitPreView(arg0, arg1)
	if LeanTween.isTweening(go(arg0.top)) or LeanTween.isTweening(go(arg0.bottomPanel)) or LeanTween.isTweening(go(arg0.chatPanel)) or LeanTween.isTweening(go(arg0.chatBtn)) then
		return
	end

	local var0 = arg1 and {
		0,
		arg0.topPanelWidth
	} or {
		arg0.topPanelWidth,
		0
	}

	LeanTween.value(go(arg0.top), var0[1], var0[2], 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.top, {
			y = arg0
		})
	end))

	local var1 = arg1 and {
		94,
		94 + arg0.bottomPanelWidth
	} or {
		94 + arg0.bottomPanelWidth,
		94
	}

	LeanTween.value(go(arg0.bottomPanel), var1[1], var1[2], 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.bottomPanel, {
			y = arg0
		})
	end))

	if arg0.isShowChatWindow then
		local var2 = arg1 and {
			0,
			arg0.chatPanelWidth
		} or {
			arg0.chatPanelWidth,
			arg0.chatPanelAnchoredPositionX or 0
		}

		LeanTween.value(go(arg0.chatPanel), var2[1], var2[2], 0.3):setOnUpdate(System.Action_float(function(arg0)
			setAnchoredPosition(arg0.chatPanel, {
				x = arg0
			})
		end))
	else
		local var3 = arg1 and {
			0,
			arg0.chatBtnWidth
		} or {
			arg0.chatBtnWidth,
			0
		}

		LeanTween.value(go(arg0.chatBtn), var3[1], var3[2], 0.3):setOnUpdate(System.Action_float(function(arg0)
			setAnchoredPosition(arg0.chatBtn, {
				x = arg0
			})
		end))
	end
end

function var0.InsertEmojiToInputText(arg0, arg1)
	arg0.msgInput.text = arg0.msgInput.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg1)
end

function var0.OnDestroy(arg0)
	if arg0.isShowChatWindow then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.chatPanel, arg0._tf)
	end

	if LeanTween.isTweening(go(arg0.chatPanel)) then
		LeanTween.cancel(go(arg0.chatPanel))
	end

	if LeanTween.isTweening(go(arg0.chatBtn)) then
		LeanTween.cancel(go(arg0.chatBtn))
	end

	arg0.modifyPage:Destroy()

	for iter0, iter1 in ipairs(arg0.chatBubbles) do
		if iter1 then
			iter1:dispose()
		end
	end

	arg0.chatBubbles = nil

	arg0:Hide()
end

return var0
