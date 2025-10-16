local var0_0 = class("Dorm3dChatLayer", import("view.base.BaseUI"))
local var1_0 = pg.dorm3d_ins_ship_group_template
local var2_0 = pg.dorm3d_ins_redpackage
local var3_0 = pg.emoji_template

function var0_0.getUIName(arg0_1)
	return "Dorm3dChatUI"
end

function var0_0.init(arg0_2)
	arg0_2.rightPanel = arg0_2._tf:Find("main/rightPanel")
	arg0_2.characterName = arg0_2.rightPanel:Find("rightTop/name")
	arg0_2.careBtn = arg0_2.rightPanel:Find("rightTop/careBtn")
	arg0_2.topicBtn = arg0_2.rightPanel:Find("rightTop/topicBtn")
	arg0_2.backgroundBtn = arg0_2.rightPanel:Find("rightTop/backgroundBtn")
	arg0_2.messageList = UIItemList.New(arg0_2.rightPanel:Find("messageScroll/Viewport/Content"), arg0_2.rightPanel:Find("messageScroll/Viewport/Content/messageCard"))
	arg0_2.optionPanel = arg0_2.rightPanel:Find("optionPanel")
	arg0_2.optionList = UIItemList.New(arg0_2.optionPanel, arg0_2.optionPanel:Find("option"))
	arg0_2.topicUI = arg0_2._tf:Find("subPages/InstagramTopicUI")
	arg0_2.backgroundUI = arg0_2._tf:Find("subPages/InstagramBackgroundUI")
	arg0_2.redPacketUI = arg0_2._tf:Find("subPages/InstagramRedPacketUI")
	arg0_2.pictureUI = arg0_2._tf:Find("subPages/PictureUI")

	setText(arg0_2.topicUI:Find("panel/topicScroll/Viewport/Content/topic/waiting"), i18n("juuschat_chattip3"))
	setText(arg0_2.topicUI:Find("panel/topicScroll/Viewport/Content/topic/selected/Text"), i18n("juuschat_label2"))
	setText(arg0_2.backgroundUI:Find("panel/backgroundScroll/Viewport/Content/background/selected/Text"), i18n("juuschat_label1"))
	setText(arg0_2.backgroundUI:Find("panel/backgroundScroll/Viewport/Content/background/lockFrame/Text"), i18n("juuschat_background_tip1"))

	arg0_2.redPacketGot = arg0_2.redPacketUI:Find("panel/got")
	arg0_2.noMessage = arg0_2.rightPanel:Find("noMessage")

	setText(arg0_2.noMessage:Find("Text"), i18n("dorm3d_ins_no_topics"))
	SetActive(arg0_2.topicUI, false)
	SetActive(arg0_2.backgroundUI, false)
	SetActive(arg0_2.redPacketUI, false)
	SetActive(arg0_2.pictureUI, false)

	arg0_2.timerList = {}
	arg0_2.canFresh = false

	local var0_2 = arg0_2.rightPanel:Find("messageScroll/Scrollbar Vertical"):GetComponent(typeof(RectTransform))

	arg0_2.messageScrollWidth = var0_2.rect.width
	arg0_2.messageScrollHeight = var0_2.rect.height

	arg0_2.topicUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_2.backgroundUI:Find("panel/title"):GetComponent(typeof(Image)):SetNativeSize()
	onButton(arg0_2, arg0_2.rightPanel:Find("closeBtn"), function()
		arg0_2:closeView()
	end, SFX_PANEL)
	arg0_2:OverlayPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_4)
	arg0_4:SetData()
	arg0_4:UpdateChat(false, false)
end

function var0_0.UpdateChat(arg0_5, arg1_5, arg2_5)
	SetActive(arg0_5.rightPanel, true)
	arg0_5:UpdateChatContent(arg1_5, arg2_5)
	arg0_5:SetTopicPanel(arg0_5.currentChat)
	arg0_5:SetBackgroundPanel(arg0_5.currentChat)

	if not arg1_5 then
		local var0_5 = arg0_5.rightPanel:GetComponent(typeof(Animation))

		var0_5:Stop()
		var0_5:Play("anim_newinstagram_chat_right_in")
	end
end

function var0_0.UpdateChatContent(arg0_6, arg1_6, arg2_6)
	SetActive(arg0_6.rightPanel, true)
	setText(arg0_6.characterName, arg0_6.currentChat.name)

	local var0_6 = arg0_6.careBtn:Find("care")

	SetActive(var0_6, arg0_6.currentChat.care == 1)
	onButton(arg0_6, arg0_6.careBtn, function()
		local var0_7 = arg0_6.currentChat.care == 0 and 1 or 0

		arg0_6:emit(Dorm3dChatMediator.CHANGE_CARE, arg0_6.currentChat.characterId, var0_7)
	end, SFX_PANEL)

	local var1_6 = arg0_6.rightPanel:Find("paintingMask")
	local var2_6 = var1_6:Find("painting")
	local var3_6 = arg0_6.rightPanel:Find("groupBackground")

	if not arg0_6.currentChat.groupBackground or arg0_6.currentChat.groupBackground == "" then
		SetActive(var1_6, true)
		SetActive(var3_6, false)

		local var4_6 = "unknown"

		if arg0_6.currentChat.skinId == 0 then
			var4_6 = arg0_6.currentChat:GetPainting()
		else
			for iter0_6, iter1_6 in ipairs(arg0_6.currentChat.skins) do
				if iter1_6.id == arg0_6.currentChat.skinId then
					var4_6 = iter1_6.painting
				end
			end
		end

		if not arg0_6.paintingName then
			setPaintingPrefabAsync(var2_6, var4_6, "pifu")

			arg0_6.paintingName = var4_6
		elseif arg0_6.paintingName and arg0_6.paintingName ~= var4_6 then
			retPaintingPrefab(var2_6, arg0_6.paintingName)
			setPaintingPrefabAsync(var2_6, var4_6, "pifu")

			arg0_6.paintingName = var4_6
		end
	else
		SetActive(var1_6, false)
		SetActive(var3_6, true)

		if arg0_6.paintingName then
			retPaintingPrefab(var2_6, arg0_6.paintingName)

			arg0_6.paintingName = nil
		end

		setImageSprite(var3_6, LoadSprite("ui/" .. arg0_6.currentChat.groupBackground), true)
	end

	setActive(arg0_6.rightPanel:Find("messageScroll"), arg0_6.currentChat.currentTopic)
	setActive(var1_6, arg0_6.currentChat.currentTopic)
	setActive(arg0_6.noMessage, not arg0_6.currentChat.currentTopic)

	if not arg0_6.currentChat.currentTopic then
		return
	end

	local var5_6 = arg0_6.currentChat.currentTopic:GetDisplayWordList()

	if not arg2_6 then
		arg0_6:UpdateOptionPanel(arg0_6.currentChat.currentTopic, var5_6)
		arg0_6:UpdateMessageList(arg0_6.currentChat.currentTopic, var5_6, arg1_6, arg0_6.currentChat.characterId)
	end

	if not arg1_6 and arg0_6.currentChat.currentTopic.readFlag == 0 then
		arg0_6:emit(Dorm3dChatMediator.SET_READED, arg0_6.currentChat.characterId, {
			arg0_6.currentChat.currentTopic.topicId
		})
	end
end

function var0_0.UpdateMessageList(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	arg0_8:RemoveAllTimer()

	local var0_8

	for iter0_8 = #arg2_8, 1, -1 do
		if arg2_8[iter0_8].ship_group == 0 or arg2_8[iter0_8].type == 3 and arg1_8:RedPacketGotFlag(tonumber(arg2_8[iter0_8].param)) then
			var0_8 = iter0_8

			break
		end
	end

	local var1_8 = {}

	if var0_8 then
		for iter1_8 = var0_8, 1, -1 do
			if arg2_8[iter1_8].ship_group == 0 then
				table.insert(var1_8, iter1_8)
			else
				break
			end
		end
	end

	if arg0_8.shouldShowOption and arg3_8 then
		arg0_8:SetOptionPanelActive(false)
	end

	if arg3_8 then
		onButton(arg0_8, arg0_8.rightPanel:Find("messageScroll"), function()
			arg0_8:SpeedUpMessage()
		end, SFX_PANEL)
	end

	local var2_8 = GetComponent(arg0_8.rightPanel:Find("messageScroll"), typeof(ScrollRect))

	local function var3_8(arg0_10)
		local var0_10 = Vector2(0, arg0_10)

		var2_8.normalizedPosition = var0_10
	end

	local var4_8 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var5_8 = pg.gameset.juuschat_entering_time.key_value / 1000
	local var6_8 = var4_8 - var5_8

	arg0_8.playbackInfos = {}

	arg0_8.messageList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg2_8[arg1_11 + 1]

			if var0_11.ship_group == 0 and var0_11.type == 0 then
				SetActive(arg2_11, false)

				return
			end

			local var1_11 = arg2_11:Find("charaMessageCard")
			local var2_11 = arg2_11:Find("playerReplyCard")

			SetActive(var1_11, var0_11.ship_group ~= 0)
			SetActive(var2_11, var0_11.ship_group == 0)
			SetActive(arg2_11:Find("nameBar"), false)

			local var3_11

			if arg3_8 and var0_8 and arg1_11 + 1 > var0_8 then
				var3_11 = (arg1_11 + 1 - var0_8) * var4_8 - var5_8

				if #var1_8 > 1 then
					var3_11 = var3_11 + (#var1_8 - 1) * var6_8
				end
			end

			if var0_11.ship_group ~= 0 then
				local var4_11 = "unknown"

				if var1_0[var0_11.ship_group] then
					var4_11 = var1_0[var0_11.ship_group].sculpture
				end

				if var0_11.type ~= 5 then
					setImageSprite(arg2_11:Find("charaMessageCard/charaBg/chara"), LoadSprite("qicon/" .. var4_11), false)
				end

				if var0_11.type == 1 then
					arg0_8:SetCharaMessageCardActive(var1_11, {
						3
					})
					setText(arg2_11:Find("charaMessageCard/msgBox/msg"), var0_11.param)

					if arg3_8 and var0_8 and arg1_11 + 1 > var0_8 then
						SetActive(arg2_11, false)
						arg0_8:StartTimer(function()
							SetActive(arg2_11, true)
							arg2_11:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_11:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_11:Find("charaMessageCard/msgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
							arg0_8:StartTimer(function()
								SetActive(arg2_11:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_11:Find("charaMessageCard/msgBox"), true)
								arg2_11:Find("charaMessageCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")

								if arg1_11 + 1 == #arg2_8 then
									arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
										arg1_8.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
								arg0_8:SetEndAniEvent(arg2_11:Find("charaMessageCard/msgBox"), function()
									if arg0_8.shouldShowOption and arg1_11 + 1 == #arg2_8 then
										arg0_8:SetOptionPanelActive(true)
									end
								end)
							end, var5_8)
						end, var3_11)
					end
				elseif var0_11.type == 2 then
					arg0_8:SetCharaMessageCardActive(var1_11, {
						2,
						7
					})
					pg.CriMgr.GetInstance():GetCueInfo("cv-" .. var0_11.ship_group, var0_11.param[1], function(arg0_15)
						setText(arg2_11:Find("charaMessageCard/voiceBox/time"), tostring(math.ceil(tonumber(tostring(arg0_15.length)) / 1000)) .. "\"")
					end)

					arg0_8.playbackInfos[var0_11.id] = nil

					setActive(arg2_11:Find("charaMessageCard/voiceBox/play/pause"), false)
					onButton(arg0_8, arg2_11:Find("charaMessageCard/voiceBox/play"), function()
						if arg0_8.playbackInfos[var0_11.id].playback:GetStatus() == CriAtomExPlayback.Status.Removed then
							arg0_8.playbackInfos[var0_11.id] = nil
						end

						if not arg0_8.playbackInfos[var0_11.id] then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/cv/" .. var0_11.ship_group .. "/" .. var0_11.param[1], function(arg0_17)
								if arg0_17 then
									arg0_8.playbackInfos[var0_11.id] = arg0_17
								end
							end)
							setActive(arg2_11:Find("charaMessageCard/voiceBox/play/pause"), true)
						elseif arg0_8.playbackInfos[var0_11.id].playback:IsPaused() then
							arg0_8.playbackInfos[var0_11.id].playback:Resume(CriWare.CriAtomEx.ResumeMode.PausedPlayback)
							setActive(arg2_11:Find("charaMessageCard/voiceBox/play/pause"), true)
						else
							arg0_8.playbackInfos[var0_11.id].playback:Pause()
							setActive(arg2_11:Find("charaMessageCard/voiceBox/play/pause"), false)
						end
					end, SFX_PANEL)
					setText(arg2_11:Find("charaMessageCard/voiceMsgBox/voiceMsg/msg"), var0_11.param[2])

					if arg3_8 and var0_8 and arg1_11 + 1 > var0_8 then
						SetActive(arg2_11, false)
						arg0_8:StartTimer(function()
							SetActive(arg2_11, true)
							arg2_11:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_11:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_11:Find("charaMessageCard/voiceBox"), false)
							SetActive(arg2_11:Find("charaMessageCard/voiceMsgBox"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
							arg0_8:StartTimer(function()
								SetActive(arg2_11:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_11:Find("charaMessageCard/voiceBox"), true)
								SetActive(arg2_11:Find("charaMessageCard/voiceMsgBox"), true)
								arg2_11:Find("charaMessageCard/voiceBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_chat_common_in")
								arg2_11:Find("charaMessageCard/voiceMsgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_voicetip_in")

								if arg1_11 + 1 == #arg2_8 then
									arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
										arg1_8.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
								arg0_8:SetEndAniEvent(arg2_11:Find("charaMessageCard/voiceBox"), function()
									if arg0_8.shouldShowOption and arg1_11 + 1 == #arg2_8 then
										arg0_8:SetOptionPanelActive(true)
									end
								end)
							end, var5_8)
						end, var3_11)
					end
				elseif var0_11.type == 3 then
					arg0_8:SetCharaMessageCardActive(var1_11, {
						5
					})

					local var5_11 = var2_0[tonumber(var0_11.param)]

					setText(arg2_11:Find("charaMessageCard/redPacket/desc"), var5_11.desc)

					local var6_11 = arg1_8:RedPacketGotFlag(var5_11.id)

					SetActive(arg2_11:Find("charaMessageCard/redPacket/got"), var6_11)
					arg0_8:SetRedPacketPanel(arg2_11:Find("charaMessageCard/redPacket"), var5_11, var6_11, var4_11, arg4_8, arg1_8.topicId, var0_11.id)

					if arg3_8 and var0_8 and arg1_11 + 1 > var0_8 then
						SetActive(arg2_11, false)
						arg0_8:StartTimer(function()
							SetActive(arg2_11, true)
							arg2_11:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_11:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_11:Find("charaMessageCard/redPacket"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
							arg0_8:StartTimer(function()
								SetActive(arg2_11:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_11:Find("charaMessageCard/redPacket"), true)
								arg2_11:Find("charaMessageCard/redPacket"):GetComponent(typeof(Animation)):Play("anim_newinstagram_redpacket_in")

								if arg1_11 + 1 == #arg2_8 then
									arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
										arg1_8.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
								arg0_8:SetEndAniEvent(arg2_11:Find("charaMessageCard/redPacket"), function()
									if arg0_8.shouldShowOption and arg1_11 + 1 == #arg2_8 then
										arg0_8:SetOptionPanelActive(true)
									end
								end)
							end, var5_8)
						end, var3_11)
					end
				elseif var0_11.type == 4 then
					arg0_8:SetCharaMessageCardActive(var1_11, {
						4
					})
					arg0_8:ClearEmoji(arg2_11:Find("charaMessageCard/emoji/emoticon"))
					arg0_8:SetEmoji(arg2_11:Find("charaMessageCard/emoji/emoticon"), var3_0[tonumber(var0_11.param)].pic)

					if arg3_8 and var0_8 and arg1_11 + 1 > var0_8 then
						SetActive(arg2_11, false)
						arg0_8:StartTimer(function()
							SetActive(arg2_11, true)
							arg2_11:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_11:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_11:Find("charaMessageCard/emoji"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
							arg0_8:StartTimer(function()
								SetActive(arg2_11:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_11:Find("charaMessageCard/emoji"), true)
								arg2_11:Find("charaMessageCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								if arg1_11 + 1 == #arg2_8 then
									arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
										arg1_8.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
								arg0_8:SetEndAniEvent(arg2_11:Find("charaMessageCard/emoji"), function()
									if arg0_8.shouldShowOption and arg1_11 + 1 == #arg2_8 then
										arg0_8:SetOptionPanelActive(true)
									end
								end)
							end, var5_8)
						end, var3_11)
					end
				elseif var0_11.type == 5 then
					arg0_8:SetCharaMessageCardActive(var1_11, {
						6
					})

					local var7_11 = var0_11.param

					for iter0_11 in string.gmatch(var0_11.param, "'%d+'") do
						local var8_11 = string.sub(iter0_11, 2, #iter0_11 - 1)

						var7_11 = string.gsub(var7_11, iter0_11, "<color=#93e9ff>" .. var1_0[tonumber(var8_11)].name .. "</color>")
					end

					setText(arg2_11:Find("charaMessageCard/systemTip/panel/Text"), var7_11)

					if arg3_8 and var0_8 and arg1_11 + 1 > var0_8 then
						SetActive(arg2_11, false)
						arg0_8:StartTimer(function()
							SetActive(arg2_11, true)
							arg2_11:Find("charaMessageCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")

							if arg1_11 + 1 == #arg2_8 then
								arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
									arg1_8.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
							arg0_8:SetEndAniEvent(arg2_11:Find("charaMessageCard/systemTip"), function()
								if arg0_8.shouldShowOption and arg1_11 + 1 == #arg2_8 then
									arg0_8:SetOptionPanelActive(true)
								end
							end)
						end, var3_11)
					end
				elseif var0_11.type == 6 then
					arg0_8:SetCharaMessageCardActive(var1_11, {
						8
					})
					setImageSprite(arg2_11:Find("charaMessageCard/picture/mask/img"), LoadSprite("dorm3dprivatechat/" .. var0_11.param), false)
					arg0_8:SetPicturePanel(arg2_11:Find("charaMessageCard/picture/mask/img"), var0_11.param)

					if arg3_8 and var0_8 and arg1_11 + 1 > var0_8 then
						SetActive(arg2_11, false)
						arg0_8:StartTimer(function()
							SetActive(arg2_11, true)
							arg2_11:Find("charaMessageCard/charaBg"):GetComponent(typeof(Animation)):Play("anim_newinstagram_charabg")
							SetActive(arg2_11:Find("charaMessageCard/waiting"), true)
							SetActive(arg2_11:Find("charaMessageCard/picture"), false)
							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
							arg0_8:StartTimer(function()
								SetActive(arg2_11:Find("charaMessageCard/waiting"), false)
								SetActive(arg2_11:Find("charaMessageCard/picture"), true)
								arg2_11:Find("charaMessageCard/picture"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")

								if arg1_11 + 1 == #arg2_8 then
									arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
										arg1_8.topicId
									})
								end

								Canvas.ForceUpdateCanvases()
								LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
								arg0_8:SetEndAniEvent(arg2_11:Find("charaMessageCard/picture"), function()
									if arg0_8.shouldShowOption and arg1_11 + 1 == #arg2_8 then
										arg0_8:SetOptionPanelActive(true)
									end
								end)
							end, var5_8)
						end, var3_11)
					end
				end
			else
				if var0_11.type == 1 then
					arg0_8:SetPlayerMessageCardActive(var2_11, {
						0
					})
					setText(arg2_11:Find("playerReplyCard/msgBox/msg"), var0_11.param)
				elseif var0_11.type == 4 then
					arg0_8:SetPlayerMessageCardActive(var2_11, {
						1
					})
					arg0_8:ClearEmoji(arg2_11:Find("playerReplyCard/emoji/emoticon"))
					arg0_8:SetEmoji(arg2_11:Find("playerReplyCard/emoji/emoticon"), var3_0[tonumber(var0_11.param)].pic)
				elseif var0_11.type == 5 then
					arg0_8:SetPlayerMessageCardActive(var2_11, {
						2
					})

					local var9_11 = var0_11.param

					for iter1_11 in string.gmatch(var0_11.param, "'%d+'") do
						local var10_11 = string.sub(iter1_11, 2, #iter1_11 - 1)

						var9_11 = string.gsub(var9_11, iter1_11, "<color=#93e9ff>" .. var1_0[tonumber(var10_11)].name .. "</color>")
					end

					setText(arg2_11:Find("playerReplyCard/systemTip/panel/Text"), var9_11)
				end

				if arg3_8 and var0_8 and _.contains(var1_8, arg1_11 + 1) then
					if table.indexof(var1_8, arg1_11 + 1) < #var1_8 then
						SetActive(arg2_11, false)
						arg0_8:StartTimer(function()
							SetActive(arg2_11, true)

							if var0_11.type == 1 then
								arg2_11:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
							elseif var0_11.type == 4 then
								arg2_11:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")
							elseif var0_11.type == 5 then
								arg2_11:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")
							end

							if arg1_11 + 1 == #arg2_8 then
								arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
									arg1_8.topicId
								})
							end

							Canvas.ForceUpdateCanvases()
							LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
						end, (#var1_8 - table.indexof(var1_8, arg1_11 + 1)) * var6_8)
					else
						if var0_11.type == 1 then
							arg2_11:Find("playerReplyCard/msgBox"):GetComponent(typeof(Animation)):Play("anim_newinstagram_playerchat_common_in")
						elseif var0_11.type == 4 then
							arg2_11:Find("playerReplyCard/emoji"):GetComponent(typeof(Animation)):Play("anim_newinstagram_emoji_in")
						elseif var0_11.type == 5 then
							arg2_11:Find("playerReplyCard/systemTip"):GetComponent(typeof(Animation)):Play("anim_newinstagram_tip_in")
						end

						if arg1_11 + 1 == #arg2_8 then
							arg0_8:emit(Dorm3dChatMediator.SET_READED, arg4_8, {
								arg1_8.topicId
							})
						end
					end
				end
			end

			if not arg1_8:isWaiting() and arg1_11 + 1 == #arg2_8 then
				if arg3_8 then
					if var0_11.ship_group ~= 0 then
						arg0_8:StartTimer(function()
							setActive(arg2_11:Find("end"), true)
						end, var3_11 + var4_8)
					else
						arg0_8:StartTimer(function()
							setActive(arg2_11:Find("end"), true)
						end, (#var1_8 - table.indexof(var1_8, arg1_11 + 1)) * var6_8 + var6_8)
					end
				else
					setActive(arg2_11:Find("end"), true)
				end
			else
				setActive(arg2_11:Find("end"), false)
			end
		end
	end)
	arg0_8.messageList:align(#arg2_8)

	if arg3_8 then
		Canvas.ForceUpdateCanvases()
		LeanTween.value(go(arg0_8.rightPanel:Find("messageScroll")), var2_8.normalizedPosition.y, 0, 0.5):setOnUpdate(System.Action_float(var3_8)):setEase(LeanTweenType.easeInOutCubic)
	else
		scrollToBottom(arg0_8.rightPanel:Find("messageScroll"))
	end
end

function var0_0.SetCharaMessageCardActive(arg0_35, arg1_35, arg2_35)
	if _.contains(arg2_35, 6) then
		SetActive(arg1_35:GetChild(0), false)
	else
		SetActive(arg1_35:GetChild(0), true)
	end

	for iter0_35 = 1, arg1_35.childCount - 1 do
		if _.contains(arg2_35, iter0_35) then
			SetActive(arg1_35:GetChild(iter0_35), true)
		else
			SetActive(arg1_35:GetChild(iter0_35), false)
		end
	end
end

function var0_0.SetPlayerMessageCardActive(arg0_36, arg1_36, arg2_36)
	for iter0_36 = 0, arg1_36.childCount - 1 do
		if _.contains(arg2_36, iter0_36) then
			SetActive(arg1_36:GetChild(iter0_36), true)
		else
			SetActive(arg1_36:GetChild(iter0_36), false)
		end
	end
end

function var0_0.SetEmoji(arg0_37, arg1_37, arg2_37)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg2_37, arg2_37, true, function(arg0_38)
		if not IsNil(arg1_37) then
			arg0_38.name = arg2_37
			tf(arg0_38).sizeDelta = arg1_37.sizeDelta
			tf(arg0_38).anchoredPosition = Vector2.zero

			local var0_38 = arg0_38:GetComponent("Animator")

			if var0_38 then
				var0_38.enabled = true
			end

			setParent(arg0_38, arg1_37, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg2_37, arg2_37, arg0_38)
		end
	end)
end

function var0_0.ClearEmoji(arg0_39, arg1_39)
	eachChild(arg1_39, function(arg0_40)
		local var0_40 = go(arg0_40)

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_40.name, var0_40.name, var0_40)
	end)
end

function var0_0.UpdateOptionPanel(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg2_41[#arg2_41].option

	if var0_41 and type(var0_41) == "table" then
		arg0_41.shouldShowOption = true
		arg0_41.optionCount = #var0_41

		arg0_41:SetOptionPanelActive(true)
		arg0_41.optionList:make(function(arg0_42, arg1_42, arg2_42)
			if arg0_42 == UIItemList.EventUpdate then
				local var0_42 = var0_41[arg1_42 + 1]

				setText(arg2_42:Find("Text"), HXSet.hxLan(var0_42[2]))
				onButton(arg0_41, arg2_42, function()
					arg0_41:emit(Dorm3dChatMediator.REPLY, arg1_41.characterId, arg1_41.topicId, arg2_41[#arg2_41].id, var0_42[1])
				end, SFX_PANEL)
			end
		end)
		arg0_41.optionList:align(#var0_41)
	else
		arg0_41:SetOptionPanelActive(false)

		arg0_41.shouldShowOption = false
	end
end

function var0_0.SetOptionPanelActive(arg0_44, arg1_44)
	SetActive(arg0_44.optionPanel, arg1_44)

	local var0_44 = arg0_44.rightPanel:Find("messageScroll/Viewport/Content"):GetComponent(typeof(VerticalLayoutGroup))
	local var1_44 = UnityEngine.RectOffset.New()

	var1_44.left = 0
	var1_44.right = 0
	var1_44.top = 0

	local var2_44 = arg0_44.rightPanel:Find("messageScroll/Scrollbar Vertical"):GetComponent(typeof(RectTransform))

	if arg1_44 then
		var1_44.bottom = 42 + 88 * arg0_44.optionCount
		var2_44.sizeDelta = Vector2(arg0_44.messageScrollWidth, -var1_44.bottom)
	else
		var1_44.bottom = 50
		var2_44.sizeDelta = Vector2(arg0_44.messageScrollWidth, 0)
	end

	var0_44.padding = var1_44

	scrollToBottom(arg0_44.rightPanel:Find("messageScroll"))
end

function var0_0.SetTopicPanel(arg0_45, arg1_45)
	SetActive(arg0_45.topicBtn:Find("tip"), arg1_45:GetCharacterEndFlagExceptCurrent() == 0)
	onButton(arg0_45, arg0_45.topicBtn, function()
		SetActive(arg0_45.topicUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_45.topicUI)

		arg0_45.currentTopic = nil

		local var0_46 = UIItemList.New(arg0_45.topicUI:Find("panel/topicScroll/Viewport/Content"), arg0_45.topicUI:Find("panel/topicScroll/Viewport/Content/topic"))

		var0_46:make(function(arg0_47, arg1_47, arg2_47)
			if arg0_47 == UIItemList.EventUpdate then
				arg1_45:SortTopicList()

				local var0_47 = arg1_45.topics[arg1_47 + 1]

				setScrollText(arg2_47:Find("mask/name"), HXSet.hxLan(var0_47.name))
				SetActive(arg2_47:Find("lock"), not var0_47.active)
				SetActive(arg2_47:Find("waiting"), var0_47.active and var0_47:isWaiting())
				SetActive(arg2_47:Find("complete"), var0_47.active and var0_47:IsCompleted())
				SetActive(arg2_47:Find("selectedFrame"), arg1_45.currentTopicId == var0_47.topicId)
				SetActive(arg2_47:Find("selected"), arg1_45.currentTopicId == var0_47.topicId)
				SetActive(arg2_47:Find("tip"), var0_47.active and not var0_47:IsCompleted())

				if arg1_45.currentTopicId == var0_47.topicId then
					arg0_45.currentTopic = var0_47
				end

				if var0_47.active then
					onButton(arg0_45, arg2_47, function()
						SetActive(arg2_47:Find("selectedFrame"), true)

						for iter0_48 = 1, #arg1_45.topics do
							if iter0_48 ~= arg1_47 + 1 then
								SetActive(arg0_45.topicUI:Find("panel/topicScroll/Viewport/Content"):GetChild(iter0_48 - 1):Find("selectedFrame"), false)
							end
						end

						arg0_45.currentTopic = var0_47
					end, SFX_PANEL)
				else
					onButton(arg0_45, arg2_47, function()
						pg.TipsMgr.GetInstance():ShowTips(var0_47.unlockDesc)
					end, SFX_PANEL)
				end
			end
		end)
		var0_46:align(#arg1_45.topics)
	end, SFX_PANEL)
	onButton(arg0_45, arg0_45.topicUI:Find("bg"), function()
		arg0_45:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_45, arg0_45.topicUI:Find("panel/bottom/close"), function()
		arg0_45:CloseTopicPanel()
	end, SFX_PANEL)
	onButton(arg0_45, arg0_45.topicUI:Find("panel/bottom/ok"), function()
		arg0_45:emit(Dorm3dChatMediator.SET_CURRENT_TOPIC, arg0_45.currentTopic.characterId, arg0_45.currentTopic.topicId)
		arg0_45:CloseTopicPanel()

		local var0_52 = arg0_45.rightPanel:GetComponent(typeof(Animation))

		var0_52:Stop()
		var0_52:Play("anim_newinstagram_chat_right_in")
	end, SFX_PANEL)
end

function var0_0.CloseTopicPanel(arg0_53)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_53.topicUI, arg0_53._tf:Find("subPages"))
	SetActive(arg0_53.topicUI, false)
end

function var0_0.SetBackgroundPanel(arg0_54, arg1_54)
	local var0_54 = arg1_54:GetPaintingId()

	onButton(arg0_54, arg0_54.backgroundBtn, function()
		SetActive(arg0_54.backgroundUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_54.backgroundUI)

		arg0_54.currentBgId = nil

		local var0_55 = arg1_54:GetSkins()
		local var1_55 = UIItemList.New(arg0_54.backgroundUI:Find("panel/backgroundScroll/Viewport/Content"), arg0_54.backgroundUI:Find("panel/backgroundScroll/Viewport/Content/background"))

		var1_55:make(function(arg0_56, arg1_56, arg2_56)
			if arg0_56 == UIItemList.EventUpdate then
				local var0_56 = var0_55[arg1_56 + 1]
				local var1_56 = 0

				if var0_56.id ~= var0_54 then
					var1_56 = var0_56.id
				end

				local var2_56 = var0_56.painting

				LoadImageSpriteAsync("herohrzicon/" .. var2_56, arg2_56:Find("skinMask/skin"), false)
				setScrollText(arg2_56:Find("skinMask/Panel/mask/Text"), var0_56.name)

				local var3_56 = getProxy(ShipSkinProxy):hasSkin(var0_56.id) or var0_56.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or var0_56.skin_type == ShipSkin.SKIN_TYPE_PROPOSE or var0_56.skin_type == ShipSkin.SKIN_TYPE_REMAKE

				SetActive(arg2_56:Find("lockFrame"), not var3_56)
				SetActive(arg2_56:Find("selectedFrame"), arg1_54.skinId == var1_56)
				SetActive(arg2_56:Find("selected"), arg1_54.skinId == var1_56)

				if arg1_54.skinId == var1_56 then
					arg0_54.currentBgId = var1_56
				end

				onButton(arg0_54, arg2_56, function()
					if var3_56 then
						SetActive(arg2_56:Find("selectedFrame"), true)

						for iter0_57 = 1, #var0_55 do
							if iter0_57 ~= arg1_56 + 1 then
								local var0_57 = arg0_54.backgroundUI:Find("panel/backgroundScroll/Viewport/Content"):GetChild(iter0_57 - 1)

								SetActive(var0_57:Find("selectedFrame"), false)
							end
						end

						arg0_54.currentBgId = var1_56
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("juuschat_background_tip2"))
					end
				end, SFX_PANEL)
			end
		end)
		var1_55:align(#var0_55)
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54.backgroundUI:Find("bg"), function()
		arg0_54:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54.backgroundUI:Find("panel/bottom/close"), function()
		arg0_54:CloseBackgroundPanel()
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54.backgroundUI:Find("panel/bottom/ok"), function()
		arg0_54:emit(Dorm3dChatMediator.SET_CURRENT_BACKGROUND, arg1_54.characterId, arg0_54.currentBgId)
		arg0_54:CloseBackgroundPanel()
	end, SFX_PANEL)
end

function var0_0.CloseBackgroundPanel(arg0_61)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_61.backgroundUI, arg0_61._tf:Find("subPages"))
	SetActive(arg0_61.backgroundUI, false)
end

function var0_0.SetRedPacketPanel(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62, arg5_62, arg6_62, arg7_62)
	onButton(arg0_62, arg1_62, function()
		SetActive(arg0_62.redPacketUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_62.redPacketUI)
		setImageSprite(arg0_62.redPacketUI:Find("panel/charaBg/chara"), LoadSprite("qicon/" .. arg4_62), false)

		if not arg3_62 then
			SetActive(arg0_62.redPacketUI:Find("panel/get"), true)
			SetActive(arg0_62.redPacketUI:Find("panel/got"), false)
			SetActive(arg0_62.redPacketUI:Find("panel/detail"), false)
			setText(arg0_62.redPacketUI:Find("panel/get/titleBg/title"), arg2_62.desc)
			onButton(arg0_62, arg0_62.redPacketUI:Find("panel/get/getBtn"), function()
				arg0_62:emit(Dorm3dChatMediator.GET_REDPACKET, arg5_62, arg6_62, arg7_62, arg2_62.id)
			end, SFX_PANEL)
		else
			arg0_62:UpdateRedPacketUI(arg2_62.id)
		end
	end, SFX_PANEL)
	onButton(arg0_62, arg0_62.redPacketUI:Find("bg"), function()
		arg0_62:CloseRedPacketPanel()

		if arg0_62.canFresh then
			arg0_62.canFresh = false

			local var0_65 = arg0_62.currentChat.currentTopic:GetDisplayWordList()

			if var0_65[#var0_65].type == 0 then
				arg0_62:UpdateChat(false, false)
			else
				arg0_62:UpdateChat(true, false)
			end
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRedPacketUI(arg0_66, arg1_66)
	local var0_66 = var2_0[arg1_66]

	SetActive(arg0_66.redPacketUI:Find("panel/get"), false)
	SetActive(arg0_66.redPacketUI:Find("panel/got"), true)
	SetActive(arg0_66.redPacketUI:Find("panel/detail"), false)

	local var1_66 = Drop.Create(var0_66.content)

	var1_66.count = 0

	updateDrop(arg0_66.redPacketUI:Find("panel/got/item"), var1_66)
	onButton(arg0_66, arg0_66.redPacketUI:Find("panel/got/item"), function()
		arg0_66:emit(BaseUI.ON_DROP, var1_66)
	end, SFX_PANEL)

	arg0_66.redPacketUI:Find("panel/got/item/icon_bg"):GetComponent(typeof(Image)).enabled = false
	arg0_66.redPacketUI:Find("panel/got/item/icon_bg/frame"):GetComponent(typeof(Image)).enabled = false

	setText(arg0_66.redPacketUI:Find("panel/got/awardCount"), var0_66.content[3])
end

function var0_0.CloseRedPacketPanel(arg0_68)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_68.redPacketUI, arg0_68._tf:Find("subPages"))
	SetActive(arg0_68.redPacketUI, false)
end

function var0_0.SetPicturePanel(arg0_69, arg1_69, arg2_69)
	onButton(arg0_69, arg1_69, function()
		setActive(arg0_69.pictureUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_69.pictureUI)
		setImageSprite(arg0_69.pictureUI:Find("picture"), LoadSprite("dorm3dprivatechat/" .. arg2_69), true)
	end, SFX_PANEL)
	onButton(arg0_69, arg0_69.pictureUI:Find("bg"), function()
		arg0_69:ClosePicturePanel()
	end, SFX_PANEL)
	onButton(arg0_69, arg0_69.pictureUI:Find("closeBtn"), function()
		arg0_69:ClosePicturePanel()
	end, SFX_PANEL)
end

function var0_0.ClosePicturePanel(arg0_73)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_73.pictureUI, arg0_73._tf:Find("subPages"))
	SetActive(arg0_73.pictureUI, false)
end

function var0_0.SetData(arg0_74)
	arg0_74.currentChat = getProxy(Dorm3dChatProxy):GetCharacterChatById(arg0_74.contextData.chatId)

	getProxy(Dorm3dChatProxy):AutoChangeCurrentTopic(arg0_74.currentChat)
end

function var0_0.willExit(arg0_75)
	local var0_75 = arg0_75.rightPanel:Find("paintingMask/painting")

	if arg0_75.paintingName then
		retPaintingPrefab(var0_75, arg0_75.paintingName)

		arg0_75.paintingName = nil
	end

	arg0_75:RemoveAllTimer()
end

function var0_0.StartTimer(arg0_76, arg1_76, arg2_76)
	local var0_76 = Timer.New(arg1_76, arg2_76, 1)

	var0_76:Start()
	table.insert(arg0_76.timerList, var0_76)
end

function var0_0.RemoveAllTimer(arg0_77)
	for iter0_77, iter1_77 in ipairs(arg0_77.timerList) do
		iter1_77:Stop()
	end

	arg0_77.timerList = {}
end

function var0_0.StartTimer2(arg0_78, arg1_78, arg2_78)
	arg0_78.timer = Timer.New(arg1_78, arg2_78, 1)

	arg0_78.timer:Start()
end

function var0_0.SpeedUpMessage(arg0_79)
	local var0_79 = pg.gameset.juuschat_dialogue_trigger_time.key_value / 1000
	local var1_79 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_79, iter1_79 in ipairs(arg0_79.timerList) do
		if iter1_79.running then
			if iter1_79.duration == var1_79 then
				iter1_79.time = 0.05
			elseif iter1_79.time - var0_79 < 0.05 then
				iter1_79.time = 0.05

				arg0_79:StartTimer2(function()
					arg0_79:SpeedUpWaiting()
				end, 0.05)
			else
				iter1_79.time = iter1_79.time - var0_79
			end
		end
	end
end

function var0_0.SpeedUpWaiting(arg0_81)
	local var0_81 = pg.gameset.juuschat_entering_time.key_value / 1000

	for iter0_81, iter1_81 in ipairs(arg0_81.timerList) do
		if iter1_81.running and iter1_81.duration == var0_81 then
			iter1_81.time = 0.05

			break
		end
	end
end

function var0_0.ChangeFresh(arg0_82)
	arg0_82.canFresh = true
end

function var0_0.SetEndAniEvent(arg0_83, arg1_83, arg2_83)
	local var0_83 = arg1_83:GetComponent(typeof(DftAniEvent))

	if var0_83 then
		var0_83:SetEndEvent(function()
			arg2_83()
			var0_83:SetEndEvent(nil)
		end)
	end
end

function var0_0.onBackPressed(arg0_85)
	if isActive(arg0_85.topicUI) then
		arg0_85:CloseTopicPanel()

		return
	end

	if isActive(arg0_85.backgroundUI) then
		arg0_85:CloseBackgroundPanel()

		return
	end

	if isActive(arg0_85.redPacketUI) then
		arg0_85:CloseRedPacketPanel()

		return
	end

	if isActive(arg0_85.pictureUI) then
		arg0_85:ClosePicturePanel()

		return
	end

	arg0_85:closeView()
end

return var0_0
