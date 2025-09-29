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
	arg0_3.leftPanel = arg0_3:findTF("main/leftPanel")
	arg0_3.filterBtn = arg0_3:findTF("leftTop/filter", arg0_3.leftPanel)
	arg0_3.isFiltered = arg0_3:findTF("isFiltered", arg0_3.filterBtn)
	arg0_3.charaList = UIItemList.New(arg0_3:findTF("charaScroll/Viewport/Content", arg0_3.leftPanel), arg0_3:findTF("charaScroll/Viewport/Content/charaMsg", arg0_3.leftPanel))
	arg0_3.rightPanel = arg0_3:findTF("main/rightPanel")
	arg0_3.characterName = arg0_3:findTF("rightTop/name", arg0_3.rightPanel)
	arg0_3.careBtn = arg0_3:findTF("rightTop/careBtn", arg0_3.rightPanel)
	arg0_3.topicBtn = arg0_3:findTF("rightTop/topicBtn", arg0_3.rightPanel)
	arg0_3.backgroundBtn = arg0_3:findTF("rightTop/backgroundBtn", arg0_3.rightPanel)
	arg0_3.messageList = UIItemList.New(arg0_3:findTF("messageScroll/Viewport/Content", arg0_3.rightPanel), arg0_3:findTF("messageScroll/Viewport/Content/messageCard", arg0_3.rightPanel))
	arg0_3.optionPanel = arg0_3:findTF("optionPanel", arg0_3.rightPanel)
	arg0_3.optionList = UIItemList.New(arg0_3.optionPanel, arg0_3:findTF("option", arg0_3.optionPanel))
	arg0_3.filterUI = arg0_3:findTF("subPages/InstagramFilterUI")
	arg0_3.topicUI = arg0_3:findTF("subPages/InstagramTopicUI")
	arg0_3.backgroundUI = arg0_3:findTF("subPages/InstagramBackgroundUI")
	arg0_3.redPacketUI = arg0_3:findTF("subPages/InstagramRedPacketUI")

	setText(arg0_3:findTF("Text", arg0_3.filterBtn), i18n("juuschat_filter_title"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/read/subTitleFrame/subTitle", arg0_3.filterUI), i18n("juuschat_filter_subtitle1"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle", arg0_3.filterUI), i18n("juuschat_filter_subtitle2"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/subTitleFrame/subTitle", arg0_3.filterUI), i18n("juuschat_filter_subtitle3"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/read/option/Text", arg0_3.filterUI), i18n("juuschat_filter_tip1"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/read/option_1/Text", arg0_3.filterUI), i18n("juuschat_filter_tip2"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/read/option_2/Text", arg0_3.filterUI), i18n("juuschat_filter_tip3"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/type/option/Text", arg0_3.filterUI), i18n("juuschat_filter_tip1"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/type/option_1/Text", arg0_3.filterUI), i18n("juuschat_filter_tip4"))
	setText(arg0_3:findTF("panel/filterScroll/Viewport/Content/type/option_2/Text", arg0_3.filterUI), i18n("juuschat_filter_tip5"))
	setText(arg0_3:findTF("panel/topicScroll/Viewport/Content/topic/waiting", arg0_3.topicUI), i18n("juuschat_chattip3"))
	setText(arg0_3:findTF("panel/topicScroll/Viewport/Content/topic/selected/Text", arg0_3.topicUI), i18n("juuschat_label2"))
	setText(arg0_3:findTF("panel/backgroundScroll/Viewport/Content/background/selected/Text", arg0_3.backgroundUI), i18n("juuschat_label1"))
	setText(arg0_3:findTF("panel/got/detailBtn/Text", arg0_3.redPacketUI), i18n("juuschat_redpacket_show_detail"))
	setText(arg0_3:findTF("panel/detail/title", arg0_3.redPacketUI), i18n("juuschat_redpacket_detail"))
	setText(arg0_3:findTF("main/noFilteredMessageBg/Text"), i18n("juuschat_filter_empty"))
	setText(arg0_3:findTF("panel/backgroundScroll/Viewport/Content/background/lockFrame/Text", arg0_3.backgroundUI), i18n("juuschat_background_tip1"))

	arg0_3.redPacketGot = arg0_3:findTF("panel/got", arg0_3.redPacketUI)

	arg0_3:OverlayPanel(arg0_3._tf)
	SetActive(arg0_3.filterUI, false)
	SetActive(arg0_3.isFiltered, false)
	SetActive(arg0_3.topicUI, false)
	SetActive(arg0_3.backgroundUI, false)
	SetActive(arg0_3.redPacketUI, false)
	SetActive(arg0_3.rightPanel, false)

	arg0_3.timerList = {}
	arg0_3.canFresh = false

	local var0_3 = arg0_3:findTF("messageScroll/Scrollbar Vertical", arg0_3.rightPanel):GetComponent(typeof(RectTransform))

	arg0_3.messageScrollWidth = var0_3.rect.width
	arg0_3.messageScrollHeight = var0_3.rect.height

	arg0_3:findTF("panel/title", arg0_3.filterUI):GetComponent(typeof(Image)):SetNativeSize()
	arg0_3:findTF("panel/title", arg0_3.topicUI):GetComponent(typeof(Image)):SetNativeSize()
	arg0_3:findTF("panel/title", arg0_3.backgroundUI):GetComponent(typeof(Image)):SetNativeSize()
end

function var0_0.didEnter(arg0_4)
	arg0_4:SetData()
	arg0_4:UpdateCharaList(false, false)
	arg0_4:SetFilterPanel()
end

function var0_0.UpdateCharaList(arg0_5, arg1_5, arg2_5)
	if not arg0_5.chatList or #arg0_5.chatList == 0 then
		SetActive(arg0_5.leftPanel, false)
		SetActive(arg0_5.rightPanel, false)
		SetActive(arg0_5:findTF("main/noMessageBg"), true)
		SetActive(arg0_5:findTF("main/noFilteredMessageBg"), false)
		SetActive(arg0_5:findTF("main/rightNoMessageBg"), false)

		return
	end

	if not arg0_5.currentChat then
		SetActive(arg0_5.rightPanel, false)
		SetActive(arg0_5:findTF("main/rightNoMessageBg"), true)
	else
		SetActive(arg0_5.rightPanel, true)
		SetActive(arg0_5:findTF("main/rightNoMessageBg"), false)
	end

	arg0_5.charaList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg0_5.chatList[arg1_6 + 1]

			setImageSprite(arg2_6:Find("charaBg/chara"), LoadSprite("qicon/" .. var0_6.sculpture), false)
			setText(arg2_6:Find("name"), var0_6.name)

			local var1_6 = var0_6:GetDisplayWord()

			if not arg0_5.currentChat or arg0_5.currentChat.characterId ~= var0_6.characterId or not arg1_5 then
				setText(arg2_6:Find("msg"), var1_6)
			end

			setText(arg2_6:Find("displayWord"), var1_6)
			SetActive(arg2_6:Find("care"), var0_6.care == 1)

			if var0_6.care == 1 and arg0_5.careAniTriggerId and arg0_5.careAniTriggerId == var0_6.characterId then
				arg0_5.careAniTriggerId = nil

				arg2_6:Find("care"):GetComponent(typeof(Animation)):Play("anim_newinstagram_care")
			end

			if arg0_5.currentChat then
				SetActive(arg2_6:Find("frame"), arg0_5.currentChat == var0_6)
			end

			SetActive(arg2_6:Find("tip"), var0_6:GetCharacterEndFlag() == 0)
			setText(arg2_6:Find("id"), var0_6.characterId)
			onButton(arg0_5, arg2_6, function()
				if arg0_5.currentChat and arg0_5.currentChat.characterId ~= var0_6.characterId then
					arg0_5:ResetCharaTextFunc(arg0_5.currentChat.characterId)
				end

				arg0_5.currentChat = var0_6

				SetActive(arg0_5.rightPanel, true)
				SetActive(arg0_5:findTF("main/rightNoMessageBg"), false)
				arg0_5:UpdateChatContent(var0_6, false, false)
				arg0_5:SetTopicPanel(var0_6)
				arg0_5:SetBackgroundPanel(var0_6)

				for iter0_7, iter1_7 in ipairs(arg0_5.chatList) do
					SetActive(arg0_5:findTF("frame", arg0_5:findTF("main/leftPanel/charaScroll/Viewport/Content"):GetChild(iter0_7 - 1)), false)
				end

				SetActive(arg2_6:Find("frame"), true)

				function arg0_5.cancelFrame()
					SetActive(arg2_6:Find("frame"), false)
				end

				local var0_7 = arg0_5.rightPanel:GetComponent(typeof(Animation))

				var0_7:Stop()
				var0_7:Play("anim_newinstagram_chat_right_in")
			end, SFX_PANEL)
		end
	end)
	arg0_5.charaList:align(#arg0_5.chatList)
	arg0_5:SetFilterResult()

	if arg0_5.currentChat then
		arg0_5:UpdateChatContent(arg0_5.currentChat, arg1_5, arg2_5)
		arg0_5:SetTopicPanel(arg0_5.currentChat)
	end
end

function var0_0.UpdateChatContent(arg0_9, arg1_9, arg2_9, arg3_9)
	SetActive(arg0_9.rightPanel, true)
	setText(arg0_9.characterName, arg1_9.name)

	local var0_9 = arg0_9:findTF("care", arg0_9.careBtn)

	SetActive(var0_9, arg1_9.care == 1)
	onButton(arg0_9, arg0_9.careBtn, function()
		local var0_10 = arg1_9.care == 0 and 1 or 0

		arg0_9:emit(InstagramChatMediator.CHANGE_CARE, arg1_9.characterId, var0_10)

		arg0_9.careAniTriggerId = arg1_9.characterId
	end, SFX_PANEL)

	local var1_9 = arg0_9:findTF("paintingMask", arg0_9.rightPanel)
	local var2_9 = arg0_9:findTF("painting", var1_9)
	local var3_9 = arg0_9:findTF("groupBackground", arg0_9.rightPanel)

	if arg1_9.type == 1 then
		SetActive(var1_9, true)
		SetActive(var3_9, false)

		local var4_9 = "unknown"

		if arg1_9.skinId == 0 then
			var4_9 = arg1_9:GetPainting()
		else
			for iter0_9, iter1_9 in ipairs(arg1_9.skins) do
				if iter1_9.id == arg1_9.skinId then
					var4_9 = iter1_9.painting
				end
			end
		end

		if not arg0_9.paintingName then
			setPaintingPrefabAsync(var2_9, var4_9, "pifu")

			arg0_9.paintingName = var4_9
		elseif arg0_9.paintingName and arg0_9.paintingName ~= var4_9 then
			retPaintingPrefab(var2_9, arg0_9.paintingName)
			setPaintingPrefabAsync(var2_9, var4_9, "pifu")

			arg0_9.paintingName = var4_9
		end
	else
		SetActive(var1_9, false)
		SetActive(var3_9, true)

		if arg0_9.paintingName then
			retPaintingPrefab(var2_9, arg0_9.paintingName)

			arg0_9.paintingName = nil
		end

		setImageSprite(var3_9, LoadSprite("ui/InstagramChatBackgrounds_atlas", arg1_9.groupBackground), true)
	end

	local var5_9 = arg1_9.currentTopic:GetDisplayWordList()

	if not arg3_9 then
		arg0_9:UpdateOptionPanel(arg1_9.currentTopic, var5_9)
		arg0_9:UpdateMessageList(arg1_9.currentTopic, var5_9, arg2_9, arg1_9.characterId, arg1_9.type)
	end

	if not arg2_9 and arg1_9.currentTopic.readFlag == 0 then
		arg0_9:emit(InstagramChatMediator.SET_READED, {
			arg1_9.currentTopic.topicId
		})
	end
end

function var0_0.UpdateMessageList(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11)
	arg0_11:RemoveAllTimer()

	local var0_11

	for iter0_11 = #arg2_11, 1, -1 do
		if arg2_11[iter0_11].ship_group == 0 or arg2_11[iter0_11].type == 3 and arg1_11:RedPacketGotFlag(tonumber(arg2_11[iter0_11].param)) then
			var0_11 = iter0_11

			break
		end
	end

	local var1_11 = {}

	if var0_11 then
		for iter1_11 = var0_11, 1, -1 do
			if arg2_11[iter1_11].ship_group == 0 then
				table.insert(var1_11, iter1_11)
			else
				break
			end
		end
	end

	if arg0_11.shouldShowOption and arg3_11 then
		arg0_11:SetOptionPanelActive(false)
	end

	if arg3_11 then
		onButton(arg0_11, arg0_11:findTF("messageScroll", arg0_11.rightPanel), function()
			arg0_11:SpeedUpMessage()
		end, SFX_PANEL)
	end

	local var2_11 = GetComponent(arg0_11:findTF("messageScroll", arg0_11.rightPanel), typeof(ScrollRect))

	local function var3_11(arg0_13)
		local var0_13 = Vector2(0, arg0_13)

		var2_11.normalizedPosition = var0_13
	end

	local var4_11 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var5_11 = pg.gameset.juuschat_entering_time.key_value / 1000
	local var6_11 = var4_11 - var5_11

	arg0_11.messageList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg2_11[arg1_14 + 1]

			if var0_14.ship_group == 0 and var0_14.type == 0 then
				SetActive(arg2_14, false)

				return
			end

			local var1_14 = arg2_14:Find("charaMessageCard")
			local var2_14 = arg2_14:Find("playerReplyCard")

			SetActive(var1_14, var0_14.ship_group ~= 0)
			SetActive(var2_14, var0_14.ship_group == 0)

			if var0_14.ship_group ~= 0 and arg5_11 == 2 and var0_14.type ~= 5 then
				SetActive(arg2_14:Find("nameBar"), true)
				setText(arg2_14:Find("nameBar/Text"), var1_0[var0_14.ship_group].name)
			else
				SetActive(arg2_14:Find("nameBar"), false)
			end

			local var3_14

			if arg3_11 and var0_11 and arg1_14 + 1 > var0_11 then
				var3_14 = (arg1_14 + 1 - var0_11) * var4_11 - var5_11

				if #var1_11 > 1 then
					var3_14 = var3_14 + (#var1_11 - 1) * var6_11
				end
			end

			if var0_14.ship_group ~= 0 then
				local var4_14 = "unknown"

				if var1_0[var0_14.ship_group] then
					var4_14 = var1_0[var0_14.ship_group].sculpture
				end

				if var0_14.type ~= 5 then
					setImageSprite(arg2_14:Find("charaMessageCard/charaBg/chara"), LoadSprite("qicon/" .. var4_14), false)
				end

				if var0_14.type == 1 then
					arg0_11:SetCharaMessageCardActive(var1_14, {
						3
					})
					setText(arg2_14:Find("charaMessageCard/msgBox/msg"), var0_14.param)

					if arg3_11 and var0_11 and arg1_14 + 1 > var0_11 then
						SetActive(arg2_14, false)
						arg0_11:StartTimer(function()
							SetActive(arg2_14, true)
							arg2_14:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_14:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_14:Find("charaMessageCard/msgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
							arg0_11:StartTimer(function()
								SetActive(arg2_14:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_14:Find("charaMessageCard/msgBox"), true)
								arg2_14:Find("charaMessageCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")

								if arg1_14 + 1 ~= #arg2_11 then
									arg0_11:ChangeCharaTextFunc(arg4_11, var0_14.param)
								else
									arg0_11:emit(InstagramChatMediator.SET_READED, {
										arg1_11.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
								arg0_11:SetEndAniEvent(arg2_14:Find("charaMessageCard/msgBox"), function()
									if arg0_11.shouldShowOption and arg1_14 + 1 == #arg2_11 then
										arg0_11:SetOptionPanelActive(true)
									end
								end)
							end, var5_11)
						end, var3_14)
					end
				elseif var0_14.type == 2 then
					arg0_11:SetCharaMessageCardActive(var1_14, {
						2,
						7
					})
					pg.CriMgr.GetInstance():GetCueInfo("cv-" .. var0_14.ship_group, var0_14.param[1], function(arg0_18)
						setText(arg2_14:Find("charaMessageCard/voiceBox/time"), tostring(math.ceil(tonumber(tostring(arg0_18.length)) / 1000)) .. "\"")
					end)
					onButton(arg0_11, arg2_14:Find("charaMessageCard/voiceBox"), function()
						pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/cv/" .. var0_14.ship_group .. "/" .. var0_14.param[1])
					end, SFX_PANEL)
					setText(arg2_14:Find("charaMessageCard/voiceMsgBox/voiceMsg/msg"), var0_14.param[2])

					if arg3_11 and var0_11 and arg1_14 + 1 > var0_11 then
						SetActive(arg2_14, false)
						arg0_11:StartTimer(function()
							SetActive(arg2_14, true)
							arg2_14:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_14:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_14:Find("charaMessageCard/voiceBox"), false)
							SetActive(arg2_14:Find("charaMessageCard/voiceMsgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
							arg0_11:StartTimer(function()
								SetActive(arg2_14:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_14:Find("charaMessageCard/voiceBox"), true)
								SetActive(arg2_14:Find("charaMessageCard/voiceMsgBox"), true)
								arg2_14:Find("charaMessageCard/voiceBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")
								arg2_14:Find("charaMessageCard/voiceMsgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_voicetip_in")

								if arg1_14 + 1 ~= #arg2_11 then
									arg0_11:ChangeCharaTextFunc(arg4_11, "<color=#ff6666>" .. i18n("juuschat_chattip1") .. "</color>")
								else
									arg0_11:emit(InstagramChatMediator.SET_READED, {
										arg1_11.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
								arg0_11:SetEndAniEvent(arg2_14:Find("charaMessageCard/voiceBox"), function()
									if arg0_11.shouldShowOption and arg1_14 + 1 == #arg2_11 then
										arg0_11:SetOptionPanelActive(true)
									end
								end)
							end, var5_11)
						end, var3_14)
					end
				elseif var0_14.type == 3 then
					arg0_11:SetCharaMessageCardActive(var1_14, {
						5
					})

					local var5_14 = var2_0[tonumber(var0_14.param)]

					setText(arg2_14:Find("charaMessageCard/redPacket/desc"), var5_14.desc)

					local var6_14 = arg1_11:RedPacketGotFlag(var5_14.id)

					SetActive(arg2_14:Find("charaMessageCard/redPacket/got"), var6_14)
					arg0_11:SetRedPacketPanel(arg2_14:Find("charaMessageCard/redPacket"), var5_14, var6_14, var4_14, arg1_11.topicId, var0_14.id)

					if arg3_11 and var0_11 and arg1_14 + 1 == var0_11 then
						arg0_11:ChangeCharaTextFunc(arg4_11, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_14.param)].desc)
					end

					if arg3_11 and var0_11 and arg1_14 + 1 > var0_11 then
						SetActive(arg2_14, false)
						arg0_11:StartTimer(function()
							SetActive(arg2_14, true)
							arg2_14:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_14:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_14:Find("charaMessageCard/redPacket"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
							arg0_11:StartTimer(function()
								SetActive(arg2_14:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_14:Find("charaMessageCard/redPacket"), true)
								arg2_14:Find("charaMessageCard/redPacket"):GetComponent(typeof(Animation)):Play("anim_newinstagram_redpacket_in")

								if arg1_14 + 1 ~= #arg2_11 then
									arg0_11:ChangeCharaTextFunc(arg4_11, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_14.param)].desc)
								else
									arg0_11:emit(InstagramChatMediator.SET_READED, {
										arg1_11.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
								arg0_11:SetEndAniEvent(arg2_14:Find("charaMessageCard/redPacket"), function()
									if arg0_11.shouldShowOption and arg1_14 + 1 == #arg2_11 then
										arg0_11:SetOptionPanelActive(true)
									end
								end)
							end, var5_11)
						end, var3_14)
					end
				elseif var0_14.type == 4 then
					arg0_11:SetCharaMessageCardActive(var1_14, {
						4
					})
					arg0_11:ClearEmoji(arg2_14:Find("charaMessageCard/emoji/emoticon"))
					arg0_11:SetEmoji(arg2_14:Find("charaMessageCard/emoji/emoticon"), var3_0[tonumber(var0_14.param)].pic)

					if arg3_11 and var0_11 and arg1_14 + 1 > var0_11 then
						SetActive(arg2_14, false)
						arg0_11:StartTimer(function()
							SetActive(arg2_14, true)
							arg2_14:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_14:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_14:Find("charaMessageCard/emoji"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
							arg0_11:StartTimer(function()
								SetActive(arg2_14:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_14:Find("charaMessageCard/emoji"), true)
								arg2_14:Find("charaMessageCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								if arg1_14 + 1 ~= #arg2_11 then
									local var0_27 = var3_0[tonumber(var0_14.param)].desc
									local var1_27 = string.gsub(var0_27, "#%w+>", "#28af6e>")

									arg0_11:ChangeCharaTextFunc(arg4_11, var1_27)
								else
									arg0_11:emit(InstagramChatMediator.SET_READED, {
										arg1_11.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
								arg0_11:SetEndAniEvent(arg2_14:Find("charaMessageCard/emoji"), function()
									if arg0_11.shouldShowOption and arg1_14 + 1 == #arg2_11 then
										arg0_11:SetOptionPanelActive(true)
									end
								end)
							end, var5_11)
						end, var3_14)
					end
				elseif var0_14.type == 5 then
					arg0_11:SetCharaMessageCardActive(var1_14, {
						6
					})

					local var7_14 = var0_14.param

					for iter0_14 in string.gmatch(var0_14.param, "'%d+'") do
						local var8_14 = string.sub(iter0_14, 2, #iter0_14 - 1)

						var7_14 = string.gsub(var7_14, iter0_14, "<color=#93e9ff>" .. var1_0[tonumber(var8_14)].name .. "</color>")
					end

					setText(arg2_14:Find("charaMessageCard/systemTip/panel/Text"), var7_14)

					if arg3_11 and var0_11 and arg1_14 + 1 > var0_11 then
						SetActive(arg2_14, false)
						arg0_11:StartTimer(function()
							SetActive(arg2_14, true)
							arg2_14:Find("charaMessageCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							if arg1_14 + 1 ~= #arg2_11 then
								arg0_11:ChangeCharaTextFunc(arg4_11, var7_14)
							else
								arg0_11:emit(InstagramChatMediator.SET_READED, {
									arg1_11.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
							arg0_11:SetEndAniEvent(arg2_14:Find("charaMessageCard/systemTip"), function()
								if arg0_11.shouldShowOption and arg1_14 + 1 == #arg2_11 then
									arg0_11:SetOptionPanelActive(true)
								end
							end)
						end, var3_14)
					end
				end
			else
				if var0_14.type == 1 then
					arg0_11:SetPlayerMessageCardActive(var2_14, {
						0
					})
					setText(arg2_14:Find("playerReplyCard/msgBox/msg"), var0_14.param)
				elseif var0_14.type == 4 then
					arg0_11:SetPlayerMessageCardActive(var2_14, {
						1
					})
					arg0_11:ClearEmoji(arg2_14:Find("playerReplyCard/emoji/emoticon"))
					arg0_11:SetEmoji(arg2_14:Find("playerReplyCard/emoji/emoticon"), var3_0[tonumber(var0_14.param)].pic)
				elseif var0_14.type == 5 then
					arg0_11:SetPlayerMessageCardActive(var2_14, {
						2
					})

					local var9_14 = var0_14.param

					for iter1_14 in string.gmatch(var0_14.param, "'%d+'") do
						local var10_14 = string.sub(iter1_14, 2, #iter1_14 - 1)

						var9_14 = string.gsub(var9_14, iter1_14, "<color=#93e9ff>" .. var1_0[tonumber(var10_14)].name .. "</color>")
					end

					setText(arg2_14:Find("playerReplyCard/systemTip/panel/Text"), var9_14)
				end

				if arg3_11 and var0_11 and _.contains(var1_11, arg1_14 + 1) then
					if table.indexof(var1_11, arg1_14 + 1) < #var1_11 then
						SetActive(arg2_14, false)
						arg0_11:StartTimer(function()
							SetActive(arg2_14, true)

							if var0_14.type == 1 then
								arg2_14:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
								arg0_11:ChangeCharaTextFunc(arg4_11, var0_14.param)
							elseif var0_14.type == 4 then
								arg2_14:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								local var0_31 = var3_0[tonumber(var0_14.param)].desc
								local var1_31 = string.gsub(var0_31, "#%w+>", "#28af6e>")

								arg0_11:ChangeCharaTextFunc(arg4_11, var1_31)
							elseif var0_14.type == 5 then
								arg2_14:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

								local var2_31 = var0_14.param

								for iter0_31 in string.gmatch(var0_14.param, "'%d+'") do
									local var3_31 = string.sub(iter0_31, 2, #iter0_31 - 1)

									var2_31 = string.gsub(var2_31, iter0_31, "<color=#93e9ff>" .. var1_0[tonumber(var3_31)].name .. "</color>")
								end

								arg0_11:ChangeCharaTextFunc(arg4_11, var2_31)
							end

							if arg1_14 + 1 == #arg2_11 then
								arg0_11:emit(InstagramChatMediator.SET_READED, {
									arg1_11.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
						end, (#var1_11 - table.indexof(var1_11, arg1_14 + 1)) * var6_11)
					else
						if var0_14.type == 1 then
							arg2_14:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
							arg0_11:ChangeCharaTextFunc(arg4_11, var0_14.param)
						elseif var0_14.type == 4 then
							arg2_14:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

							local var11_14 = var3_0[tonumber(var0_14.param)].desc
							local var12_14 = string.gsub(var11_14, "#%w+>", "#28af6e>")

							arg0_11:ChangeCharaTextFunc(arg4_11, var12_14)
						elseif var0_14.type == 5 then
							arg2_14:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							local var13_14 = var0_14.param

							for iter2_14 in string.gmatch(var0_14.param, "'%d+'") do
								local var14_14 = string.sub(iter2_14, 2, #iter2_14 - 1)

								var13_14 = string.gsub(var13_14, iter2_14, "<color=#93e9ff>" .. var1_0[tonumber(var14_14)].name .. "</color>")
							end

							arg0_11:ChangeCharaTextFunc(arg4_11, var13_14)
						end

						if arg1_14 + 1 == #arg2_11 then
							arg0_11:emit(InstagramChatMediator.SET_READED, {
								arg1_11.topicId
							})
						end
					end
				end
			end

			if not arg1_11:isWaiting() and arg1_14 + 1 == #arg2_11 then
				if arg3_11 then
					if var0_14.ship_group ~= 0 then
						arg0_11:StartTimer(function()
							setActive(arg2_14:Find("end"), true)
						end, var3_14 + var4_11)
					else
						arg0_11:StartTimer(function()
							setActive(arg2_14:Find("end"), true)
						end, (#var1_11 - table.indexof(var1_11, arg1_14 + 1)) * var6_11 + var6_11)
					end
				else
					setActive(arg2_14:Find("end"), true)
				end
			else
				setActive(arg2_14:Find("end"), false)
			end
		end
	end)
	arg0_11.messageList:align(#arg2_11)

	if arg3_11 then
		Canvas.ForceUpdateCanvases()
		LeanTween.value(go(arg0_11:findTF("messageScroll", arg0_11.rightPanel)), var2_11.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_11)):setEase(LeanTweenType.easeInOutCubic)
	else
		scrollToBottom(arg0_11:findTF("messageScroll", arg0_11.rightPanel))
	end
end

function var0_0.SetCharaMessageCardActive(arg0_34, arg1_34, arg2_34)
	if _.contains(arg2_34, 6) then
		SetActive(arg1_34:GetChild(0), false)
	else
		SetActive(arg1_34:GetChild(0), true)
	end

	for iter0_34 = 1, arg1_34.childCount - 1 do
		if _.contains(arg2_34, iter0_34) then
			SetActive(arg1_34:GetChild(iter0_34), true)
		else
			SetActive(arg1_34:GetChild(iter0_34), false)
		end
	end
end

function var0_0.SetPlayerMessageCardActive(arg0_35, arg1_35, arg2_35)
	for iter0_35 = 0, arg1_35.childCount - 1 do
		if _.contains(arg2_35, iter0_35) then
			SetActive(arg1_35:GetChild(iter0_35), true)
		else
			SetActive(arg1_35:GetChild(iter0_35), false)
		end
	end
end

function var0_0.SetEmoji(arg0_36, arg1_36, arg2_36)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg2_36, arg2_36, true, function(arg0_37)
		if not IsNil(arg1_36) then
			arg0_37.name = arg2_36
			tf(arg0_37).sizeDelta = arg1_36.sizeDelta
			tf(arg0_37).anchoredPosition = Vector2.zero

			local var0_37 = arg0_37:GetComponent("Animator")

			if var0_37 then
				var0_37.enabled = true
			end

			setParent(arg0_37, arg1_36, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg2_36, arg2_36, arg0_37)
		end
	end)
end

function var0_0.ClearEmoji(arg0_38, arg1_38)
	eachChild(arg1_38, function(arg0_39)
		local var0_39 = go(arg0_39)

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_39.name, var0_39.name, var0_39)
	end)
end

function var0_0.UpdateOptionPanel(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg2_40[#arg2_40].option

	if var0_40 and type(var0_40) == "table" then
		arg0_40.shouldShowOption = true
		arg0_40.optionCount = #var0_40

		arg0_40:SetOptionPanelActive(true)
		arg0_40.optionList:make(function(arg0_41, arg1_41, arg2_41)
			if arg0_41 == UIItemList.EventUpdate then
				local var0_41 = var0_40[arg1_41 + 1]

				setText(arg2_41:Find("Text"), HXSet.hxLan(var0_41[2]))
				onButton(arg0_40, arg2_41, function()
					arg0_40:emit(InstagramChatMediator.REPLY, arg1_40.topicId, arg2_40[#arg2_40].id, var0_41[1])
				end, SFX_PANEL)
			end
		end)
		arg0_40.optionList:align(#var0_40)
	else
		arg0_40:SetOptionPanelActive(false)

		arg0_40.shouldShowOption = false
	end
end

function var0_0.SetOptionPanelActive(arg0_43, arg1_43)
	SetActive(arg0_43.optionPanel, arg1_43)

	local var0_43 = arg0_43:findTF("messageScroll/Viewport/Content", arg0_43.rightPanel):GetComponent(typeof(VerticalLayoutGroup))
	local var1_43 = UnityEngine.RectOffset.New()

	var1_43.left = 0
	var1_43.right = 0
	var1_43.top = 0

	local var2_43 = arg0_43:findTF("messageScroll/Scrollbar Vertical", arg0_43.rightPanel):GetComponent(typeof(RectTransform))

	if arg1_43 then
		var1_43.bottom = 42 + 88 * arg0_43.optionCount
		var2_43.sizeDelta = Vector2(arg0_43.messageScrollWidth, -var1_43.bottom)
	else
		var1_43.bottom = 50
		var2_43.sizeDelta = Vector2(arg0_43.messageScrollWidth, 0)
	end

	var0_43.padding = var1_43

	scrollToBottom(arg0_43:findTF("messageScroll", arg0_43.rightPanel))
end

function var0_0.SetFilterPanel(arg0_44)
	arg0_44.readFilter = arg0_44.readFilter or var0_0.ReadType[1]
	arg0_44.typeFilter = arg0_44.typeFilter or var0_0.TypeType[1]
	arg0_44.campFilter = arg0_44.campFilter or {
		var0_0.CampIds[1]
	}

	local var0_44 = arg0_44:findTF("panel/filterScroll/Viewport/Content/read", arg0_44.filterUI)
	local var1_44 = arg0_44:findTF("panel/filterScroll/Viewport/Content/type", arg0_44.filterUI)
	local var2_44 = arg0_44:findTF("panel/filterScroll/Viewport/Content/camp", arg0_44.filterUI)
	local var3_44 = UIItemList.New(var2_44, arg0_44:findTF("option", var2_44))

	onButton(arg0_44, arg0_44.filterBtn, function()
		SetActive(arg0_44.filterUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_44.filterUI)

		for iter0_45, iter1_45 in ipairs(var0_0.ReadType) do
			local var0_45 = var0_44:GetChild(iter0_45)
			local var1_45 = arg0_44:findTF("selectedFrame", var0_45)

			SetActive(var1_45, arg0_44.readFilter == iter1_45)
			onButton(arg0_44, var0_45, function()
				for iter0_46, iter1_46 in ipairs(var0_0.ReadType) do
					SetActive(arg0_44:findTF("selectedFrame", var0_44:GetChild(iter0_46)), false)
				end

				SetActive(var1_45, true)
			end, SFX_PANEL)
		end

		for iter2_45, iter3_45 in ipairs(var0_0.TypeType) do
			local var2_45 = var1_44:GetChild(iter2_45)
			local var3_45 = arg0_44:findTF("selectedFrame", var2_45)

			SetActive(var3_45, arg0_44.typeFilter == iter3_45)
			onButton(arg0_44, var2_45, function()
				for iter0_47, iter1_47 in ipairs(var0_0.TypeType) do
					SetActive(arg0_44:findTF("selectedFrame", var1_44:GetChild(iter0_47)), false)
				end

				SetActive(var3_45, true)
			end, SFX_PANEL)
		end

		var3_44:make(function(arg0_48, arg1_48, arg2_48)
			if arg0_48 == UIItemList.EventUpdate then
				setText(arg2_48:Find("Text"), i18n(var0_0.CampNames[arg1_48 + 1]))

				local var0_48 = arg2_48:Find("selectedFrame")

				SetActive(var0_48, _.contains(arg0_44.campFilter, var0_0.CampIds[arg1_48 + 1]))
				onButton(arg0_44, arg2_48, function()
					if arg1_48 == 0 then
						SetActive(var0_48, true)

						for iter0_49 = 2, #var0_0.CampIds do
							SetActive(arg0_44:findTF("selectedFrame", var2_44:GetChild(iter0_49 - 1)), false)
						end
					else
						SetActive(var0_48, not isActive(var0_48))

						local var0_49 = true
						local var1_49 = true

						for iter1_49 = 2, #var0_0.CampIds do
							if not isActive(arg0_44:findTF("selectedFrame", var2_44:GetChild(iter1_49 - 1))) then
								var0_49 = false
							end

							if isActive(arg0_44:findTF("selectedFrame", var2_44:GetChild(iter1_49 - 1))) then
								var1_49 = false
							end
						end

						if var0_49 then
							SetActive(arg0_44:findTF("selectedFrame", var2_44:GetChild(0)), true)

							for iter2_49 = 2, #var0_0.CampIds do
								SetActive(arg0_44:findTF("selectedFrame", var2_44:GetChild(iter2_49 - 1)), false)
							end
						elseif var1_49 then
							SetActive(arg0_44:findTF("selectedFrame", var2_44:GetChild(0)), true)
						else
							SetActive(arg0_44:findTF("selectedFrame", var2_44:GetChild(0)), false)
						end
					end
				end, SFX_PANEL)
			end
		end)
		var3_44:align(#var0_0.CampIds)
	end, SFX_PANEL)
	onButton(arg0_44, arg0_44:findTF("bg", arg0_44.filterUI), function()
		arg0_44:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_44, arg0_44:findTF("panel/bottom/close", arg0_44.filterUI), function()
		arg0_44:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_44, arg0_44:findTF("panel/bottom/ok", arg0_44.filterUI), function()
		for iter0_52, iter1_52 in ipairs(var0_0.ReadType) do
			local var0_52 = var0_44:GetChild(iter0_52)
			local var1_52 = arg0_44:findTF("selectedFrame", var0_52)

			if isActive(var1_52) then
				arg0_44.readFilter = iter1_52
			end
		end

		for iter2_52, iter3_52 in ipairs(var0_0.TypeType) do
			local var2_52 = var1_44:GetChild(iter2_52)
			local var3_52 = arg0_44:findTF("selectedFrame", var2_52)

			if isActive(var3_52) then
				arg0_44.typeFilter = iter3_52
			end
		end

		arg0_44.campFilter = {}

		for iter4_52, iter5_52 in ipairs(var0_0.CampIds) do
			local var4_52 = var2_44:GetChild(iter4_52 - 1)
			local var5_52 = arg0_44:findTF("selectedFrame", var4_52)

			if isActive(var5_52) then
				table.insert(arg0_44.campFilter, iter5_52)
			end
		end

		arg0_44:CloseFilterPanel()
		arg0_44:SetFilterResult()
	end, SFX_PANEL)
end

function var0_0.SetFilterResult(arg0_53)
	local var0_53 = true
	local var1_53 = false

	if not arg0_53.readFilter then
		arg0_53.readFilter = var0_0.ReadType[1]
		arg0_53.typeFilter = var0_0.TypeType[1]
		arg0_53.campFilter = {
			var0_0.CampIds[1]
		}
	end

	for iter0_53, iter1_53 in ipairs(arg0_53.chatList) do
		local var2_53 = true

		if arg0_53.readFilter ~= "all" then
			local var3_53 = arg0_53.readFilter == "hasReaded" and 1 or 0

			if iter1_53:GetCharacterEndFlag() ~= var3_53 then
				var2_53 = false
			end
		end

		if arg0_53.typeFilter ~= "all" then
			local var4_53 = arg0_53.typeFilter == "single" and 1 or 2

			if iter1_53.type ~= var4_53 then
				var2_53 = false
			end
		end

		if not _.contains(arg0_53.campFilter, 0) and not _.contains(arg0_53.campFilter, iter1_53.nationality) then
			var2_53 = false
		end

		SetActive(arg0_53:findTF("main/leftPanel/charaScroll/Viewport/Content"):GetChild(iter0_53 - 1), var2_53)

		if var2_53 then
			var0_53 = false
		end

		if arg0_53.currentChat and arg0_53.currentChat.characterId == iter1_53.characterId and var2_53 then
			var1_53 = true
		end
	end

	local var5_53 = arg0_53.readFilter == "all" and arg0_53.typeFilter == "all" and _.contains(arg0_53.campFilter, 0)

	SetActive(arg0_53.isFiltered, not var5_53)

	if var0_53 then
		SetActive(arg0_53:findTF("charaScroll", arg0_53.leftPanel), false)
		SetActive(arg0_53:findTF("main/noFilteredMessageBg"), true)
		SetActive(arg0_53.rightPanel, false)
		SetActive(arg0_53:findTF("main/rightNoMessageBg"), false)
	else
		SetActive(arg0_53:findTF("charaScroll", arg0_53.leftPanel), true)
		SetActive(arg0_53:findTF("main/noFilteredMessageBg"), false)

		if var1_53 then
			SetActive(arg0_53.rightPanel, true)
			SetActive(arg0_53:findTF("main/rightNoMessageBg"), false)
		else
			SetActive(arg0_53.rightPanel, false)
			SetActive(arg0_53:findTF("main/rightNoMessageBg"), true)

			arg0_53.currentChat = nil

			if arg0_53.cancelFrame then
				arg0_53.cancelFrame()

				arg0_53.cancelFrame = nil
			end
		end
	end
end

function var0_0.CloseFilterPanel(arg0_54)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_54.filterUI, arg0_54:findTF("subPages"))
	SetActive(arg0_54.filterUI, false)
end

function var0_0.SetTopicPanel(arg0_55, arg1_55)
	SetActive(arg0_55:findTF("tip", arg0_55.topicBtn), arg1_55:GetCharacterEndFlagExceptCurrent() == 0)
	onButton(arg0_55, arg0_55.topicBtn, function()
		SetActive(arg0_55.topicUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_55.topicUI)

		arg0_55.currentTopic = nil

		local var0_56 = UIItemList.New(arg0_55:findTF("panel/topicScroll/Viewport/Content", arg0_55.topicUI), arg0_55:findTF("panel/topicScroll/Viewport/Content/topic", arg0_55.topicUI))

		var0_56:make(function(arg0_57, arg1_57, arg2_57)
			if arg0_57 == UIItemList.EventUpdate then
				arg1_55:SortTopicList()

				local var0_57 = arg1_55.topics[arg1_57 + 1]

				setScrollText(arg2_57:Find("mask/name"), HXSet.hxLan(var0_57.name))
				SetActive(arg2_57:Find("lock"), not var0_57.active)
				SetActive(arg2_57:Find("waiting"), var0_57.active and var0_57:isWaiting())
				SetActive(arg2_57:Find("complete"), var0_57.active and var0_57:IsCompleted())
				SetActive(arg2_57:Find("selectedFrame"), arg1_55.currentTopicId == var0_57.topicId)
				SetActive(arg2_57:Find("selected"), arg1_55.currentTopicId == var0_57.topicId)
				SetActive(arg2_57:Find("tip"), var0_57.active and not var0_57:IsCompleted())

				if arg1_55.currentTopicId == var0_57.topicId then
					arg0_55.currentTopic = var0_57
				end

				SetActive(arg2_57, var0_57.active)

				if var0_57.active then
					onButton(arg0_55, arg2_57, function()
						SetActive(arg2_57:Find("selectedFrame"), true)

						for iter0_58 = 1, #arg1_55.topics do
							if iter0_58 ~= arg1_57 + 1 then
								SetActive(arg0_55:findTF("selectedFrame", arg0_55:findTF("panel/topicScroll/Viewport/Content", arg0_55.topicUI):GetChild(iter0_58 - 1)), false)
							end
						end

						arg0_55.currentTopic = var0_57
					end, SFX_PANEL)
				else
					onButton(arg0_55, arg2_57, function()
						pg.TipsMgr.GetInstance():ShowTips(var0_57.unlockDesc)
					end, SFX_PANEL)
				end
			end
		end)
		var0_56:align(#arg1_55.topics)
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55:findTF("bg", arg0_55.topicUI), function()
		arg0_55:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55:findTF("panel/bottom/close", arg0_55.topicUI), function()
		arg0_55:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55:findTF("panel/bottom/ok", arg0_55.topicUI), function()
		arg0_55:emit(InstagramChatMediator.SET_CURRENT_TOPIC, arg0_55.currentTopic.topicId)
		arg0_55:CloseTopicPanel()

		local var0_62 = arg0_55.rightPanel:GetComponent(typeof(Animation))

		var0_62:Stop()
		var0_62:Play("anim_newinstagram_chat_right_in")
	end, SFX_PANEL)
end

function var0_0.CloseTopicPanel(arg0_63)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_63.topicUI, arg0_63:findTF("subPages"))
	SetActive(arg0_63.topicUI, false)
end

function var0_0.SetBackgroundPanel(arg0_64, arg1_64)
	if arg1_64.type == 2 then
		SetActive(arg0_64.backgroundBtn, false)

		return
	end

	SetActive(arg0_64.backgroundBtn, true)

	local var0_64 = arg1_64:GetPaintingId()

	onButton(arg0_64, arg0_64.backgroundBtn, function()
		SetActive(arg0_64.backgroundUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_64.backgroundUI)

		arg0_64.currentBgId = nil

		local var0_65 = arg1_64:GetSkins()
		local var1_65 = UIItemList.New(arg0_64:findTF("panel/backgroundScroll/Viewport/Content", arg0_64.backgroundUI), arg0_64:findTF("panel/backgroundScroll/Viewport/Content/background", arg0_64.backgroundUI))

		var1_65:make(function(arg0_66, arg1_66, arg2_66)
			if arg0_66 == UIItemList.EventUpdate then
				local var0_66 = var0_65[arg1_66 + 1]
				local var1_66 = 0

				if var0_66.id ~= var0_64 then
					var1_66 = var0_66.id
				end

				local var2_66 = var0_66.painting

				LoadImageSpriteAsync("herohrzicon/" .. var2_66, arg2_66:Find("skinMask/skin"), false)
				setScrollText(arg2_66:Find("skinMask/Panel/mask/Text"), var0_66.name)

				local var3_66 = getProxy(ShipSkinProxy):hasSkin(var0_66.id) or var0_66.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or var0_66.skin_type == ShipSkin.SKIN_TYPE_PROPOSE or var0_66.skin_type == ShipSkin.SKIN_TYPE_REMAKE

				SetActive(arg2_66:Find("lockFrame"), not var3_66)
				SetActive(arg2_66:Find("selectedFrame"), arg1_64.skinId == var1_66)
				SetActive(arg2_66:Find("selected"), arg1_64.skinId == var1_66)

				if arg1_64.skinId == var1_66 then
					arg0_64.currentBgId = var1_66
				end

				onButton(arg0_64, arg2_66, function()
					if var3_66 then
						SetActive(arg2_66:Find("selectedFrame"), true)

						for iter0_67 = 1, #var0_65 do
							if iter0_67 ~= arg1_66 + 1 then
								local var0_67 = arg0_64:findTF("panel/backgroundScroll/Viewport/Content", arg0_64.backgroundUI):GetChild(iter0_67 - 1)

								SetActive(arg0_64:findTF("selectedFrame", var0_67), false)
							end
						end

						arg0_64.currentBgId = var1_66
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("juuschat_background_tip2"))
					end
				end, SFX_PANEL)
			end
		end)
		var1_65:align(#var0_65)
	end, SFX_PANEL)
	onButton(arg0_64, arg0_64:findTF("bg", arg0_64.backgroundUI), function()
		arg0_64:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_64, arg0_64:findTF("panel/bottom/close", arg0_64.backgroundUI), function()
		arg0_64:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_64, arg0_64:findTF("panel/bottom/ok", arg0_64.backgroundUI), function()
		arg0_64:emit(InstagramChatMediator.SET_CURRENT_BACKGROUND, arg1_64.characterId, arg0_64.currentBgId)
		arg0_64:CloseBackgroundPanel()
	end, SFX_PANEL)
end

function var0_0.CloseBackgroundPanel(arg0_71)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_71.backgroundUI, arg0_71:findTF("subPages"))
	SetActive(arg0_71.backgroundUI, false)
end

function var0_0.SetRedPacketPanel(arg0_72, arg1_72, arg2_72, arg3_72, arg4_72, arg5_72, arg6_72)
	onButton(arg0_72, arg1_72, function()
		SetActive(arg0_72.redPacketUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_72.redPacketUI)
		setImageSprite(arg0_72:findTF("panel/charaBg/chara", arg0_72.redPacketUI), LoadSprite("qicon/" .. arg4_72), false)

		if not arg3_72 then
			SetActive(arg0_72:findTF("panel/panelBg", arg0_72.redPacketUI), true)
			SetActive(arg0_72:findTF("panel/openImg", arg0_72.redPacketUI), false)
			SetActive(arg0_72:findTF("panel/get", arg0_72.redPacketUI), true)
			SetActive(arg0_72:findTF("panel/got", arg0_72.redPacketUI), false)
			SetActive(arg0_72:findTF("panel/detail", arg0_72.redPacketUI), false)
			setText(arg0_72:findTF("panel/get/titleBg/title", arg0_72.redPacketUI), arg2_72.desc)
			onButton(arg0_72, arg0_72:findTF("panel/get/getBtn", arg0_72.redPacketUI), function()
				arg0_72:emit(InstagramChatMediator.GET_REDPACKET, arg5_72, arg6_72, arg2_72.id)
			end, SFX_PANEL)
		else
			arg0_72:UpdateRedPacketUI(arg2_72.id)
		end
	end, SFX_PANEL)
	onButton(arg0_72, arg0_72:findTF("bg", arg0_72.redPacketUI), function()
		arg0_72:CloseRedPacketPanel()

		if arg0_72.canFresh then
			arg0_72.canFresh = false

			local var0_75 = arg0_72.currentChat.currentTopic:GetDisplayWordList()

			if var0_75[#var0_75].type == 0 then
				arg0_72:UpdateCharaList(false, false)
			else
				arg0_72:UpdateCharaList(true, false)
			end
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRedPacketUI(arg0_76, arg1_76)
	local var0_76 = var2_0[arg1_76]

	SetActive(arg0_76:findTF("panel/panelBg", arg0_76.redPacketUI), true)
	SetActive(arg0_76:findTF("panel/openImg", arg0_76.redPacketUI), false)
	SetActive(arg0_76:findTF("panel/get", arg0_76.redPacketUI), false)
	SetActive(arg0_76:findTF("panel/got", arg0_76.redPacketUI), true)
	SetActive(arg0_76:findTF("panel/detail", arg0_76.redPacketUI), false)

	local var1_76 = Drop.Create(var0_76.content)

	var1_76.count = 0

	updateDrop(arg0_76:findTF("panel/got/item", arg0_76.redPacketUI), var1_76)
	onButton(arg0_76, arg0_76:findTF("panel/got/item", arg0_76.redPacketUI), function()
		arg0_76:emit(BaseUI.ON_DROP, var1_76)
	end, SFX_PANEL)

	arg0_76:findTF("panel/got/item/icon_bg", arg0_76.redPacketUI):GetComponent(typeof(Image)).enabled = false
	arg0_76:findTF("panel/got/item/icon_bg/frame", arg0_76.redPacketUI):GetComponent(typeof(Image)).enabled = false

	setText(arg0_76:findTF("panel/got/awardCount", arg0_76.redPacketUI), var0_76.content[3])

	if var0_76.type == 1 then
		SetActive(arg0_76:findTF("panel/got/detailBtn", arg0_76.redPacketUI), false)
	else
		SetActive(arg0_76:findTF("panel/got/detailBtn", arg0_76.redPacketUI), true)
		onButton(arg0_76, arg0_76:findTF("panel/got/detailBtn", arg0_76.redPacketUI), function()
			SetActive(arg0_76:findTF("panel/panelBg", arg0_76.redPacketUI), false)
			SetActive(arg0_76:findTF("panel/openImg", arg0_76.redPacketUI), true)
			SetActive(arg0_76:findTF("panel/got", arg0_76.redPacketUI), false)
			SetActive(arg0_76:findTF("panel/detail", arg0_76.redPacketUI), true)

			local var0_78 = 0
			local var1_78 = 0
			local var2_78 = UIItemList.New(arg0_76:findTF("panel/detail/detailScroll/Viewport/Content", arg0_76.redPacketUI), arg0_76:findTF("panel/detail/detailScroll/Viewport/Content/charaGetCard", arg0_76.redPacketUI))

			var2_78:make(function(arg0_79, arg1_79, arg2_79)
				if arg0_79 == UIItemList.EventUpdate then
					local var0_79 = var0_76.group_receive[arg1_79 + 1]
					local var1_79 = var0_79[1]
					local var2_79 = {
						var0_79[2],
						var0_79[3],
						var0_79[4]
					}

					if var0_79[1] ~= 0 then
						local var3_79 = "unknown"

						if var1_0[var1_79] then
							var3_79 = var1_0[var1_79].sculpture
						end

						setImageSprite(arg2_79:Find("charaBg/chara"), LoadSprite("qicon/" .. var3_79), false)
					else
						setImageSprite(arg2_79:Find("charaBg/chara"), GetSpriteFromAtlas("ui/InstagramUI_atlas", "txdi_3"), false)
					end

					local var4_79 = Drop.Create(var2_79)

					var4_79.count = 0

					updateDrop(arg2_79:Find("item"), var4_79)
					onButton(arg0_76, arg2_79:Find("item"), function()
						arg0_76:emit(BaseUI.ON_DROP, var4_79)
					end, SFX_PANEL)

					arg2_79:Find("item/icon_bg"):GetComponent(typeof(Image)).enabled = false
					arg2_79:Find("item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

					setText(arg2_79:Find("awardCount"), var0_79[4])

					if var0_79[4] > var1_78 then
						var0_78 = arg1_79
						var1_78 = var0_79[4]
					end
				end
			end)
			var2_78:align(#var0_76.group_receive)

			for iter0_78 = 1, #var0_76.group_receive do
				SetActive(arg0_76:findTF("charaBg/king", arg0_76:findTF("panel/detail/detailScroll/Viewport/Content", arg0_76.redPacketUI):GetChild(iter0_78 - 1)), var0_78 == iter0_78 - 1)
			end
		end, SFX_PANEL)
	end
end

function var0_0.CloseRedPacketPanel(arg0_81)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_81.redPacketUI, arg0_81:findTF("subPages"))
	SetActive(arg0_81.redPacketUI, false)
end

function var0_0.SetData(arg0_82)
	local var0_82 = getProxy(InstagramChatProxy)

	arg0_82.chatList = var0_82:GetChatList()

	var0_82:SortChatList()
end

function var0_0.willExit(arg0_83)
	local var0_83 = arg0_83:findTF("paintingMask/painting", arg0_83.rightPanel)

	if arg0_83.paintingName then
		retPaintingPrefab(var0_83, arg0_83.paintingName)

		arg0_83.paintingName = nil
	end

	arg0_83:RemoveAllTimer()
end

function var0_0.StartTimer(arg0_84, arg1_84, arg2_84)
	local var0_84 = Timer.New(arg1_84, arg2_84, 1)

	var0_84:Start()
	table.insert(arg0_84.timerList, var0_84)
end

function var0_0.RemoveAllTimer(arg0_85)
	for iter0_85, iter1_85 in ipairs(arg0_85.timerList) do
		iter1_85:Stop()
	end

	arg0_85.timerList = {}
end

function var0_0.StartTimer2(arg0_86, arg1_86, arg2_86)
	arg0_86.timer = Timer.New(arg1_86, arg2_86, 1)

	arg0_86.timer:Start()
end

function var0_0.SpeedUpMessage(arg0_87)
	local var0_87 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var1_87 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_87, iter1_87 in ipairs(arg0_87.timerList) do
		if iter1_87.running then
			if iter1_87.duration == var1_87 then
				iter1_87.time = 0.05
			elseif iter1_87.time - var0_87 < 0.05 then
				iter1_87.time = 0.05

				arg0_87:StartTimer2(function()
					arg0_87:SpeedUpWaiting()
				end, 0.05)
			else
				iter1_87.time = iter1_87.time - var0_87
			end
		end
	end
end

function var0_0.SpeedUpWaiting(arg0_89)
	local var0_89 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_89, iter1_89 in ipairs(arg0_89.timerList) do
		if iter1_89.running and iter1_89.duration == var0_89 then
			iter1_89.time = 0.05

			break
		end
	end
end

function var0_0.ChangeFresh(arg0_90)
	arg0_90.canFresh = true
end

function var0_0.ChangeCharaTextFunc(arg0_91, arg1_91, arg2_91)
	local function var0_91(arg0_92, arg1_92)
		if arg1_92:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_91) then
			setText(arg1_92:Find("msg"), arg2_91)
		end
	end

	arg0_91.charaList:each(var0_91)
end

function var0_0.ResetCharaTextFunc(arg0_93, arg1_93)
	local function var0_93(arg0_94, arg1_94)
		if arg1_94:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_93) then
			setText(arg1_94:Find("msg"), arg1_94:Find("displayWord"):GetComponent(typeof(Text)).text)
		end
	end

	arg0_93.charaList:each(var0_93)
end

function var0_0.SetEndAniEvent(arg0_95, arg1_95, arg2_95)
	local var0_95 = arg1_95:GetComponent(typeof(DftAniEvent))

	if var0_95 then
		var0_95:SetEndEvent(function()
			arg2_95()
			var0_95:SetEndEvent(nil)
		end)
	end
end

function var0_0.onBackPressed(arg0_97)
	if isActive(arg0_97.filterUI) then
		arg0_97:CloseFilterPanel()

		return
	end

	if isActive(arg0_97.topicUI) then
		arg0_97:CloseTopicPanel()

		return
	end

	if isActive(arg0_97.backgroundUI) then
		arg0_97:CloseBackgroundPanel()

		return
	end

	if isActive(arg0_97.redPacketUI) then
		arg0_97:CloseRedPacketPanel()

		return
	end

	arg0_97:emit(InstagramChatMediator.CLOSE_ALL)
end

return var0_0
