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
	12
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
	"word_shipNation_other"
}

function var0_0.init(arg0_3)
	arg0_3.leftPanel = arg0_3._tf:Find("main/leftPanel")
	arg0_3.filterBtn = arg0_3.leftPanel:Find("leftTop/filter")
	arg0_3.isFiltered = arg0_3.filterBtn:Find("isFiltered")
	arg0_3.charaScrollrect = arg0_3.leftPanel:Find("charaScroll"):GetComponent("LScrollRect")
	arg0_3.charaScrollContent = arg0_3.leftPanel:Find("charaScroll/Viewport/Content")
	arg0_3.rightPanel = arg0_3._tf:Find("main/rightPanel")
	arg0_3.characterName = arg0_3.rightPanel:Find("rightTop/name")
	arg0_3.careBtn = arg0_3.rightPanel:Find("rightTop/careBtn")
	arg0_3.topicBtn = arg0_3.rightPanel:Find("rightTop/topicBtn")
	arg0_3.backgroundBtn = arg0_3.rightPanel:Find("rightTop/backgroundBtn")
	arg0_3.messageList = UIItemList.New(arg0_3.rightPanel:Find("messageScroll/Viewport/Content"), arg0_3.rightPanel:Find("messageScroll/Viewport/Content/messageCard"))
	arg0_3.optionPanel = arg0_3.rightPanel:Find("optionPanel")
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
	setText(arg0_3.topicUI:Find("panel/topicScroll/Viewport/Content/topic/waiting"), i18n("juuschat_chattip3"))
	setText(arg0_3.topicUI:Find("panel/topicScroll/Viewport/Content/topic/selected/Text"), i18n("juuschat_label2"))
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

	local var0_3 = arg0_3.rightPanel:Find("messageScroll/Scrollbar Vertical"):GetComponent(typeof(RectTransform))

	arg0_3.messageScrollWidth = var0_3.rect.width
	arg0_3.messageScrollHeight = var0_3.rect.height

	arg0_3.filterUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_3.topicUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_3.backgroundUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
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
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	return
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.chatList[arg1_8 + 1]
	local var1_8 = tf(arg2_8)

	setActive(var1_8, true)
	setImageSprite(var1_8:Find("charaBg/chara"), LoadSprite("qicon/" .. var0_8.sculpture), false)
	setText(var1_8:Find("name"), var0_8.name)

	local var2_8 = var0_8:GetDisplayWord()

	if not arg0_8.currentChat or arg0_8.currentChat.characterId ~= var0_8.characterId or not arg0_8.isSlowMsg then
		setText(var1_8:Find("msg"), var2_8)
	end

	setText(var1_8:Find("displayWord"), var2_8)
	SetActive(var1_8:Find("care"), var0_8.care == 1)

	if var0_8.care == 1 and arg0_8.careAniTriggerId and arg0_8.careAniTriggerId == var0_8.characterId then
		arg0_8.careAniTriggerId = nil

		var1_8:Find("care"):GetComponent(typeof(Animation)):Play("anim_newinstagram_care")
	end

	if arg0_8.currentChat then
		SetActive(var1_8:Find("frame"), arg0_8.currentChat == var0_8)
	end

	SetActive(var1_8:Find("tip"), var0_8:GetCharacterEndFlag() == 0)
	setText(var1_8:Find("id"), var0_8.characterId)
	onButton(arg0_8, var1_8, function()
		if arg0_8.currentChat and arg0_8.currentChat.characterId ~= var0_8.characterId then
			arg0_8:ResetCharaTextFunc(arg0_8.currentChat.characterId)
		end

		arg0_8.currentChat = var0_8

		SetActive(arg0_8.rightPanel, true)
		SetActive(arg0_8._tf:Find("main/rightNoMessageBg"), false)
		arg0_8:UpdateChatContent(var0_8, false, false)
		arg0_8:SetTopicPanel(var0_8)
		arg0_8:SetBackgroundPanel(var0_8)

		for iter0_9 = 0, arg0_8.charaScrollContent.childCount - 1 do
			SetActive(arg0_8.charaScrollContent:GetChild(iter0_9):Find("frame"), false)
		end

		SetActive(var1_8:Find("frame"), true)

		function arg0_8.cancelFrame()
			if not IsNil(var1_8) then
				SetActive(var1_8:Find("frame"), false)
			end
		end

		local var0_9 = arg0_8.rightPanel:GetComponent(typeof(Animation))

		var0_9:Stop()
		var0_9:Play("anim_newinstagram_chat_right_in")
	end, SFX_PANEL)
end

function var0_0.UpdateCharaList(arg0_11, arg1_11, arg2_11)
	if not arg0_11.chatList or #arg0_11.chatList == 0 then
		SetActive(arg0_11.leftPanel, false)
		SetActive(arg0_11.rightPanel, false)
		SetActive(arg0_11._tf:Find("main/noMessageBg"), true)
		SetActive(arg0_11._tf:Find("main/noFilteredMessageBg"), false)
		SetActive(arg0_11._tf:Find("main/rightNoMessageBg"), false)

		return
	end

	if not arg0_11.currentChat then
		SetActive(arg0_11.rightPanel, false)
		SetActive(arg0_11._tf:Find("main/rightNoMessageBg"), true)
	else
		SetActive(arg0_11.rightPanel, true)
		SetActive(arg0_11._tf:Find("main/rightNoMessageBg"), false)
	end

	arg0_11.isSlowMsg = arg1_11

	arg0_11:SetFilterResult()

	if arg0_11.currentChat then
		arg0_11:UpdateChatContent(arg0_11.currentChat, arg1_11, arg2_11)
		arg0_11:SetTopicPanel(arg0_11.currentChat)
	end
end

function var0_0.UpdateChatContent(arg0_12, arg1_12, arg2_12, arg3_12)
	SetActive(arg0_12.rightPanel, true)
	setText(arg0_12.characterName, arg1_12.name)

	local var0_12 = arg0_12.careBtn:Find("care")

	SetActive(var0_12, arg1_12.care == 1)
	onButton(arg0_12, arg0_12.careBtn, function()
		local var0_13 = arg1_12.care == 0 and 1 or 0

		arg0_12:emit(InstagramChatMediator.CHANGE_CARE, arg1_12.characterId, var0_13)

		arg0_12.careAniTriggerId = arg1_12.characterId
	end, SFX_PANEL)

	local var1_12 = arg0_12.rightPanel:Find("paintingMask")
	local var2_12 = var1_12:Find("painting")
	local var3_12 = arg0_12.rightPanel:Find("groupBackground")

	if arg1_12.type == 1 then
		SetActive(var1_12, true)
		SetActive(var3_12, false)

		local var4_12 = "unknown"

		if arg1_12.skinId == 0 then
			var4_12 = arg1_12:GetPainting()
		else
			for iter0_12, iter1_12 in ipairs(arg1_12.skins) do
				if iter1_12.id == arg1_12.skinId then
					var4_12 = iter1_12.painting
				end
			end
		end

		if not arg0_12.paintingName then
			setPaintingPrefabAsync(var2_12, var4_12, "pifu")

			arg0_12.paintingName = var4_12
		elseif arg0_12.paintingName and arg0_12.paintingName ~= var4_12 then
			retPaintingPrefab(var2_12, arg0_12.paintingName)
			setPaintingPrefabAsync(var2_12, var4_12, "pifu")

			arg0_12.paintingName = var4_12
		end
	else
		SetActive(var1_12, false)
		SetActive(var3_12, true)

		if arg0_12.paintingName then
			retPaintingPrefab(var2_12, arg0_12.paintingName)

			arg0_12.paintingName = nil
		end

		setImageSprite(var3_12, LoadSprite("ui/InstagramChatBackgrounds_atlas", arg1_12.groupBackground), true)
	end

	local var5_12 = arg1_12.currentTopic:GetDisplayWordList()

	if not arg3_12 then
		arg0_12:UpdateOptionPanel(arg1_12.currentTopic, var5_12)
		arg0_12:UpdateMessageList(arg1_12.currentTopic, var5_12, arg2_12, arg1_12.characterId, arg1_12.type)
	end

	if not arg2_12 and arg1_12.currentTopic.readFlag == 0 then
		arg0_12:emit(InstagramChatMediator.SET_READED, {
			arg1_12.currentTopic.topicId
		})
	end
end

function var0_0.UpdateMessageList(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14, arg5_14)
	arg0_14:RemoveAllTimer()

	local var0_14

	for iter0_14 = #arg2_14, 1, -1 do
		if arg2_14[iter0_14].ship_group == 0 or arg2_14[iter0_14].type == 3 and arg1_14:RedPacketGotFlag(tonumber(arg2_14[iter0_14].param)) then
			var0_14 = iter0_14

			break
		end
	end

	local var1_14 = {}

	if var0_14 then
		for iter1_14 = var0_14, 1, -1 do
			if arg2_14[iter1_14].ship_group == 0 then
				table.insert(var1_14, iter1_14)
			else
				break
			end
		end
	end

	if arg0_14.shouldShowOption and arg3_14 then
		arg0_14:SetOptionPanelActive(false)
	end

	if arg3_14 then
		onButton(arg0_14, arg0_14.rightPanel:Find("messageScroll"), function()
			arg0_14:SpeedUpMessage()
		end, SFX_PANEL)
	end

	local var2_14 = GetComponent(arg0_14.rightPanel:Find("messageScroll"), typeof(ScrollRect))

	local function var3_14(arg0_16)
		local var0_16 = Vector2(0, arg0_16)

		var2_14.normalizedPosition = var0_16
	end

	local var4_14 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var5_14 = pg.gameset.juuschat_entering_time.key_value / 1000
	local var6_14 = var4_14 - var5_14

	arg0_14.messageList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg2_14[arg1_17 + 1]

			if var0_17.ship_group == 0 and var0_17.type == 0 then
				SetActive(arg2_17, false)

				return
			end

			local var1_17 = arg2_17:Find("charaMessageCard")
			local var2_17 = arg2_17:Find("playerReplyCard")

			SetActive(var1_17, var0_17.ship_group ~= 0)
			SetActive(var2_17, var0_17.ship_group == 0)

			if var0_17.ship_group ~= 0 and arg5_14 == 2 and var0_17.type ~= 5 then
				SetActive(arg2_17:Find("nameBar"), true)
				setText(arg2_17:Find("nameBar/Text"), var1_0[var0_17.ship_group].name)
			else
				SetActive(arg2_17:Find("nameBar"), false)
			end

			local var3_17

			if arg3_14 and var0_14 and arg1_17 + 1 > var0_14 then
				var3_17 = (arg1_17 + 1 - var0_14) * var4_14 - var5_14

				if #var1_14 > 1 then
					var3_17 = var3_17 + (#var1_14 - 1) * var6_14
				end
			end

			if var0_17.ship_group ~= 0 then
				local var4_17 = "unknown"

				if var1_0[var0_17.ship_group] then
					var4_17 = var1_0[var0_17.ship_group].sculpture
				end

				if var0_17.type ~= 5 then
					setImageSprite(arg2_17:Find("charaMessageCard/charaBg/chara"), LoadSprite("qicon/" .. var4_17), false)
				end

				if var0_17.type == 1 then
					arg0_14:SetCharaMessageCardActive(var1_17, {
						3
					})
					setText(arg2_17:Find("charaMessageCard/msgBox/msg"), var0_17.param)

					if arg3_14 and var0_14 and arg1_17 + 1 > var0_14 then
						SetActive(arg2_17, false)
						arg0_14:StartTimer(function()
							SetActive(arg2_17, true)
							arg2_17:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_17:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_17:Find("charaMessageCard/msgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
							arg0_14:StartTimer(function()
								SetActive(arg2_17:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_17:Find("charaMessageCard/msgBox"), true)
								arg2_17:Find("charaMessageCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")

								if arg1_17 + 1 ~= #arg2_14 then
									arg0_14:ChangeCharaTextFunc(arg4_14, var0_17.param)
								else
									arg0_14:emit(InstagramChatMediator.SET_READED, {
										arg1_14.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
								arg0_14:SetEndAniEvent(arg2_17:Find("charaMessageCard/msgBox"), function()
									if arg0_14.shouldShowOption and arg1_17 + 1 == #arg2_14 then
										arg0_14:SetOptionPanelActive(true)
									end
								end)
							end, var5_14)
						end, var3_17)
					end
				elseif var0_17.type == 2 then
					arg0_14:SetCharaMessageCardActive(var1_17, {
						2,
						7
					})
					pg.CriMgr.GetInstance():GetCueInfo("cv-" .. var0_17.ship_group, var0_17.param[1], function(arg0_21)
						setText(arg2_17:Find("charaMessageCard/voiceBox/time"), tostring(math.ceil(tonumber(tostring(arg0_21.length)) / 1000)) .. "\"")
					end)
					onButton(arg0_14, arg2_17:Find("charaMessageCard/voiceBox"), function()
						pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/cv/" .. var0_17.ship_group .. "/" .. var0_17.param[1])
					end, SFX_PANEL)
					setText(arg2_17:Find("charaMessageCard/voiceMsgBox/voiceMsg/msg"), var0_17.param[2])

					if arg3_14 and var0_14 and arg1_17 + 1 > var0_14 then
						SetActive(arg2_17, false)
						arg0_14:StartTimer(function()
							SetActive(arg2_17, true)
							arg2_17:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_17:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_17:Find("charaMessageCard/voiceBox"), false)
							SetActive(arg2_17:Find("charaMessageCard/voiceMsgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
							arg0_14:StartTimer(function()
								SetActive(arg2_17:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_17:Find("charaMessageCard/voiceBox"), true)
								SetActive(arg2_17:Find("charaMessageCard/voiceMsgBox"), true)
								arg2_17:Find("charaMessageCard/voiceBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")
								arg2_17:Find("charaMessageCard/voiceMsgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_voicetip_in")

								if arg1_17 + 1 ~= #arg2_14 then
									arg0_14:ChangeCharaTextFunc(arg4_14, "<color=#ff6666>" .. i18n("juuschat_chattip1") .. "</color>")
								else
									arg0_14:emit(InstagramChatMediator.SET_READED, {
										arg1_14.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
								arg0_14:SetEndAniEvent(arg2_17:Find("charaMessageCard/voiceBox"), function()
									if arg0_14.shouldShowOption and arg1_17 + 1 == #arg2_14 then
										arg0_14:SetOptionPanelActive(true)
									end
								end)
							end, var5_14)
						end, var3_17)
					end
				elseif var0_17.type == 3 then
					arg0_14:SetCharaMessageCardActive(var1_17, {
						5
					})

					local var5_17 = var2_0[tonumber(var0_17.param)]

					setText(arg2_17:Find("charaMessageCard/redPacket/desc"), var5_17.desc)

					local var6_17 = arg1_14:RedPacketGotFlag(var5_17.id)

					SetActive(arg2_17:Find("charaMessageCard/redPacket/got"), var6_17)
					arg0_14:SetRedPacketPanel(arg2_17:Find("charaMessageCard/redPacket"), var5_17, var6_17, var4_17, arg1_14.topicId, var0_17.id)

					if arg3_14 and var0_14 and arg1_17 + 1 == var0_14 then
						arg0_14:ChangeCharaTextFunc(arg4_14, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_17.param)].desc)
					end

					if arg3_14 and var0_14 and arg1_17 + 1 > var0_14 then
						SetActive(arg2_17, false)
						arg0_14:StartTimer(function()
							SetActive(arg2_17, true)
							arg2_17:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_17:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_17:Find("charaMessageCard/redPacket"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
							arg0_14:StartTimer(function()
								SetActive(arg2_17:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_17:Find("charaMessageCard/redPacket"), true)
								arg2_17:Find("charaMessageCard/redPacket"):GetComponent(typeof(Animation)):Play("anim_newinstagram_redpacket_in")

								if arg1_17 + 1 ~= #arg2_14 then
									arg0_14:ChangeCharaTextFunc(arg4_14, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_17.param)].desc)
								else
									arg0_14:emit(InstagramChatMediator.SET_READED, {
										arg1_14.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
								arg0_14:SetEndAniEvent(arg2_17:Find("charaMessageCard/redPacket"), function()
									if arg0_14.shouldShowOption and arg1_17 + 1 == #arg2_14 then
										arg0_14:SetOptionPanelActive(true)
									end
								end)
							end, var5_14)
						end, var3_17)
					end
				elseif var0_17.type == 4 then
					arg0_14:SetCharaMessageCardActive(var1_17, {
						4
					})
					arg0_14:ClearEmoji(arg2_17:Find("charaMessageCard/emoji/emoticon"))
					arg0_14:SetEmoji(arg2_17:Find("charaMessageCard/emoji/emoticon"), var3_0[tonumber(var0_17.param)].pic)

					if arg3_14 and var0_14 and arg1_17 + 1 > var0_14 then
						SetActive(arg2_17, false)
						arg0_14:StartTimer(function()
							SetActive(arg2_17, true)
							arg2_17:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_17:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_17:Find("charaMessageCard/emoji"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
							arg0_14:StartTimer(function()
								SetActive(arg2_17:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_17:Find("charaMessageCard/emoji"), true)
								arg2_17:Find("charaMessageCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								if arg1_17 + 1 ~= #arg2_14 then
									local var0_30 = var3_0[tonumber(var0_17.param)].desc
									local var1_30 = string.gsub(var0_30, "#%w+>", "#28af6e>")

									arg0_14:ChangeCharaTextFunc(arg4_14, var1_30)
								else
									arg0_14:emit(InstagramChatMediator.SET_READED, {
										arg1_14.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
								arg0_14:SetEndAniEvent(arg2_17:Find("charaMessageCard/emoji"), function()
									if arg0_14.shouldShowOption and arg1_17 + 1 == #arg2_14 then
										arg0_14:SetOptionPanelActive(true)
									end
								end)
							end, var5_14)
						end, var3_17)
					end
				elseif var0_17.type == 5 then
					arg0_14:SetCharaMessageCardActive(var1_17, {
						6
					})

					local var7_17 = var0_17.param

					for iter0_17 in string.gmatch(var0_17.param, "'%d+'") do
						local var8_17 = string.sub(iter0_17, 2, #iter0_17 - 1)

						var7_17 = string.gsub(var7_17, iter0_17, "<color=#93e9ff>" .. var1_0[tonumber(var8_17)].name .. "</color>")
					end

					setText(arg2_17:Find("charaMessageCard/systemTip/panel/Text"), var7_17)

					if arg3_14 and var0_14 and arg1_17 + 1 > var0_14 then
						SetActive(arg2_17, false)
						arg0_14:StartTimer(function()
							SetActive(arg2_17, true)
							arg2_17:Find("charaMessageCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							if arg1_17 + 1 ~= #arg2_14 then
								arg0_14:ChangeCharaTextFunc(arg4_14, var7_17)
							else
								arg0_14:emit(InstagramChatMediator.SET_READED, {
									arg1_14.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
							arg0_14:SetEndAniEvent(arg2_17:Find("charaMessageCard/systemTip"), function()
								if arg0_14.shouldShowOption and arg1_17 + 1 == #arg2_14 then
									arg0_14:SetOptionPanelActive(true)
								end
							end)
						end, var3_17)
					end
				end
			else
				if var0_17.type == 1 then
					arg0_14:SetPlayerMessageCardActive(var2_17, {
						0
					})
					setText(arg2_17:Find("playerReplyCard/msgBox/msg"), var0_17.param)
				elseif var0_17.type == 4 then
					arg0_14:SetPlayerMessageCardActive(var2_17, {
						1
					})
					arg0_14:ClearEmoji(arg2_17:Find("playerReplyCard/emoji/emoticon"))
					arg0_14:SetEmoji(arg2_17:Find("playerReplyCard/emoji/emoticon"), var3_0[tonumber(var0_17.param)].pic)
				elseif var0_17.type == 5 then
					arg0_14:SetPlayerMessageCardActive(var2_17, {
						2
					})

					local var9_17 = var0_17.param

					for iter1_17 in string.gmatch(var0_17.param, "'%d+'") do
						local var10_17 = string.sub(iter1_17, 2, #iter1_17 - 1)

						var9_17 = string.gsub(var9_17, iter1_17, "<color=#93e9ff>" .. var1_0[tonumber(var10_17)].name .. "</color>")
					end

					setText(arg2_17:Find("playerReplyCard/systemTip/panel/Text"), var9_17)
				end

				if arg3_14 and var0_14 and _.contains(var1_14, arg1_17 + 1) then
					if table.indexof(var1_14, arg1_17 + 1) < #var1_14 then
						SetActive(arg2_17, false)
						arg0_14:StartTimer(function()
							SetActive(arg2_17, true)

							if var0_17.type == 1 then
								arg2_17:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
								arg0_14:ChangeCharaTextFunc(arg4_14, var0_17.param)
							elseif var0_17.type == 4 then
								arg2_17:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								local var0_34 = var3_0[tonumber(var0_17.param)].desc
								local var1_34 = string.gsub(var0_34, "#%w+>", "#28af6e>")

								arg0_14:ChangeCharaTextFunc(arg4_14, var1_34)
							elseif var0_17.type == 5 then
								arg2_17:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

								local var2_34 = var0_17.param

								for iter0_34 in string.gmatch(var0_17.param, "'%d+'") do
									local var3_34 = string.sub(iter0_34, 2, #iter0_34 - 1)

									var2_34 = string.gsub(var2_34, iter0_34, "<color=#93e9ff>" .. var1_0[tonumber(var3_34)].name .. "</color>")
								end

								arg0_14:ChangeCharaTextFunc(arg4_14, var2_34)
							end

							if arg1_17 + 1 == #arg2_14 then
								arg0_14:emit(InstagramChatMediator.SET_READED, {
									arg1_14.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
						end, (#var1_14 - table.indexof(var1_14, arg1_17 + 1)) * var6_14)
					else
						if var0_17.type == 1 then
							arg2_17:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
							arg0_14:ChangeCharaTextFunc(arg4_14, var0_17.param)
						elseif var0_17.type == 4 then
							arg2_17:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

							local var11_17 = var3_0[tonumber(var0_17.param)].desc
							local var12_17 = string.gsub(var11_17, "#%w+>", "#28af6e>")

							arg0_14:ChangeCharaTextFunc(arg4_14, var12_17)
						elseif var0_17.type == 5 then
							arg2_17:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							local var13_17 = var0_17.param

							for iter2_17 in string.gmatch(var0_17.param, "'%d+'") do
								local var14_17 = string.sub(iter2_17, 2, #iter2_17 - 1)

								var13_17 = string.gsub(var13_17, iter2_17, "<color=#93e9ff>" .. var1_0[tonumber(var14_17)].name .. "</color>")
							end

							arg0_14:ChangeCharaTextFunc(arg4_14, var13_17)
						end

						if arg1_17 + 1 == #arg2_14 then
							arg0_14:emit(InstagramChatMediator.SET_READED, {
								arg1_14.topicId
							})
						end
					end
				end
			end

			if not arg1_14:isWaiting() and arg1_17 + 1 == #arg2_14 then
				if arg3_14 then
					if var0_17.ship_group ~= 0 then
						arg0_14:StartTimer(function()
							setActive(arg2_17:Find("end"), true)
						end, var3_17 + var4_14)
					else
						arg0_14:StartTimer(function()
							setActive(arg2_17:Find("end"), true)
						end, (#var1_14 - table.indexof(var1_14, arg1_17 + 1)) * var6_14 + var6_14)
					end
				else
					setActive(arg2_17:Find("end"), true)
				end
			else
				setActive(arg2_17:Find("end"), false)
			end
		end
	end)
	arg0_14.messageList:align(#arg2_14)

	if arg3_14 then
		Canvas.ForceUpdateCanvases()
		LeanTween.value(go(arg0_14.rightPanel:Find("messageScroll")), var2_14.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_14)):setEase(LeanTweenType.easeInOutCubic)
	else
		scrollToBottom(arg0_14.rightPanel:Find("messageScroll"))
	end
end

function var0_0.SetCharaMessageCardActive(arg0_37, arg1_37, arg2_37)
	if _.contains(arg2_37, 6) then
		SetActive(arg1_37:GetChild(0), false)
	else
		SetActive(arg1_37:GetChild(0), true)
	end

	for iter0_37 = 1, arg1_37.childCount - 1 do
		if _.contains(arg2_37, iter0_37) then
			SetActive(arg1_37:GetChild(iter0_37), true)
		else
			SetActive(arg1_37:GetChild(iter0_37), false)
		end
	end
end

function var0_0.SetPlayerMessageCardActive(arg0_38, arg1_38, arg2_38)
	for iter0_38 = 0, arg1_38.childCount - 1 do
		if _.contains(arg2_38, iter0_38) then
			SetActive(arg1_38:GetChild(iter0_38), true)
		else
			SetActive(arg1_38:GetChild(iter0_38), false)
		end
	end
end

function var0_0.SetEmoji(arg0_39, arg1_39, arg2_39)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg2_39, arg2_39, true, function(arg0_40)
		if not IsNil(arg1_39) then
			arg0_40.name = arg2_39
			tf(arg0_40).sizeDelta = arg1_39.sizeDelta
			tf(arg0_40).anchoredPosition = Vector2.zero

			local var0_40 = arg0_40:GetComponent("Animator")

			if var0_40 then
				var0_40.enabled = true
			end

			setParent(arg0_40, arg1_39, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg2_39, arg2_39, arg0_40)
		end
	end)
end

function var0_0.ClearEmoji(arg0_41, arg1_41)
	eachChild(arg1_41, function(arg0_42)
		local var0_42 = go(arg0_42)

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_42.name, var0_42.name, var0_42)
	end)
end

function var0_0.UpdateOptionPanel(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg2_43[#arg2_43].option

	if var0_43 and type(var0_43) == "table" then
		arg0_43.shouldShowOption = true
		arg0_43.optionCount = #var0_43

		arg0_43:SetOptionPanelActive(true)
		arg0_43.optionList:make(function(arg0_44, arg1_44, arg2_44)
			if arg0_44 == UIItemList.EventUpdate then
				local var0_44 = var0_43[arg1_44 + 1]

				setText(arg2_44:Find("Text"), HXSet.hxLan(var0_44[2]))
				onButton(arg0_43, arg2_44, function()
					arg0_43:emit(InstagramChatMediator.REPLY, arg1_43.topicId, arg2_43[#arg2_43].id, var0_44[1])
				end, SFX_PANEL)
			end
		end)
		arg0_43.optionList:align(#var0_43)
	else
		arg0_43:SetOptionPanelActive(false)

		arg0_43.shouldShowOption = false
	end
end

function var0_0.SetOptionPanelActive(arg0_46, arg1_46)
	SetActive(arg0_46.optionPanel, arg1_46)

	local var0_46 = arg0_46.rightPanel:Find("messageScroll/Viewport/Content"):GetComponent(typeof(VerticalLayoutGroup))
	local var1_46 = UnityEngine.RectOffset.New()

	var1_46.left = 0
	var1_46.right = 0
	var1_46.top = 0

	local var2_46 = arg0_46.rightPanel:Find("messageScroll/Scrollbar Vertical"):GetComponent(typeof(RectTransform))

	if arg1_46 then
		var1_46.bottom = 42 + 88 * arg0_46.optionCount
		var2_46.sizeDelta = Vector2(arg0_46.messageScrollWidth, -var1_46.bottom)
	else
		var1_46.bottom = 50
		var2_46.sizeDelta = Vector2(arg0_46.messageScrollWidth, 0)
	end

	var0_46.padding = var1_46

	scrollToBottom(arg0_46.rightPanel:Find("messageScroll"))
end

function var0_0.SetFilterPanel(arg0_47)
	arg0_47.readFilter = arg0_47.readFilter or var0_0.ReadType[1]
	arg0_47.typeFilter = arg0_47.typeFilter or var0_0.TypeType[1]
	arg0_47.campFilter = arg0_47.campFilter or {
		var0_0.CampIds[1]
	}

	local var0_47 = arg0_47.filterUI:Find("panel/filterScroll/Viewport/Content/read")
	local var1_47 = arg0_47.filterUI:Find("panel/filterScroll/Viewport/Content/type")
	local var2_47 = arg0_47.filterUI:Find("panel/filterScroll/Viewport/Content/camp")
	local var3_47 = UIItemList.New(var2_47, var2_47:Find("option"))

	onButton(arg0_47, arg0_47.filterBtn, function()
		SetActive(arg0_47.filterUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_47.filterUI)

		for iter0_48, iter1_48 in ipairs(var0_0.ReadType) do
			local var0_48 = var0_47:GetChild(iter0_48)
			local var1_48 = var0_48:Find("selectedFrame")

			SetActive(var1_48, arg0_47.readFilter == iter1_48)
			onButton(arg0_47, var0_48, function()
				for iter0_49, iter1_49 in ipairs(var0_0.ReadType) do
					SetActive(var0_47:GetChild(iter0_49):Find("selectedFrame"), false)
				end

				SetActive(var1_48, true)
			end, SFX_PANEL)
		end

		for iter2_48, iter3_48 in ipairs(var0_0.TypeType) do
			local var2_48 = var1_47:GetChild(iter2_48)
			local var3_48 = var2_48:Find("selectedFrame")

			SetActive(var3_48, arg0_47.typeFilter == iter3_48)
			onButton(arg0_47, var2_48, function()
				for iter0_50, iter1_50 in ipairs(var0_0.TypeType) do
					SetActive(var1_47:GetChild(iter0_50):Find("selectedFrame"), false)
				end

				SetActive(var3_48, true)
			end, SFX_PANEL)
		end

		var3_47:make(function(arg0_51, arg1_51, arg2_51)
			if arg0_51 == UIItemList.EventUpdate then
				setText(arg2_51:Find("Text"), i18n(var0_0.CampNames[arg1_51 + 1]))

				local var0_51 = arg2_51:Find("selectedFrame")

				SetActive(var0_51, _.contains(arg0_47.campFilter, var0_0.CampIds[arg1_51 + 1]))
				onButton(arg0_47, arg2_51, function()
					if arg1_51 == 0 then
						SetActive(var0_51, true)

						for iter0_52 = 2, #var0_0.CampIds do
							SetActive(var2_47:GetChild(iter0_52 - 1):Find("selectedFrame"), false)
						end
					else
						SetActive(var0_51, not isActive(var0_51))

						local var0_52 = true
						local var1_52 = true

						for iter1_52 = 2, #var0_0.CampIds do
							if not isActive(var2_47:GetChild(iter1_52 - 1):Find("selectedFrame")) then
								var0_52 = false
							end

							if isActive(var2_47:GetChild(iter1_52 - 1):Find("selectedFrame")) then
								var1_52 = false
							end
						end

						if var0_52 then
							SetActive(var2_47:GetChild(0):Find("selectedFrame"), true)

							for iter2_52 = 2, #var0_0.CampIds do
								SetActive(var2_47:GetChild(iter2_52 - 1):Find("selectedFrame"), false)
							end
						elseif var1_52 then
							SetActive(var2_47:GetChild(0):Find("selectedFrame"), true)
						else
							SetActive(var2_47:GetChild(0):Find("selectedFrame"), false)
						end
					end
				end, SFX_PANEL)
			end
		end)
		var3_47:align(#var0_0.CampIds)
	end, SFX_PANEL)
	onButton(arg0_47, arg0_47.filterUI:Find("bg"), function()
		arg0_47:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_47, arg0_47.filterUI:Find("panel/bottom/close"), function()
		arg0_47:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_47, arg0_47.filterUI:Find("panel/bottom/ok"), function()
		for iter0_55, iter1_55 in ipairs(var0_0.ReadType) do
			local var0_55 = var0_47:GetChild(iter0_55):Find("selectedFrame")

			if isActive(var0_55) then
				arg0_47.readFilter = iter1_55
			end
		end

		for iter2_55, iter3_55 in ipairs(var0_0.TypeType) do
			local var1_55 = var1_47:GetChild(iter2_55):Find("selectedFrame")

			if isActive(var1_55) then
				arg0_47.typeFilter = iter3_55
			end
		end

		arg0_47.campFilter = {}

		for iter4_55, iter5_55 in ipairs(var0_0.CampIds) do
			local var2_55 = var2_47:GetChild(iter4_55 - 1):Find("selectedFrame")

			if isActive(var2_55) then
				table.insert(arg0_47.campFilter, iter5_55)
			end
		end

		arg0_47:CloseFilterPanel()
		arg0_47:SetFilterResult()
	end, SFX_PANEL)
end

function var0_0.SetFilterResult(arg0_56)
	local var0_56 = true
	local var1_56 = false

	if not arg0_56.readFilter then
		arg0_56.readFilter = var0_0.ReadType[1]
		arg0_56.typeFilter = var0_0.TypeType[1]
		arg0_56.campFilter = {
			var0_0.CampIds[1]
		}
	end

	arg0_56.chatList = table.insertto({}, arg0_56.allChatList)

	for iter0_56 = #arg0_56.chatList, 1, -1 do
		local var2_56 = arg0_56.chatList[iter0_56]
		local var3_56 = true

		if arg0_56.readFilter ~= "all" then
			local var4_56 = arg0_56.readFilter == "hasReaded" and 1 or 0

			if var2_56:GetCharacterEndFlag() ~= var4_56 then
				var3_56 = false
			end
		end

		if arg0_56.typeFilter ~= "all" then
			local var5_56 = arg0_56.typeFilter == "single" and 1 or 2

			if var2_56.type ~= var5_56 then
				var3_56 = false
			end
		end

		if not _.contains(arg0_56.campFilter, 0) and not _.contains(arg0_56.campFilter, var2_56.nationality) then
			var3_56 = false
		end

		if not var3_56 then
			table.remove(arg0_56.chatList, iter0_56)
		end

		if var3_56 then
			var0_56 = false
		end

		if arg0_56.currentChat and arg0_56.currentChat.characterId == var2_56.characterId and var3_56 then
			var1_56 = true
		end
	end

	local var6_56 = arg0_56.readFilter == "all" and arg0_56.typeFilter == "all" and _.contains(arg0_56.campFilter, 0)

	SetActive(arg0_56.isFiltered, not var6_56)

	if var0_56 then
		SetActive(arg0_56.leftPanel:Find("charaScroll"), false)
		SetActive(arg0_56._tf:Find("main/noFilteredMessageBg"), true)
		SetActive(arg0_56.rightPanel, false)
		SetActive(arg0_56._tf:Find("main/rightNoMessageBg"), false)
	else
		SetActive(arg0_56.leftPanel:Find("charaScroll"), true)
		arg0_56.charaScrollrect:SetTotalCount(#arg0_56.chatList)
		SetActive(arg0_56._tf:Find("main/noFilteredMessageBg"), false)

		if var1_56 then
			SetActive(arg0_56.rightPanel, true)
			SetActive(arg0_56._tf:Find("main/rightNoMessageBg"), false)
		else
			SetActive(arg0_56.rightPanel, false)
			SetActive(arg0_56._tf:Find("main/rightNoMessageBg"), true)

			arg0_56.currentChat = nil

			if arg0_56.cancelFrame then
				arg0_56.cancelFrame()

				arg0_56.cancelFrame = nil
			end
		end
	end
end

function var0_0.CloseFilterPanel(arg0_57)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_57.filterUI, arg0_57._tf:Find("subPages"))
	SetActive(arg0_57.filterUI, false)
end

function var0_0.SetTopicPanel(arg0_58, arg1_58)
	SetActive(arg0_58.topicBtn:Find("tip"), arg1_58:GetCharacterEndFlagExceptCurrent() == 0)
	onButton(arg0_58, arg0_58.topicBtn, function()
		SetActive(arg0_58.topicUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_58.topicUI)

		arg0_58.currentTopic = nil

		local var0_59 = UIItemList.New(arg0_58.topicUI:Find("panel/topicScroll/Viewport/Content"), arg0_58.topicUI:Find("panel/topicScroll/Viewport/Content/topic"))

		var0_59:make(function(arg0_60, arg1_60, arg2_60)
			if arg0_60 == UIItemList.EventUpdate then
				arg1_58:SortTopicList()

				local var0_60 = arg1_58.topics[arg1_60 + 1]

				setScrollText(arg2_60:Find("mask/name"), HXSet.hxLan(var0_60.name))
				SetActive(arg2_60:Find("lock"), not var0_60.active)
				SetActive(arg2_60:Find("waiting"), var0_60.active and var0_60:isWaiting())
				SetActive(arg2_60:Find("complete"), var0_60.active and var0_60:IsCompleted())
				SetActive(arg2_60:Find("selectedFrame"), arg1_58.currentTopicId == var0_60.topicId)
				SetActive(arg2_60:Find("selected"), arg1_58.currentTopicId == var0_60.topicId)
				SetActive(arg2_60:Find("tip"), var0_60.active and not var0_60:IsCompleted())

				if arg1_58.currentTopicId == var0_60.topicId then
					arg0_58.currentTopic = var0_60
				end

				SetActive(arg2_60, var0_60.active)

				if var0_60.active then
					onButton(arg0_58, arg2_60, function()
						SetActive(arg2_60:Find("selectedFrame"), true)

						for iter0_61 = 1, #arg1_58.topics do
							if iter0_61 ~= arg1_60 + 1 then
								SetActive(arg0_58.topicUI:Find("panel/topicScroll/Viewport/Content"):GetChild(iter0_61 - 1):Find("selectedFrame"), false)
							end
						end

						arg0_58.currentTopic = var0_60
					end, SFX_PANEL)
				else
					onButton(arg0_58, arg2_60, function()
						pg.TipsMgr.GetInstance():ShowTips(var0_60.unlockDesc)
					end, SFX_PANEL)
				end
			end
		end)
		var0_59:align(#arg1_58.topics)
	end, SFX_PANEL)
	onButton(arg0_58, arg0_58.topicUI:Find("bg"), function()
		arg0_58:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_58, arg0_58.topicUI:Find("panel/bottom/close"), function()
		arg0_58:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_58, arg0_58.topicUI:Find("panel/bottom/ok"), function()
		arg0_58:emit(InstagramChatMediator.SET_CURRENT_TOPIC, arg0_58.currentTopic.topicId)
		arg0_58:CloseTopicPanel()

		local var0_65 = arg0_58.rightPanel:GetComponent(typeof(Animation))

		var0_65:Stop()
		var0_65:Play("anim_newinstagram_chat_right_in")
	end, SFX_PANEL)
end

function var0_0.CloseTopicPanel(arg0_66)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_66.topicUI, arg0_66._tf:Find("subPages"))
	SetActive(arg0_66.topicUI, false)
end

function var0_0.SetBackgroundPanel(arg0_67, arg1_67)
	if arg1_67.type == 2 then
		SetActive(arg0_67.backgroundBtn, false)

		return
	end

	SetActive(arg0_67.backgroundBtn, true)

	local var0_67 = arg1_67:GetPaintingId()

	onButton(arg0_67, arg0_67.backgroundBtn, function()
		SetActive(arg0_67.backgroundUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_67.backgroundUI)

		arg0_67.currentBgId = nil

		local var0_68 = arg1_67:GetSkins()
		local var1_68 = UIItemList.New(arg0_67.backgroundUI:Find("panel/backgroundScroll/Viewport/Content"), arg0_67.backgroundUI:Find("panel/backgroundScroll/Viewport/Content/background"))

		var1_68:make(function(arg0_69, arg1_69, arg2_69)
			if arg0_69 == UIItemList.EventUpdate then
				local var0_69 = var0_68[arg1_69 + 1]
				local var1_69 = 0

				if var0_69.id ~= var0_67 then
					var1_69 = var0_69.id
				end

				local var2_69 = var0_69.painting

				LoadImageSpriteAsync("herohrzicon/" .. var2_69, arg2_69:Find("skinMask/skin"), false)
				setScrollText(arg2_69:Find("skinMask/Panel/mask/Text"), var0_69.name)

				local var3_69 = getProxy(ShipSkinProxy):hasSkin(var0_69.id) or var0_69.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or var0_69.skin_type == ShipSkin.SKIN_TYPE_PROPOSE or var0_69.skin_type == ShipSkin.SKIN_TYPE_REMAKE

				SetActive(arg2_69:Find("lockFrame"), not var3_69)
				SetActive(arg2_69:Find("selectedFrame"), arg1_67.skinId == var1_69)
				SetActive(arg2_69:Find("selected"), arg1_67.skinId == var1_69)

				if arg1_67.skinId == var1_69 then
					arg0_67.currentBgId = var1_69
				end

				onButton(arg0_67, arg2_69, function()
					if var3_69 then
						SetActive(arg2_69:Find("selectedFrame"), true)

						for iter0_70 = 1, #var0_68 do
							if iter0_70 ~= arg1_69 + 1 then
								local var0_70 = arg0_67.backgroundUI:Find("panel/backgroundScroll/Viewport/Content"):GetChild(iter0_70 - 1)

								SetActive(var0_70:Find("selectedFrame"), false)
							end
						end

						arg0_67.currentBgId = var1_69
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("juuschat_background_tip2"))
					end
				end, SFX_PANEL)
			end
		end)
		var1_68:align(#var0_68)
	end, SFX_PANEL)
	onButton(arg0_67, arg0_67.backgroundUI:Find("bg"), function()
		arg0_67:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_67, arg0_67.backgroundUI:Find("panel/bottom/close"), function()
		arg0_67:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_67, arg0_67.backgroundUI:Find("panel/bottom/ok"), function()
		arg0_67:emit(InstagramChatMediator.SET_CURRENT_BACKGROUND, arg1_67.characterId, arg0_67.currentBgId)
		arg0_67:CloseBackgroundPanel()
	end, SFX_PANEL)
end

function var0_0.CloseBackgroundPanel(arg0_74)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_74.backgroundUI, arg0_74._tf:Find("subPages"))
	SetActive(arg0_74.backgroundUI, false)
end

function var0_0.SetRedPacketPanel(arg0_75, arg1_75, arg2_75, arg3_75, arg4_75, arg5_75, arg6_75)
	onButton(arg0_75, arg1_75, function()
		SetActive(arg0_75.redPacketUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_75.redPacketUI)
		setImageSprite(arg0_75.redPacketUI:Find("panel/charaBg/chara"), LoadSprite("qicon/" .. arg4_75), false)

		if not arg3_75 then
			SetActive(arg0_75.redPacketUI:Find("panel/panelBg"), true)
			SetActive(arg0_75.redPacketUI:Find("panel/openImg"), false)
			SetActive(arg0_75.redPacketUI:Find("panel/get"), true)
			SetActive(arg0_75.redPacketUI:Find("panel/got"), false)
			SetActive(arg0_75.redPacketUI:Find("panel/detail"), false)
			setText(arg0_75.redPacketUI:Find("panel/get/titleBg/title"), arg2_75.desc)
			onButton(arg0_75, arg0_75.redPacketUI:Find("panel/get/getBtn"), function()
				arg0_75:emit(InstagramChatMediator.GET_REDPACKET, arg5_75, arg6_75, arg2_75.id)
			end, SFX_PANEL)
		else
			arg0_75:UpdateRedPacketUI(arg2_75.id)
		end
	end, SFX_PANEL)
	onButton(arg0_75, arg0_75.redPacketUI:Find("bg"), function()
		arg0_75:CloseRedPacketPanel()

		if arg0_75.canFresh then
			arg0_75.canFresh = false

			local var0_78 = arg0_75.currentChat.currentTopic:GetDisplayWordList()

			if var0_78[#var0_78].type == 0 then
				arg0_75:UpdateCharaList(false, false)
			else
				arg0_75:UpdateCharaList(true, false)
			end
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRedPacketUI(arg0_79, arg1_79)
	local var0_79 = var2_0[arg1_79]

	SetActive(arg0_79.redPacketUI:Find("panel/panelBg"), true)
	SetActive(arg0_79.redPacketUI:Find("panel/openImg"), false)
	SetActive(arg0_79.redPacketUI:Find("panel/get"), false)
	SetActive(arg0_79.redPacketUI:Find("panel/got"), true)
	SetActive(arg0_79.redPacketUI:Find("panel/detail"), false)

	local var1_79 = Drop.Create(var0_79.content)

	var1_79.count = 0

	updateDrop(arg0_79.redPacketUI:Find("panel/got/item"), var1_79)
	onButton(arg0_79, arg0_79.redPacketUI:Find("panel/got/item"), function()
		arg0_79:emit(BaseUI.ON_DROP, var1_79)
	end, SFX_PANEL)

	arg0_79.redPacketUI:Find("panel/got/item/icon_bg"):GetComponent(typeof(Image)).enabled = false
	arg0_79.redPacketUI:Find("panel/got/item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

	setText(arg0_79.redPacketUI:Find("panel/got/awardCount"), var0_79.content[3])

	if var0_79.type == 1 then
		SetActive(arg0_79.redPacketUI:Find("panel/got/detailBtn"), false)
	else
		SetActive(arg0_79.redPacketUI:Find("panel/got/detailBtn"), true)
		onButton(arg0_79, arg0_79.redPacketUI:Find("panel/got/detailBtn"), function()
			SetActive(arg0_79.redPacketUI:Find("panel/panelBg"), false)
			SetActive(arg0_79.redPacketUI:Find("panel/openImg"), true)
			SetActive(arg0_79.redPacketUI:Find("panel/got"), false)
			SetActive(arg0_79.redPacketUI:Find("panel/detail"), true)

			local var0_81 = 0
			local var1_81 = 0
			local var2_81 = UIItemList.New(arg0_79.redPacketUI:Find("panel/detail/detailScroll/Viewport/Content"), arg0_79.redPacketUI:Find("panel/detail/detailScroll/Viewport/Content/charaGetCard"))

			var2_81:make(function(arg0_82, arg1_82, arg2_82)
				if arg0_82 == UIItemList.EventUpdate then
					local var0_82 = var0_79.group_receive[arg1_82 + 1]
					local var1_82 = var0_82[1]
					local var2_82 = {
						var0_82[2],
						var0_82[3],
						var0_82[4]
					}

					if var0_82[1] ~= 0 then
						local var3_82 = "unknown"

						if var1_0[var1_82] then
							var3_82 = var1_0[var1_82].sculpture
						end

						setImageSprite(arg2_82:Find("charaBg/chara"), LoadSprite("qicon/" .. var3_82), false)
					else
						setImageSprite(arg2_82:Find("charaBg/chara"), GetSpriteFromAtlas("ui/InstagramUI_atlas", "txdi_3"), false)
					end

					local var4_82 = Drop.Create(var2_82)

					var4_82.count = 0

					updateDrop(arg2_82:Find("item"), var4_82)
					onButton(arg0_79, arg2_82:Find("item"), function()
						arg0_79:emit(BaseUI.ON_DROP, var4_82)
					end, SFX_PANEL)

					arg2_82:Find("item/icon_bg"):GetComponent(typeof(Image)).enabled = false
					arg2_82:Find("item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

					setText(arg2_82:Find("awardCount"), var0_82[4])

					if var0_82[4] > var1_81 then
						var0_81 = arg1_82
						var1_81 = var0_82[4]
					end
				end
			end)
			var2_81:align(#var0_79.group_receive)

			for iter0_81 = 1, #var0_79.group_receive do
				SetActive(arg0_79.redPacketUI:Find("panel/detail/detailScroll/Viewport/Content"):GetChild(iter0_81 - 1):Find("charaBg/king"), var0_81 == iter0_81 - 1)
			end
		end, SFX_PANEL)
	end
end

function var0_0.CloseRedPacketPanel(arg0_84)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_84.redPacketUI, arg0_84._tf:Find("subPages"))
	SetActive(arg0_84.redPacketUI, false)
end

function var0_0.SetData(arg0_85)
	local var0_85 = getProxy(InstagramChatProxy)

	arg0_85.allChatList = var0_85:GetChatList()
	arg0_85.chatList = table.insertto({}, arg0_85.allChatList)

	var0_85:SortChatList()
end

function var0_0.willExit(arg0_86)
	local var0_86 = arg0_86.rightPanel:Find("paintingMask/painting")

	if arg0_86.paintingName then
		retPaintingPrefab(var0_86, arg0_86.paintingName)

		arg0_86.paintingName = nil
	end

	arg0_86:RemoveAllTimer()
end

function var0_0.StartTimer(arg0_87, arg1_87, arg2_87)
	local var0_87 = Timer.New(arg1_87, arg2_87, 1)

	var0_87:Start()
	table.insert(arg0_87.timerList, var0_87)
end

function var0_0.RemoveAllTimer(arg0_88)
	for iter0_88, iter1_88 in ipairs(arg0_88.timerList) do
		iter1_88:Stop()
	end

	arg0_88.timerList = {}
end

function var0_0.StartTimer2(arg0_89, arg1_89, arg2_89)
	arg0_89.timer = Timer.New(arg1_89, arg2_89, 1)

	arg0_89.timer:Start()
end

function var0_0.SpeedUpMessage(arg0_90)
	local var0_90 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var1_90 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_90, iter1_90 in ipairs(arg0_90.timerList) do
		if iter1_90.running then
			if iter1_90.duration == var1_90 then
				iter1_90.time = 0.05
			elseif iter1_90.time - var0_90 < 0.05 then
				iter1_90.time = 0.05

				arg0_90:StartTimer2(function()
					arg0_90:SpeedUpWaiting()
				end, 0.05)
			else
				iter1_90.time = iter1_90.time - var0_90
			end
		end
	end
end

function var0_0.SpeedUpWaiting(arg0_92)
	local var0_92 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_92, iter1_92 in ipairs(arg0_92.timerList) do
		if iter1_92.running and iter1_92.duration == var0_92 then
			iter1_92.time = 0.05

			break
		end
	end
end

function var0_0.ChangeFresh(arg0_93)
	arg0_93.canFresh = true
end

function var0_0.ChangeCharaTextFunc(arg0_94, arg1_94, arg2_94)
	local function var0_94(arg0_95)
		if arg0_95:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_94) then
			setText(arg0_95:Find("msg"), arg2_94)
		end
	end

	for iter0_94 = 0, arg0_94.charaScrollContent.childCount - 1 do
		local var1_94 = arg0_94.charaScrollContent:GetChild(iter0_94)

		var0_94(var1_94)
	end
end

function var0_0.ResetCharaTextFunc(arg0_96, arg1_96)
	local function var0_96(arg0_97)
		if arg0_97:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_96) then
			setText(arg0_97:Find("msg"), arg0_97:Find("displayWord"):GetComponent(typeof(Text)).text)
		end
	end

	for iter0_96 = 0, arg0_96.charaScrollContent.childCount - 1 do
		local var1_96 = arg0_96.charaScrollContent:GetChild(iter0_96)

		var0_96(var1_96)
	end
end

function var0_0.SetEndAniEvent(arg0_98, arg1_98, arg2_98)
	local var0_98 = arg1_98:GetComponent(typeof(DftAniEvent))

	if var0_98 then
		var0_98:SetEndEvent(function()
			arg2_98()
			var0_98:SetEndEvent(nil)
		end)
	end
end

function var0_0.onBackPressed(arg0_100)
	if isActive(arg0_100.filterUI) then
		arg0_100:CloseFilterPanel()

		return
	end

	if isActive(arg0_100.topicUI) then
		arg0_100:CloseTopicPanel()

		return
	end

	if isActive(arg0_100.backgroundUI) then
		arg0_100:CloseBackgroundPanel()

		return
	end

	if isActive(arg0_100.redPacketUI) then
		arg0_100:CloseRedPacketPanel()

		return
	end

	arg0_100:emit(InstagramChatMediator.CLOSE_ALL)
end

return var0_0
