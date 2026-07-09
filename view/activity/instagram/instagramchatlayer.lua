local var0_0 = class("InstagramChatLayer", import("...base.BaseUI"))
local var1_0 = pg.activity_ins_ship_group_template
local var2_0 = pg.activity_ins_redpackage
local var3_0 = pg.emoji_template

function var0_0.getUIName(arg0_1)
	return "InstagramChatUI"
end

function var0_0.getGroupName(arg0_2)
	return "InstagramMainUI"
end

var0_0.ReadType = {
	"all",
	"hasReaded",
	"waitingForRead"
}
var0_0.TypeType = {
	"all",
	"single",
	"multiple"
}
var0_0.CampIds = {
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13
}
var0_0.CampNames = {
	"word_shipNation_all",
	"word_shipNation_baiYing",
	"word_shipNation_huangJia",
	"word_shipNation_chongYing",
	"word_shipNation_tieXue",
	"word_shipNation_dongHuang",
	"word_shipNation_saDing",
	"word_shipNation_beiLian",
	"word_shipNation_ziyou",
	"word_shipNation_weixi",
	"word_shipNation_mot",
	"word_shipNation_yujinwangguo",
	"word_shipNation_jinghuanlianmeng",
	"word_shipNation_other"
}

function var0_0.init(arg0_3)
	arg0_3.leftPanel = arg0_3._tf:Find("main/leftPanel")
	arg0_3.filterBtn = arg0_3.leftPanel:Find("leftTop/filter")
	arg0_3.isFiltered = arg0_3.filterBtn:Find("isFiltered")
	arg0_3.charaScrollrect = arg0_3.leftPanel:Find("charaScroll"):GetComponent("LScrollRect")
	arg0_3.charaScrollContent = arg0_3.leftPanel:Find("charaScroll/Viewport/Content")
	arg0_3.rightPanel = arg0_3._tf:Find("main/rightPanel")
	arg0_3.rightChatPanel = arg0_3.rightPanel:Find("chat")
	arg0_3.rightOfficialAccountsPanel = arg0_3.rightPanel:Find("officialAccounts")
	arg0_3.characterName = arg0_3.rightPanel:Find("chat/rightTop/name")
	arg0_3.careBtn = arg0_3.rightPanel:Find("chat/rightTop/careBtn")
	arg0_3.topicBtn = arg0_3.rightPanel:Find("chat/rightTop/topicBtn")
	arg0_3.backgroundBtn = arg0_3.rightPanel:Find("chat/rightTop/backgroundBtn")
	arg0_3.messageList = UIItemList.New(arg0_3.rightPanel:Find("chat/messageScroll/Viewport/Content"), arg0_3.rightPanel:Find("chat/messageScroll/Viewport/Content/messageCard"))
	arg0_3.optionPanel = arg0_3.rightPanel:Find("chat/optionPanel")
	arg0_3.optionList = UIItemList.New(arg0_3.optionPanel, arg0_3.optionPanel:Find("option"))
	arg0_3.filterUI = arg0_3._tf:Find("subPages/InstagramFilterUI")
	arg0_3.topicUI = arg0_3._tf:Find("subPages/InstagramTopicUI")
	arg0_3.backgroundUI = arg0_3._tf:Find("subPages/InstagramBackgroundUI")
	arg0_3.redPacketUI = arg0_3._tf:Find("subPages/InstagramRedPacketUI")

	setText(arg0_3.filterBtn:Find("Text"), i18n("juuschat_filter_title"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/read/subTitleFrame/subTitle"), i18n("juuschat_filter_subtitle1"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle"), i18n("juuschat_filter_subtitle2"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/subTitleFrame/subTitle"), i18n("juuschat_filter_subtitle3"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/read/option/Text"), i18n("juuschat_filter_tip1"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/read/option_1/Text"), i18n("juuschat_filter_tip2"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/read/option_2/Text"), i18n("juuschat_filter_tip3"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/option/Text"), i18n("juuschat_filter_tip1"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/option_1/Text"), i18n("juuschat_filter_tip4"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/option_2/Text"), i18n("juuschat_filter_tip5"))
	setText(arg0_3.topicUI:Find("panel/topicScroll/Viewport/Content/self/topic/waiting"), i18n("juuschat_chattip3"))
	setText(arg0_3.topicUI:Find("panel/topicScroll/Viewport/Content/self/topic/selected/Text"), i18n("juuschat_label2"))
	setText(arg0_3.topicUI:Find("panel/topicScroll/Viewport/Content/other/topic/waiting"), i18n("juuschat_chattip3"))
	setText(arg0_3.topicUI:Find("panel/topicScroll/Viewport/Content/other/topic/selected/Text"), i18n("juuschat_label2"))
	setText(arg0_3.backgroundUI:Find("panel/backgroundScroll/Viewport/Content/background/selected/Text"), i18n("juuschat_label1"))
	setText(arg0_3.redPacketUI:Find("panel/got/detailBtn/Text"), i18n("juuschat_redpacket_show_detail"))
	setText(arg0_3.redPacketUI:Find("panel/detail/title"), i18n("juuschat_redpacket_detail"))
	setText(arg0_3._tf:Find("main/noFilteredMessageBg/Text"), i18n("juuschat_filter_empty"))
	setText(arg0_3.backgroundUI:Find("panel/backgroundScroll/Viewport/Content/background/lockFrame/Text"), i18n("juuschat_background_tip1"))

	arg0_3.redPacketGot = arg0_3.redPacketUI:Find("panel/got")

	arg0_3:OverlayPanel(arg0_3._tf)
	SetActive(arg0_3.filterUI, false)
	SetActive(arg0_3.isFiltered, false)
	SetActive(arg0_3.topicUI, false)
	SetActive(arg0_3.backgroundUI, false)
	SetActive(arg0_3.redPacketUI, false)
	SetActive(arg0_3.rightPanel, false)

	arg0_3.timerList = {}
	arg0_3.canFresh = false

	local var0_3 = arg0_3.rightPanel:Find("chat/messageScroll/Scrollbar Vertical"):GetComponent(typeof(RectTransform))

	arg0_3.messageScrollWidth = var0_3.rect.width
	arg0_3.messageScrollHeight = var0_3.rect.height

	arg0_3.filterUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_3.topicUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_3.backgroundUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_3:InitOfficialAccounts()
end

function var0_0.didEnter(arg0_4)
	arg0_4:SetData()

	function arg0_4.charaScrollrect.onInitItem(arg0_5)
		arg0_4:OnInitItem(arg0_5)
	end

	function arg0_4.charaScrollrect.onUpdateItem(arg0_6, arg1_6)
		arg0_4:OnUpdateItem(arg0_6, arg1_6)
	end

	arg0_4:UpdateCharaList(false, false)
	arg0_4:SetFilterPanel()

	arg0_4.officialAccountsTimerList = {}
	arg0_4.officialAccountsItemList = {}

	arg0_4:AddOfficialAccountsTimer()
end

function var0_0.InsertOfficialAccounts(arg0_7)
	if InstagramTools.ExistOfficialAccounts() then
		table.insert(arg0_7.chatList, 1, {
			chatType = InstagramConst.INSTAGRAM_CHAT_TYPE.OFFICIAL_ACCOUNT
		})
	end
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	return
end

function var0_0.OnUpdateItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.chatList[arg1_9 + 1]
	local var1_9 = tf(arg2_9)

	setActive(var1_9, true)

	local var2_9 = var0_9.chatType == InstagramConst.INSTAGRAM_CHAT_TYPE.OFFICIAL_ACCOUNT

	setActive(var1_9:Find("chat"), not var2_9)
	setActive(var1_9:Find("officialAccounts"), var2_9)

	if not var2_9 then
		local var3_9 = var0_9.sculpture

		if var0_9.currentTopic.isII and var0_9.sculptureII ~= "" then
			var3_9 = var0_9.sculptureII
		end

		setImageSprite(var1_9:Find("chat/charaBg/chara"), LoadSprite("qicon/" .. var3_9), false)
		setText(var1_9:Find("chat/name"), var0_9.name)

		local var4_9 = var0_9:GetDisplayWord()

		if not arg0_9.currentChat or arg0_9.currentChat.characterId ~= var0_9.characterId or not arg0_9.isSlowMsg then
			setText(var1_9:Find("chat/msg"), var4_9)
		end

		setText(var1_9:Find("chat/displayWord"), var4_9)
		SetActive(var1_9:Find("chat/care"), var0_9.care == 1)

		if var0_9.care == 1 and arg0_9.careAniTriggerId and arg0_9.careAniTriggerId == var0_9.characterId then
			arg0_9.careAniTriggerId = nil

			var1_9:Find("chat/care"):GetComponent(typeof(Animation)):Play("anim_newinstagram_care")
		end

		SetActive(var1_9:Find("chat/tip"), var0_9:GetCharacterEndFlag() == 0)
		setText(var1_9:Find("chat/id"), var0_9.characterId)
		onButton(arg0_9, var1_9, function()
			if arg0_9.currentChat and arg0_9.currentChat.characterId ~= var0_9.characterId then
				arg0_9:ResetCharaTextFunc(arg0_9.currentChat.characterId)
			end

			arg0_9.currentChat = var0_9

			SetActive(arg0_9.rightPanel, true)
			SetActive(arg0_9._tf:Find("main/rightNoMessageBg"), false)
			arg0_9:UpdateChatContent(var0_9, false, false)
			arg0_9:SetTopicPanel(var0_9)
			arg0_9:SetBackgroundPanel(var0_9)

			for iter0_10 = 0, arg0_9.charaScrollContent.childCount - 1 do
				SetActive(arg0_9.charaScrollContent:GetChild(iter0_10):Find("frame"), false)
			end

			SetActive(var1_9:Find("frame"), true)

			function arg0_9.cancelFrame()
				if not IsNil(var1_9) then
					SetActive(var1_9:Find("frame"), false)
				end
			end

			local var0_10 = arg0_9.rightPanel:GetComponent(typeof(Animation))

			var0_10:Stop()
			var0_10:Play("anim_newinstagram_chat_right_in")
		end, SFX_PANEL)
	else
		SetActive(var1_9:Find("officialAccounts/tip"), getProxy(InstagramProxy):ShouldShowOfficialAccountsTip())
		onButton(arg0_9, var1_9, function()
			SetActive(arg0_9.rightPanel, true)
			SetActive(arg0_9._tf:Find("main/rightNoMessageBg"), false)

			for iter0_12 = 0, arg0_9.charaScrollContent.childCount - 1 do
				SetActive(arg0_9.charaScrollContent:GetChild(iter0_12):Find("frame"), false)
			end

			SetActive(var1_9:Find("frame"), true)

			function arg0_9.cancelFrame()
				if not IsNil(var1_9) then
					SetActive(var1_9:Find("frame"), false)
				end
			end

			arg0_9.currentChat = var0_9

			arg0_9:UpdateOfficialAccounts(var0_9)

			local var0_12 = arg0_9.rightPanel:GetComponent(typeof(Animation))

			var0_12:Stop()
			var0_12:Play("anim_newinstagram_chat_right_in")
		end, SFX_PANEL)
	end

	if arg0_9.currentChat then
		SetActive(var1_9:Find("frame"), arg0_9.currentChat == var0_9)
	end
end

function var0_0.UpdateCharaList(arg0_14, arg1_14, arg2_14)
	if not arg0_14.chatList or #arg0_14.chatList == 0 then
		SetActive(arg0_14.leftPanel, false)
		SetActive(arg0_14.rightPanel, false)
		SetActive(arg0_14._tf:Find("main/noMessageBg"), true)
		SetActive(arg0_14._tf:Find("main/noFilteredMessageBg"), false)
		SetActive(arg0_14._tf:Find("main/rightNoMessageBg"), false)

		return
	end

	if not arg0_14.currentChat then
		SetActive(arg0_14.rightPanel, false)
		SetActive(arg0_14._tf:Find("main/rightNoMessageBg"), true)
	else
		SetActive(arg0_14.rightPanel, true)
		SetActive(arg0_14._tf:Find("main/rightNoMessageBg"), false)
	end

	arg0_14.isSlowMsg = arg1_14

	arg0_14:SetFilterResult()

	if arg0_14.currentChat then
		if arg0_14.currentChat.chatType == InstagramConst.INSTAGRAM_CHAT_TYPE.OFFICIAL_ACCOUNT then
			arg0_14:UpdateOfficialAccounts(arg0_14.currentChat)
		else
			arg0_14:UpdateChatContent(arg0_14.currentChat, arg1_14, arg2_14)
			arg0_14:SetTopicPanel(arg0_14.currentChat)
		end
	end
end

function var0_0.UpdateChatContent(arg0_15, arg1_15, arg2_15, arg3_15)
	setActive(arg0_15.rightChatPanel, true)
	setActive(arg0_15.rightOfficialAccountsPanel, false)
	SetActive(arg0_15.rightPanel, true)
	setText(arg0_15.characterName, arg1_15.name)

	local var0_15 = arg0_15.careBtn:Find("care")

	SetActive(var0_15, arg1_15.care == 1)
	onButton(arg0_15, arg0_15.careBtn, function()
		local var0_16 = arg1_15.care == 0 and 1 or 0

		arg0_15:emit(InstagramChatMediator.CHANGE_CARE, arg1_15.characterId, var0_16)

		arg0_15.careAniTriggerId = arg1_15.characterId
	end, SFX_PANEL)

	local var1_15 = arg0_15.rightPanel:Find("chat/paintingMask")
	local var2_15 = var1_15:Find("painting")
	local var3_15 = arg0_15.rightPanel:Find("chat/groupBackground")

	if arg1_15.type == 1 then
		SetActive(var1_15, true)
		SetActive(var3_15, false)

		local var4_15 = "unknown"

		if arg1_15.skinId == 0 then
			var4_15 = arg1_15:GetPainting()
		else
			for iter0_15, iter1_15 in ipairs(arg1_15.skins) do
				if iter1_15.id == arg1_15.skinId then
					var4_15 = iter1_15.painting
				end
			end
		end

		if not arg0_15.paintingName then
			setPaintingPrefabAsync(var2_15, var4_15, "pifu")

			arg0_15.paintingName = var4_15
		elseif arg0_15.paintingName and arg0_15.paintingName ~= var4_15 then
			retPaintingPrefab(var2_15, arg0_15.paintingName)
			setPaintingPrefabAsync(var2_15, var4_15, "pifu")

			arg0_15.paintingName = var4_15
		end
	else
		SetActive(var1_15, false)
		SetActive(var3_15, true)

		if arg0_15.paintingName then
			retPaintingPrefab(var2_15, arg0_15.paintingName)

			arg0_15.paintingName = nil
		end

		setImageSprite(var3_15, LoadSprite("ui/InstagramChatBackgrounds_atlas", arg1_15.groupBackground), true)
	end

	local var5_15 = arg1_15.currentTopic:GetDisplayWordList()

	if not arg3_15 then
		arg0_15:UpdateOptionPanel(arg1_15.currentTopic, var5_15)
		arg0_15:UpdateMessageList(arg1_15.currentTopic, var5_15, arg2_15, arg1_15.characterId, arg1_15.type)
	end

	if not arg2_15 and arg1_15.currentTopic.readFlag == 0 then
		arg0_15:emit(InstagramChatMediator.SET_READED, {
			arg1_15.currentTopic.topicId
		})
	end
end

function var0_0.UpdateMessageList(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17, arg5_17)
	arg0_17:RemoveAllTimer()

	local var0_17

	for iter0_17 = #arg2_17, 1, -1 do
		if arg2_17[iter0_17].ship_group == 0 or arg2_17[iter0_17].type == 3 and arg1_17:RedPacketGotFlag(tonumber(arg2_17[iter0_17].param)) then
			var0_17 = iter0_17

			break
		end
	end

	local var1_17 = {}

	if var0_17 then
		for iter1_17 = var0_17, 1, -1 do
			if arg2_17[iter1_17].ship_group == 0 then
				table.insert(var1_17, iter1_17)
			else
				break
			end
		end
	end

	if arg0_17.shouldShowOption and arg3_17 then
		arg0_17:SetOptionPanelActive(false)
	end

	if arg3_17 then
		onButton(arg0_17, arg0_17.rightPanel:Find("chat/messageScroll"), function()
			arg0_17:SpeedUpMessage()
		end, SFX_PANEL)
	end

	local var2_17 = GetComponent(arg0_17.rightPanel:Find("chat/messageScroll"), typeof(ScrollRect))

	local function var3_17(arg0_19)
		local var0_19 = Vector2(0, arg0_19)

		var2_17.normalizedPosition = var0_19
	end

	local var4_17 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var5_17 = pg.gameset.juuschat_entering_time.key_value / 1000
	local var6_17 = var4_17 - var5_17

	arg0_17.messageList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = arg2_17[arg1_20 + 1]

			if var0_20.ship_group == 0 and var0_20.type == 0 then
				SetActive(arg2_20, false)

				return
			end

			local var1_20 = arg2_20:Find("charaMessageCard")
			local var2_20 = arg2_20:Find("playerReplyCard")

			SetActive(var1_20, var0_20.ship_group ~= 0)
			SetActive(var2_20, var0_20.ship_group == 0)

			if var0_20.ship_group ~= 0 and arg5_17 == 2 and var0_20.type ~= 5 then
				SetActive(arg2_20:Find("nameBar"), true)
				setText(arg2_20:Find("nameBar/Text"), var1_0[var0_20.ship_group].name)
			else
				SetActive(arg2_20:Find("nameBar"), false)
			end

			local var3_20

			if arg3_17 and var0_17 and arg1_20 + 1 > var0_17 then
				var3_20 = (arg1_20 + 1 - var0_17) * var4_17 - var5_17

				if #var1_17 > 1 then
					var3_20 = var3_20 + (#var1_17 - 1) * var6_17
				end
			end

			if var0_20.ship_group ~= 0 then
				local var4_20 = "unknown"
				local var5_20 = var1_0[var0_20.ship_group]

				if var5_20 then
					if var0_20.ship_group == arg4_17 and arg1_17.isII and var5_20.sculpture_ii ~= "" then
						var4_20 = var5_20.sculpture_ii
					else
						var4_20 = var5_20.sculpture
					end
				end

				if var0_20.type ~= 5 then
					setImageSprite(arg2_20:Find("charaMessageCard/charaBg/chara"), LoadSprite("qicon/" .. var4_20), false)
				end

				if var0_20.type == 1 then
					arg0_17:SetCharaMessageCardActive(var1_20, {
						3
					})
					setText(arg2_20:Find("charaMessageCard/msgBox/msg"), var0_20.param)

					if arg3_17 and var0_17 and arg1_20 + 1 > var0_17 then
						SetActive(arg2_20, false)
						arg0_17:StartTimer(function()
							SetActive(arg2_20, true)
							arg2_20:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_20:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_20:Find("charaMessageCard/msgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
							arg0_17:StartTimer(function()
								SetActive(arg2_20:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_20:Find("charaMessageCard/msgBox"), true)
								arg2_20:Find("charaMessageCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")

								if arg1_20 + 1 ~= #arg2_17 then
									arg0_17:ChangeCharaTextFunc(arg4_17, var0_20.param)
								else
									arg0_17:emit(InstagramChatMediator.SET_READED, {
										arg1_17.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
								arg0_17:SetEndAniEvent(arg2_20:Find("charaMessageCard/msgBox"), function()
									if arg0_17.shouldShowOption and arg1_20 + 1 == #arg2_17 then
										arg0_17:SetOptionPanelActive(true)
									end
								end)
							end, var5_17)
						end, var3_20)
					end
				elseif var0_20.type == 2 then
					arg0_17:SetCharaMessageCardActive(var1_20, {
						2,
						7
					})
					pg.CriMgr.GetInstance():GetCueInfo("cv-" .. var0_20.ship_group, var0_20.param[1], function(arg0_24)
						setText(arg2_20:Find("charaMessageCard/voiceBox/time"), tostring(math.ceil(tonumber(tostring(arg0_24.length)) / 1000)) .. "\"")
					end)
					onButton(arg0_17, arg2_20:Find("charaMessageCard/voiceBox"), function()
						pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/cv/" .. var0_20.ship_group .. "/" .. var0_20.param[1])
					end, SFX_PANEL)
					setText(arg2_20:Find("charaMessageCard/voiceMsgBox/voiceMsg/msg"), var0_20.param[2])

					if arg3_17 and var0_17 and arg1_20 + 1 > var0_17 then
						SetActive(arg2_20, false)
						arg0_17:StartTimer(function()
							SetActive(arg2_20, true)
							arg2_20:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_20:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_20:Find("charaMessageCard/voiceBox"), false)
							SetActive(arg2_20:Find("charaMessageCard/voiceMsgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
							arg0_17:StartTimer(function()
								SetActive(arg2_20:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_20:Find("charaMessageCard/voiceBox"), true)
								SetActive(arg2_20:Find("charaMessageCard/voiceMsgBox"), true)
								arg2_20:Find("charaMessageCard/voiceBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")
								arg2_20:Find("charaMessageCard/voiceMsgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_voicetip_in")

								if arg1_20 + 1 ~= #arg2_17 then
									arg0_17:ChangeCharaTextFunc(arg4_17, "<color=#ff6666>" .. i18n("juuschat_chattip1") .. "</color>")
								else
									arg0_17:emit(InstagramChatMediator.SET_READED, {
										arg1_17.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
								arg0_17:SetEndAniEvent(arg2_20:Find("charaMessageCard/voiceBox"), function()
									if arg0_17.shouldShowOption and arg1_20 + 1 == #arg2_17 then
										arg0_17:SetOptionPanelActive(true)
									end
								end)
							end, var5_17)
						end, var3_20)
					end
				elseif var0_20.type == 3 then
					arg0_17:SetCharaMessageCardActive(var1_20, {
						5
					})

					local var6_20 = var2_0[tonumber(var0_20.param)]

					setText(arg2_20:Find("charaMessageCard/redPacket/desc"), var6_20.desc)

					local var7_20 = arg1_17:RedPacketGotFlag(var6_20.id)

					SetActive(arg2_20:Find("charaMessageCard/redPacket/got"), var7_20)
					arg0_17:SetRedPacketPanel(arg2_20:Find("charaMessageCard/redPacket"), var6_20, var7_20, var4_20, arg1_17.topicId, var0_20.id)

					if arg3_17 and var0_17 and arg1_20 + 1 == var0_17 then
						arg0_17:ChangeCharaTextFunc(arg4_17, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_20.param)].desc)
					end

					if arg3_17 and var0_17 and arg1_20 + 1 > var0_17 then
						SetActive(arg2_20, false)
						arg0_17:StartTimer(function()
							SetActive(arg2_20, true)
							arg2_20:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_20:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_20:Find("charaMessageCard/redPacket"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
							arg0_17:StartTimer(function()
								SetActive(arg2_20:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_20:Find("charaMessageCard/redPacket"), true)
								arg2_20:Find("charaMessageCard/redPacket"):GetComponent(typeof(Animation)):Play("anim_newinstagram_redpacket_in")

								if arg1_20 + 1 ~= #arg2_17 then
									arg0_17:ChangeCharaTextFunc(arg4_17, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_20.param)].desc)
								else
									arg0_17:emit(InstagramChatMediator.SET_READED, {
										arg1_17.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
								arg0_17:SetEndAniEvent(arg2_20:Find("charaMessageCard/redPacket"), function()
									if arg0_17.shouldShowOption and arg1_20 + 1 == #arg2_17 then
										arg0_17:SetOptionPanelActive(true)
									end
								end)
							end, var5_17)
						end, var3_20)
					end
				elseif var0_20.type == 4 then
					arg0_17:SetCharaMessageCardActive(var1_20, {
						4
					})
					arg0_17:ClearEmoji(arg2_20:Find("charaMessageCard/emoji/emoticon"))
					arg0_17:SetEmoji(arg2_20:Find("charaMessageCard/emoji/emoticon"), var3_0[tonumber(var0_20.param)].pic)

					if arg3_17 and var0_17 and arg1_20 + 1 > var0_17 then
						SetActive(arg2_20, false)
						arg0_17:StartTimer(function()
							SetActive(arg2_20, true)
							arg2_20:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_20:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_20:Find("charaMessageCard/emoji"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
							arg0_17:StartTimer(function()
								SetActive(arg2_20:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_20:Find("charaMessageCard/emoji"), true)
								arg2_20:Find("charaMessageCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								if arg1_20 + 1 ~= #arg2_17 then
									local var0_33 = var3_0[tonumber(var0_20.param)].desc
									local var1_33 = string.gsub(var0_33, "#%w+>", "#28af6e>")

									arg0_17:ChangeCharaTextFunc(arg4_17, var1_33)
								else
									arg0_17:emit(InstagramChatMediator.SET_READED, {
										arg1_17.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
								arg0_17:SetEndAniEvent(arg2_20:Find("charaMessageCard/emoji"), function()
									if arg0_17.shouldShowOption and arg1_20 + 1 == #arg2_17 then
										arg0_17:SetOptionPanelActive(true)
									end
								end)
							end, var5_17)
						end, var3_20)
					end
				elseif var0_20.type == 5 then
					arg0_17:SetCharaMessageCardActive(var1_20, {
						6
					})

					local var8_20 = var0_20.param

					for iter0_20 in string.gmatch(var0_20.param, "'%d+'") do
						local var9_20 = string.sub(iter0_20, 2, #iter0_20 - 1)

						var8_20 = string.gsub(var8_20, iter0_20, "<color=#93e9ff>" .. var1_0[tonumber(var9_20)].name .. "</color>")
					end

					setText(arg2_20:Find("charaMessageCard/systemTip/panel/Text"), var8_20)

					if arg3_17 and var0_17 and arg1_20 + 1 > var0_17 then
						SetActive(arg2_20, false)
						arg0_17:StartTimer(function()
							SetActive(arg2_20, true)
							arg2_20:Find("charaMessageCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							if arg1_20 + 1 ~= #arg2_17 then
								arg0_17:ChangeCharaTextFunc(arg4_17, var8_20)
							else
								arg0_17:emit(InstagramChatMediator.SET_READED, {
									arg1_17.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
							arg0_17:SetEndAniEvent(arg2_20:Find("charaMessageCard/systemTip"), function()
								if arg0_17.shouldShowOption and arg1_20 + 1 == #arg2_17 then
									arg0_17:SetOptionPanelActive(true)
								end
							end)
						end, var3_20)
					end
				end
			else
				if var0_20.type == 1 then
					arg0_17:SetPlayerMessageCardActive(var2_20, {
						0
					})
					setText(arg2_20:Find("playerReplyCard/msgBox/msg"), var0_20.param)
				elseif var0_20.type == 4 then
					arg0_17:SetPlayerMessageCardActive(var2_20, {
						1
					})
					arg0_17:ClearEmoji(arg2_20:Find("playerReplyCard/emoji/emoticon"))
					arg0_17:SetEmoji(arg2_20:Find("playerReplyCard/emoji/emoticon"), var3_0[tonumber(var0_20.param)].pic)
				elseif var0_20.type == 5 then
					arg0_17:SetPlayerMessageCardActive(var2_20, {
						2
					})

					local var10_20 = var0_20.param

					for iter1_20 in string.gmatch(var0_20.param, "'%d+'") do
						local var11_20 = string.sub(iter1_20, 2, #iter1_20 - 1)

						var10_20 = string.gsub(var10_20, iter1_20, "<color=#93e9ff>" .. var1_0[tonumber(var11_20)].name .. "</color>")
					end

					setText(arg2_20:Find("playerReplyCard/systemTip/panel/Text"), var10_20)
				end

				if arg3_17 and var0_17 and _.contains(var1_17, arg1_20 + 1) then
					if table.indexof(var1_17, arg1_20 + 1) < #var1_17 then
						SetActive(arg2_20, false)
						arg0_17:StartTimer(function()
							SetActive(arg2_20, true)

							if var0_20.type == 1 then
								arg2_20:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
								arg0_17:ChangeCharaTextFunc(arg4_17, var0_20.param)
							elseif var0_20.type == 4 then
								arg2_20:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								local var0_37 = var3_0[tonumber(var0_20.param)].desc
								local var1_37 = string.gsub(var0_37, "#%w+>", "#28af6e>")

								arg0_17:ChangeCharaTextFunc(arg4_17, var1_37)
							elseif var0_20.type == 5 then
								arg2_20:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

								local var2_37 = var0_20.param

								for iter0_37 in string.gmatch(var0_20.param, "'%d+'") do
									local var3_37 = string.sub(iter0_37, 2, #iter0_37 - 1)

									var2_37 = string.gsub(var2_37, iter0_37, "<color=#93e9ff>" .. var1_0[tonumber(var3_37)].name .. "</color>")
								end

								arg0_17:ChangeCharaTextFunc(arg4_17, var2_37)
							end

							if arg1_20 + 1 == #arg2_17 then
								arg0_17:emit(InstagramChatMediator.SET_READED, {
									arg1_17.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
						end, (#var1_17 - table.indexof(var1_17, arg1_20 + 1)) * var6_17)
					else
						if var0_20.type == 1 then
							arg2_20:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
							arg0_17:ChangeCharaTextFunc(arg4_17, var0_20.param)
						elseif var0_20.type == 4 then
							arg2_20:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

							local var12_20 = var3_0[tonumber(var0_20.param)].desc
							local var13_20 = string.gsub(var12_20, "#%w+>", "#28af6e>")

							arg0_17:ChangeCharaTextFunc(arg4_17, var13_20)
						elseif var0_20.type == 5 then
							arg2_20:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							local var14_20 = var0_20.param

							for iter2_20 in string.gmatch(var0_20.param, "'%d+'") do
								local var15_20 = string.sub(iter2_20, 2, #iter2_20 - 1)

								var14_20 = string.gsub(var14_20, iter2_20, "<color=#93e9ff>" .. var1_0[tonumber(var15_20)].name .. "</color>")
							end

							arg0_17:ChangeCharaTextFunc(arg4_17, var14_20)
						end

						if arg1_20 + 1 == #arg2_17 then
							arg0_17:emit(InstagramChatMediator.SET_READED, {
								arg1_17.topicId
							})
						end
					end
				end
			end

			if not arg1_17:isWaiting() and arg1_20 + 1 == #arg2_17 then
				if arg3_17 then
					if var0_20.ship_group ~= 0 then
						arg0_17:StartTimer(function()
							setActive(arg2_20:Find("end"), true)
						end, var3_20 + var4_17)
					else
						arg0_17:StartTimer(function()
							setActive(arg2_20:Find("end"), true)
						end, (#var1_17 - table.indexof(var1_17, arg1_20 + 1)) * var6_17 + var6_17)
					end
				else
					setActive(arg2_20:Find("end"), true)
				end
			else
				setActive(arg2_20:Find("end"), false)
			end
		end
	end)
	arg0_17.messageList:align(#arg2_17)

	if arg3_17 then
		Canvas.ForceUpdateCanvases()
		LeanTween.value(go(arg0_17.rightPanel:Find("chat/messageScroll")), var2_17.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_17)):setEase(LeanTweenType.easeInOutCubic)
	else
		scrollToBottom(arg0_17.rightPanel:Find("chat/messageScroll"))
	end
end

function var0_0.SetCharaMessageCardActive(arg0_40, arg1_40, arg2_40)
	if _.contains(arg2_40, 6) then
		SetActive(arg1_40:GetChild(0), false)
	else
		SetActive(arg1_40:GetChild(0), true)
	end

	for iter0_40 = 1, arg1_40.childCount - 1 do
		if _.contains(arg2_40, iter0_40) then
			SetActive(arg1_40:GetChild(iter0_40), true)
		else
			SetActive(arg1_40:GetChild(iter0_40), false)
		end
	end
end

function var0_0.SetPlayerMessageCardActive(arg0_41, arg1_41, arg2_41)
	for iter0_41 = 0, arg1_41.childCount - 1 do
		if _.contains(arg2_41, iter0_41) then
			SetActive(arg1_41:GetChild(iter0_41), true)
		else
			SetActive(arg1_41:GetChild(iter0_41), false)
		end
	end
end

function var0_0.SetEmoji(arg0_42, arg1_42, arg2_42)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg2_42, arg2_42, true, function(arg0_43)
		if not IsNil(arg1_42) then
			arg0_43.name = arg2_42
			tf(arg0_43).sizeDelta = arg1_42.sizeDelta
			tf(arg0_43).anchoredPosition = Vector2.zero

			local var0_43 = arg0_43:GetComponent("Animator")

			if var0_43 then
				var0_43.enabled = true
			end

			setParent(arg0_43, arg1_42, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg2_42, arg2_42, arg0_43)
		end
	end)
end

function var0_0.ClearEmoji(arg0_44, arg1_44)
	eachChild(arg1_44, function(arg0_45)
		local var0_45 = go(arg0_45)

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_45.name, var0_45.name, var0_45)
	end)
end

function var0_0.UpdateOptionPanel(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg2_46[#arg2_46].option

	if var0_46 and type(var0_46) == "table" then
		arg0_46.shouldShowOption = true
		arg0_46.optionCount = #var0_46

		arg0_46:SetOptionPanelActive(true)
		arg0_46.optionList:make(function(arg0_47, arg1_47, arg2_47)
			if arg0_47 == UIItemList.EventUpdate then
				local var0_47 = var0_46[arg1_47 + 1]

				setText(arg2_47:Find("Text"), HXSet.hxLan(var0_47[2]))
				onButton(arg0_46, arg2_47, function()
					arg0_46:emit(InstagramChatMediator.REPLY, arg1_46.topicId, arg2_46[#arg2_46].id, var0_47[1])
				end, SFX_PANEL)
			end
		end)
		arg0_46.optionList:align(#var0_46)
	else
		arg0_46:SetOptionPanelActive(false)

		arg0_46.shouldShowOption = false
	end
end

function var0_0.SetOptionPanelActive(arg0_49, arg1_49)
	SetActive(arg0_49.optionPanel, arg1_49)

	local var0_49 = arg0_49.rightPanel:Find("chat/messageScroll/Viewport/Content"):GetComponent(typeof(VerticalLayoutGroup))
	local var1_49 = UnityEngine.RectOffset.New()

	var1_49.left = 0
	var1_49.right = 0
	var1_49.top = 0

	local var2_49 = arg0_49.rightPanel:Find("chat/messageScroll/Scrollbar Vertical"):GetComponent(typeof(RectTransform))

	if arg1_49 then
		var1_49.bottom = 42 + 88 * arg0_49.optionCount
		var2_49.sizeDelta = Vector2(arg0_49.messageScrollWidth, -var1_49.bottom)
	else
		var1_49.bottom = 50
		var2_49.sizeDelta = Vector2(arg0_49.messageScrollWidth, 0)
	end

	var0_49.padding = var1_49

	scrollToBottom(arg0_49.rightPanel:Find("chat/messageScroll"))
end

function var0_0.SetFilterPanel(arg0_50)
	arg0_50.readFilter = arg0_50.readFilter or var0_0.ReadType[1]
	arg0_50.typeFilter = arg0_50.typeFilter or var0_0.TypeType[1]
	arg0_50.campFilter = arg0_50.campFilter or {
		var0_0.CampIds[1]
	}

	local var0_50 = arg0_50.filterUI:Find("panel/filterScroll/Viewport/Content/read")
	local var1_50 = arg0_50.filterUI:Find("panel/filterScroll/Viewport/Content/type")
	local var2_50 = arg0_50.filterUI:Find("panel/filterScroll/Viewport/Content/camp")
	local var3_50 = UIItemList.New(var2_50, var2_50:Find("option"))

	onButton(arg0_50, arg0_50.filterBtn, function()
		SetActive(arg0_50.filterUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_50.filterUI)

		for iter0_51, iter1_51 in ipairs(var0_0.ReadType) do
			local var0_51 = var0_50:GetChild(iter0_51)
			local var1_51 = var0_51:Find("selectedFrame")

			SetActive(var1_51, arg0_50.readFilter == iter1_51)
			onButton(arg0_50, var0_51, function()
				for iter0_52, iter1_52 in ipairs(var0_0.ReadType) do
					SetActive(var0_50:GetChild(iter0_52):Find("selectedFrame"), false)
				end

				SetActive(var1_51, true)
			end, SFX_PANEL)
		end

		for iter2_51, iter3_51 in ipairs(var0_0.TypeType) do
			local var2_51 = var1_50:GetChild(iter2_51)
			local var3_51 = var2_51:Find("selectedFrame")

			SetActive(var3_51, arg0_50.typeFilter == iter3_51)
			onButton(arg0_50, var2_51, function()
				for iter0_53, iter1_53 in ipairs(var0_0.TypeType) do
					SetActive(var1_50:GetChild(iter0_53):Find("selectedFrame"), false)
				end

				SetActive(var3_51, true)
			end, SFX_PANEL)
		end

		var3_50:make(function(arg0_54, arg1_54, arg2_54)
			if arg0_54 == UIItemList.EventUpdate then
				setText(arg2_54:Find("Text"), i18n(var0_0.CampNames[arg1_54 + 1]))

				local var0_54 = arg2_54:Find("selectedFrame")

				SetActive(var0_54, _.contains(arg0_50.campFilter, var0_0.CampIds[arg1_54 + 1]))
				onButton(arg0_50, arg2_54, function()
					if arg1_54 == 0 then
						SetActive(var0_54, true)

						for iter0_55 = 2, #var0_0.CampIds do
							SetActive(var2_50:GetChild(iter0_55 - 1):Find("selectedFrame"), false)
						end
					else
						SetActive(var0_54, not isActive(var0_54))

						local var0_55 = true
						local var1_55 = true

						for iter1_55 = 2, #var0_0.CampIds do
							if not isActive(var2_50:GetChild(iter1_55 - 1):Find("selectedFrame")) then
								var0_55 = false
							end

							if isActive(var2_50:GetChild(iter1_55 - 1):Find("selectedFrame")) then
								var1_55 = false
							end
						end

						if var0_55 then
							SetActive(var2_50:GetChild(0):Find("selectedFrame"), true)

							for iter2_55 = 2, #var0_0.CampIds do
								SetActive(var2_50:GetChild(iter2_55 - 1):Find("selectedFrame"), false)
							end
						elseif var1_55 then
							SetActive(var2_50:GetChild(0):Find("selectedFrame"), true)
						else
							SetActive(var2_50:GetChild(0):Find("selectedFrame"), false)
						end
					end
				end, SFX_PANEL)
			end
		end)
		var3_50:align(#var0_0.CampIds)
	end, SFX_PANEL)
	onButton(arg0_50, arg0_50.filterUI:Find("bg"), function()
		arg0_50:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_50, arg0_50.filterUI:Find("panel/bottom/close"), function()
		arg0_50:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_50, arg0_50.filterUI:Find("panel/bottom/ok"), function()
		for iter0_58, iter1_58 in ipairs(var0_0.ReadType) do
			local var0_58 = var0_50:GetChild(iter0_58):Find("selectedFrame")

			if isActive(var0_58) then
				arg0_50.readFilter = iter1_58
			end
		end

		for iter2_58, iter3_58 in ipairs(var0_0.TypeType) do
			local var1_58 = var1_50:GetChild(iter2_58):Find("selectedFrame")

			if isActive(var1_58) then
				arg0_50.typeFilter = iter3_58
			end
		end

		arg0_50.campFilter = {}

		for iter4_58, iter5_58 in ipairs(var0_0.CampIds) do
			local var2_58 = var2_50:GetChild(iter4_58 - 1):Find("selectedFrame")

			if isActive(var2_58) then
				table.insert(arg0_50.campFilter, iter5_58)
			end
		end

		arg0_50:CloseFilterPanel()
		arg0_50:SetFilterResult()
	end, SFX_PANEL)
end

function var0_0.SetFilterResult(arg0_59)
	local var0_59 = true
	local var1_59 = false

	if not arg0_59.readFilter then
		arg0_59.readFilter = var0_0.ReadType[1]
		arg0_59.typeFilter = var0_0.TypeType[1]
		arg0_59.campFilter = {
			var0_0.CampIds[1]
		}
	end

	arg0_59.chatList = table.insertto({}, arg0_59.allChatList)

	for iter0_59 = #arg0_59.chatList, 1, -1 do
		local var2_59 = arg0_59.chatList[iter0_59]
		local var3_59 = true

		if arg0_59.readFilter ~= "all" then
			local var4_59 = arg0_59.readFilter == "hasReaded" and 1 or 0

			if var2_59:GetCharacterEndFlag() ~= var4_59 then
				var3_59 = false
			end
		end

		if arg0_59.typeFilter ~= "all" then
			local var5_59 = arg0_59.typeFilter == "single" and 1 or 2

			if var2_59.type ~= var5_59 then
				var3_59 = false
			end
		end

		if not _.contains(arg0_59.campFilter, 0) and not _.contains(arg0_59.campFilter, var2_59.nationality) then
			var3_59 = false
		end

		if not var3_59 then
			table.remove(arg0_59.chatList, iter0_59)
		end

		if var3_59 then
			var0_59 = false
		end

		if arg0_59.currentChat and arg0_59.currentChat.characterId == var2_59.characterId and var3_59 then
			var1_59 = true
		end
	end

	local var6_59 = arg0_59.readFilter == "all" and arg0_59.typeFilter == "all" and _.contains(arg0_59.campFilter, 0)

	SetActive(arg0_59.isFiltered, not var6_59)

	if var6_59 then
		arg0_59:InsertOfficialAccounts()
	end

	if var0_59 then
		SetActive(arg0_59.leftPanel:Find("charaScroll"), false)
		SetActive(arg0_59._tf:Find("main/noFilteredMessageBg"), true)
		SetActive(arg0_59.rightPanel, false)
		SetActive(arg0_59._tf:Find("main/rightNoMessageBg"), false)
	else
		SetActive(arg0_59.leftPanel:Find("charaScroll"), true)
		arg0_59.charaScrollrect:SetTotalCount(#arg0_59.chatList)
		SetActive(arg0_59._tf:Find("main/noFilteredMessageBg"), false)

		if var1_59 then
			SetActive(arg0_59.rightPanel, true)
			SetActive(arg0_59._tf:Find("main/rightNoMessageBg"), false)
		else
			SetActive(arg0_59.rightPanel, false)
			SetActive(arg0_59._tf:Find("main/rightNoMessageBg"), true)

			arg0_59.currentChat = nil

			if arg0_59.cancelFrame then
				arg0_59.cancelFrame()

				arg0_59.cancelFrame = nil
			end
		end
	end
end

function var0_0.CloseFilterPanel(arg0_60)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_60.filterUI, arg0_60._tf:Find("subPages"))
	SetActive(arg0_60.filterUI, false)
end

function var0_0.SetTopicPanel(arg0_61, arg1_61)
	SetActive(arg0_61.topicBtn:Find("tip"), arg1_61:GetCharacterEndFlagExceptCurrent() == 0)
	onButton(arg0_61, arg0_61.topicBtn, function()
		SetActive(arg0_61.topicUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_61.topicUI)

		arg0_61.currentTopic = nil

		arg1_61:SortTopicList()

		local var0_62 = {}
		local var1_62 = {}

		for iter0_62, iter1_62 in ipairs(arg1_61.topics) do
			if iter1_62.active then
				if iter1_62.isII then
					table.insert(var1_62, iter1_62)
				else
					table.insert(var0_62, iter1_62)
				end
			end
		end

		setActive(arg0_61.topicUI:Find("panel/topicScroll/Viewport/Content/self"), #var0_62 > 0)
		setActive(arg0_61.topicUI:Find("panel/topicScroll/Viewport/Content/other"), #var1_62 > 0)
		setActive(arg0_61.topicUI:Find("panel/topicScroll/Viewport/Content/line"), #var0_62 > 0 and #var1_62 > 0)

		if #var0_62 > 0 then
			local var2_62 = UIItemList.New(arg0_61.topicUI:Find("panel/topicScroll/Viewport/Content/self"), arg0_61.topicUI:Find("panel/topicScroll/Viewport/Content/self/topic"))

			var2_62:make(function(arg0_63, arg1_63, arg2_63)
				if arg0_63 == UIItemList.EventUpdate then
					local var0_63 = var0_62[arg1_63 + 1]

					arg0_61:SetTopic(arg2_63, arg1_61, var0_63, var0_62, var1_62)
				end
			end)
			var2_62:align(#var0_62)
		end

		if #var1_62 > 0 then
			local var3_62 = UIItemList.New(arg0_61.topicUI:Find("panel/topicScroll/Viewport/Content/other"), arg0_61.topicUI:Find("panel/topicScroll/Viewport/Content/other/topic"))

			var3_62:make(function(arg0_64, arg1_64, arg2_64)
				if arg0_64 == UIItemList.EventUpdate then
					local var0_64 = var1_62[arg1_64 + 1]

					arg0_61:SetTopic(arg2_64, arg1_61, var0_64, var0_62, var1_62)
				end
			end)
			var3_62:align(#var1_62)
		end
	end, SFX_PANEL)
	onButton(arg0_61, arg0_61.topicUI:Find("bg"), function()
		arg0_61:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_61, arg0_61.topicUI:Find("panel/bottom/close"), function()
		arg0_61:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_61, arg0_61.topicUI:Find("panel/bottom/ok"), function()
		arg0_61:emit(InstagramChatMediator.SET_CURRENT_TOPIC, arg0_61.currentTopic.topicId)
		arg0_61:CloseTopicPanel()

		local var0_67 = arg0_61.rightPanel:GetComponent(typeof(Animation))

		var0_67:Stop()
		var0_67:Play("anim_newinstagram_chat_right_in")
	end, SFX_PANEL)
end

function var0_0.SetTopic(arg0_68, arg1_68, arg2_68, arg3_68, arg4_68, arg5_68)
	setScrollText(arg1_68:Find("mask/name"), HXSet.hxLan(arg3_68.name))
	SetActive(arg1_68:Find("lock"), not arg3_68.active)
	SetActive(arg1_68:Find("waiting"), arg3_68.active and arg3_68:isWaiting())
	SetActive(arg1_68:Find("complete"), arg3_68.active and arg3_68:IsCompleted())
	SetActive(arg1_68:Find("selectedFrame"), arg2_68.currentTopicId == arg3_68.topicId)
	SetActive(arg1_68:Find("selected"), arg2_68.currentTopicId == arg3_68.topicId)
	SetActive(arg1_68:Find("tip"), arg3_68.active and not arg3_68:IsCompleted())

	if arg2_68.currentTopicId == arg3_68.topicId then
		arg0_68.currentTopic = arg3_68
	end

	SetActive(arg1_68, arg3_68.active)

	if arg3_68.active then
		onButton(arg0_68, arg1_68, function()
			for iter0_69 = 1, #arg4_68 do
				SetActive(arg0_68.topicUI:Find("panel/topicScroll/Viewport/Content/self"):GetChild(iter0_69 - 1):Find("selectedFrame"), false)
			end

			for iter1_69 = 1, #arg5_68 do
				SetActive(arg0_68.topicUI:Find("panel/topicScroll/Viewport/Content/other"):GetChild(iter1_69 - 1):Find("selectedFrame"), false)
			end

			SetActive(arg1_68:Find("selectedFrame"), true)

			arg0_68.currentTopic = arg3_68
		end, SFX_PANEL)
	else
		onButton(arg0_68, arg1_68, function()
			pg.TipsMgr.GetInstance():ShowTips(arg3_68.unlockDesc)
		end, SFX_PANEL)
	end
end

function var0_0.CloseTopicPanel(arg0_71)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_71.topicUI, arg0_71._tf:Find("subPages"))
	SetActive(arg0_71.topicUI, false)
end

function var0_0.SetBackgroundPanel(arg0_72, arg1_72)
	if arg1_72.type == 2 then
		SetActive(arg0_72.backgroundBtn, false)

		return
	end

	SetActive(arg0_72.backgroundBtn, true)
	onButton(arg0_72, arg0_72.backgroundBtn, function()
		SetActive(arg0_72.backgroundUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_72.backgroundUI)

		arg0_72.currentBgId = nil

		local var0_73 = arg1_72:GetSkins()
		local var1_73 = UIItemList.New(arg0_72.backgroundUI:Find("panel/backgroundScroll/Viewport/Content"), arg0_72.backgroundUI:Find("panel/backgroundScroll/Viewport/Content/background"))

		var1_73:make(function(arg0_74, arg1_74, arg2_74)
			if arg0_74 == UIItemList.EventUpdate then
				local var0_74 = var0_73[arg1_74 + 1]
				local var1_74 = var0_74.id
				local var2_74 = var0_74.painting

				LoadImageSpriteAsync("herohrzicon/" .. var2_74, arg2_74:Find("skinMask/skin"), false)
				setScrollText(arg2_74:Find("skinMask/Panel/mask/Text"), var0_74.name)

				local var3_74 = getProxy(ShipSkinProxy):hasSkin(var0_74.id) or var0_74.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or var0_74.skin_type == ShipSkin.SKIN_TYPE_PROPOSE or var0_74.skin_type == ShipSkin.SKIN_TYPE_REMAKE

				SetActive(arg2_74:Find("lockFrame"), not var3_74)

				if arg1_72.skinId ~= 0 then
					SetActive(arg2_74:Find("selectedFrame"), arg1_72.skinId == var1_74)
					SetActive(arg2_74:Find("selected"), arg1_72.skinId == var1_74)

					if arg1_72.skinId == var1_74 then
						arg0_72.currentBgId = var1_74
					end
				else
					local var4_74 = arg1_72:GetPaintingId()

					SetActive(arg2_74:Find("selectedFrame"), var4_74 == var1_74)
					SetActive(arg2_74:Find("selected"), var4_74 == var1_74)

					if var4_74 == var1_74 then
						arg0_72.currentBgId = var1_74
					end
				end

				onButton(arg0_72, arg2_74, function()
					if var3_74 then
						SetActive(arg2_74:Find("selectedFrame"), true)

						for iter0_75 = 1, #var0_73 do
							if iter0_75 ~= arg1_74 + 1 then
								local var0_75 = arg0_72.backgroundUI:Find("panel/backgroundScroll/Viewport/Content"):GetChild(iter0_75 - 1)

								SetActive(var0_75:Find("selectedFrame"), false)
							end
						end

						arg0_72.currentBgId = var1_74
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("juuschat_background_tip2"))
					end
				end, SFX_PANEL)
			end
		end)
		var1_73:align(#var0_73)
	end, SFX_PANEL)
	onButton(arg0_72, arg0_72.backgroundUI:Find("bg"), function()
		arg0_72:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_72, arg0_72.backgroundUI:Find("panel/bottom/close"), function()
		arg0_72:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_72, arg0_72.backgroundUI:Find("panel/bottom/ok"), function()
		arg0_72:emit(InstagramChatMediator.SET_CURRENT_BACKGROUND, arg1_72.characterId, arg0_72.currentBgId)
		arg0_72:CloseBackgroundPanel()
	end, SFX_PANEL)
end

function var0_0.CloseBackgroundPanel(arg0_79)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_79.backgroundUI, arg0_79._tf:Find("subPages"))
	SetActive(arg0_79.backgroundUI, false)
end

function var0_0.SetRedPacketPanel(arg0_80, arg1_80, arg2_80, arg3_80, arg4_80, arg5_80, arg6_80)
	onButton(arg0_80, arg1_80, function()
		SetActive(arg0_80.redPacketUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_80.redPacketUI)
		setImageSprite(arg0_80.redPacketUI:Find("panel/charaBg/chara"), LoadSprite("qicon/" .. arg4_80), false)

		if not arg3_80 then
			SetActive(arg0_80.redPacketUI:Find("panel/panelBg"), true)
			SetActive(arg0_80.redPacketUI:Find("panel/openImg"), false)
			SetActive(arg0_80.redPacketUI:Find("panel/get"), true)
			SetActive(arg0_80.redPacketUI:Find("panel/got"), false)
			SetActive(arg0_80.redPacketUI:Find("panel/detail"), false)
			setText(arg0_80.redPacketUI:Find("panel/get/titleBg/title"), arg2_80.desc)
			onButton(arg0_80, arg0_80.redPacketUI:Find("panel/get/getBtn"), function()
				arg0_80:emit(InstagramChatMediator.GET_REDPACKET, arg5_80, arg6_80, arg2_80.id)
			end, SFX_PANEL)
		else
			arg0_80:UpdateRedPacketUI(arg2_80.id)
		end
	end, SFX_PANEL)
	onButton(arg0_80, arg0_80.redPacketUI:Find("bg"), function()
		arg0_80:CloseRedPacketPanel()

		if arg0_80.canFresh then
			arg0_80.canFresh = false

			local var0_83 = arg0_80.currentChat.currentTopic:GetDisplayWordList()

			if var0_83[#var0_83].type == 0 then
				arg0_80:UpdateCharaList(false, false)
			else
				arg0_80:UpdateCharaList(true, false)
			end
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRedPacketUI(arg0_84, arg1_84)
	local var0_84 = var2_0[arg1_84]

	SetActive(arg0_84.redPacketUI:Find("panel/panelBg"), true)
	SetActive(arg0_84.redPacketUI:Find("panel/openImg"), false)
	SetActive(arg0_84.redPacketUI:Find("panel/get"), false)
	SetActive(arg0_84.redPacketUI:Find("panel/got"), true)
	SetActive(arg0_84.redPacketUI:Find("panel/detail"), false)

	local var1_84 = Drop.Create(var0_84.content)

	var1_84.count = 0

	updateDrop(arg0_84.redPacketUI:Find("panel/got/item"), var1_84)
	onButton(arg0_84, arg0_84.redPacketUI:Find("panel/got/item"), function()
		arg0_84:emit(BaseUI.ON_DROP, var1_84)
	end, SFX_PANEL)

	arg0_84.redPacketUI:Find("panel/got/item/icon_bg"):GetComponent(typeof(Image)).enabled = false
	arg0_84.redPacketUI:Find("panel/got/item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

	setText(arg0_84.redPacketUI:Find("panel/got/awardCount"), var0_84.content[3])

	if var0_84.type == 1 then
		SetActive(arg0_84.redPacketUI:Find("panel/got/detailBtn"), false)
	else
		SetActive(arg0_84.redPacketUI:Find("panel/got/detailBtn"), true)
		onButton(arg0_84, arg0_84.redPacketUI:Find("panel/got/detailBtn"), function()
			SetActive(arg0_84.redPacketUI:Find("panel/panelBg"), false)
			SetActive(arg0_84.redPacketUI:Find("panel/openImg"), true)
			SetActive(arg0_84.redPacketUI:Find("panel/got"), false)
			SetActive(arg0_84.redPacketUI:Find("panel/detail"), true)

			local var0_86 = 0
			local var1_86 = 0
			local var2_86 = UIItemList.New(arg0_84.redPacketUI:Find("panel/detail/detailScroll/Viewport/Content"), arg0_84.redPacketUI:Find("panel/detail/detailScroll/Viewport/Content/charaGetCard"))

			var2_86:make(function(arg0_87, arg1_87, arg2_87)
				if arg0_87 == UIItemList.EventUpdate then
					local var0_87 = var0_84.group_receive[arg1_87 + 1]
					local var1_87 = var0_87[1]
					local var2_87 = {
						var0_87[2],
						var0_87[3],
						var0_87[4]
					}

					if var0_87[1] ~= 0 then
						local var3_87 = "unknown"

						if var1_0[var1_87] then
							var3_87 = var1_0[var1_87].sculpture
						end

						setImageSprite(arg2_87:Find("charaBg/chara"), LoadSprite("qicon/" .. var3_87), false)
					else
						setImageSprite(arg2_87:Find("charaBg/chara"), GetSpriteFromAtlas("ui/InstagramUI_atlas", "txdi_3"), false)
					end

					local var4_87 = Drop.Create(var2_87)

					var4_87.count = 0

					updateDrop(arg2_87:Find("item"), var4_87)
					onButton(arg0_84, arg2_87:Find("item"), function()
						arg0_84:emit(BaseUI.ON_DROP, var4_87)
					end, SFX_PANEL)

					arg2_87:Find("item/icon_bg"):GetComponent(typeof(Image)).enabled = false
					arg2_87:Find("item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

					setText(arg2_87:Find("awardCount"), var0_87[4])

					if var0_87[4] > var1_86 then
						var0_86 = arg1_87
						var1_86 = var0_87[4]
					end
				end
			end)
			var2_86:align(#var0_84.group_receive)

			for iter0_86 = 1, #var0_84.group_receive do
				SetActive(arg0_84.redPacketUI:Find("panel/detail/detailScroll/Viewport/Content"):GetChild(iter0_86 - 1):Find("charaBg/king"), var0_86 == iter0_86 - 1)
			end
		end, SFX_PANEL)
	end
end

function var0_0.CloseRedPacketPanel(arg0_89)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_89.redPacketUI, arg0_89._tf:Find("subPages"))
	SetActive(arg0_89.redPacketUI, false)
end

function var0_0.SetData(arg0_90)
	local var0_90 = getProxy(InstagramChatProxy)

	arg0_90.allChatList = var0_90:GetChatList()
	arg0_90.chatList = table.insertto({}, arg0_90.allChatList)

	var0_90:SortChatList()
end

function var0_0.willExit(arg0_91)
	local var0_91 = arg0_91.rightPanel:Find("chat/paintingMask/painting")

	if arg0_91.paintingName then
		retPaintingPrefab(var0_91, arg0_91.paintingName)

		arg0_91.paintingName = nil
	end

	arg0_91:RemoveAllTimer()
	arg0_91:EixtOfficialAccounts()
end

function var0_0.StartTimer(arg0_92, arg1_92, arg2_92)
	local var0_92 = Timer.New(arg1_92, arg2_92, 1)

	var0_92:Start()
	table.insert(arg0_92.timerList, var0_92)
end

function var0_0.RemoveAllTimer(arg0_93)
	for iter0_93, iter1_93 in ipairs(arg0_93.timerList) do
		iter1_93:Stop()
	end

	arg0_93.timerList = {}
end

function var0_0.StartTimer2(arg0_94, arg1_94, arg2_94)
	arg0_94.timer = Timer.New(arg1_94, arg2_94, 1)

	arg0_94.timer:Start()
end

function var0_0.SpeedUpMessage(arg0_95)
	local var0_95 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var1_95 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_95, iter1_95 in ipairs(arg0_95.timerList) do
		if iter1_95.running then
			if iter1_95.duration == var1_95 then
				iter1_95.time = 0.05
			elseif iter1_95.time - var0_95 < 0.05 then
				iter1_95.time = 0.05

				arg0_95:StartTimer2(function()
					arg0_95:SpeedUpWaiting()
				end, 0.05)
			else
				iter1_95.time = iter1_95.time - var0_95
			end
		end
	end
end

function var0_0.SpeedUpWaiting(arg0_97)
	local var0_97 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_97, iter1_97 in ipairs(arg0_97.timerList) do
		if iter1_97.running and iter1_97.duration == var0_97 then
			iter1_97.time = 0.05

			break
		end
	end
end

function var0_0.ChangeFresh(arg0_98)
	arg0_98.canFresh = true
end

function var0_0.ChangeCharaTextFunc(arg0_99, arg1_99, arg2_99)
	local function var0_99(arg0_100)
		if arg0_100:Find("chat/id"):GetComponent(typeof(Text)).text == tostring(arg1_99) then
			setText(arg0_100:Find("chat/msg"), arg2_99)
		end
	end

	for iter0_99 = 0, arg0_99.charaScrollContent.childCount - 1 do
		local var1_99 = arg0_99.charaScrollContent:GetChild(iter0_99)

		var0_99(var1_99)
	end
end

function var0_0.ResetCharaTextFunc(arg0_101, arg1_101)
	local function var0_101(arg0_102)
		if arg0_102:Find("chat/id"):GetComponent(typeof(Text)).text == tostring(arg1_101) then
			setText(arg0_102:Find("chat/msg"), arg0_102:Find("chat/displayWord"):GetComponent(typeof(Text)).text)
		end
	end

	for iter0_101 = 0, arg0_101.charaScrollContent.childCount - 1 do
		local var1_101 = arg0_101.charaScrollContent:GetChild(iter0_101)

		var0_101(var1_101)
	end
end

function var0_0.SetEndAniEvent(arg0_103, arg1_103, arg2_103)
	local var0_103 = arg1_103:GetComponent(typeof(DftAniEvent))

	if var0_103 then
		var0_103:SetEndEvent(function()
			arg2_103()
			var0_103:SetEndEvent(nil)
		end)
	end
end

function var0_0.onBackPressed(arg0_105)
	if isActive(arg0_105.filterUI) then
		arg0_105:CloseFilterPanel()

		return
	end

	if isActive(arg0_105.topicUI) then
		arg0_105:CloseTopicPanel()

		return
	end

	if isActive(arg0_105.backgroundUI) then
		arg0_105:CloseBackgroundPanel()

		return
	end

	if isActive(arg0_105.redPacketUI) then
		arg0_105:CloseRedPacketPanel()

		return
	end

	if isActive(arg0_105.rightOfficialAccountsPanel) and isActive(arg0_105.rightOfficialAccountsInfoPanel) then
		arg0_105:ExitOfficialAccountsInfo()

		return
	end

	arg0_105:emit(InstagramChatMediator.CLOSE_ALL)
end

function var0_0.InitOfficialAccounts(arg0_106)
	arg0_106.rightOfficialAccountsListPanel = arg0_106.rightOfficialAccountsPanel:Find("officialAccountsPanel")
	arg0_106.rightOfficialAccountsInfoPanel = arg0_106.rightOfficialAccountsPanel:Find("officialAccountsInfoPanel")

	setText(arg0_106.rightOfficialAccountsListPanel:Find("topBg/Text"), i18n("juusoa_title"))
	setText(arg0_106.rightOfficialAccountsInfoPanel:Find("topBg/Text"), i18n("juusoa_title"))

	arg0_106.officialAccountsScroll = arg0_106.rightOfficialAccountsListPanel:Find("charaScroll"):GetComponent("LScrollRect")
	arg0_106.officialAccountsScroll.onInitItem = handler(arg0_106, arg0_106.OfficialAccountsInitItem)
	arg0_106.officialAccountsScroll.onUpdateItem = handler(arg0_106, arg0_106.OfficialAccountsUpdateItem)
	arg0_106.downloadmgr = BulletinBoardMgr.Inst
	arg0_106.sprites = {}
	arg0_106.toDownloadList = {}
	arg0_106.officialAccountsInfoScroll = arg0_106.rightOfficialAccountsInfoPanel:Find("scroll"):GetComponent(typeof(ScrollRect))
	arg0_106.officialAccountsInfoItem = arg0_106.rightOfficialAccountsInfoPanel:Find("scroll/content/infoItem")
	arg0_106.commentList = UIItemList.New(arg0_106.rightOfficialAccountsInfoPanel:Find("scroll/content/commentPanel"), arg0_106.rightOfficialAccountsInfoPanel:Find("scroll/content/commentPanel/tpl"))
	arg0_106.commentPanel = arg0_106.rightOfficialAccountsInfoPanel:Find("last/bg2")
	arg0_106.optionalPanel = arg0_106.rightOfficialAccountsInfoPanel:Find("last/bg2/option")

	setActive(arg0_106.rightOfficialAccountsPanel, false)
	setActive(arg0_106.rightOfficialAccountsInfoPanel, false)
end

function var0_0.UpdateOfficialAccounts(arg0_107, arg1_107)
	setActive(arg0_107.rightChatPanel, false)
	setActive(arg0_107.rightOfficialAccountsPanel, true)
	setActive(arg0_107.rightOfficialAccountsListPanel, true)
	setActive(arg0_107.rightOfficialAccountsInfoPanel, false)

	arg0_107.currentChat = arg1_107
	arg0_107.instagramOfficialAccounts = {}

	for iter0_107, iter1_107 in pairs(getProxy(InstagramProxy):GetOfficialAccounts()) do
		table.insert(arg0_107.instagramOfficialAccounts, iter1_107)
	end

	table.sort(arg0_107.instagramOfficialAccounts, function(arg0_108, arg1_108)
		return arg0_108.id > arg1_108.id
	end)
	arg0_107.officialAccountsScroll:SetTotalCount(#arg0_107.instagramOfficialAccounts)
end

function var0_0.OfficialAccountsInitItem(arg0_109, arg1_109)
	arg0_109.officialAccountsItemList[arg1_109] = InstagramOfficialAccountsItem.New(tf(arg1_109), arg0_109)
end

function var0_0.OfficialAccountsUpdateItem(arg0_110, arg1_110, arg2_110)
	local var0_110 = arg0_110.officialAccountsItemList[arg2_110]

	if var0_110 == nil then
		arg0_110:OfficialAccountsInitItem(arg2_110)

		var0_110 = arg0_110.officialAccountsItemList[arg2_110]
	end

	local var1_110 = arg0_110.instagramOfficialAccounts[arg1_110 + 1]
	local var2_110 = tf(arg2_110)

	var0_110:SetData(var1_110.id)
	arg0_110:SetImageByUrl(var1_110.oaListPic, var2_110:Find("Image"):GetComponent(typeof(RawImage)))
	onButton(arg0_110, var2_110, function()
		arg0_110.currentOfficalID = var1_110.id

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildJuusOfficialAccountsClick(var1_110.id))
		arg0_110:ShowOfficialAccountsInfo(var1_110)
		arg0_110:ReadOfficialAccountComment()

		arg0_110.officialAccountsInfoScroll.verticalNormalizedPosition = 1
	end, SFX_PANEL)
end

function var0_0.ShowOfficialAccountsInfo(arg0_112, arg1_112)
	setActive(arg0_112.rightOfficialAccountsListPanel, false)
	setActive(arg0_112.rightOfficialAccountsInfoPanel, true)
	arg0_112:CloseCommentPanel()
	onButton(arg0_112, arg0_112.rightOfficialAccountsInfoPanel:Find("topBg"), function()
		arg0_112:ExitOfficialAccountsInfo()
	end, SFX_PANEL)
	setScrollText(arg0_112.officialAccountsInfoItem:Find("title/Text"), arg1_112:getConfig("title"))
	setText(arg0_112.officialAccountsInfoItem:Find("content"), arg1_112.text)
	arg0_112:SetImageByUrl(arg1_112:GetImage(), arg0_112.officialAccountsInfoItem:Find("Image/Image"):GetComponent(typeof(RawImage)))
	setText(arg0_112.officialAccountsInfoItem:Find("bottom/time"), arg1_112:GetPushTime())
	arg0_112:UpdateLinkBtn(arg1_112.id)
	onButton(arg0_112, arg0_112.officialAccountsInfoItem:Find("bottom/time/share"), function()
		arg0_112:emit(InstagramChatMediator.ON_OFFICIAL_ACCOUNTS_OPERATE, ActivityConst.INSTAGRAM_OP_SHARE, arg1_112.id)
	end, SFX_PANEL)
	arg0_112:UpdateCommentList(arg1_112.id)
	Canvas.ForceUpdateCanvases()
	onToggle(arg0_112, arg0_112.commentPanel, function(arg0_115)
		if arg0_115 then
			arg0_112:OpenCommentPanel(arg1_112.id)
		else
			arg0_112:CloseCommentPanel()
		end
	end, SFX_PANEL)
end

function var0_0.ExitOfficialAccountsInfo(arg0_116)
	setActive(arg0_116.rightOfficialAccountsListPanel, true)
	setActive(arg0_116.rightOfficialAccountsInfoPanel, false)

	arg0_116.currentOfficalID = nil
end

function var0_0.UpdateLinkBtn(arg0_117, arg1_117)
	local var0_117 = getProxy(InstagramProxy):GetOfficialAccounts()[arg1_117]
	local var1_117 = var0_117:IsLiking()
	local var2_117 = arg0_117.officialAccountsInfoItem:Find("bottom/notCare")

	if not var1_117 then
		onButton(arg0_117, var2_117, function()
			arg0_117:emit(InstagramChatMediator.ON_OFFICIAL_ACCOUNTS_OPERATE, ActivityConst.INSTAGRAM_OP_LIKE, var0_117.id)
		end, SFX_PANEL)
	else
		removeOnButton(var2_117)
	end

	setActive(var2_117, not var1_117)
	setActive(arg0_117.officialAccountsInfoItem:Find("bottom/care"), var1_117)
	setText(arg0_117.officialAccountsInfoItem:Find("bottom/careText"), i18n("ins_word_like", var0_117:GetLikeCnt()))
end

function var0_0.UpdateCommentList(arg0_119, arg1_119)
	if arg0_119.currentOfficalID ~= arg1_119 then
		return
	end

	local var0_119 = getProxy(InstagramProxy):GetOfficialAccounts()[arg1_119]

	if not var0_119 then
		return
	end

	local var1_119, var2_119 = var0_119:GetCanDisplayComments()

	table.sort(var1_119, function(arg0_120, arg1_120)
		return arg0_120.time < arg1_120.time
	end)
	arg0_119.commentList:make(function(arg0_121, arg1_121, arg2_121)
		if arg0_121 == UIItemList.EventUpdate then
			local var0_121 = var1_119[arg1_121 + 1]
			local var1_121 = var0_121:HasReply()

			setText(arg2_121:Find("main/reply"), var0_121:GetReplyBtnTxt())

			local var2_121 = var0_121:GetContent()
			local var3_121 = SwitchSpecialChar(var2_121)

			setText(arg2_121:Find("main/content"), HXSet.hxLan(var3_121))
			setText(arg2_121:Find("main/bubble/Text"), var0_121:GetReplyCnt())
			setText(arg2_121:Find("main/time"), var0_121:GetTime())

			if var0_121:GetType() == Instagram.TYPE_PLAYER_COMMENT then
				local var4_121, var5_121 = var0_121:GetIcon()

				setImageSprite(arg2_121:Find("main/head/icon"), GetSpriteFromAtlas(var4_121, var5_121))
			else
				setImageSprite(arg2_121:Find("main/head/icon"), LoadSprite("qicon/" .. var0_121:GetIcon()), false)
			end

			if var1_121 then
				onToggle(arg0_119, arg2_121:Find("main/bubble"), function(arg0_122)
					setActive(arg2_121:Find("replys"), arg0_122)
				end, SFX_PANEL)
				arg0_119:UpdateReplys(arg2_121, var0_121)
				triggerToggle(arg2_121:Find("main/bubble"), true)
			else
				setActive(arg2_121:Find("replys"), false)
				triggerToggle(arg2_121:Find("main/bubble"), false)
			end

			arg2_121:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var1_121
		end
	end)
	Canvas.ForceUpdateCanvases()
	arg0_119.commentList:align(#var1_119)
end

function var0_0.UpdateReplys(arg0_123, arg1_123, arg2_123)
	local var0_123, var1_123 = arg2_123:GetCanDisplayReply()
	local var2_123 = UIItemList.New(arg1_123:Find("replys"), arg1_123:Find("replys/sub"))

	table.sort(var0_123, function(arg0_124, arg1_124)
		if arg0_124.level == arg1_124.level then
			if arg0_124.time == arg1_124.time then
				return arg0_124.id < arg1_124.id
			else
				return arg0_124.time < arg1_124.time
			end
		else
			return arg0_124.level < arg1_124.level
		end
	end)
	var2_123:make(function(arg0_125, arg1_125, arg2_125)
		if arg0_125 == UIItemList.EventUpdate then
			local var0_125 = var0_123[arg1_125 + 1]

			setImageSprite(arg2_125:Find("head/icon"), LoadSprite("qicon/" .. var0_125:GetIcon()), false)

			local var1_125 = var0_125:GetContent()
			local var2_125 = SwitchSpecialChar(var1_125)

			setText(arg2_125:Find("content"), HXSet.hxLan(var2_125))
		end
	end)
	var2_123:align(#var0_123)
end

function var0_0.OpenCommentPanel(arg0_126, arg1_126)
	local var0_126 = getProxy(InstagramProxy):GetOfficialAccounts()[arg1_126]

	if not var0_126:CanOpenComment() then
		return
	end

	setActive(arg0_126.optionalPanel, true)

	local var1_126 = var0_126:GetOptionComment()

	arg0_126.commentPanel.sizeDelta = Vector2(0, #var1_126 * 120 + 40)

	local var2_126 = UIItemList.New(arg0_126.optionalPanel, arg0_126.optionalPanel:Find("option1"))

	var2_126:make(function(arg0_127, arg1_127, arg2_127)
		if arg0_127 == UIItemList.EventUpdate then
			local var0_127 = arg1_127 + 1
			local var1_127 = var1_126[var0_127].text
			local var2_127 = var1_126[var0_127].id
			local var3_127 = var1_126[var0_127].index

			setText(arg2_127:Find("Text"), HXSet.hxLan(var1_127))
			onButton(arg0_126, arg2_127, function()
				arg0_126:emit(InstagramChatMediator.ON_OFFICIAL_ACCOUNTS_OPERATE, ActivityConst.INSTAGRAM_OP_COMMENT, arg1_126, var2_127, var3_127)
				arg0_126:CloseCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_126:align(#var1_126)
end

function var0_0.CloseCommentPanel(arg0_129)
	arg0_129.commentPanel.sizeDelta = Vector2(0, 0)

	setActive(arg0_129.optionalPanel, false)
end

function var0_0.ReadOfficialAccountComment(arg0_130)
	if arg0_130.currentChat and arg0_130.currentChat.chatType == InstagramConst.INSTAGRAM_CHAT_TYPE.OFFICIAL_ACCOUNT and arg0_130.currentOfficalID then
		local var0_130 = getProxy(InstagramProxy):GetOfficialAccounts()[arg0_130.currentOfficalID]

		if var0_130 and not var0_130:IsReaded() then
			arg0_130:emit(InstagramChatMediator.ON_OFFICIAL_ACCOUNTS_OPERATE, ActivityConst.INSTAGRAM_OP_MARK_READ, arg0_130.currentOfficalID)
		end
	end
end

function var0_0.RefreshOfficialAccountTips(arg0_131)
	for iter0_131, iter1_131 in pairs(arg0_131.officialAccountsItemList) do
		iter1_131:RefreshTip()
	end

	arg0_131.charaScrollrect:SetTotalCount(#arg0_131.chatList)
end

function var0_0.SetImageByUrl(arg0_132, arg1_132, arg2_132, arg3_132)
	if not arg1_132 or arg1_132 == "" then
		setActive(arg2_132.gameObject, false)

		if arg3_132 then
			arg3_132()
		end
	else
		setActive(arg2_132.gameObject, true)

		local var0_132 = arg0_132.sprites[arg1_132]

		if var0_132 then
			arg2_132.texture = var0_132

			if arg3_132 then
				arg3_132()
			end
		else
			arg2_132.enabled = false

			arg0_132.downloadmgr:GetTexture("ins", "1", arg1_132, UnityEngine.Events.UnityAction_UnityEngine_Texture(function(arg0_133)
				if arg0_132.exited then
					return
				end

				if not arg0_132.sprites then
					return
				end

				arg0_132.sprites[arg1_132] = arg0_133
				arg2_132.texture = arg0_133
				arg2_132.enabled = true

				if arg3_132 then
					arg3_132()
				end
			end))
			table.insert(arg0_132.toDownloadList, arg1_132)
		end
	end
end

function var0_0.AddOfficialAccountsTimer(arg0_134)
	arg0_134:StopOfficialAccountsTimer()

	local var0_134 = getProxy(InstagramProxy):GetOfficialAccounts()
	local var1_134 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_134, iter1_134 in pairs(var0_134) do
		local var2_134 = iter1_134:GetFastestRefreshTime()

		if var2_134 then
			local var3_134 = var2_134 - var1_134

			if var3_134 <= 0 then
				arg0_134:emit(InstagramChatMediator.ON_OFFICIAL_ACCOUNTS_OPERATE, ActivityConst.INSTAGRAM_OP_UPDATE, iter1_134.id)
			else
				arg0_134.officialAccountsTimerList[iter1_134.id] = Timer.New(function()
					arg0_134:emit(InstagramChatMediator.ON_OFFICIAL_ACCOUNTS_OPERATE, ActivityConst.INSTAGRAM_OP_UPDATE, iter1_134.id)
				end, var3_134, 1)

				arg0_134.officialAccountsTimerList[iter1_134.id]:Start()
			end
		end
	end
end

function var0_0.StopOfficialAccountsTimer(arg0_136)
	for iter0_136, iter1_136 in pairs(arg0_136.officialAccountsTimerList) do
		arg0_136.officialAccountsTimerList[iter0_136]:Stop()
	end

	arg0_136.officialAccountsTimerList = {}
end

function var0_0.EixtOfficialAccounts(arg0_137)
	arg0_137:StopOfficialAccountsTimer()

	arg0_137.officialAccountsItemList = nil
	arg0_137.exited = true
	arg0_137.sprites = nil

	for iter0_137, iter1_137 in ipairs(arg0_137.toDownloadList or {}) do
		arg0_137.downloadmgr:StopLoader(iter1_137)
	end

	arg0_137.toDownloadList = {}
end

return var0_0
