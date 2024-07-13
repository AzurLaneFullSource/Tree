local var0_0 = class("GuildThemePage", import("...base.GuildBasePage"))

function var0_0.getTargetUI(arg0_1)
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "GuildThemeBlueUI4Mellow", "GuildThemeRedUI4Mellow"
	else
		return "GuildThemeBlueUI", "GuildThemeRedUI"
	end
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.top = arg0_2:findTF("top")
	arg0_2.chatBtn = arg0_2:findTF("chat_bg")
	arg0_2.chatBtnTip = arg0_2.chatBtn:Find("tip")
	arg0_2.chatBtnTipCnt = arg0_2.chatBtn:Find("tip/Text"):GetComponent(typeof(Text))
	arg0_2.chatPanel = arg0_2:findTF("chat_frame")
	arg0_2.chatCloseBtn = arg0_2.chatPanel:Find("close")
	arg0_2.bottomPanel = arg0_2:findTF("bottom")
	arg0_2.battleEvent = arg0_2:findTF("bottom/battle_event")
	arg0_2.battleEventTip = arg0_2.battleEvent:Find("tip")
	arg0_2.battleEventTipCnt = arg0_2.battleEventTip:Find("Text"):GetComponent(typeof(Text))
	arg0_2.battleReport = arg0_2:findTF("bottom/battle_report")
	arg0_2.battleReportTip = arg0_2.battleReport:Find("tip")
	arg0_2.battleReportCnt = arg0_2.battleReportTip:Find("Text"):GetComponent(typeof(Text))
	arg0_2.shopBtn = arg0_2:findTF("bottom/battle_shop")
	arg0_2.nameTxt = arg0_2:findTF("top/name/Text"):GetComponent(typeof(Text))
	arg0_2.modifyBtn = arg0_2:findTF("top/name")
	arg0_2.levelImg = arg0_2:findTF("top/level/Text"):GetComponent(typeof(Text))
	arg0_2.factionTxt = arg0_2:findTF("top/policy/label"):GetComponent(typeof(Text))
	arg0_2.policyTxt = arg0_2:findTF("top/policy/Text"):GetComponent(typeof(Text))
	arg0_2.idTxt = arg0_2:findTF("top/id/Text"):GetComponent(typeof(Text))
	arg0_2.numberTxt = arg0_2:findTF("top/id/number"):GetComponent(typeof(Text))
	arg0_2.expImg = arg0_2:findTF("top/exp/bar")
	arg0_2.levelTxt = arg0_2:findTF("top/exp/lv/Text"):GetComponent(typeof(Text))

	local var0_2 = 300

	arg0_2.topPanelWidth = arg0_2.top.rect.height
	arg0_2.bottomPanelWidth = -165
	arg0_2.chatPanelWidth = arg0_2.chatPanel.rect.width + var0_2
	arg0_2.chatBtnWidth = arg0_2.chatBtn.rect.width + var0_2

	setAnchoredPosition(arg0_2.chatPanel, {
		x = arg0_2.chatPanelWidth
	})
	setAnchoredPosition(arg0_2.chatBtn, {
		x = 0
	})

	arg0_2.modifyPage = GuildModifitonPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.chatBubbles = {}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.battleEvent, function()
		local var0_4 = arg0_3.contextData.toggles[GuildMainScene.TOGGLE_TAG[6]]

		triggerToggle(var0_4, true)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.battleReport, function()
		arg0_3:emit(GuildMainMediator.OPEN_EVENT_REPORT)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.shopBtn, function()
		arg0_3:emit(GuildMainMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.chatBtn, function()
		arg0_3:InitChatWindow()
		arg0_3:ShowOrHideChatWindow(true)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.chatCloseBtn, function()
		getProxy(GuildProxy):ClearNewChatMsgCnt()
		arg0_3:UpdateChatBtn()
		arg0_3:ShowOrHideChatWindow(false)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.modifyBtn, function()
		arg0_3.modifyPage:ExecuteAction("Show", arg0_3.guildVO, arg0_3.playerVO)
	end, SFX_PANEL)
end

function var0_0.Update(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10:UpdateData(arg1_10, arg2_10, arg3_10)
	arg0_10:UpdateMainInfo()
	arg0_10:UpdateChatBtn()
	arg0_10:UpdateBattleBtn()
	arg0_10:Show()
end

function var0_0.ResUISettings(arg0_11)
	return {
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0_0.UpdateData(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12:UpdateGuild(arg1_12)

	arg0_12.playerVO = arg2_12
	arg0_12.chatMsgs = arg3_12
	arg0_12.isAdmin = arg1_12:IsAdministrator()
end

function var0_0.UpdateGuild(arg0_13, arg1_13)
	arg0_13.guildVO = arg1_13
end

function var0_0.RefreshReportBtn(arg0_14)
	arg0_14:UpdateBattleBtn()
end

function var0_0.UpdateBattleBtn(arg0_15)
	local var0_15 = getProxy(GuildProxy):GetReports()

	setActive(arg0_15.battleEvent, arg0_15.guildVO:GetActiveEvent() ~= nil)
	setActive(arg0_15.battleEventTip, false)

	local var1_15 = arg0_15.guildVO:getMemberById(arg0_15.playerVO.id)
	local var2_15 = _.select(_.values(var0_15), function(arg0_16)
		return arg0_16:CanSubmit()
	end)
	local var3_15 = #var2_15 > 0 and not var1_15:IsRecruit()

	setActive(arg0_15.battleReport, var3_15)
	setActive(arg0_15.battleReportTip, var3_15)

	if var3_15 then
		arg0_15.battleReportCnt.text = #var2_15
	end
end

function var0_0.UpdateChatBtn(arg0_17)
	local var0_17 = getProxy(GuildProxy):GetNewChatMsgCnt()
	local var1_17 = var0_17 > 0

	setActive(arg0_17.chatBtnTip, var1_17)

	if var1_17 then
		arg0_17.chatBtnTipCnt.text = var0_17
	end
end

function var0_0.InitChatWindow(arg0_18)
	if arg0_18.isInitChatWindow then
		return
	end

	arg0_18.isInitChatWindow = true
	arg0_18.noticeTxt = arg0_18.chatPanel:Find("log/notice/InputField"):GetComponent(typeof(InputField))
	arg0_18.noticeMask = arg0_18.chatPanel:Find("log/notice/mask")
	arg0_18.noticeScrollTxt = arg0_18.chatPanel:Find("log/notice/mask/label"):GetComponent(typeof(ScrollText))
	arg0_18.logContent = arg0_18.chatPanel:Find("log/content/viewport/list")
	arg0_18.prefabPublic = arg0_18:getTpl("tpl", arg0_18.logContent)
	arg0_18.chatRect = arg0_18.chatPanel:Find("bottom/list")
	arg0_18.chatContent = arg0_18.chatPanel:Find("bottom/list/content")
	arg0_18.prefabOthers = arg0_18.chatPanel:Find("bottom/list/popo_other")
	arg0_18.prefabSelf = arg0_18.chatPanel:Find("bottom/list/popo_self")
	arg0_18.prefabWorldboss = arg0_18.chatPanel:Find("bottom/list/popo_worldboss")
	arg0_18.sendBtn = arg0_18.chatPanel:Find("bottom/bottom/send")
	arg0_18.msgInput = arg0_18.chatPanel:Find("bottom/bottom/input"):GetComponent(typeof(InputField))
	arg0_18.emojiBtn = arg0_18.chatPanel:Find("bottom/bottom/emoji")
	arg0_18.newMsgTip = arg0_18.chatPanel:Find("bottom/bottom/tip")

	onButton(arg0_18, arg0_18.sendBtn, function()
		local var0_19 = arg0_18.msgInput.text

		if wordVer(var0_19) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("playerinfo_mask_word"))

			return
		end

		if var0_19 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_msg_is_null"))

			return
		end

		if arg0_18.chatTimer and pg.TimeMgr.GetInstance():GetServerTime() - arg0_18.chatTimer < 5 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dont_send_message_frequently"))

			return
		end

		arg0_18.chatTimer = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_18:emit(GuildMainMediator.SEND_MSG, var0_19)

		arg0_18.msgInput.text = ""
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.emojiBtn, function()
		local var0_20 = arg0_18.emojiBtn.position

		arg0_18:emit(GuildMainMediator.OPEN_EMOJI, Vector3(var0_20.x, var0_20.y, 0), function(arg0_21)
			arg0_18:emit(GuildMainMediator.SEND_MSG, string.gsub(ChatConst.EmojiCode, "code", arg0_21))
		end)
	end, SFX_PANEL)
	GetOrAddComponent(arg0_18.chatRect, typeof(EventTriggerListener)):AddDragEndFunc(function(arg0_22, arg1_22)
		if GetComponent(arg0_18.chatRect, typeof(ScrollRect)).normalizedPosition.y <= 0.1 then
			arg0_18:ClearChatTip()
		end
	end)
	arg0_18:UpdateChatWindow()

	if arg0_18.isAdmin then
		onInputEndEdit(arg0_18, arg0_18.noticeTxt.gameObject, function()
			local var0_23 = arg0_18.guildVO:GetAnnounce() or ""
			local var1_23 = getInputText(arg0_18.noticeTxt.gameObject)

			if var1_23 == "" or var1_23 == var0_23 then
				return
			end

			if wordVer(var1_23) > 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("playerinfo_mask_word"))
				setInputText(arg0_18.noticeTxt.gameObject, "")

				return
			end

			arg0_18.noticeScrollTxt:SetText(var1_23)
			arg0_18:emit(GuildMainMediator.MODIFY, 5, 0, var1_23)
			setInputText(arg0_18.noticeTxt.gameObject, "")
		end)
	end

	setButtonEnabled(arg0_18.noticeMask, arg0_18.isAdmin)
end

function var0_0.UpdateChatWindow(arg0_24)
	local var0_24 = arg0_24.guildVO

	arg0_24:UpdateNotice()

	local var1_24 = var0_24.logInfo

	arg0_24:UpdateAllLog(var1_24)

	local var2_24 = arg0_24.chatMsgs

	arg0_24:UpdateAllChat(var2_24)
end

function var0_0.UpdateNotice(arg0_25)
	local var0_25 = arg0_25.guildVO:GetAnnounce()
	local var1_25 = (not var0_25 or var0_25 == "") and i18n("guild_not_exist_notifycation") or var0_25

	arg0_25.noticeScrollTxt:SetText(var1_25)
end

function var0_0.UpdateAllLog(arg0_26, arg1_26)
	removeAllChildren(arg0_26.logContent)

	for iter0_26, iter1_26 in ipairs(arg1_26) do
		arg0_26:AppendLog(iter1_26)
	end
end

function var0_0.AppendLog(arg0_27, arg1_27, arg2_27)
	if not arg0_27.isInitChatWindow then
		return
	end

	if arg0_27.logContent.childCount >= 200 then
		arg0_27:emit(GuildMainMediator.ON_REBUILD_LOG_ALL)
	else
		local var0_27 = cloneTplTo(arg0_27.prefabPublic, arg0_27.logContent)

		if arg2_27 then
			var0_27:SetAsFirstSibling()
		end

		local var1_27 = var0_27:Find("text"):GetComponent("RichText")
		local var2_27 = var0_27:Find("time"):GetComponent(typeof(Text))
		local var3_27, var4_27 = arg1_27:getConent()

		if arg1_27.cmd == GuildLogInfo.CMD_TYPE_GET_SHIP then
			ChatProxy.InjectPublic(var1_27, var3_27, true)
		else
			var1_27.text = var3_27
		end

		var2_27.text = var4_27
	end
end

function var0_0.UpdateAllChat(arg0_28, arg1_28)
	local var0_28 = arg1_28 or {}

	removeAllChildren(arg0_28.chatContent)

	local var1_28 = {}

	arg0_28.index = math.max(1, #var0_28 - GuildConst.CHAT_LOG_MAX_COUNT)

	for iter0_28 = arg0_28.index, #var0_28 do
		table.insert(var1_28, function(arg0_29)
			arg0_28:Append(var0_28[iter0_28], -1, true)
			arg0_29()
		end)
	end

	seriesAsync(var1_28, function()
		Timer.New(function()
			if not IsNil(arg0_28.chatContent) then
				scrollToBottom(arg0_28.chatContent.parent)
			end
		end, 0.5, 1):Start()
	end)
end

function var0_0.Append(arg0_32, arg1_32, arg2_32, arg3_32)
	arg0_32:UpdateChatBtn()

	if not arg0_32.isInitChatWindow then
		return
	end

	if arg0_32.chatContent.childCount >= GuildConst.CHAT_LOG_MAX_COUNT * 2 then
		arg0_32:emit(GuildMainMediator.REBUILD_ALL)
	elseif arg1_32.id and arg1_32.id == 4 then
		arg0_32:AddWorldBossMsg(arg1_32, arg2_32, arg3_32)
	else
		arg0_32:AppendWorld(arg1_32, arg2_32, arg3_32)
	end
end

function var0_0.ShowChatTip(arg0_33)
	setActive(arg0_33.newMsgTip, true)
end

function var0_0.ClearChatTip(arg0_34)
	setActive(arg0_34.newMsgTip, false)
end

function var0_0.AddWorldBossMsg(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = Clone(arg1_35)
	local var1_35 = var0_35.player

	if not arg3_35 then
		arg0_35:ShowChatTip()
	end

	local var2_35 = cloneTplTo(arg0_35.prefabWorldboss, arg0_35.chatContent)
	local var3_35 = ChatBubbleWorldBoss.New(var2_35)

	if arg2_35 >= 0 then
		var3_35.tf:SetSiblingIndex(arg2_35)
	end

	var3_35:update(var0_35)
	table.insert(arg0_35.chatBubbles, var3_35)
end

function var0_0.AppendWorld(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = Clone(arg1_36)
	local var1_36 = var0_36.player
	local var2_36 = arg0_36.prefabOthers

	if var1_36.id == arg0_36.playerVO.id then
		var2_36 = arg0_36.prefabSelf
		var0_36.player = setmetatable(Clone(arg0_36.playerVO), {
			__index = var0_36.player
		})
	elseif not arg3_36 then
		arg0_36:ShowChatTip()
	end

	local var3_36 = cloneTplTo(var2_36, arg0_36.chatContent)
	local var4_36 = GuildChatBubble.New(var3_36)

	if arg2_36 >= 0 then
		var4_36.tf:SetSiblingIndex(arg2_36)
	end

	var0_36.isSelf = var1_36.id == arg0_36.playerVO.id

	var4_36:update(var0_36)

	if not arg3_36 and var0_36.isSelf then
		onNextTick(function()
			scrollToBottom(arg0_36.chatContent.parent)
		end)
	end

	table.insert(arg0_36.chatBubbles, var4_36)
end

function var0_0.UpdateMainInfo(arg0_38)
	local var0_38 = arg0_38.guildVO

	arg0_38.nameTxt.text = var0_38:getName()
	arg0_38.factionTxt.text = var0_38:getFactionName()
	arg0_38.policyTxt.text = var0_38:getPolicyName()
	arg0_38.idTxt.text = "ID:" .. var0_38.id
	arg0_38.numberTxt.text = var0_38.memberCount .. "/" .. var0_38:getMaxMember()

	setFillAmount(arg0_38.expImg, var0_38.exp / math.max(var0_38:getLevelMaxExp(), 1))

	arg0_38.levelTxt.text = var0_38.level <= 9 and "0" .. var0_38.level or var0_38.level

	local var1_38 = ""
	local var2_38 = ""
	local var3_38 = math.floor(var0_38.level / 10)

	for iter0_38 = 1, var3_38 do
		var2_38 = var2_38 .. ":"
	end

	local var4_38 = var0_38.level % 10
	local var5_38 = var2_38 .. (var4_38 == 0 and "" or var4_38)

	arg0_38.levelImg.text = var5_38

	if arg0_38.isInitChatWindow then
		arg0_38:UpdateNotice()
	end
end

function var0_0.ShowOrHideChatWindow(arg0_39, arg1_39)
	if LeanTween.isTweening(go(arg0_39.chatPanel)) then
		return
	end

	local var0_39
	local var1_39
	local var2_39
	local var3_39

	if not arg1_39 then
		var0_39, var1_39 = 0, arg0_39.chatPanelWidth
		var2_39, var3_39 = arg0_39.chatBtnWidth, 0
	else
		var0_39, var1_39 = arg0_39.chatPanelWidth, 0
		var2_39, var3_39 = 0, arg0_39.chatBtnWidth
	end

	arg0_39.isShowChatWindow = arg1_39

	local function var4_39()
		if arg1_39 then
			setParent(arg0_39.chatPanel, pg.UIMgr:GetInstance().OverlayMain, true)

			local var0_40 = arg0_39.chatPanel.localPosition

			arg0_39.chatPanel.localPosition = Vector3(var0_40.x, var0_40.y, 0)

			pg.UIMgr.GetInstance():OverlayPanelPB(arg0_39.chatPanel, {
				pbList = {
					arg0_39.chatPanel
				}
			})

			arg0_39.chatPanelAnchoredPositionX = arg0_39.chatPanel.anchoredPosition.x
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_39.chatPanel, arg0_39._tf)
		end
	end

	LeanTween.value(go(arg0_39.chatPanel), var0_39, var1_39, 0.3):setOnUpdate(System.Action_float(function(arg0_41)
		setAnchoredPosition(arg0_39.chatPanel, {
			x = arg0_41
		})
	end)):setOnComplete(System.Action(var4_39))
	LeanTween.value(go(arg0_39.chatBtn), var2_39, var3_39, 0.3):setOnUpdate(System.Action_float(function(arg0_42)
		setAnchoredPosition(arg0_39.chatBtn, {
			x = arg0_42
		})
	end))
end

function var0_0.EnterOrExitPreView(arg0_43, arg1_43)
	if LeanTween.isTweening(go(arg0_43.top)) or LeanTween.isTweening(go(arg0_43.bottomPanel)) or LeanTween.isTweening(go(arg0_43.chatPanel)) or LeanTween.isTweening(go(arg0_43.chatBtn)) then
		return
	end

	local var0_43 = arg1_43 and {
		0,
		arg0_43.topPanelWidth
	} or {
		arg0_43.topPanelWidth,
		0
	}

	LeanTween.value(go(arg0_43.top), var0_43[1], var0_43[2], 0.3):setOnUpdate(System.Action_float(function(arg0_44)
		setAnchoredPosition(arg0_43.top, {
			y = arg0_44
		})
	end))

	local var1_43 = arg1_43 and {
		94,
		94 + arg0_43.bottomPanelWidth
	} or {
		94 + arg0_43.bottomPanelWidth,
		94
	}

	LeanTween.value(go(arg0_43.bottomPanel), var1_43[1], var1_43[2], 0.3):setOnUpdate(System.Action_float(function(arg0_45)
		setAnchoredPosition(arg0_43.bottomPanel, {
			y = arg0_45
		})
	end))

	if arg0_43.isShowChatWindow then
		local var2_43 = arg1_43 and {
			0,
			arg0_43.chatPanelWidth
		} or {
			arg0_43.chatPanelWidth,
			arg0_43.chatPanelAnchoredPositionX or 0
		}

		LeanTween.value(go(arg0_43.chatPanel), var2_43[1], var2_43[2], 0.3):setOnUpdate(System.Action_float(function(arg0_46)
			setAnchoredPosition(arg0_43.chatPanel, {
				x = arg0_46
			})
		end))
	else
		local var3_43 = arg1_43 and {
			0,
			arg0_43.chatBtnWidth
		} or {
			arg0_43.chatBtnWidth,
			0
		}

		LeanTween.value(go(arg0_43.chatBtn), var3_43[1], var3_43[2], 0.3):setOnUpdate(System.Action_float(function(arg0_47)
			setAnchoredPosition(arg0_43.chatBtn, {
				x = arg0_47
			})
		end))
	end
end

function var0_0.InsertEmojiToInputText(arg0_48, arg1_48)
	arg0_48.msgInput.text = arg0_48.msgInput.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg1_48)
end

function var0_0.OnDestroy(arg0_49)
	if arg0_49.isShowChatWindow then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_49.chatPanel, arg0_49._tf)
	end

	if LeanTween.isTweening(go(arg0_49.chatPanel)) then
		LeanTween.cancel(go(arg0_49.chatPanel))
	end

	if LeanTween.isTweening(go(arg0_49.chatBtn)) then
		LeanTween.cancel(go(arg0_49.chatBtn))
	end

	arg0_49.modifyPage:Destroy()

	for iter0_49, iter1_49 in ipairs(arg0_49.chatBubbles) do
		if iter1_49 then
			iter1_49:dispose()
		end
	end

	arg0_49.chatBubbles = nil

	arg0_49:Hide()
end

return var0_0
