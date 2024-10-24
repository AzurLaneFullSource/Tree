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
	setText(arg0_2:findTF("panel/detail/title", arg0_2.redPacketUI), i18n("juuschat_redpacket_detail"))
	setText(arg0_2:findTF("main/noFilteredMessageBg/Text"), i18n("juuschat_filter_empty"))

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
					arg0_10:SetEmoji(arg2_13:Find("playerReplyCard/emoji/emoticon"), var3_0[tonumber(var0_13.param)].pic)
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
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_10:findTF("messageScroll", arg0_10.rightPanel)), var2_10.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_10)):setEase(LeanTweenType.easeInOutCubic)
						end, (#var1_10 - table.indexof(var1_10, arg1_13 + 1)) * var6_10)
					elseif var0_13.type == 1 then
						arg2_13:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
						arg0_10:ChangeCharaTextFunc(arg4_10, var0_13.param)
					elseif var0_13.type == 4 then
						arg2_13:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

						local var9_13 = var3_0[tonumber(var0_13.param)].desc
						local var10_13 = string.gsub(var9_13, "#%w+>", "#28af6e>")

						arg0_10:ChangeCharaTextFunc(arg4_10, var10_13)
					end
				end
			end

			if not arg1_10:isWaiting() and arg1_13 + 1 == #arg2_10 then
				if arg3_10 then
					arg0_10:StartTimer(function()
						setActive(arg2_13:Find("end"), true)
					end, var3_13 + var4_10)
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

function var0_0.SetCharaMessageCardActive(arg0_32, arg1_32, arg2_32)
	if _.contains(arg2_32, 6) then
		SetActive(arg1_32:GetChild(0), false)
	else
		SetActive(arg1_32:GetChild(0), true)
	end

	for iter0_32 = 1, arg1_32.childCount - 1 do
		if _.contains(arg2_32, iter0_32) then
			SetActive(arg1_32:GetChild(iter0_32), true)
		else
			SetActive(arg1_32:GetChild(iter0_32), false)
		end
	end
end

function var0_0.SetPlayerMessageCardActive(arg0_33, arg1_33, arg2_33)
	for iter0_33 = 0, arg1_33.childCount - 1 do
		if _.contains(arg2_33, iter0_33) then
			SetActive(arg1_33:GetChild(iter0_33), true)
		else
			SetActive(arg1_33:GetChild(iter0_33), false)
		end
	end
end

function var0_0.SetEmoji(arg0_34, arg1_34, arg2_34)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg2_34, arg2_34, true, function(arg0_35)
		if not IsNil(arg1_34) then
			arg0_35.name = arg2_34
			tf(arg0_35).sizeDelta = arg1_34.sizeDelta
			tf(arg0_35).anchoredPosition = Vector2.zero

			local var0_35 = arg0_35:GetComponent("Animator")

			if var0_35 then
				var0_35.enabled = false
			end

			local var1_35 = arg0_35:GetComponent("CriManaEffectUI")

			if var1_35 then
				var1_35:Pause(true)
			end

			setParent(arg0_35, arg1_34, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg2_34, arg2_34, arg0_35)
		end
	end)
end

function var0_0.UpdateOptionPanel(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg2_36[#arg2_36].option

	if var0_36 and type(var0_36) == "table" then
		arg0_36.shouldShowOption = true
		arg0_36.optionCount = #var0_36

		arg0_36:SetOptionPanelActive(true)
		arg0_36.optionList:make(function(arg0_37, arg1_37, arg2_37)
			if arg0_37 == UIItemList.EventUpdate then
				local var0_37 = var0_36[arg1_37 + 1]

				setText(arg2_37:Find("Text"), var0_37[2])
				onButton(arg0_36, arg2_37, function()
					arg0_36:emit(InstagramChatMediator.REPLY, arg1_36.topicId, arg2_36[#arg2_36].id, var0_37[1])
				end, SFX_PANEL)
			end
		end)
		arg0_36.optionList:align(#var0_36)
	else
		arg0_36:SetOptionPanelActive(false)

		arg0_36.shouldShowOption = false
	end
end

function var0_0.SetOptionPanelActive(arg0_39, arg1_39)
	SetActive(arg0_39.optionPanel, arg1_39)

	local var0_39 = arg0_39:findTF("messageScroll/Viewport/Content", arg0_39.rightPanel):GetComponent(typeof(VerticalLayoutGroup))
	local var1_39 = UnityEngine.RectOffset.New()

	var1_39.left = 0
	var1_39.right = 0
	var1_39.top = 0

	local var2_39 = arg0_39:findTF("messageScroll/Scrollbar Vertical", arg0_39.rightPanel):GetComponent(typeof(RectTransform))

	if arg1_39 then
		var1_39.bottom = 42 + 88 * arg0_39.optionCount
		var2_39.sizeDelta = Vector2(arg0_39.messageScrollWidth, -var1_39.bottom)
	else
		var1_39.bottom = 50
		var2_39.sizeDelta = Vector2(arg0_39.messageScrollWidth, 0)
	end

	var0_39.padding = var1_39

	scrollToBottom(arg0_39:findTF("messageScroll", arg0_39.rightPanel))
end

function var0_0.SetFilterPanel(arg0_40)
	arg0_40.readFilter = arg0_40.readFilter or var0_0.ReadType[1]
	arg0_40.typeFilter = arg0_40.typeFilter or var0_0.TypeType[1]
	arg0_40.campFilter = arg0_40.campFilter or {
		var0_0.CampIds[1]
	}

	local var0_40 = arg0_40:findTF("panel/filterScroll/Viewport/Content/read", arg0_40.filterUI)
	local var1_40 = arg0_40:findTF("panel/filterScroll/Viewport/Content/type", arg0_40.filterUI)
	local var2_40 = arg0_40:findTF("panel/filterScroll/Viewport/Content/camp", arg0_40.filterUI)
	local var3_40 = UIItemList.New(var2_40, arg0_40:findTF("option", var2_40))

	onButton(arg0_40, arg0_40.filterBtn, function()
		SetActive(arg0_40.filterUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_40.filterUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		for iter0_41, iter1_41 in ipairs(var0_0.ReadType) do
			local var0_41 = var0_40:GetChild(iter0_41)
			local var1_41 = arg0_40:findTF("selectedFrame", var0_41)

			SetActive(var1_41, arg0_40.readFilter == iter1_41)
			onButton(arg0_40, var0_41, function()
				for iter0_42, iter1_42 in ipairs(var0_0.ReadType) do
					SetActive(arg0_40:findTF("selectedFrame", var0_40:GetChild(iter0_42)), false)
				end

				SetActive(var1_41, true)
			end, SFX_PANEL)
		end

		for iter2_41, iter3_41 in ipairs(var0_0.TypeType) do
			local var2_41 = var1_40:GetChild(iter2_41)
			local var3_41 = arg0_40:findTF("selectedFrame", var2_41)

			SetActive(var3_41, arg0_40.typeFilter == iter3_41)
			onButton(arg0_40, var2_41, function()
				for iter0_43, iter1_43 in ipairs(var0_0.TypeType) do
					SetActive(arg0_40:findTF("selectedFrame", var1_40:GetChild(iter0_43)), false)
				end

				SetActive(var3_41, true)
			end, SFX_PANEL)
		end

		var3_40:make(function(arg0_44, arg1_44, arg2_44)
			if arg0_44 == UIItemList.EventUpdate then
				setText(arg2_44:Find("Text"), i18n(var0_0.CampNames[arg1_44 + 1]))

				local var0_44 = arg2_44:Find("selectedFrame")

				SetActive(var0_44, _.contains(arg0_40.campFilter, var0_0.CampIds[arg1_44 + 1]))
				onButton(arg0_40, arg2_44, function()
					if arg1_44 == 0 then
						SetActive(var0_44, true)

						for iter0_45 = 2, #var0_0.CampIds do
							SetActive(arg0_40:findTF("selectedFrame", var2_40:GetChild(iter0_45 - 1)), false)
						end
					else
						SetActive(var0_44, not isActive(var0_44))

						local var0_45 = true
						local var1_45 = true

						for iter1_45 = 2, #var0_0.CampIds do
							if not isActive(arg0_40:findTF("selectedFrame", var2_40:GetChild(iter1_45 - 1))) then
								var0_45 = false
							end

							if isActive(arg0_40:findTF("selectedFrame", var2_40:GetChild(iter1_45 - 1))) then
								var1_45 = false
							end
						end

						if var0_45 then
							SetActive(arg0_40:findTF("selectedFrame", var2_40:GetChild(0)), true)

							for iter2_45 = 2, #var0_0.CampIds do
								SetActive(arg0_40:findTF("selectedFrame", var2_40:GetChild(iter2_45 - 1)), false)
							end
						elseif var1_45 then
							SetActive(arg0_40:findTF("selectedFrame", var2_40:GetChild(0)), true)
						else
							SetActive(arg0_40:findTF("selectedFrame", var2_40:GetChild(0)), false)
						end
					end
				end, SFX_PANEL)
			end
		end)
		var3_40:align(#var0_0.CampIds)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40:findTF("bg", arg0_40.filterUI), function()
		arg0_40:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40:findTF("panel/bottom/close", arg0_40.filterUI), function()
		arg0_40:CloseFilterPanel()
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40:findTF("panel/bottom/ok", arg0_40.filterUI), function()
		for iter0_48, iter1_48 in ipairs(var0_0.ReadType) do
			local var0_48 = var0_40:GetChild(iter0_48)
			local var1_48 = arg0_40:findTF("selectedFrame", var0_48)

			if isActive(var1_48) then
				arg0_40.readFilter = iter1_48
			end
		end

		for iter2_48, iter3_48 in ipairs(var0_0.TypeType) do
			local var2_48 = var1_40:GetChild(iter2_48)
			local var3_48 = arg0_40:findTF("selectedFrame", var2_48)

			if isActive(var3_48) then
				arg0_40.typeFilter = iter3_48
			end
		end

		arg0_40.campFilter = {}

		for iter4_48, iter5_48 in ipairs(var0_0.CampIds) do
			local var4_48 = var2_40:GetChild(iter4_48 - 1)
			local var5_48 = arg0_40:findTF("selectedFrame", var4_48)

			if isActive(var5_48) then
				table.insert(arg0_40.campFilter, iter5_48)
			end
		end

		arg0_40:CloseFilterPanel()
		arg0_40:SetFilterResult()
	end, SFX_PANEL)
end

function var0_0.SetFilterResult(arg0_49)
	local var0_49 = true
	local var1_49 = false

	if not arg0_49.readFilter then
		arg0_49.readFilter = var0_0.ReadType[1]
		arg0_49.typeFilter = var0_0.TypeType[1]
		arg0_49.campFilter = {
			var0_0.CampIds[1]
		}
	end

	for iter0_49, iter1_49 in ipairs(arg0_49.chatList) do
		local var2_49 = true

		if arg0_49.readFilter ~= "all" then
			local var3_49 = arg0_49.readFilter == "hasReaded" and 1 or 0

			if iter1_49:GetCharacterEndFlag() ~= var3_49 then
				var2_49 = false
			end
		end

		if arg0_49.typeFilter ~= "all" then
			local var4_49 = arg0_49.typeFilter == "single" and 1 or 2

			if iter1_49.type ~= var4_49 then
				var2_49 = false
			end
		end

		if not _.contains(arg0_49.campFilter, 0) and not _.contains(arg0_49.campFilter, iter1_49.nationality) then
			var2_49 = false
		end

		SetActive(arg0_49:findTF("main/leftPanel/charaScroll/Viewport/Content"):GetChild(iter0_49 - 1), var2_49)

		if var2_49 then
			var0_49 = false
		end

		if arg0_49.currentChat and arg0_49.currentChat.characterId == iter1_49.characterId and var2_49 then
			var1_49 = true
		end
	end

	local var5_49 = arg0_49.readFilter == "all" and arg0_49.typeFilter == "all" and _.contains(arg0_49.campFilter, 0)

	SetActive(arg0_49.isFiltered, not var5_49)

	if var0_49 then
		SetActive(arg0_49:findTF("charaScroll", arg0_49.leftPanel), false)
		SetActive(arg0_49:findTF("main/noFilteredMessageBg"), true)
		SetActive(arg0_49.rightPanel, false)
		SetActive(arg0_49:findTF("main/rightNoMessageBg"), false)
	else
		SetActive(arg0_49:findTF("charaScroll", arg0_49.leftPanel), true)
		SetActive(arg0_49:findTF("main/noFilteredMessageBg"), false)

		if var1_49 then
			SetActive(arg0_49.rightPanel, true)
			SetActive(arg0_49:findTF("main/rightNoMessageBg"), false)
		else
			SetActive(arg0_49.rightPanel, false)
			SetActive(arg0_49:findTF("main/rightNoMessageBg"), true)

			arg0_49.currentChat = nil

			if arg0_49.cancelFrame then
				arg0_49.cancelFrame()

				arg0_49.cancelFrame = nil
			end
		end
	end
end

function var0_0.CloseFilterPanel(arg0_50)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_50.filterUI, arg0_50:findTF("subPages"))
	SetActive(arg0_50.filterUI, false)
end

function var0_0.SetTopicPanel(arg0_51, arg1_51)
	SetActive(arg0_51:findTF("tip", arg0_51.topicBtn), arg1_51:GetCharacterEndFlagExceptCurrent() == 0)
	onButton(arg0_51, arg0_51.topicBtn, function()
		SetActive(arg0_51.topicUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_51.topicUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		arg0_51.currentTopic = nil

		local var0_52 = UIItemList.New(arg0_51:findTF("panel/topicScroll/Viewport/Content", arg0_51.topicUI), arg0_51:findTF("panel/topicScroll/Viewport/Content/topic", arg0_51.topicUI))

		var0_52:make(function(arg0_53, arg1_53, arg2_53)
			if arg0_53 == UIItemList.EventUpdate then
				arg1_51:SortTopicList()

				local var0_53 = arg1_51.topics[arg1_53 + 1]

				setScrollText(arg2_53:Find("mask/name"), var0_53.name)
				SetActive(arg2_53:Find("lock"), not var0_53.active)
				SetActive(arg2_53:Find("waiting"), var0_53.active and var0_53:isWaiting())
				SetActive(arg2_53:Find("complete"), var0_53.active and var0_53:IsCompleted())
				SetActive(arg2_53:Find("selectedFrame"), arg1_51.currentTopicId == var0_53.topicId)
				SetActive(arg2_53:Find("selected"), arg1_51.currentTopicId == var0_53.topicId)
				SetActive(arg2_53:Find("tip"), var0_53.active and not var0_53:IsCompleted())

				if arg1_51.currentTopicId == var0_53.topicId then
					arg0_51.currentTopic = var0_53
				end

				SetActive(arg2_53, var0_53.active)

				if var0_53.active then
					onButton(arg0_51, arg2_53, function()
						SetActive(arg2_53:Find("selectedFrame"), true)

						for iter0_54 = 1, #arg1_51.topics do
							if iter0_54 ~= arg1_53 + 1 then
								SetActive(arg0_51:findTF("selectedFrame", arg0_51:findTF("panel/topicScroll/Viewport/Content", arg0_51.topicUI):GetChild(iter0_54 - 1)), false)
							end
						end

						arg0_51.currentTopic = var0_53
					end, SFX_PANEL)
				else
					onButton(arg0_51, arg2_53, function()
						pg.TipsMgr.GetInstance():ShowTips(var0_53.unlockDesc)
					end, SFX_PANEL)
				end
			end
		end)
		var0_52:align(#arg1_51.topics)
	end, SFX_PANEL)
	onButton(arg0_51, arg0_51:findTF("bg", arg0_51.topicUI), function()
		arg0_51:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_51, arg0_51:findTF("panel/bottom/close", arg0_51.topicUI), function()
		arg0_51:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_51, arg0_51:findTF("panel/bottom/ok", arg0_51.topicUI), function()
		arg0_51:emit(InstagramChatMediator.SET_CURRENT_TOPIC, arg0_51.currentTopic.topicId)
		arg0_51:CloseTopicPanel()

		local var0_58 = arg0_51.rightPanel:GetComponent(typeof(Animation))

		var0_58:Stop()
		var0_58:Play("anim_newinstagram_chat_right_in")
	end, SFX_PANEL)
end

function var0_0.CloseTopicPanel(arg0_59)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_59.topicUI, arg0_59:findTF("subPages"))
	SetActive(arg0_59.topicUI, false)
end

function var0_0.SetBackgroundPanel(arg0_60, arg1_60)
	if arg1_60.type == 2 then
		SetActive(arg0_60.backgroundBtn, false)

		return
	end

	SetActive(arg0_60.backgroundBtn, true)

	local var0_60 = arg1_60:GetPaintingId()

	onButton(arg0_60, arg0_60.backgroundBtn, function()
		SetActive(arg0_60.backgroundUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_60.backgroundUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		arg0_60.currentBgId = nil

		local var0_61 = UIItemList.New(arg0_60:findTF("panel/backgroundScroll/Viewport/Content", arg0_60.backgroundUI), arg0_60:findTF("panel/backgroundScroll/Viewport/Content/background", arg0_60.backgroundUI))

		var0_61:make(function(arg0_62, arg1_62, arg2_62)
			if arg0_62 == UIItemList.EventUpdate then
				local var0_62 = arg1_60.skins[arg1_62 + 1]
				local var1_62 = 0

				if var0_62.id ~= var0_60 then
					var1_62 = var0_62.id
				end

				local var2_62 = var0_62.painting

				LoadImageSpriteAsync("herohrzicon/" .. var2_62, arg2_62:Find("skinMask/skin"), false)
				setText(arg2_62:Find("skinMask/Panel/Text"), var0_62.name)
				SetActive(arg2_62:Find("selectedFrame"), arg1_60.skinId == var1_62)
				SetActive(arg2_62:Find("selected"), arg1_60.skinId == var1_62)

				if arg1_60.skinId == var1_62 then
					arg0_60.currentBgId = var1_62
				end

				onButton(arg0_60, arg2_62, function()
					SetActive(arg2_62:Find("selectedFrame"), true)

					for iter0_63 = 1, #arg1_60.skins do
						if iter0_63 ~= arg1_62 + 1 then
							local var0_63 = arg0_60:findTF("panel/backgroundScroll/Viewport/Content", arg0_60.backgroundUI):GetChild(iter0_63 - 1)

							SetActive(arg0_60:findTF("selectedFrame", var0_63), false)
						end
					end

					arg0_60.currentBgId = var1_62
				end, SFX_PANEL)
			end
		end)
		var0_61:align(#arg1_60.skins)
	end, SFX_PANEL)
	onButton(arg0_60, arg0_60:findTF("bg", arg0_60.backgroundUI), function()
		arg0_60:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_60, arg0_60:findTF("panel/bottom/close", arg0_60.backgroundUI), function()
		arg0_60:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_60, arg0_60:findTF("panel/bottom/ok", arg0_60.backgroundUI), function()
		arg0_60:emit(InstagramChatMediator.SET_CURRENT_BACKGROUND, arg1_60.characterId, arg0_60.currentBgId)
		arg0_60:CloseBackgroundPanel()
	end, SFX_PANEL)
end

function var0_0.CloseBackgroundPanel(arg0_67)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_67.backgroundUI, arg0_67:findTF("subPages"))
	SetActive(arg0_67.backgroundUI, false)
end

function var0_0.SetRedPacketPanel(arg0_68, arg1_68, arg2_68, arg3_68, arg4_68, arg5_68, arg6_68)
	onButton(arg0_68, arg1_68, function()
		SetActive(arg0_68.redPacketUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_68.redPacketUI, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setImageSprite(arg0_68:findTF("panel/charaBg/chara", arg0_68.redPacketUI), LoadSprite("qicon/" .. arg4_68), false)

		if not arg3_68 then
			SetActive(arg0_68:findTF("panel/panelBg", arg0_68.redPacketUI), true)
			SetActive(arg0_68:findTF("panel/openImg", arg0_68.redPacketUI), false)
			SetActive(arg0_68:findTF("panel/get", arg0_68.redPacketUI), true)
			SetActive(arg0_68:findTF("panel/got", arg0_68.redPacketUI), false)
			SetActive(arg0_68:findTF("panel/detail", arg0_68.redPacketUI), false)
			setText(arg0_68:findTF("panel/get/titleBg/title", arg0_68.redPacketUI), arg2_68.desc)
			onButton(arg0_68, arg0_68:findTF("panel/get/getBtn", arg0_68.redPacketUI), function()
				arg0_68:emit(InstagramChatMediator.GET_REDPACKET, arg5_68, arg6_68, arg2_68.id)
			end, SFX_PANEL)
		else
			arg0_68:UpdateRedPacketUI(arg2_68.id)
		end
	end, SFX_PANEL)
	onButton(arg0_68, arg0_68:findTF("bg", arg0_68.redPacketUI), function()
		arg0_68:CloseRedPacketPanel()

		if arg0_68.canFresh then
			arg0_68.canFresh = false

			local var0_71 = arg0_68.currentChat.currentTopic:GetDisplayWordList()

			if var0_71[#var0_71].type == 0 then
				arg0_68:UpdateCharaList(false, false)
			else
				arg0_68:UpdateCharaList(true, false)
			end
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRedPacketUI(arg0_72, arg1_72)
	local var0_72 = var2_0[arg1_72]

	SetActive(arg0_72:findTF("panel/panelBg", arg0_72.redPacketUI), true)
	SetActive(arg0_72:findTF("panel/openImg", arg0_72.redPacketUI), false)
	SetActive(arg0_72:findTF("panel/get", arg0_72.redPacketUI), false)
	SetActive(arg0_72:findTF("panel/got", arg0_72.redPacketUI), true)
	SetActive(arg0_72:findTF("panel/detail", arg0_72.redPacketUI), false)

	local var1_72 = Drop.Create(var0_72.content)

	var1_72.count = 0

	updateDrop(arg0_72:findTF("panel/got/item", arg0_72.redPacketUI), var1_72)
	onButton(arg0_72, arg0_72:findTF("panel/got/item", arg0_72.redPacketUI), function()
		arg0_72:emit(BaseUI.ON_DROP, var1_72)
	end, SFX_PANEL)

	arg0_72:findTF("panel/got/item/icon_bg", arg0_72.redPacketUI):GetComponent(typeof(Image)).enabled = false
	arg0_72:findTF("panel/got/item/icon_bg/frame", arg0_72.redPacketUI):GetComponent(typeof(Image)).enabled = false

	setText(arg0_72:findTF("panel/got/awardCount", arg0_72.redPacketUI), var0_72.content[3])

	if var0_72.type == 1 then
		SetActive(arg0_72:findTF("panel/got/detailBtn", arg0_72.redPacketUI), false)
	else
		SetActive(arg0_72:findTF("panel/got/detailBtn", arg0_72.redPacketUI), true)
		onButton(arg0_72, arg0_72:findTF("panel/got/detailBtn", arg0_72.redPacketUI), function()
			SetActive(arg0_72:findTF("panel/panelBg", arg0_72.redPacketUI), false)
			SetActive(arg0_72:findTF("panel/openImg", arg0_72.redPacketUI), true)
			SetActive(arg0_72:findTF("panel/got", arg0_72.redPacketUI), false)
			SetActive(arg0_72:findTF("panel/detail", arg0_72.redPacketUI), true)

			local var0_74 = 0
			local var1_74 = 0
			local var2_74 = UIItemList.New(arg0_72:findTF("panel/detail/detailScroll/Viewport/Content", arg0_72.redPacketUI), arg0_72:findTF("panel/detail/detailScroll/Viewport/Content/charaGetCard", arg0_72.redPacketUI))

			var2_74:make(function(arg0_75, arg1_75, arg2_75)
				if arg0_75 == UIItemList.EventUpdate then
					local var0_75 = var0_72.group_receive[arg1_75 + 1]
					local var1_75 = var0_75[1]
					local var2_75 = {
						var0_75[2],
						var0_75[3],
						var0_75[4]
					}

					if var0_75[1] ~= 0 then
						local var3_75 = "unknown"

						if var1_0[var1_75] then
							var3_75 = var1_0[var1_75].sculpture
						end

						setImageSprite(arg2_75:Find("charaBg/chara"), LoadSprite("qicon/" .. var3_75), false)
					else
						setImageSprite(arg2_75:Find("charaBg/chara"), GetSpriteFromAtlas("ui/InstagramUI_atlas", "txdi_3"), false)
					end

					local var4_75 = Drop.Create(var2_75)

					var4_75.count = 0

					updateDrop(arg2_75:Find("item"), var4_75)
					onButton(arg0_72, arg2_75:Find("item"), function()
						arg0_72:emit(BaseUI.ON_DROP, var4_75)
					end, SFX_PANEL)

					arg2_75:Find("item/icon_bg"):GetComponent(typeof(Image)).enabled = false
					arg2_75:Find("item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

					setText(arg2_75:Find("awardCount"), var0_75[4])

					if var0_75[4] > var1_74 then
						var0_74 = arg1_75
						var1_74 = var0_75[4]
					end
				end
			end)
			var2_74:align(#var0_72.group_receive)

			for iter0_74 = 1, #var0_72.group_receive do
				SetActive(arg0_72:findTF("charaBg/king", arg0_72:findTF("panel/detail/detailScroll/Viewport/Content", arg0_72.redPacketUI):GetChild(iter0_74 - 1)), var0_74 == iter0_74 - 1)
			end
		end, SFX_PANEL)
	end
end

function var0_0.CloseRedPacketPanel(arg0_77)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_77.redPacketUI, arg0_77:findTF("subPages"))
	SetActive(arg0_77.redPacketUI, false)
end

function var0_0.SetData(arg0_78)
	local var0_78 = getProxy(InstagramChatProxy)

	arg0_78.chatList = var0_78:GetChatList()

	var0_78:SortChatList()
end

function var0_0.willExit(arg0_79)
	local var0_79 = arg0_79:findTF("paintingMask/painting", arg0_79.rightPanel)

	if arg0_79.paintingName then
		retPaintingPrefab(var0_79, arg0_79.paintingName)

		arg0_79.paintingName = nil
	end

	arg0_79:RemoveAllTimer()
end

function var0_0.StartTimer(arg0_80, arg1_80, arg2_80)
	local var0_80 = Timer.New(arg1_80, arg2_80, 1)

	var0_80:Start()
	table.insert(arg0_80.timerList, var0_80)
end

function var0_0.RemoveAllTimer(arg0_81)
	for iter0_81, iter1_81 in ipairs(arg0_81.timerList) do
		iter1_81:Stop()
	end

	arg0_81.timerList = {}
end

function var0_0.StartTimer2(arg0_82, arg1_82, arg2_82)
	arg0_82.timer = Timer.New(arg1_82, arg2_82, 1)

	arg0_82.timer:Start()
end

function var0_0.SpeedUpMessage(arg0_83)
	local var0_83 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var1_83 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_83, iter1_83 in ipairs(arg0_83.timerList) do
		if iter1_83.running then
			if iter1_83.duration == var1_83 then
				iter1_83.time = 0.05
			elseif iter1_83.time - var0_83 < 0.05 then
				iter1_83.time = 0.05

				arg0_83:StartTimer2(function()
					arg0_83:SpeedUpWaiting()
				end, 0.05)
			else
				iter1_83.time = iter1_83.time - var0_83
			end
		end
	end
end

function var0_0.SpeedUpWaiting(arg0_85)
	local var0_85 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_85, iter1_85 in ipairs(arg0_85.timerList) do
		if iter1_85.running and iter1_85.duration == var0_85 then
			iter1_85.time = 0.05

			break
		end
	end
end

function var0_0.ChangeFresh(arg0_86)
	arg0_86.canFresh = true
end

function var0_0.ChangeCharaTextFunc(arg0_87, arg1_87, arg2_87)
	local function var0_87(arg0_88, arg1_88)
		if arg1_88:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_87) then
			setText(arg1_88:Find("msg"), arg2_87)
		end
	end

	arg0_87.charaList:each(var0_87)
end

function var0_0.ResetCharaTextFunc(arg0_89, arg1_89)
	local function var0_89(arg0_90, arg1_90)
		if arg1_90:Find("id"):GetComponent(typeof(Text)).text == tostring(arg1_89) then
			setText(arg1_90:Find("msg"), arg1_90:Find("displayWord"):GetComponent(typeof(Text)).text)
		end
	end

	arg0_89.charaList:each(var0_89)
end

function var0_0.SetEndAniEvent(arg0_91, arg1_91, arg2_91)
	local var0_91 = arg1_91:GetComponent(typeof(DftAniEvent))

	if var0_91 then
		var0_91:SetEndEvent(function()
			arg2_91()
			var0_91:SetEndEvent(nil)
		end)
	end
end

function var0_0.onBackPressed(arg0_93)
	if isActive(arg0_93.filterUI) then
		arg0_93:CloseFilterPanel()

		return
	end

	if isActive(arg0_93.topicUI) then
		arg0_93:CloseTopicPanel()

		return
	end

	if isActive(arg0_93.backgroundUI) then
		arg0_93:CloseBackgroundPanel()

		return
	end

	if isActive(arg0_93.redPacketUI) then
		arg0_93:CloseRedPacketPanel()

		return
	end

	arg0_93:emit(InstagramChatMediator.CLOSE_ALL)
end

return var0_0
