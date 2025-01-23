local var0_0 = class("NewEducateMainScene", import("view.newEducate.base.NewEducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateMainUI"
end

function var0_0.PlayBGM(arg0_2)
	local var0_2 = arg0_2.contextData.char:GetBgm()

	if var0_2 then
		pg.BgmMgr.GetInstance():Push(arg0_2.__cname, var0_2)
	end
end

function var0_0.init(arg0_3)
	arg0_3.rootTF = arg0_3._tf:Find("root")
	arg0_3.mainAnim = arg0_3.rootTF:GetComponent(typeof(Animation))
	arg0_3.bgTF = arg0_3.rootTF:Find("bg")
	arg0_3.paintTF = arg0_3.rootTF:Find("painting")
	arg0_3.dialogueTF = arg0_3.rootTF:Find("main/dialogue")
	arg0_3.dialogueContent = arg0_3.dialogueTF:Find("content")

	setActive(arg0_3.dialogueTF, false)
	setActive(arg0_3.dialogueTF:Find("arrows"), false)

	arg0_3.topicBtn = arg0_3.rootTF:Find("main/topic")

	setActive(arg0_3.topicBtn, false)

	arg0_3.mindBtn = arg0_3.rootTF:Find("main/mind")

	setActive(arg0_3.mindBtn, false)

	arg0_3.adaptTF = arg0_3.rootTF:Find("adapt")
	arg0_3.favorTF = arg0_3.adaptTF:Find("favor")
	arg0_3.normalBtns = arg0_3.adaptTF:Find("normal")
	arg0_3.scheduleBtn = arg0_3.normalBtns:Find("schedule")
	arg0_3.mapBtn = arg0_3.normalBtns:Find("map")
	arg0_3.endingBtn = arg0_3.adaptTF:Find("ending")
	arg0_3.resetBtn = arg0_3.adaptTF:Find("reset")
	arg0_3.topPanel = NewEducateTopPanel.New(arg0_3.adaptTF, arg0_3.event, setmetatable({
		hideBlurBg = true
	}, {
		__index = arg0_3.contextData
	}))
	arg0_3.infoPanel = NewEducateInfoPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)
	arg0_3.roundTipPanel = NewEducateRoundTipPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)
	arg0_3.assessPanel = NewEducateAssessPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)
	arg0_3.favorPanel = NewEducateFavorPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)
	arg0_3.personalityTipPanel = NewEducatePersonalityTipPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)
	arg0_3.nodePanel = NewEducateNodePanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)
end

function var0_0.didEnter(arg0_4)
	local var0_4 = "neweducateicon/" .. arg0_4.contextData.char:getConfig("child2_data_personality_icon")[2]

	LoadImageSpriteAsync(var0_4, arg0_4.mindBtn, true)
	onButton(arg0_4, arg0_4:findTF("fitter", arg0_4.paintTF), function()
		arg0_4:ShowDialogue()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.mindBtn, function()
		setActive(arg0_4.mindBtn, false)
		arg0_4:emit(NewEducateMainMediator.ON_SELECT_MIND, function()
			arg0_4:SeriesCheck()
		end)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.favorTF, function()
		arg0_4.favorPanel:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.scheduleBtn, function()
		arg0_4:emit(var0_0.GO_SCENE, SCENE.NEW_EDUCATE_SCHEDULE, {
			scheduleDataTable = arg0_4.contextData.scheduleDataTable
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.mapBtn, function()
		if not arg0_4.contextData.char:IsUnlock("out") then
			return
		end

		arg0_4:emit(var0_0.GO_SCENE, SCENE.NEW_EDUCATE_MAP)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.endingBtn, function()
		arg0_4:OnEndingClick()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.resetBtn, function()
		arg0_4:OnClickResetBtn()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.topicBtn, function()
		seriesAsync({
			function(arg0_14)
				if not arg0_4.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.TOPIC) then
					arg0_4:emit(NewEducateMainMediator.ON_REQ_TOPICS, arg0_14)
				else
					arg0_14()
				end
			end
		}, function()
			local var0_15 = arg0_4.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.TOPIC):GetTopics()

			if #var0_15 > 0 then
				setActive(arg0_4.topicBtn, false)
				arg0_4:emit(NewEducateMainMediator.ON_SELECT_TOPIC, var0_15[1])
			end
		end)
	end, SFX_PANEL)
	arg0_4:UpdatePaintingUI()
	arg0_4:UpdateFavorInfo()
	arg0_4:UpdateUnlockUI()

	arg0_4.contextData.scheduleDataTable = arg0_4.contextData.scheduleDataTable or {}

	seriesAsync({
		function(arg0_16)
			arg0_4:CheckNewChar(arg0_16)
		end
	}, function()
		if arg0_4.contextData.scheduleDataTable.OnScheduleDone then
			local var0_17 = arg0_4.contextData.scheduleDataTable.OnScheduleDone

			arg0_4.contextData.scheduleDataTable.OnScheduleDone = nil

			if #var0_17.drops == 0 then
				existCall(var0_17.callback)
			else
				arg0_4:emit(NewEducateBaseUI.ON_DROP, {
					items = var0_17.drops,
					removeFunc = var0_17.callback
				})
			end
		else
			arg0_4:SeriesCheck()
		end
	end)

	arg0_4.newRoundDrops = {}
end

function var0_0._loadSubViews(arg0_18)
	arg0_18.topPanel:Load()
	arg0_18.infoPanel:Load()
end

function var0_0.SeriesCheck(arg0_19)
	local var0_19 = {}

	table.insert(var0_19, function(arg0_20)
		arg0_19:CheckFavorUpgrade(arg0_20)
	end)
	seriesAsync(var0_19, function()
		arg0_19:CheckFSM()
	end)
end

function var0_0.UpdatePaintingUI(arg0_22)
	local var0_22 = arg0_22.contextData.char:GetRoundData():getConfig("main_background")

	setImageSprite(arg0_22.bgTF, LoadSprite("bg/" .. var0_22), false)

	arg0_22.paintingName = arg0_22.contextData.char:GetPaintingName()

	setPaintingPrefab(arg0_22.paintTF, arg0_22.paintingName, "yangcheng")

	arg0_22.wordList, arg0_22.faceList = arg0_22.contextData.char:GetMainDialogueInfo()
end

function var0_0.HideDialogueUI(arg0_23)
	arg0_23.isShowInfoPanel = arg0_23.infoPanel:isShowing() and arg0_23.infoPanel:IsShowPanel()

	arg0_23.infoPanel:ExecuteAction("HidePanel")
	arg0_23.topPanel:ExecuteAction("PlayHide")
	arg0_23.mainAnim:Play("anim_educate_mainui_icon_hide")
end

function var0_0.ShowDialogueUI(arg0_24)
	if arg0_24.isShowInfoPanel then
		arg0_24.infoPanel:ExecuteAction("ShowPanel")
	end

	arg0_24.topPanel:ExecuteAction("PlayShow")
	arg0_24.mainAnim:Play("anim_educate_mainui_icon_show")
end

function var0_0.UpdatePaintingFace(arg0_25, arg1_25)
	if arg0_25:findTF("fitter", arg0_25.paintTF).childCount == 0 then
		return
	end

	local var0_25 = arg0_25:findTF("fitter", arg0_25.paintTF):GetChild(0):Find("face")

	if arg1_25 == 0 then
		if var0_25 then
			setActive(var0_25, false)
		end

		arg0_25:ShowDialogueUI()

		return
	end

	local var1_25 = pg.child2_node[arg1_25]

	if var1_25.type == NewEducateNodePanel.NODE_TYPE.MAIN_TEXT then
		local var2_25 = var1_25.text
		local var3_25 = pg.child2_word[var2_25].main_character_face

		if var3_25 == 0 then
			if var0_25 then
				setActive(var0_25, false)
			end
		else
			local var4_25 = GetSpriteFromAtlas("paintingface/" .. arg0_25.paintingName, var3_25)

			if var0_25 and var4_25 then
				setImageSprite(var0_25, var4_25)
				setActive(var0_25, true)
			end
		end
	end
end

function var0_0.ShowDialogue(arg0_26)
	if LeanTween.isTweening(arg0_26.dialogueTF) then
		return
	end

	local var0_26 = math.random(#arg0_26.wordList)
	local var1_26 = pg.child2_word[arg0_26.wordList[var0_26]].word
	local var2_26 = string.gsub(var1_26, "$1", arg0_26.contextData.char:GetCallName())

	setText(arg0_26.dialogueContent, var2_26)

	local var3_26 = GetSpriteFromAtlas("paintingface/" .. arg0_26.paintingName, arg0_26.faceList[var0_26])
	local var4_26 = arg0_26:findTF("fitter", arg0_26.paintTF):GetChild(0):Find("face")

	if var4_26 and var3_26 then
		setImageSprite(var4_26, var3_26)
		setActive(var4_26, true)
	end

	arg0_26.dialogueTF.localScale = Vector3.zero

	setActive(arg0_26.dialogueTF, true)
	LeanTween.scale(arg0_26.dialogueTF, Vector3.one, 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(arg0_26.dialogueTF, Vector3.zero, 0.3):setEase(LeanTweenType.easeInBack):setDelay(3):setOnComplete(System.Action(function()
			setActive(arg0_26.dialogueTF, false)

			if var4_26 then
				setActive(var4_26, false)
			end
		end))
	end))
end

function var0_0.UpdataTopicAndMind(arg0_29)
	local var0_29 = arg0_29.contextData.char:GetFSM()
	local var1_29 = var0_29:GetState(NewEducateFSM.STYSTEM.TOPIC)

	if var1_29 and var1_29:IsFinish() then
		setActive(arg0_29.topicBtn, false)
	else
		setActive(arg0_29.topicBtn, true)
	end

	local var2_29 = arg0_29.contextData.char:GetRoundData():getConfig("main_event_chat_node_id")

	if var2_29 ~= "" and #var2_29 > 0 then
		local var3_29 = var0_29:GetState(NewEducateFSM.STYSTEM.MIND)

		setActive(arg0_29.mindBtn, not var3_29)
	else
		setActive(arg0_29.mindBtn, false)
	end
end

function var0_0.CheckNewChar(arg0_30, arg1_30)
	if arg0_30.contextData.char:GetCallName() == "" then
		setActive(arg0_30._tf, false)

		local var0_30 = arg0_30.contextData.char:getConfig("special_memory")
		local var1_30 = {}

		table.insert(var1_30, function(arg0_31)
			NewEducateHelper.PlaySpecialStoryList(var0_30.pre_name, arg0_31, true)
		end)
		table.insert(var1_30, function(arg0_32)
			arg0_30:emit(var0_0.GO_SUBLAYER, Context.New({
				mediator = NewEducateSetCallediator,
				viewComponent = NewEducateSetCallLayer,
				data = {
					callback = arg0_32
				}
			}))
		end)
		table.insert(var1_30, function(arg0_33)
			NewEducateHelper.PlaySpecialStoryList(var0_30.after_name, arg0_33, true)
		end)

		arg0_30.lockBackPressed = true

		seriesAsync(var1_30, function()
			setActive(arg0_30._tf, true)
			arg0_30:_loadSubViews()
			arg1_30()

			arg0_30.lockBackPressed = false
		end)
	else
		arg0_30:_loadSubViews()
		arg1_30()
	end
end

function var0_0.UpdateFavorInfo(arg0_35)
	setText(arg0_35.favorTF:Find("Text"), "Lv" .. arg0_35.contextData.char:GetFavorInfo().lv)
end

function var0_0.CheckFavorUpgrade(arg0_36, arg1_36)
	if arg0_36.contextData.char:CheckFavor() then
		arg0_36:emit(NewEducateMainMediator.ON_UPGRADE_FAVOR, arg1_36)
	else
		existCall(arg1_36)
	end
end

function var0_0.CheckFSM(arg0_37)
	local var0_37 = arg0_37.contextData.char:GetFSM():CheckStystem()

	arg0_37:UpdateStateUI(var0_37)
	switch(var0_37, {
		[NewEducateFSM.STYSTEM.EVENT] = function()
			arg0_37:EventHandler()
		end,
		[NewEducateFSM.STYSTEM.TALENT] = function()
			arg0_37:TalentHandler()
		end,
		[NewEducateFSM.STYSTEM.TOPIC] = function()
			arg0_37:TopicHandler()
		end,
		[NewEducateFSM.STYSTEM.MAP] = function()
			arg0_37:MapHandler()
		end,
		[NewEducateFSM.STYSTEM.PLAN] = function()
			arg0_37:PlanHandler()
		end,
		[NewEducateFSM.STYSTEM.ASSESS] = function()
			arg0_37:AssessHandler()
		end,
		[NewEducateFSM.STYSTEM.PHASE] = function()
			arg0_37:StageHandler()
		end,
		[NewEducateFSM.STYSTEM.ENDING] = function()
			arg0_37:EndingHandler()
		end,
		[NewEducateFSM.STYSTEM.MIND] = function()
			arg0_37:MindHandler()
		end
	}, function()
		assert(false, "不合法FSM状态")
	end)
end

function var0_0.OnReset(arg0_48)
	arg0_48:HideDialogueUI()
	arg0_48.infoPanel:ExecuteAction("Hide")

	arg0_48.contextData.char = getProxy(NewEducateProxy):GetCurChar()

	setActive(arg0_48.topicBtn, false)
	setActive(arg0_48.mindBtn, false)
	arg0_48.infoPanel:ExecuteAction("Flush")
	arg0_48.topPanel:ExecuteAction("Flush", NewEducateFSM.STYSTEM.INIT)
	arg0_48:UpdatePaintingUI()
	arg0_48:UpdateUnlockUI()
	seriesAsync({
		function(arg0_49)
			arg0_48:CheckNewChar(arg0_49)
		end
	}, function()
		arg0_48:ShowDialogueUI()
		arg0_48.infoPanel:ExecuteAction("Show")
		arg0_48:SeriesCheck()
	end)
end

function var0_0.UpdateStateUI(arg0_51, arg1_51)
	arg0_51:UpdateBtns(arg1_51)
	arg0_51.topPanel:ExecuteAction("FlushProgress", arg1_51)
end

function var0_0.UpdateBtns(arg0_52, arg1_52)
	setActive(arg0_52.endingBtn, false)
	setActive(arg0_52.resetBtn, false)
	setActive(arg0_52.normalBtns, arg1_52 ~= NewEducateFSM.STYSTEM.ENDING)

	local var0_52 = arg0_52.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.MAP)

	setActive(arg0_52.mapBtn:Find("tip"), var0_52 and var0_52:IsSpecial())
end

function var0_0.AddNewRoundDrops(arg0_53, arg1_53)
	arg0_53.newRoundDrops = arg1_53
end

function var0_0.ContinuePlayNode(arg0_54)
	seriesAsync({
		function(arg0_55)
			arg0_54:emit(var0_0.ON_BOX, {
				hideClose = true,
				content = i18n("child2_replay_tip"),
				noText = i18n("child2_replay_clear"),
				yesText = i18n("child2_replay_continue"),
				onYes = arg0_55,
				onNo = function()
					arg0_54:emit(NewEducateMainMediator.ON_CLEAR_NODE_CHAIN)
				end
			})
		end
	}, function()
		arg0_54:OnNodeStart(arg0_54.contextData.char:GetFSM():GetCurNode())
	end)
end

function var0_0.EventHandler(arg0_58)
	if arg0_58.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_58:ContinuePlayNode()

		return
	end

	seriesAsync({
		function(arg0_59)
			arg0_58.roundTipPanel:ExecuteAction("Show", arg0_59)
		end,
		function(arg0_60)
			if #arg0_58.newRoundDrops > 0 then
				arg0_58:emit(NewEducateBaseUI.ON_DROP, {
					items = arg0_58.newRoundDrops,
					removeFunc = arg0_60
				})
			else
				arg0_60()
			end
		end
	}, function()
		arg0_58.newRoundDrops = {}

		arg0_58:emit(NewEducateMainMediator.ON_TRIGGER_MAIN_EVENT)
	end)
end

function var0_0.TalentHandler(arg0_62)
	local var0_62 = arg0_62.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.TALENT)

	seriesAsync({
		function(arg0_63)
			if not var0_62 then
				arg0_62:emit(NewEducateMainMediator.ON_REQ_TALENTS, arg0_63)
			else
				arg0_63()
			end
		end,
		function(arg0_64)
			if arg0_62.contextData.char:GetRoundData():IsTalentRound() then
				arg0_62:emit(var0_0.GO_SUBLAYER, Context.New({
					mediator = NewEducateTalentMediator,
					viewComponent = NewEducateTalentLayer,
					data = {
						onExit = arg0_64
					}
				}))
			else
				arg0_64()
			end
		end
	}, function()
		arg0_62:SeriesCheck()
	end)
end

function var0_0.ReqParallelData(arg0_66)
	if not arg0_66.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.MAP) then
		arg0_66:emit(NewEducateMainMediator.ON_REQ_MAP)
	else
		arg0_66:UpdataTopicAndMind()
		NewEducateGuideSequence.CheckGuide(arg0_66.__cname)
	end
end

function var0_0.TopicHandler(arg0_67)
	if arg0_67.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_67:ContinuePlayNode()

		return
	end

	arg0_67:ReqParallelData()
end

function var0_0.MindHandler(arg0_68)
	if arg0_68.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_68:ContinuePlayNode()

		return
	end

	arg0_68:ReqParallelData()
end

function var0_0.MapHandler(arg0_69)
	if arg0_69.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_69:emit(var0_0.ON_BOX, {
			hideClose = true,
			content = i18n("child2_replay_tip"),
			noText = i18n("child2_replay_clear"),
			yesText = i18n("child2_replay_continue"),
			onYes = function()
				arg0_69:emit(var0_0.GO_SCENE, SCENE.NEW_EDUCATE_MAP)
			end,
			onNo = function()
				arg0_69:emit(NewEducateMainMediator.ON_CLEAR_NODE_CHAIN)
			end
		})

		return
	end

	arg0_69:ReqParallelData()
end

function var0_0.PlanHandler(arg0_72)
	if arg0_72.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_72:ContinuePlayNode()

		return
	end

	arg0_72:emit(NewEducateMainMediator.ON_NEXT_PLAN, true)
end

function var0_0.AssessHandler(arg0_73)
	if arg0_73.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_73:ContinuePlayNode()

		return
	end

	local var0_73 = arg0_73.contextData.char:GetAssessPreStory()
	local var1_73 = arg0_73.contextData.char:GetAssessRankIdx()

	seriesAsync({
		function(arg0_74)
			if var0_73 and var0_73 ~= "" then
				NewEducateHelper.PlaySpecialStory(var0_73, arg0_74, true)
			else
				arg0_74()
			end
		end,
		function(arg0_75)
			if var1_73 ~= 0 then
				arg0_73.assessPanel:ExecuteAction("Show", arg0_75)
			else
				arg0_73:emit(NewEducateMainMediator.ON_SET_ASSESS_RANK, var1_73, arg0_75)
			end
		end
	}, function(arg0_76)
		arg0_73:SeriesCheck()
	end)
end

function var0_0.StageHandler(arg0_77)
	if arg0_77.assessPanel:isShowing() then
		arg0_77.assessPanel:ExecuteAction("Hide")
	end

	if arg0_77.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_77:ContinuePlayNode()

		return
	end

	arg0_77:emit(NewEducateMainMediator.ON_STAGE_CHANGE)
end

function var0_0.EndingHandler(arg0_78)
	if arg0_78.assessPanel:isShowing() then
		arg0_78.assessPanel:ExecuteAction("Hide")
	end

	local var0_78 = arg0_78.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.ENDING)
	local var1_78 = var0_78 and var0_78:IsFinish()

	setActive(arg0_78.resetBtn, var1_78)
	setActive(arg0_78.endingBtn, not var1_78)

	if var1_78 then
		local var2_78 = arg0_78.contextData.char:getConfig("special_memory").after_ending

		if not pg.NewStoryMgr.GetInstance():IsPlayed(var2_78) then
			NewEducateHelper.PlaySpecialStory(var2_78, function()
				return
			end)
		end
	else
		local var3_78 = arg0_78.contextData.char:getConfig("special_memory").pre_ending

		if var3_78 ~= "" then
			NewEducateHelper.PlaySpecialStory(var3_78, function()
				return
			end)
		end
	end
end

function var0_0.OnEndingClick(arg0_81)
	local var0_81 = arg0_81.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.ENDING)

	seriesAsync({
		function(arg0_82)
			if not var0_81 then
				arg0_81:emit(NewEducateMainMediator.ON_REQ_ENDINGS, arg0_82)
			else
				arg0_82()
			end
		end
	}, function()
		local var0_83 = arg0_81.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.ENDING):GetEndings()

		if #var0_83 == 1 then
			arg0_81:emit(NewEducateMainMediator.ON_SELECT_ENDING, var0_83[1])
		else
			arg0_81:emit(var0_0.GO_SUBLAYER, Context.New({
				mediator = NewEducateSelEndingMediator,
				viewComponent = NewEducateSelEndingLayer,
				data = {
					onExit = function()
						arg0_81:SeriesCheck()
					end
				}
			}))
		end
	end)
end

function var0_0.OnSelDone(arg0_85, arg1_85)
	local var0_85 = pg.child2_ending[arg1_85].performance

	NewEducateHelper.PlaySpecialStory(var0_85, function()
		arg0_85:SeriesCheck()
	end, true)
end

function var0_0.OnClickResetBtn(arg0_87)
	seriesAsync({
		function(arg0_88)
			arg0_87:emit(var0_0.ON_BOX, {
				content = i18n("child2_reset_sure_tip"),
				onYes = arg0_88
			})
		end,
		function(arg0_89)
			arg0_87:emit(NewEducateMainMediator.ON_RESET, arg0_89)
		end
	}, function()
		arg0_87:OnReset()
	end)
end

function var0_0.OnResUpdate(arg0_91)
	arg0_91.topPanel:ExecuteAction("FlushRes")
	arg0_91:CheckFavorUpgrade()
end

function var0_0.OnAttrUpdate(arg0_92)
	arg0_92.infoPanel:ExecuteAction("FlushAttrs")
	arg0_92.topPanel:ExecuteAction("FlushProgress")
end

function var0_0.OnPersonalityUpdate(arg0_93, arg1_93, arg2_93)
	arg0_93.personalityTipPanel:ExecuteAction("FlushPersonality", arg1_93, arg2_93)

	if arg0_93.contextData.char:GetPersonalityTag() ~= arg2_93 then
		arg0_93:UpdatePaintingUI()
		arg0_93:PlayBGM()
	end
end

function var0_0.OnTalentUpdate(arg0_94)
	arg0_94.infoPanel:ExecuteAction("FlushTalents")
end

function var0_0.OnStatusUpdate(arg0_95)
	arg0_95.infoPanel:ExecuteAction("FlushStatus")
end

function var0_0.UpdateUnlockUI(arg0_96)
	setActive(arg0_96.mapBtn:Find("lock"), not arg0_96.contextData.char:IsUnlock("out"))
end

function var0_0.OnNextRound(arg0_97)
	arg0_97.topPanel:ExecuteAction("Flush")
	arg0_97.infoPanel:ExecuteAction("Flush")
	arg0_97:UpdatePaintingUI()
	arg0_97:UpdateUnlockUI()
end

function var0_0.OnNodeStart(arg0_98, arg1_98)
	if arg1_98 == 0 then
		return
	end

	assert(pg.child2_node[arg1_98], "child2_node缺少id:" .. arg1_98)
	arg0_98.nodePanel:ExecuteAction("StartNode", arg1_98)

	if pg.child2_node[arg1_98].type == NewEducateNodePanel.NODE_TYPE.MAIN_TEXT then
		arg0_98:HideDialogueUI()
		arg0_98:UpdatePaintingFace(arg1_98)
	end
end

function var0_0.OnNextNode(arg0_99, arg1_99)
	arg0_99.nodePanel:ExecuteAction("ProceedNode", arg1_99.node, arg1_99.drop, arg1_99.noNextCb)

	if arg0_99.contextData.char:GetFSM():GetStystemNo() ~= NewEducateFSM.STYSTEM.PLAN then
		arg0_99:UpdatePaintingFace(arg1_99.node)
	end
end

function var0_0.UpdateCallName(arg0_100)
	arg0_100.nodePanel:ExecuteAction("UpdateCallName")
end

function var0_0.onBackPressed(arg0_101)
	if arg0_101.lockBackPressed then
		return
	end

	if arg0_101.assessPanel:isShowing() then
		return
	end

	if arg0_101.nodePanel:isShowing() then
		return
	end

	if arg0_101.roundTipPanel:isShowing() then
		return
	end

	arg0_101.super.onBackPressed(arg0_101)
end

function var0_0.willExit(arg0_102)
	arg0_102.contextData.isMainEnter = nil

	if arg0_102.topPanel then
		arg0_102.topPanel:Destroy()

		arg0_102.topPanel = nil
	end

	if arg0_102.infoPanel then
		arg0_102.infoPanel:Destroy()

		arg0_102.infoPanel = nil
	end

	if arg0_102.roundTipPanel then
		arg0_102.roundTipPanel:Destroy()

		arg0_102.roundTipPanel = nil
	end

	if arg0_102.assessPanel then
		arg0_102.assessPanel:Destroy()

		arg0_102.assessPanel = nil
	end

	if arg0_102.favorPanel then
		arg0_102.favorPanel:Destroy()

		arg0_102.favorPanel = nil
	end

	if arg0_102.personalityTipPanel then
		arg0_102.personalityTipPanel:Destroy()

		arg0_102.personalityTipPanel = nil
	end

	if arg0_102.nodePanel then
		arg0_102.nodePanel:Destroy()

		arg0_102.nodePanel = nil
	end

	if LeanTween.isTweening(arg0_102.dialogueTF) then
		LeanTween.cancel(arg0_102.dialogueTF)
	end
end

return var0_0
