local var0_0 = class("InstagramChatLayer", import("...base.BaseUI"))
local var1_0 = pg.activity_ins_ship_group_template
local var2_0 = pg.activity_ins_redpackage
local var3_0 = pg.emoji_template

function var0_0.getUIName(arg0_1)
	return "InstagramChatUI"
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
	11
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
	"word_shipNation_other"
}

function var0_0.init(arg0_2)
	arg0_2.leftPanel = arg0_2:findTF("main/leftPanel")
	arg0_2.filterBtn = arg0_2:findTF("leftTop/filter", arg0_2.leftPanel)
	arg0_2.isFiltered = arg0_2:findTF("isFiltered", arg0_2.filterBtn)
	arg0_2.charaList = UIItemList.New(arg0_2:findTF("charaScroll/Viewport/Content", arg0_2.leftPanel), arg0_2:findTF("charaScroll/Viewport/Content/charaMsg", arg0_2.leftPanel))
	arg0_2.rightPanel = arg0_2:findTF("main/rightPanel")
	arg0_2.characterName = arg0_2:findTF("rightTop/name", arg0_2.rightPanel)
	arg0_2.careBtn = arg0_2:findTF("rightTop/careBtn", arg0_2.rightPanel)
	arg0_2.topicBtn = arg0_2:findTF("rightTop/topicBtn", arg0_2.rightPanel)
	arg0_2.backgroundBtn = arg0_2:findTF("rightTop/backgroundBtn", arg0_2.rightPanel)
	arg0_2.messageList = UIItemList.New(arg0_2:findTF("messageScroll/Viewport/Content", arg0_2.rightPanel), arg0_2:findTF("messageScroll/Viewport/Content/messageCard", arg0_2.rightPanel))
	arg0_2.optionPanel = arg0_2:findTF("optionPanel", arg0_2.rightPanel)
	arg0_2.optionList = UIItemList.New(arg0_2.optionPanel, arg0_2:findTF("option", arg0_2.optionPanel))
	arg0_2.filterUI = arg0_2:findTF("subPages/InstagramFilterUI")
	arg0_2.topicUI = arg0_2:findTF("subPages/InstagramTopicUI")
	arg0_2.backgroundUI = arg0_2:findTF("subPages/InstagramBackgroundUI")
	arg0_2.redPacketUI = arg0_2:findTF("subPages/InstagramRedPacketUI")

	setText(arg0_2:findTF("Text", arg0_2.filterBtn), i18n("juuschat_filter_title"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/read/subTitleFrame/subTitle", arg0_2.filterUI), i18n("juuschat_filter_subtitle1"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle", arg0_2.filterUI), i18n("juuschat_filter_subtitle2"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/subTitleFrame/subTitle", arg0_2.filterUI), i18n("juuschat_filter_subtitle3"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/read/option/Text", arg0_2.filterUI), i18n("juuschat_filter_tip1"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/read/option_1/Text", arg0_2.filterUI), i18n("juuschat_filter_tip2"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/read/option_2/Text", arg0_2.filterUI), i18n("juuschat_filter_tip3"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/type/option/Text", arg0_2.filterUI), i18n("juuschat_filter_tip1"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/type/option_1/Text", arg0_2.filterUI), i18n("juuschat_filter_tip4"))
	setText(arg0_2:findTF("panel/filterScroll/Viewport/Content/type/option_2/Text", arg0_2.filterUI), i18n("juuschat_filter_tip5"))
	setText(arg0_2:findTF("panel/topicScroll/Viewport/Content/topic/waiting", arg0_2.topicUI), i18n("juuschat_chattip3"))
	setText(arg0_2:findTF("panel/topicScroll/Viewport/Content/topic/selected/Text", arg0_2.topicUI), i18n("juuschat_label2"))
	setText(arg0_2:findTF("panel/backgroundScroll/Viewport/Content/background/selected/Text", arg0_2.backgroundUI), i18n("juuschat_label1"))
	setText(arg0_2:findTF("panel/got/detailBtn/Text", arg0_2.redPacketUI), i18n("juuschat_redpacket_show_detail"))
	setText(arg0_2:findTF("panel/detail/title", arg0_2.redPacketUI), i18n("juuschat_redpacket_detail"))
	setText(arg0_2:findTF("main/noFilteredMessageBg/Text"), i18n("juuschat_filter_empty"))
	setText(arg0_2:findTF("panel/backgroundScroll/Viewport/Content/background/lockFrame/Text", arg0_2.backgroundUI), i18n("juuschat_background_tip1"))

	arg0_2.redPacketGot = arg0_2:findTF("panel/got", arg0_2.redPacketUI)

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		groupName = "Instagram",
		weight = LayerWeightConst.SECOND_LAYER
	})
	SetActive(arg0_2.filterUI, false)
	SetActive(arg0_2.isFiltered, false)
	SetActive(arg0_2.topicUI, false)
	SetActive(arg0_2.backgroundUI, false)
	SetActive(arg0_2.redPacketUI, false)
	SetActive(arg0_2.rightPanel, false)

	arg0_2.timerList = {}
	arg0_2.canFresh = false

	local var0_2 = arg0_2:findTF("messageScroll/Scrollbar Vertical", arg0_2.rightPanel):GetComponent(typeof(RectTransform))

	arg0_2.messageScrollWidth = var0_2.rect.width
	arg0_2.messageScrollHeight = var0_2.rect.height

	arg0_2:findTF("panel/title", arg0_2.filterUI):GetComponent(typeof(Image)):SetNativeSize()
	arg0_2:findTF("panel/title", arg0_2.topicUI):GetComponent(typeof(Image)):SetNativeSize()
	arg0_2:findTF("panel/title", arg0_2.backgroundUI):GetComponent(typeof(Image)):SetNativeSize()
end

function var0_0.didEnter(arg0_3)
	arg0_3:SetData()
	arg0_3:UpdateCharaList(false, false)
	arg0_3:SetFilterPanel()
end

function var0_0.UpdateCharaList(arg0_4, arg1_4, arg2_4)
	if not arg0_4.chatList or #arg0_4.chatList == 0 then
		SetActive(arg0_4.leftPanel, false)
		SetActive(arg0_4.rightPanel, false)
		SetActive(arg0_4:findTF("main/noMessageBg"), true)
		SetActive(arg0_4:findTF("main/noFilteredMessageBg"), false)
		SetActive(arg0_4:findTF("main/rightNoMessageBg"), false)

		return
	end

	if not arg0_4.currentChat then
		SetActive(arg0_4.rightPanel, false)
		SetActive(arg0_4:findTF("main/rightNoMessageBg"), true)
	else
		SetActive(arg0_4.rightPanel, true)
		SetActive(arg0_4:findTF("main/rightNoMessageBg"), false)
	end

	arg0_4.charaList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_4.chatList[arg1_5 + 1]

			setImageSprite(arg2_5:Find("charaBg/chara"), LoadSprite("qicon/" .. var0_5.sculpture), false)
			setText(arg2_5:Find("name"), var0_5.name)

			local var1_5 = var0_5:GetDisplayWord()

			if not arg0_4.currentChat or arg0_4.currentChat.characterId ~= var0_5.characterId or not arg1_4 then
				setText(arg2_5:Find("msg"), var1_5)
			end

			setText(arg2_5:Find("displayWord"), var1_5)
			SetActive(arg2_5:Find("care"), var0_5.care == 1)

			if var0_5.care == 1 and arg0_4.careAniTriggerId and arg0_4.careAniTriggerId == var0_5.characterId then
				arg0_4.careAniTriggerId = nil

				arg2_5:Find("care"):GetComponent(typeof(Animation)):Play("anim_newinstagram_care")
			end

			if arg0_4.currentChat then
				SetActive(arg2_5:Find("frame"), arg0_4.currentChat == var0_5)
			end

			SetActive(arg2_5:Find("tip"), var0_5:GetCharacterEndFlag() == 0)
			setText(arg2_5:Find("id"), var0_5.characterId)
			onButton(arg0_4, arg2_5, function()
				if arg0_4.currentChat and arg0_4.currentChat.characterId ~= var0_5.characterId then
					arg0_4:ResetCharaTextFunc(arg0_4.currentChat.characterId)
				end

				arg0_4.currentChat = var0_5

				SetActive(arg0_4.rightPanel, true)
				SetActive(arg0_4:findTF("main/rightNoMessageBg"), false)
				arg0_4:UpdateChatContent(var0_5, false, false)
				arg0_4:SetTopicPanel(var0_5)
				arg0_4:SetBackgroundPanel(var0_5)

				for iter0_6, iter1_6 in ipairs(arg0_4.chatList) do
					SetActive(arg0_4:findTF("frame", arg0_4:findTF("main/leftPanel/charaScroll/Viewport/Content"):GetChild(iter0_6 - 1)), false)
				end

				SetActive(arg2_5:Find("frame"), true)

				function arg0_4.cancelFrame()
					SetActive(arg2_5:Find("frame"), false)
				end

				local var0_6 = arg0_4.rightPanel:GetComponent(typeof(Animation))

				var0_6:Stop()
				var0_6:Play("anim_newinstagram_chat_right_in")
			end, SFX_PANEL)
		end
	end)
	arg0_4.charaList:align(#arg0_4.chatList)
	arg0_4:SetFilterResult()

	if arg0_4.currentChat then
		arg0_4:UpdateChatContent(arg0_4.currentChat, arg1_4, arg2_4)
		arg0_4:SetTopicPanel(arg0_4.currentChat)
	end
end

function var0_0.UpdateChatContent(arg0_8, arg1_8, arg2_8, arg3_8)
	SetActive(arg0_8.rightPanel, true)
	setText(arg0_8.characterName, arg1_8.name)

	local var0_8 = arg0_8:findTF("care", arg0_8.careBtn)

	SetActive(var0_8, arg1_8.care == 1)
	onButton(arg0_8, arg0_8.careBtn, function()
		local var0_9 = arg1_8.care == 0 and 1 or 0

		arg0_8:emit(InstagramChatMediator.CHANGE_CARE, arg1_8.characterId, var0_9)

		arg0_8.careAniTriggerId = arg1_8.characterId
	end, SFX_PANEL)

	local var1_8 = arg0_8:findTF("paintingMask", arg0_8.rightPanel)
	local var2_8 = arg0_8:findTF("painting", var1_8)
	local var3_8 = arg0_8:findTF("groupBackground", arg0_8.rightPanel)

	if arg1_8.type == 1 then
		SetActive(var1_8, true)
		SetActive(var3_8, false)

		local var4_8 = "unknown"

		if arg1_8.skinId == 0 then
			var4_8 = arg1_8:GetPainting()
		else
			for iter0_8, iter1_8 in ipairs(arg1_8.skins) do
				if iter1_8.id == arg1_8.skinId then
					var4_8 = iter1_8.painting
				end
			end
		end

		if not arg0_8.paintingName then
			setPaintingPrefabAsync(var2_8, var4_8, "pifu")

			arg0_8.paintingName = var4_8
		elseif arg0_8.paintingName and arg0_8.paintingName ~= var4_8 then
			retPaintingPrefab(var2_8, arg0_8.paintingName)
			setPaintingPrefabAsync(var2_8, var4_8, "pifu")

			arg0_8.paintingName = var4_8
		end
	else
		SetActive(var1_8, false)
		SetActive(var3_8, true)

		if arg0_8.paintingName then
			retPaintingPrefab(var2_8, arg0_8.paintingName)

			arg0_8.paintingName = nil
		end

		setImageSprite(var3_8, LoadSprite("ui/" .. arg1_8.groupBackground), true)
	end

	local var5_8 = arg1_8.currentTopic:GetDisplayWordList()

	if not arg3_8 then
		arg0_8:UpdateOptionPanel(arg1_8.currentTopic, var5_8)
		arg0_8:UpdateMessageList(arg1_8.currentTopic, var5_8, arg2_8, arg1_8.characterId, arg1_8.type)
	end

	if not arg2_8 and arg1_8.currentTopic.readFlag == 0 then
		arg0_8:emit(InstagramChatMediator.SET_READED, {
			arg1_8.currentTopic.topicId
		})
	end
end

function var0_0.UpdateMessageList(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10)
	arg0_10:RemoveAllTimer()

	local var0_10

	for iter0_10 = #arg2_10, 1, -1 do
		if arg2_10[iter0_10].ship_group == 0 or arg2_10[iter0_10].type == 3 and arg1_10:RedPacketGotFlag(tonumber(arg2_10[iter0_10].param)) then
			var0_10 = iter0_10

			break
		end
	end

	local var1_10 = {}

	if var0_10 then
		for iter1_10 = var0_10, 1, -1 do
			if arg2_10[iter1_10].ship_group == 0 then
				table.insert(var1_10, iter1_10)
			else
				break
			end
		end
	end

	if arg0_10.shouldShowOption and arg3_10 then
		arg0_10:SetOptionPanelActive(false)
	end

	if arg3_10 then
		onButton(arg0_10, arg0_10:findTF("messageScroll", arg0_10.rightPanel), function()
			arg0_10:SpeedUpMessage()
		end, SFX_PANEL)
	end

	local var2_10 = GetComponent(arg0_10:findTF("messageScroll", arg0_10.rightPanel), typeof(ScrollRect))

	local function var3_10(arg0_12)
		local var0_12 = Vector2(0, arg0_12)

		var2_10.normalizedPosition = var0_12
	end

	local var4_10 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var5_10 = pg.gameset.juuschat_entering_time.key_value / 1000
	local var6_10 = var4_10 - var5_10

	arg0_10.messageList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg2_10[arg1_13 + 1]

			if var0_13.ship_group == 0 and var0_13.type == 0 then
				SetActive(arg2_13, false)

				return
			end

			local var1_13 = arg2_13:Find("charaMessageCard")
			local var2_13 = arg2_13:Find("playerReplyCard")

			SetActive(var1_13, var0_13.ship_group ~= 0)
			SetActive(var2_13, var0_13.ship_group == 0)

			if var0_13.ship_group ~= 0 and arg5_10 == 2 and var0_13.type ~= 5 then
				SetActive(arg2_13:Find("nameBar"), true)
				setText(arg2_13:Find("nameBar/Text"), var1_0[var0_13.ship_group].name)
			else
				SetActive(arg2_13:Find("nameBar"), false)
			end

			local var3_13

			if arg3_10 and var0_10 and arg1_13 + 1 > var0_10 then
				var3_13 = (arg1_13 + 1 - var0_10) * var4_10 - var5_10

				if #var1_10 > 1 then
					var3_13 = var3_13 + (#var1_10 - 1) * var6_10
				end
			end

			if var0_13.ship_group ~= 0 then
				local var4_13 = "unknown"

				if var1_0[var0_13.ship_group] then
					var4_13 = var1_0[var0_13.ship_group].sculpture
				end

				if var0_13.type ~= 5 then
					setImageSprite(arg2_13:Find("charaMessageCard/charaBg/chara"), LoadSprite("qicon/" .. var4_13), false)
				end

				if var0_13.type == 1 then
					arg0_10:SetCharaMessageCardActive(var1_13, {
						3
					})
					setText(arg2_13:Find("charaMessageCard/msgBox/msg"), var0_13.param)

					if arg3_10 and var0_10 and arg1_13 + 1 > var0_10 then
						SetActive(arg2_13, false)
						arg0_10:StartTimer(function()
							SetActive(arg2_13, true)
							arg2_13:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_13:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_13:Find("charaMessageCard/msgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
							arg0_10:StartTimer(function()
								SetActive(arg2_13:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_13:Find("charaMessageCard/msgBox"), true)
								arg2_13:Find("charaMessageCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")

								if arg1_13 + 1 ~= #arg2_10 then
									arg0_10:ChangeCharaTextFunc(arg4_10, var0_13.param)
								else
									arg0_10:emit(InstagramChatMediator.SET_READED, {
										arg1_10.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
								arg0_10:SetEndAniEvent(arg2_13:Find("charaMessageCard/msgBox"), function()
									if arg0_10.shouldShowOption and arg1_13 + 1 == #arg2_10 then
										arg0_10:SetOptionPanelActive(true)
									end
								end)
							end, var5_10)
						end, var3_13)
					end
				elseif var0_13.type == 2 then
					arg0_10:SetCharaMessageCardActive(var1_13, {
						2,
						7
					})
					pg.CriMgr.GetInstance():GetCueInfo("cv-" .. var0_13.ship_group, var0_13.param[1], function(arg0_17)
						setText(arg2_13:Find("charaMessageCard/voiceBox/time"), tostring(math.ceil(tonumber(tostring(arg0_17.length)) / 1000)) .. "\"")
					end)
					onButton(arg0_10, arg2_13:Find("charaMessageCard/voiceBox"), function()
						pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/cv/" .. var0_13.ship_group .. "/" .. var0_13.param[1])
					end, SFX_PANEL)
					setText(arg2_13:Find("charaMessageCard/voiceMsgBox/voiceMsg/msg"), var0_13.param[2])

					if arg3_10 and var0_10 and arg1_13 + 1 > var0_10 then
						SetActive(arg2_13, false)
						arg0_10:StartTimer(function()
							SetActive(arg2_13, true)
							arg2_13:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_13:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_13:Find("charaMessageCard/voiceBox"), false)
							SetActive(arg2_13:Find("charaMessageCard/voiceMsgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
							arg0_10:StartTimer(function()
								SetActive(arg2_13:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_13:Find("charaMessageCard/voiceBox"), true)
								SetActive(arg2_13:Find("charaMessageCard/voiceMsgBox"), true)
								arg2_13:Find("charaMessageCard/voiceBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")
								arg2_13:Find("charaMessageCard/voiceMsgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_voicetip_in")

								if arg1_13 + 1 ~= #arg2_10 then
									arg0_10:ChangeCharaTextFunc(arg4_10, "<color=#ff6666>" .. i18n("juuschat_chattip1") .. "</color>")
								else
									arg0_10:emit(InstagramChatMediator.SET_READED, {
										arg1_10.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
								arg0_10:SetEndAniEvent(arg2_13:Find("charaMessageCard/voiceBox"), function()
									if arg0_10.shouldShowOption and arg1_13 + 1 == #arg2_10 then
										arg0_10:SetOptionPanelActive(true)
									end
								end)
							end, var5_10)
						end, var3_13)
					end
				elseif var0_13.type == 3 then
					arg0_10:SetCharaMessageCardActive(var1_13, {
						5
					})

					local var5_13 = var2_0[tonumber(var0_13.param)]

					setText(arg2_13:Find("charaMessageCard/redPacket/desc"), var5_13.desc)

					local var6_13 = arg1_10:RedPacketGotFlag(var5_13.id)

					SetActive(arg2_13:Find("charaMessageCard/redPacket/got"), var6_13)
					arg0_10:SetRedPacketPanel(arg2_13:Find("charaMessageCard/redPacket"), var5_13, var6_13, var4_13, arg1_10.topicId, var0_13.id)

					if arg3_10 and var0_10 and arg1_13 + 1 == var0_10 then
						arg0_10:ChangeCharaTextFunc(arg4_10, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_13.param)].desc)
					end

					if arg3_10 and var0_10 and arg1_13 + 1 > var0_10 then
						SetActive(arg2_13, false)
						arg0_10:StartTimer(function()
							SetActive(arg2_13, true)
							arg2_13:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_13:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_13:Find("charaMessageCard/redPacket"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
							arg0_10:StartTimer(function()
								SetActive(arg2_13:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_13:Find("charaMessageCard/redPacket"), true)
								arg2_13:Find("charaMessageCard/redPacket"):GetComponent(typeof(Animation)):Play("anim_newinstagram_redpacket_in")

								if arg1_13 + 1 ~= #arg2_10 then
									arg0_10:ChangeCharaTextFunc(arg4_10, "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_13.param)].desc)
								else
									arg0_10:emit(InstagramChatMediator.SET_READED, {
										arg1_10.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
								arg0_10:SetEndAniEvent(arg2_13:Find("charaMessageCard/redPacket"), function()
									if arg0_10.shouldShowOption and arg1_13 + 1 == #arg2_10 then
										arg0_10:SetOptionPanelActive(true)
									end
								end)
							end, var5_10)
						end, var3_13)
					end
				elseif var0_13.type == 4 then
					arg0_10:SetCharaMessageCardActive(var1_13, {
						4
					})
					arg0_10:ClearEmoji(arg2_13:Find("charaMessageCard/emoji/emoticon"))
					arg0_10:SetEmoji(arg2_13:Find("charaMessageCard/emoji/emoticon"), var3_0[tonumber(var0_13.param)].pic)

					if arg3_10 and var0_10 and arg1_13 + 1 > var0_10 then
						SetActive(arg2_13, false)
						arg0_10:StartTimer(function()
							SetActive(arg2_13, true)
							arg2_13:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_13:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_13:Find("charaMessageCard/emoji"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
							arg0_10:StartTimer(function()
								SetActive(arg2_13:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_13:Find("charaMessageCard/emoji"), true)
								arg2_13:Find("charaMessageCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								if arg1_13 + 1 ~= #arg2_10 then
									local var0_26 = var3_0[tonumber(var0_13.param)].desc
									local var1_26 = string.gsub(var0_26, "#%w+>", "#28af6e>")

									arg0_10:ChangeCharaTextFunc(arg4_10, var1_26)
								else
									arg0_10:emit(InstagramChatMediator.SET_READED, {
										arg1_10.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
								arg0_10:SetEndAniEvent(arg2_13:Find("charaMessageCard/emoji"), function()
									if arg0_10.shouldShowOption and arg1_13 + 1 == #arg2_10 then
										arg0_10:SetOptionPanelActive(true)
									end
								end)
							end, var5_10)
						end, var3_13)
					end
				elseif var0_13.type == 5 then
					arg0_10:SetCharaMessageCardActive(var1_13, {
						6
					})

					local var7_13 = var0_13.param

					for iter0_13 in string.gmatch(var0_13.param, "'%d+'") do
						local var8_13 = string.sub(iter0_13, 2, #iter0_13 - 1)

						var7_13 = string.gsub(var7_13, iter0_13, "<color=#93e9ff>" .. var1_0[tonumber(var8_13)].name .. "</color>")
					end

					setText(arg2_13:Find("charaMessageCard/systemTip/panel/Text"), var7_13)

					if arg3_10 and var0_10 and arg1_13 + 1 > var0_10 then
						SetActive(arg2_13, false)
						arg0_10:StartTimer(function()
							SetActive(arg2_13, true)
							arg2_13:Find("charaMessageCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							if arg1_13 + 1 ~= #arg2_10 then
								arg0_10:ChangeCharaTextFunc(arg4_10, var7_13)
							else
								arg0_10:emit(InstagramChatMediator.SET_READED, {
									arg1_10.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
							arg0_10:SetEndAniEvent(arg2_13:Find("charaMessageCard/systemTip"), function()
								if arg0_10.shouldShowOption and arg1_13 + 1 == #arg2_10 then
									arg0_10:SetOptionPanelActive(true)
								end
							end)
						end, var3_13)
					end
				end
			else
				if var0_13.type == 1 then
					arg0_10:SetPlayerMessageCardActive(var2_13, {
						0
					})
					setText(arg2_13:Find("playerReplyCard/msgBox/msg"), var0_13.param)
				elseif var0_13.type == 4 then
					arg0_10:SetPlayerMessageCardActive(var2_13, {
						1
					})
					arg0_10:ClearEmoji(arg2_13:Find("playerReplyCard/emoji/emoticon"))
					arg0_10:SetEmoji(arg2_13:Find("playerReplyCard/emoji/emoticon"), var3_0[tonumber(var0_13.param)].pic)
				elseif var0_13.type == 5 then
					arg0_10:SetPlayerMessageCardActive(var2_13, {
						2
					})

					local var9_13 = var0_13.param

					for iter1_13 in string.gmatch(var0_13.param, "'%d+'") do
						local var10_13 = string.sub(iter1_13, 2, #iter1_13 - 1)

						var9_13 = string.gsub(var9_13, iter1_13, "<color=#93e9ff>" .. var1_0[tonumber(var10_13)].name .. "</color>")
					end

					setText(arg2_13:Find("playerReplyCard/systemTip/panel/Text"), var9_13)
				end

				if arg3_10 and var0_10 and _.contains(var1_10, arg1_13 + 1) then
					if table.indexof(var1_10, arg1_13 + 1) < #var1_10 then
						SetActive(arg2_13, false)
						arg0_10:StartTimer(function()
							SetActive(arg2_13, true)

							if var0_13.type == 1 then
								arg2_13:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
								arg0_10:ChangeCharaTextFunc(arg4_10, var0_13.param)
							elseif var0_13.type == 4 then
								arg2_13:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								local var0_30 = var3_0[tonumber(var0_13.param)].desc
								local var1_30 = string.gsub(var0_30, "#%w+>", "#28af6e>")

								arg0_10:ChangeCharaTextFunc(arg4_10, var1_30)
							elseif var0_13.type == 5 then
								arg2_13:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

								local var2_30 = var0_13.param

								for iter0_30 in string.gmatch(var0_13.param, "'%d+'") do
									local var3_30 = string.sub(iter0_30, 2, #iter0_30 - 1)

									var2_30 = string.gsub(var2_30, iter0_30, "<color=#93e9ff>" .. var1_0[tonumber(var3_30)].name .. "</color>")
								end

								arg0_10:ChangeCharaTextFunc(arg4_10, var2_30)
							end

							if arg1_13 + 1 == #arg2_10 then
								arg0_10:emit(InstagramChatMediator.SET_READED, {
									arg1_10.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
						end, (#var1_10 - table.indexof(var1_10, arg1_13 + 1)) * var6_10)
					else
						if var0_13.type == 1 then
							arg2_13:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
							arg0_10:ChangeCharaTextFunc(arg4_10, var0_13.param)
						elseif var0_13.type == 4 then
							arg2_13:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

							local var11_13 = var3_0[tonumber(var0_13.param)].desc
							local var12_13 = string.gsub(var11_13, "#%w+>", "#28af6e>")

							arg0_10:ChangeCharaTextFunc(arg4_10, var12_13)
						elseif var0_13.type == 5 then
							arg2_13:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							local var13_13 = var0_13.param

							for iter2_13 in string.gmatch(var0_13.param, "'%d+'") do
								local var14_13 = string.sub(iter2_13, 2, #iter2_13 - 1)

								var13_13 = string.gsub(var13_13, iter2_13, "<color=#93e9ff>" .. var1_0[tonumber(var14_13)].name .. "</color>")
							end

							arg0_10:ChangeCharaTextFunc(arg4_10, var13_13)
						end

						if arg1_13 + 1 == #arg2_10 then
							arg0_10:emit(InstagramChatMediator.SET_READED, {
								arg1_10.topicId
							})
						end
					end
				end
			end

			if not arg1_10:isWaiting() and arg1_13 + 1 == #arg2_10 then
				if arg3_10 then
					if var0_13.ship_group ~= 0 then
						arg0_10:StartTimer(function()
							setActive(arg2_13:Find("end"), true)
						end, var3_13 + var4_10)
					else
						arg0_10:StartTimer(function()
							setActive(arg2_13:Find("end"), true)
						end, (#var1_10 - table.indexof(var1_10, arg1_13 + 1)) * var6_10 + var6_10)
					end
				else
					setActive(arg2_13:Find("end"), true)
				end
			else
				setActive(arg2_13:Find("end"), false)
			end
		end
	end)
	arg0_10.messageList:align(#arg2_10)

	if arg3_10 then
		Canvas.ForceUpdateCanvases()
		LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
	else
		scrollToBottom(arg0_10:findTF("messageScroll", arg0_10.rightPanel))
	end
end

function var0_0.SetCharaMessageCardActive(arg0_33, arg1_33, arg2_33)
	if _.contains(arg2_33, 6) then
		SetActive(arg1_33:GetChild(0), false)
	else
		SetActive(arg1_33:GetChild(0), true)
	end

	for iter0_33 = 1, arg1_33.childCount - 1 do
		if _.contains(arg2_33, iter0_33) then
			SetActive(arg1_33:GetChild(iter0_33), true)
		else
			SetActive(arg1_33:GetChild(iter0_33), false)
		end
	end
end

function var0_0.SetPlayerMessageCardActive(arg0_34, arg1_34, arg2_34)
	for iter0_34 = 0, arg1_34.childCount - 1 do
		if _.contains(arg2_34, iter0_34) then
			SetActive(arg1_34:GetChild(iter0_34), true)
		else
			SetActive(arg1_34:GetChild(iter0_34), false)
		end
	end
end

function var0_0.SetEmoji(arg0_35, arg1_35, arg2_35)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg2_35, arg2_35, true, function(arg0_36)
		if not IsNil(arg1_35) then
			arg0_36.name = arg2_35
			tf(arg0_36).sizeDelta = arg1_35.sizeDelta
			tf(arg0_36).anchoredPosition = Vector2.zero

			local var0_36 = arg0_36:GetComponent("Animator")

			if var0_36 then
				var0_36.enabled = true
			end

			setParent(arg0_36, arg1_35, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg2_35, arg2_35, arg0_36)
		end
	end)
end

function var0_0.ClearEmoji(arg0_37, arg1_37)
	eachChild(arg1_37, function(arg0_38)
		local var0_38 = go(arg0_38)

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_38.name, var0_38.name, var0_38)
	end)
end

function var0_0.UpdateOptionPanel(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg2_39[#arg2_39].option

	if var0_39 and type(var0_39) == "table" then
		arg0_39.shouldShowOption = true
		arg0_39.optionCount = #var0_39

		arg0_39:SetOptionPanelActive(true)
		arg0_39.optionList:make(function(arg0_40, arg1_40, arg2_40)
			if arg0_40 == UIItemList.EventUpdate then
				local var0_40 = var0_39[arg1_40 + 1]

				setText(arg2_40:Find("Text"), HXSet.hxLan(var0_40[2]))
				onButton(arg0_39, arg2_40, function()
					arg0_39:emit(InstagramChatMediator.REPLY, arg1_39.topicId, arg2_39[#arg2_39].id, var0_40[1])
				end, SFX_PANEL)
			end
		end)
		arg0_39.optionList:align(#var0_39)
	else
		arg0_39:SetOptionPanelActive(false)

		arg0_39.shouldShowOption = false
	end
end

function var0_0.SetOptionPanelActive(arg0_42, arg1_42)
	SetActive(arg0_42.optionPanel, arg1_42)

	local var0_42 = arg0_42:findTF("messageScroll/Viewport/Content", arg0_42.rightPanel):GetComponent(typeof(VerticalLayoutGroup))
	local var1_42 = UnityEngine.RectOffset.New()

	var1_42.left = 0
	var1_42.right = 0
	var1_42.top = 0

	local var2_42 = arg0_42:findTF("messageScroll/Scrollbar Vertical", arg0_42.rightPanel):GetComponent(typeof(RectTransform))

	if arg1_42 then
		var1_42.bottom = 42 + 88 * arg0_42.optionCount
		var2_42.sizeDelta = Vector2(arg0_42.messageScrollWidth, -var1_42.bottom)
	else
		var1_42.bottom = 50
		var2_42.sizeDelta = Vector2(arg0_42.messageScrollWidth, 0)
	end

	var0_42.padding = var1_42

	scrollToBottom(arg0_42:findTF("messageScroll", arg0_42.rightPanel))
end

function var0_0.SetFilterPanel(arg0_43)
	arg0_43.readFilter = arg0_43.readFilter or var0_0.ReadType[1]
	arg0_43.typeFilter = arg0_43.typeFilter or var0_0.TypeType[1]
	arg0_43.campFilter = arg0_43.campFilter or {
		var0_0.CampIds[1]
	}

	local var0_43 = arg0_43:findTF("panel/filterScroll/Viewport/Content/read", arg0_43.filterUI)
	local var1_43 = arg0_43:findTF("panel/filterScroll/Viewport/Content/type", arg0_43.filterUI)
	local var2_43 = arg0_43:findTF("panel/filterScroll/Viewport/Content/camp", arg0_43.filterUI)
	local var3_43 = UIItemList.New(var2_43, arg0_43:findTF("option", var2_43))

	onButton(arg0_43, arg0_43.filterBtn, function()
		SetActive(arg0_43.filterUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_43.filterUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		for iter0_44, iter1_44 in ipairs(var0_0.ReadType) do
			local var0_44 = var0_43:GetChild(iter0_44)
			local var1_44 = arg0_43:findTF("selectedFrame", var0_44)

			SetActive(var1_44, arg0_43.readFilter == iter1_44)
			onButton(arg0_43, var0_44, function()
				for iter0_45, iter1_45 in ipairs(var0_0.ReadType) do
					SetActive(arg0_43:findTF("selectedFrame", var0_43:GetChild(iter0_45)), false)
				end

				SetActive(var1_44, true)
			end, SFX_PANEL)
		end

		for iter2_44, iter3_44 in ipairs(var0_0.TypeType) do
			local var2_44 = var1_43:GetChild(iter2_44)
			local var3_44 = arg0_43:findTF("selectedFrame", var2_44)

			SetActive(var3_44, arg0_43.typeFilter == iter3_44)
			onButton(arg0_43, var2_44, function()
				for iter0_46, iter1_46 in ipairs(var0_0.TypeType) do
					SetActive(arg0_43:findTF("selectedFrame", var1_43:GetChild(iter0_46)), false)
				end

				SetActive(var3_44, true)
			end, SFX_PANEL)
		end

		var3_43:make(function(arg0_47, arg1_47, arg2_47)
			if arg0_47 == UIItemList.EventUpdate then
				setText(arg2_47:Find("Text"), i18n(var0_0.CampNames[arg1_47 + 1]))

				local var0_47 = arg2_47:Find("selectedFrame")

				SetActive(var0_47, _.contains(arg0_43.campFilter, var0_0.CampIds[arg1_47 + 1]))
				onButton(arg0_43, arg2_47, function()
					if arg1_47 == 0 then
						SetActive(var0_47, true)

						for iter0_48 = 2, #var0_0.CampIds do
							SetActive(arg0_43:findTF("selectedFrame", var2_43:GetChild(iter0_48 - 1)), false)
						end
					else
						SetActive(var0_47, not isActive(var0_47))

						local var0_48 = true
						local var1_48 = true

						for iter1_48 = 2, #var0_0.CampIds do
							if not isActive(arg0_43:findTF("selectedFrame", var2_43:GetChild(iter1_48 - 1))) then
								var0_48 = false
							end

							if isActive(arg0_43:findTF("selectedFrame", var2_43:GetChild(iter1_48 - 1))) then
								var1_48 = false
							end
						end

						if var0_48 then
							SetActive(arg0_43:findTF("selectedFrame", var2_43:GetChild(0)), true)

							for iter2_48 = 2, #var0_0.CampIds do
								SetActive(arg0_43:findTF("selectedFrame", var2_43:GetChild(iter2_48 - 1)), false)
							end
						elseif var1_48 then
							SetActive(arg0_43:findTF("selectedFrame", var2_43:GetChild(0)), true)
						else
							SetActive(arg0_43:findTF("selectedFrame", var2_43:GetChild(0)), false)
						end
					end
				end, SFX_PANEL)
			end
		end)
		var3_43:align(#var0_0.CampIds)
	end, SFX_PANEL)
	onButton(arg0_43, arg0_43:findTF("bg", arg0_43.filterUI), function()
		arg0_43:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_43, arg0_43:findTF("panel/bottom/close", arg0_43.filterUI), function()
		arg0_43:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_43, arg0_43:findTF("panel/bottom/ok", arg0_43.filterUI), function()
		for iter0_51, iter1_51 in ipairs(var0_0.ReadType) do
			local var0_51 = var0_43:GetChild(iter0_51)
			local var1_51 = arg0_43:findTF("selectedFrame", var0_51)

			if isActive(var1_51) then
				arg0_43.readFilter = iter1_51
			end
		end

		for iter2_51, iter3_51 in ipairs(var0_0.TypeType) do
			local var2_51 = var1_43:GetChild(iter2_51)
			local var3_51 = arg0_43:findTF("selectedFrame", var2_51)

			if isActive(var3_51) then
				arg0_43.typeFilter = iter3_51
			end
		end

		arg0_43.campFilter = {}

		for iter4_51, iter5_51 in ipairs(var0_0.CampIds) do
			local var4_51 = var2_43:GetChild(iter4_51 - 1)
			local var5_51 = arg0_43:findTF("selectedFrame", var4_51)

			if isActive(var5_51) then
				table.insert(arg0_43.campFilter, iter5_51)
			end
		end

		arg0_43:CloseFilterPanel()
		arg0_43:SetFilterResult()
	end, SFX_PANEL)
end

function var0_0.SetFilterResult(arg0_52)
	local var0_52 = true
	local var1_52 = false

	if not arg0_52.readFilter then
		arg0_52.readFilter = var0_0.ReadType[1]
		arg0_52.typeFilter = var0_0.TypeType[1]
		arg0_52.campFilter = {
			var0_0.CampIds[1]
		}
	end

	for iter0_52, iter1_52 in ipairs(arg0_52.chatList) do
		local var2_52 = true

		if arg0_52.readFilter ~= "all" then
			local var3_52 = arg0_52.readFilter == "hasReaded" and 1 or 0

			if iter1_52:GetCharacterEndFlag() ~= var3_52 then
				var2_52 = false
			end
		end

		if arg0_52.typeFilter ~= "all" then
			local var4_52 = arg0_52.typeFilter == "single" and 1 or 2

			if iter1_52.type ~= var4_52 then
				var2_52 = false
			end
		end

		if not _.contains(arg0_52.campFilter, 0) and not _.contains(arg0_52.campFilter, iter1_52.nationality) then
			var2_52 = false
		end

		SetActive(arg0_52:findTF("main/leftPanel/charaScroll/Viewport/Content"):GetChild(iter0_52 - 1), var2_52)

		if var2_52 then
			var0_52 = false
		end

		if arg0_52.currentChat and arg0_52.currentChat.characterId == iter1_52.characterId and var2_52 then
			var1_52 = true
		end
	end

	local var5_52 = arg0_52.readFilter == "all" and arg0_52.typeFilter == "all" and _.contains(arg0_52.campFilter, 0)

	SetActive(arg0_52.isFiltered, not var5_52)

	if var0_52 then
		SetActive(arg0_52:findTF("charaScroll", arg0_52.leftPanel), false)
		SetActive(arg0_52:findTF("main/noFilteredMessageBg"), true)
		SetActive(arg0_52.rightPanel, false)
		SetActive(arg0_52:findTF("main/rightNoMessageBg"), false)
	else
		SetActive(arg0_52:findTF("charaScroll", arg0_52.leftPanel), true)
		SetActive(arg0_52:findTF("main/noFilteredMessageBg"), false)

		if var1_52 then
			SetActive(arg0_52.rightPanel, true)
			SetActive(arg0_52:findTF("main/rightNoMessageBg"), false)
		else
			SetActive(arg0_52.rightPanel, false)
			SetActive(arg0_52:findTF("main/rightNoMessageBg"), true)

			arg0_52.currentChat = nil

			if arg0_52.cancelFrame then
				arg0_52.cancelFrame()

				arg0_52.cancelFrame = nil
			end
		end
	end
end

function var0_0.CloseFilterPanel(arg0_53)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_53.filterUI, arg0_53:findTF("subPages"))
	SetActive(arg0_53.filterUI, false)
end

function var0_0.SetTopicPanel(arg0_54, arg1_54)
	SetActive(arg0_54:findTF("tip", arg0_54.topicBtn), arg1_54:GetCharacterEndFlagExceptCurrent() == 0)
	onButton(arg0_54, arg0_54.topicBtn, function()
		SetActive(arg0_54.topicUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_54.topicUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		arg0_54.currentTopic = nil

		local var0_55 = UIItemList.New(arg0_54:findTF("panel/topicScroll/Viewport/Content", arg0_54.topicUI), arg0_54:findTF("panel/topicScroll/Viewport/Content/topic", arg0_54.topicUI))

		var0_55:make(function(arg0_56, arg1_56, arg2_56)
			if arg0_56 == UIItemList.EventUpdate then
				arg1_54:SortTopicList()

				local var0_56 = arg1_54.topics[arg1_56 + 1]

				setScrollText(arg2_56:Find("mask/name"), HXSet.hxLan(var0_56.name))
				SetActive(arg2_56:Find("lock"), not var0_56.active)
				SetActive(arg2_56:Find("waiting"), var0_56.active and var0_56:isWaiting())
				SetActive(arg2_56:Find("complete"), var0_56.active and var0_56:IsCompleted())
				SetActive(arg2_56:Find("selectedFrame"), arg1_54.currentTopicId == var0_56.topicId)
				SetActive(arg2_56:Find("selected"), arg1_54.currentTopicId == var0_56.topicId)
				SetActive(arg2_56:Find("tip"), var0_56.active and not var0_56:IsCompleted())

				if arg1_54.currentTopicId == var0_56.topicId then
					arg0_54.currentTopic = var0_56
				end

				SetActive(arg2_56, var0_56.active)

				if var0_56.active then
					onButton(arg0_54, arg2_56, function()
						SetActive(arg2_56:Find("selectedFrame"), true)

						for iter0_57 = 1, #arg1_54.topics do
							if iter0_57 ~= arg1_56 + 1 then
								SetActive(arg0_54:findTF("selectedFrame", arg0_54:findTF("panel/topicScroll/Viewport/Content", arg0_54.topicUI):GetChild(iter0_57 - 1)), false)
							end
						end

						arg0_54.currentTopic = var0_56
					end, SFX_PANEL)
				else
					onButton(arg0_54, arg2_56, function()
						pg.TipsMgr.GetInstance():ShowTips(var0_56.unlockDesc)
					end, SFX_PANEL)
				end
			end
		end)
		var0_55:align(#arg1_54.topics)
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54:findTF("bg", arg0_54.topicUI), function()
		arg0_54:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54:findTF("panel/bottom/close", arg0_54.topicUI), function()
		arg0_54:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54:findTF("panel/bottom/ok", arg0_54.topicUI), function()
		arg0_54:emit(InstagramChatMediator.SET_CURRENT_TOPIC, arg0_54.currentTopic.topicId)
		arg0_54:CloseTopicPanel()

		local var0_61 = arg0_54.rightPanel:GetComponent(typeof(Animation))

		var0_61:Stop()
		var0_61:Play("anim_newinstagram_chat_right_in")
	end, SFX_PANEL)
end

function var0_0.CloseTopicPanel(arg0_62)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_62.topicUI, arg0_62:findTF("subPages"))
	SetActive(arg0_62.topicUI, false)
end

function var0_0.SetBackgroundPanel(arg0_63, arg1_63)
	if arg1_63.type == 2 then
		SetActive(arg0_63.backgroundBtn, false)

		return
	end

	SetActive(arg0_63.backgroundBtn, true)

	local var0_63 = arg1_63:GetPaintingId()

	onButton(arg0_63, arg0_63.backgroundBtn, function()
		SetActive(arg0_63.backgroundUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_63.backgroundUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		arg0_63.currentBgId = nil

		local var0_64 = UIItemList.New(arg0_63:findTF("panel/backgroundScroll/Viewport/Content", arg0_63.backgroundUI), arg0_63:findTF("panel/backgroundScroll/Viewport/Content/background", arg0_63.backgroundUI))

		var0_64:make(function(arg0_65, arg1_65, arg2_65)
			if arg0_65 == UIItemList.EventUpdate then
				local var0_65 = arg1_63.skins[arg1_65 + 1]
				local var1_65 = 0

				if var0_65.id ~= var0_63 then
					var1_65 = var0_65.id
				end

				local var2_65 = var0_65.painting

				LoadImageSpriteAsync("herohrzicon/" .. var2_65, arg2_65:Find("skinMask/skin"), false)
				setScrollText(arg2_65:Find("skinMask/Panel/mask/Text"), var0_65.name)

				local var3_65 = getProxy(ShipSkinProxy):hasSkin(var0_65.id) or var0_65.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or var0_65.skin_type == ShipSkin.SKIN_TYPE_PROPOSE or var0_65.skin_type == ShipSkin.SKIN_TYPE_REMAKE

				SetActive(arg2_65:Find("lockFrame"), not var3_65)
				SetActive(arg2_65:Find("selectedFrame"), arg1_63.skinId == var1_65)
				SetActive(arg2_65:Find("selected"), arg1_63.skinId == var1_65)

				if arg1_63.skinId == var1_65 then
					arg0_63.currentBgId = var1_65
				end

				onButton(arg0_63, arg2_65, function()
					if var3_65 then
						SetActive(arg2_65:Find("selectedFrame"), true)

						for iter0_66 = 1, #arg1_63.skins do
							if iter0_66 ~= arg1_65 + 1 then
								local var0_66 = arg0_63:findTF("panel/backgroundScroll/Viewport/Content", arg0_63.backgroundUI):GetChild(iter0_66 - 1)

								SetActive(arg0_63:findTF("selectedFrame", var0_66), false)
							end
						end

						arg0_63.currentBgId = var1_65
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("juuschat_background_tip2"))
					end
				end, SFX_PANEL)
			end
		end)
		var0_64:align(#arg1_63.skins)
	end, SFX_PANEL)
	onButton(arg0_63, arg0_63:findTF("bg", arg0_63.backgroundUI), function()
		arg0_63:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_63, arg0_63:findTF("panel/bottom/close", arg0_63.backgroundUI), function()
		arg0_63:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_63, arg0_63:findTF("panel/bottom/ok", arg0_63.backgroundUI), function()
		arg0_63:emit(InstagramChatMediator.SET_CURRENT_BACKGROUND, arg1_63.characterId, arg0_63.currentBgId)
		arg0_63:CloseBackgroundPanel()
	end, SFX_PANEL)
end

function var0_0.CloseBackgroundPanel(arg0_70)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_70.backgroundUI, arg0_70:findTF("subPages"))
	SetActive(arg0_70.backgroundUI, false)
end

function var0_0.SetRedPacketPanel(arg0_71, arg1_71, arg2_71, arg3_71, arg4_71, arg5_71, arg6_71)
	onButton(arg0_71, arg1_71, function()
		SetActive(arg0_71.redPacketUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_71.redPacketUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setImageSprite(arg0_71:findTF("panel/charaBg/chara", arg0_71.redPacketUI), LoadSprite("qicon/" .. arg4_71), false)

		if not arg3_71 then
			SetActive(arg0_71:findTF("panel/panelBg", arg0_71.redPacketUI), true)
			SetActive(arg0_71:findTF("panel/openImg", arg0_71.redPacketUI), false)
			SetActive(arg0_71:findTF("panel/get", arg0_71.redPacketUI), true)
			SetActive(arg0_71:findTF("panel/got", arg0_71.redPacketUI), false)
			SetActive(arg0_71:findTF("panel/detail", arg0_71.redPacketUI), false)
			setText(arg0_71:findTF("panel/get/titleBg/title", arg0_71.redPacketUI), arg2_71.desc)
			onButton(arg0_71, arg0_71:findTF("panel/get/getBtn", arg0_71.redPacketUI), function()
				arg0_71:emit(InstagramChatMediator.GET_REDPACKET, arg5_71, arg6_71, arg2_71.id)
			end, SFX_PANEL)
		else
			arg0_71:UpdateRedPacketUI(arg2_71.id)
		end
	end, SFX_PANEL)
	onButton(arg0_71, arg0_71:findTF("bg", arg0_71.redPacketUI), function()
		arg0_71:CloseRedPacketPanel()

		if arg0_71.canFresh then
			arg0_71.canFresh = false

			local var0_74 = arg0_71.currentChat.currentTopic:GetDisplayWordList()

			if var0_74[#var0_74].type == 0 then
				arg0_71:UpdateCharaList(false, false)
			else
				arg0_71:UpdateCharaList(true, false)
			end
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRedPacketUI(arg0_75, arg1_75)
	local var0_75 = var2_0[arg1_75]

	SetActive(arg0_75:findTF("panel/panelBg", arg0_75.redPacketUI), true)
	SetActive(arg0_75:findTF("panel/openImg", arg0_75.redPacketUI), false)
	SetActive(arg0_75:findTF("panel/get", arg0_75.redPacketUI), false)
	SetActive(arg0_75:findTF("panel/got", arg0_75.redPacketUI), true)
	SetActive(arg0_75:findTF("panel/detail", arg0_75.redPacketUI), false)

	local var1_75 = Drop.Create(var0_75.content)

	var1_75.count = 0

	updateDrop(arg0_75:findTF("panel/got/item", arg0_75.redPacketUI), var1_75)
	onButton(arg0_75, arg0_75:findTF("panel/got/item", arg0_75.redPacketUI), function()
		arg0_75:emit(BaseUI.ON_DROP, var1_75)
	end, SFX_PANEL)

	arg0_75:findTF("panel/got/item/icon_bg", arg0_75.redPacketUI):GetComponent(typeof(Image)).enabled = false
	arg0_75:findTF("panel/got/item/icon_bg/frame", arg0_75.redPacketUI):GetComponent(typeof(Image)).enabled = false

	setText(arg0_75:findTF("panel/got/awardCount", arg0_75.redPacketUI), var0_75.content[3])

	if var0_75.type == 1 then
		SetActive(arg0_75:findTF("panel/got/detailBtn", arg0_75.redPacketUI), false)
	else
		SetActive(arg0_75:findTF("panel/got/detailBtn", arg0_75.redPacketUI), true)
		onButton(arg0_75, arg0_75:findTF("panel/got/detailBtn", arg0_75.redPacketUI), function()
			SetActive(arg0_75:findTF("panel/panelBg", arg0_75.redPacketUI), false)
			SetActive(arg0_75:findTF("panel/openImg", arg0_75.redPacketUI), true)
			SetActive(arg0_75:findTF("panel/got", arg0_75.redPacketUI), false)
			SetActive(arg0_75:findTF("panel/detail", arg0_75.redPacketUI), true)

			local var0_77 = 0
			local var1_77 = 0
			local var2_77 = UIItemList.New(arg0_75:findTF("panel/detail/detailScroll/Viewport/Content", arg0_75.redPacketUI), arg0_75:findTF("panel/detail/detailScroll/Viewport/Content/charaGetCard", arg0_75.redPacketUI))

			var2_77:make(function(arg0_78, arg1_78, arg2_78)
				if arg0_78 == UIItemList.EventUpdate then
					local var0_78 = var0_75.group_receive[arg1_78 + 1]
					local var1_78 = var0_78[1]
					local var2_78 = {
						var0_78[2],
						var0_78[3],
						var0_78[4]
					}

					if var0_78[1] ~= 0 then
						local var3_78 = "unknown"

						if var1_0[var1_78] then
							var3_78 = var1_0[var1_78].sculpture
						end

						setImageSprite(arg2_78:Find("charaBg/chara"), LoadSprite("qicon/" .. var3_78), false)
					else
						setImageSprite(arg2_78:Find("charaBg/chara"), GetSpriteFromAtlas("ui/InstagramUI_atlas", "txdi_3"), false)
					end

					local var4_78 = Drop.Create(var2_78)

					var4_78.count = 0

					updateDrop(arg2_78:Find("item"), var4_78)
					onButton(arg0_75, arg2_78:Find("item"), function()
						arg0_75:emit(BaseUI.ON_DROP, var4_78)
					end, SFX_PANEL)

					arg2_78:Find("item/icon_bg"):GetComponent(typeof(Image)).enabled = false
					arg2_78:Find("item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

					setText(arg2_78:Find("awardCount"), var0_78[4])

					if var0_78[4] > var1_77 then
						var0_77 = arg1_78
						var1_77 = var0_78[4]
					end
				end
			end)
			var2_77:align(#var0_75.group_receive)

			for iter0_77 = 1, #var0_75.group_receive do
				SetActive(arg0_75:findTF("charaBg/king", arg0_75:findTF("panel/detail/detailScroll/Viewport/Content", arg0_75.redPacketUI):GetChild(iter0_77 - 1)), var0_77 == iter0_77 - 1)
			end
		end, SFX_PANEL)
	end
end

function var0_0.CloseRedPacketPanel(arg0_80)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_80.redPacketUI, arg0_80:findTF("subPages"))
	SetActive(arg0_80.redPacketUI, false)
end

function var0_0.SetData(arg0_81)
	local var0_81 = getProxy(InstagramChatProxy)

	arg0_81.chatList = var0_81:GetChatList()

	var0_81:SortChatList()
end

function var0_0.willExit(arg0_82)
	local var0_82 = arg0_82:findTF("paintingMask/painting", arg0_82.rightPanel)

	if arg0_82.paintingName then
		retPaintingPrefab(var0_82, arg0_82.paintingName)

		arg0_82.paintingName = nil
	end

	arg0_82:RemoveAllTimer()
end

function var0_0.StartTimer(arg0_83, arg1_83, arg2_83)
	local var0_83 = Timer.New(arg1_83, arg2_83, 1)

	var0_83:Start()
	table.insert(arg0_83.timerList, var0_83)
end

function var0_0.RemoveAllTimer(arg0_84)
	for iter0_84, iter1_84 in ipairs(arg0_84.timerList) do
		iter1_84:Stop()
	end

	arg0_84.timerList = {}
end

function var0_0.StartTimer2(arg0_85, arg1_85, arg2_85)
	arg0_85.timer = Timer.New(arg1_85, arg2_85, 1)

	arg0_85.timer:Start()
end

function var0_0.SpeedUpMessage(arg0_86)
	local var0_86 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var1_86 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_86, iter1_86 in ipairs(arg0_86.timerList) do
		if iter1_86.running then
			if iter1_86.duration == var1_86 then
				iter1_86.time = 0.05
			elseif iter1_86.time - var0_86 < 0.05 then
				iter1_86.time = 0.05

				arg0_86:StartTimer2(function()
					arg0_86:SpeedUpWaiting()
				end, 0.05)
			else
				iter1_86.time = iter1_86.time - var0_86
			end
		end
	end
end

function var0_0.SpeedUpWaiting(arg0_88)
	local var0_88 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_88, iter1_88 in ipairs(arg0_88.timerList) do
		if iter1_88.running and iter1_88.duration == var0_88 then
			iter1_88.time = 0.05

			break
		end
	end
end

function var0_0.ChangeFresh(arg0_89)
	arg0_89.canFresh = true
end

function var0_0.ChangeCharaTextFunc(arg0_90, arg1_90, arg2_90)
	local function var0_90(arg0_91, arg1_91)
		if arg1_91:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_90) then
			setText(arg1_91:Find("msg"), arg2_90)
		end
	end

	arg0_90.charaList:each(var0_90)
end

function var0_0.ResetCharaTextFunc(arg0_92, arg1_92)
	local function var0_92(arg0_93, arg1_93)
		if arg1_93:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_92) then
			setText(arg1_93:Find("msg"), arg1_93:Find("displayWord"):GetComponent(typeof(Text)).text)
		end
	end

	arg0_92.charaList:each(var0_92)
end

function var0_0.SetEndAniEvent(arg0_94, arg1_94, arg2_94)
	local var0_94 = arg1_94:GetComponent(typeof(DftAniEvent))

	if var0_94 then
		var0_94:SetEndEvent(function()
			arg2_94()
			var0_94:SetEndEvent(nil)
		end)
	end
end

function var0_0.onBackPressed(arg0_96)
	if isActive(arg0_96.filterUI) then
		arg0_96:CloseFilterPanel()

		return
	end

	if isActive(arg0_96.topicUI) then
		arg0_96:CloseTopicPanel()

		return
	end

	if isActive(arg0_96.backgroundUI) then
		arg0_96:CloseBackgroundPanel()

		return
	end

	if isActive(arg0_96.redPacketUI) then
		arg0_96:CloseRedPacketPanel()

		return
	end

	arg0_96:emit(InstagramChatMediator.CLOSE_ALL)
end

return var0_0
