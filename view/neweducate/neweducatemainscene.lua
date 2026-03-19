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
	arg0_3.resetInEndlessBtn = arg0_3.adaptTF:Find("reset_endless")
	arg0_3.resetBtns = arg0_3.adaptTF:Find("reset")
	arg0_3.resetBtn = arg0_3.resetBtns:Find("reset")
	arg0_3.endlessBtn = arg0_3.resetBtns:Find("endless")
	arg0_3.topPanel = NewEducateTopPanel.New(arg0_3.adaptTF, arg0_3.event, setmetatable({
		hideBlurBg = true
	}, {
		__index = arg0_3.contextData
	}))

	arg0_3.topPanel:RegisterView(arg0_3)

	arg0_3.infoPanel = NewEducateInfoPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)

	arg0_3.infoPanel:RegisterView(arg0_3)

	arg0_3.roundTipPanel = NewEducateRoundTipPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)

	arg0_3.roundTipPanel:RegisterView(arg0_3)

	arg0_3.assessPanel = NewEducateAssessPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)

	arg0_3.assessPanel:RegisterView(arg0_3)

	arg0_3.favorPanel = NewEducateFavorPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)

	arg0_3.favorPanel:RegisterView(arg0_3)

	arg0_3.personalityTipPanel = NewEducatePersonalityTipPanel.New(arg0_3.adaptTF, arg0_3.event, arg0_3.contextData)

	arg0_3.personalityTipPanel:RegisterView(arg0_3)

	arg0_3.nodePanel = NewEducateNodePanel.New(arg0_3.adaptTF, arg0_3.event, setmetatable({
		view = arg0_3
	}, {
		__index = arg0_3.contextData
	}))

	arg0_3.nodePanel:RegisterView(arg0_3)
end

function var0_0.didEnter(arg0_4)
	local var0_4 = "neweducateicon/" .. arg0_4.contextData.char:getConfig("child2_data_personality_icon")[2]

	LoadImageSpriteAsync(var0_4, arg0_4.mindBtn, true)
	onButton(arg0_4, arg0_4.paintTF:Find("fitter"), function()
		arg0_4:ShowDialogue()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.mindBtn, function()
		if arg0_4.contextData.char:GetFSM():CheckPriorityStystem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

			return
		end

		setActive(arg0_4.mindBtn, false)
		arg0_4:emit(NewEducateMainMediator.ON_SELECT_MIND, function()
			arg0_4:SeriesCheck()
		end)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.favorTF, function()
		if arg0_4.contextData.char:GetFSM():CheckPriorityStystem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

			return
		end

		arg0_4.favorPanel:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.scheduleBtn, function()
		if arg0_4.contextData.char:GetFSM():CheckPriorityStystem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

			return
		end

		arg0_4:emit(var0_0.GO_SCENE, SCENE.NEW_EDUCATE_SCHEDULE, {
			scheduleDataTable = arg0_4.contextData.scheduleDataTable
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.mapBtn, function()
		if arg0_4.contextData.char:GetFSM():CheckPriorityStystem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

			return
		end

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
	onButton(arg0_4, arg0_4.resetInEndlessBtn, function()
		arg0_4:OnClickResetInEndlessBtn()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.endlessBtn, function()
		arg0_4:OnClickEndlessBtn()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.topicBtn, function()
		setActive(arg0_4.topicBtn, false)

		local var0_15 = arg0_4.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.TOPIC):GetTopics()

		if var0_15[1] then
			arg0_4:emit(NewEducateMainMediator.ON_SELECT_TOPIC, var0_15[1])
		end
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
	if arg0_25.paintTF:Find("fitter").childCount == 0 then
		return
	end

	local var0_25 = arg0_25.paintTF:Find("fitter"):GetChild(0):Find("face")

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
	local var4_26 = arg0_26.paintTF:Find("fitter"):GetChild(0):Find("face")

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
	local var1_29 = arg0_29.contextData.char:GetRoundData()
	local var2_29 = var0_29:GetState(NewEducateFSM.SYSTEM.TOPIC)

	if var1_29:IsTemp() or var2_29 and var2_29:IsFinish() then
		setActive(arg0_29.topicBtn, false)
	else
		setActive(arg0_29.topicBtn, true)
	end

	local var3_29 = var1_29:getConfig("main_event_chat_node_id")

	if var3_29 ~= "" and #var3_29 > 0 and not var1_29:IsTemp() then
		local var4_29 = var0_29:GetState(NewEducateFSM.SYSTEM.MIND)

		setActive(arg0_29.mindBtn, not var4_29)
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
	if arg0_37.contextData.char:GetFSM():CheckPriorityStystem() then
		arg0_37:emit(var0_0.ON_PRIORITY_STATE)
	else
		arg0_37:CheckGameFSM()
	end
end

function var0_0.CheckGameFSM(arg0_38)
	local var0_38 = arg0_38.contextData.char:GetFSM()
	local var1_38 = var0_38:CheckStystem()

	warning("CheckGameFSM", var0_38:GetSystemNo() .. "->" .. var1_38)
	arg0_38:UpdateStateUI(var1_38)
	switch(var1_38, {
		[NewEducateFSM.SYSTEM.EVENT] = function()
			arg0_38:EventHandler()
		end,
		[NewEducateFSM.SYSTEM.TALENT] = function()
			arg0_38:TalentHandler()
		end,
		[NewEducateFSM.SYSTEM.TOPIC] = function()
			arg0_38:TopicHandler()
		end,
		[NewEducateFSM.SYSTEM.MAP] = function()
			arg0_38:MapHandler()
		end,
		[NewEducateFSM.SYSTEM.PLAN] = function()
			arg0_38:PlanHandler()
		end,
		[NewEducateFSM.SYSTEM.ASSESS] = function()
			arg0_38:AssessHandler()
		end,
		[NewEducateFSM.SYSTEM.PHASE] = function()
			arg0_38:StageHandler()
		end,
		[NewEducateFSM.SYSTEM.ENDING] = function()
			arg0_38:EndingHandler()
		end,
		[NewEducateFSM.SYSTEM.MIND] = function()
			arg0_38:MindHandler()
		end,
		[NewEducateFSM.SYSTEM.CHOOSE] = function()
			arg0_38:ChooseHandler()
		end,
		[NewEducateFSM.SYSTEM.FAIL] = function()
			arg0_38:FailHandler()
		end
	}, function()
		assert(false, "不合法FSM状态")
	end)
end

function var0_0.OnReset(arg0_51)
	arg0_51:HideDialogueUI()
	arg0_51.infoPanel:ExecuteAction("Hide")

	arg0_51.contextData.char = getProxy(NewEducateProxy):GetCurChar()

	setActive(arg0_51.topicBtn, false)
	setActive(arg0_51.mindBtn, false)
	arg0_51.infoPanel:ExecuteAction("Flush")
	arg0_51.topPanel:ExecuteAction("Flush", NewEducateFSM.SYSTEM.INIT)
	arg0_51:UpdatePaintingUI()
	arg0_51:UpdateUnlockUI()
	seriesAsync({
		function(arg0_52)
			arg0_51:CheckNewChar(arg0_52)
		end
	}, function()
		arg0_51:ShowDialogueUI()
		arg0_51.infoPanel:ExecuteAction("Show")
		arg0_51:SeriesCheck()
	end)
end

function var0_0.UpdateStateUI(arg0_54, arg1_54)
	arg0_54:UpdateBtns(arg1_54)
	arg0_54.topPanel:ExecuteAction("FlushProgress", arg1_54)
end

function var0_0.UpdateBtns(arg0_55, arg1_55)
	setActive(arg0_55.endingBtn, false)
	setActive(arg0_55.resetBtns, false)
	setActive(arg0_55.endlessBtn, false)

	local var0_55 = arg0_55.contextData.char:GetRoundData()

	setActive(arg0_55.resetInEndlessBtn, var0_55:IsEndless())
	setActive(arg0_55.normalBtns, arg1_55 ~= NewEducateFSM.SYSTEM.ENDING and not var0_55:IsEndlessFail())

	local var1_55 = arg0_55.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.MAP)

	setActive(arg0_55.mapBtn:Find("tip"), var1_55 and var1_55:IsSpecial())
end

function var0_0.AddNewRoundDrops(arg0_56, arg1_56)
	arg0_56.newRoundDrops = arg1_56
end

function var0_0.ContinuePlayNode(arg0_57)
	seriesAsync({
		function(arg0_58)
			arg0_57:emit(var0_0.ON_BOX, {
				hideClose = true,
				content = i18n("child2_replay_tip"),
				noText = i18n("child2_replay_clear"),
				yesText = i18n("child2_replay_continue"),
				onYes = arg0_58,
				onNo = function()
					arg0_57:emit(NewEducateMainMediator.ON_CLEAR_NODE_CHAIN)
				end
			})
		end
	}, function()
		arg0_57:OnNodeStart(arg0_57.contextData.char:GetFSM():GetCurNode())
	end)
end

function var0_0.EventHandler(arg0_61)
	if arg0_61.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_61:ContinuePlayNode()

		return
	end

	seriesAsync({
		function(arg0_62)
			arg0_61.roundTipPanel:ExecuteAction("Show", arg0_62)
		end,
		function(arg0_63)
			if #arg0_61.newRoundDrops > 0 then
				arg0_61:emit(NewEducateBaseUI.ON_DROP, {
					items = arg0_61.newRoundDrops,
					removeFunc = arg0_63
				})
			else
				arg0_63()
			end
		end
	}, function()
		arg0_61.newRoundDrops = {}

		arg0_61:emit(NewEducateMainMediator.ON_TRIGGER_MAIN_EVENT)
	end)
end

function var0_0.TalentHandler(arg0_65)
	local var0_65 = arg0_65.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.TALENT)

	seriesAsync({
		function(arg0_66)
			if not var0_65 then
				arg0_65:emit(NewEducateMainMediator.ON_REQ_TALENTS, arg0_66)
			else
				arg0_66()
			end
		end,
		function(arg0_67)
			if arg0_65.contextData.char:GetRoundData():IsTalentRound() then
				arg0_65:emit(var0_0.GO_SUBLAYER, Context.New({
					mediator = NewEducateTalentMediator,
					viewComponent = NewEducateTalentLayer,
					data = {
						onExit = arg0_67
					}
				}))
			else
				arg0_67()
			end
		end
	}, function()
		arg0_65:SeriesCheck()
	end)
end

function var0_0.ReqParallelData(arg0_69)
	local var0_69 = arg0_69.contextData.char:GetFSM()

	seriesAsync({
		function(arg0_70)
			if not arg0_69.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.TOPIC) then
				arg0_69:emit(NewEducateMainMediator.ON_REQ_TOPICS, arg0_70)
			else
				arg0_70()
			end
		end,
		function(arg0_71)
			if not arg0_69.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.MAP) then
				arg0_69:emit(NewEducateMainMediator.ON_REQ_MAP)
			else
				arg0_71()
			end
		end
	}, function()
		arg0_69:UpdataTopicAndMind()
		NewEducateGuideSequence.CheckGuide(arg0_69.__cname)
	end)
end

function var0_0.TopicHandler(arg0_73)
	if arg0_73.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_73:ContinuePlayNode()

		return
	end

	arg0_73:ReqParallelData()
end

function var0_0.MindHandler(arg0_74)
	if arg0_74.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_74:ContinuePlayNode()

		return
	end

	arg0_74:ReqParallelData()
end

function var0_0.MapHandler(arg0_75)
	if arg0_75.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_75:emit(var0_0.ON_BOX, {
			hideClose = true,
			content = i18n("child2_replay_tip"),
			noText = i18n("child2_replay_clear"),
			yesText = i18n("child2_replay_continue"),
			onYes = function()
				arg0_75:emit(var0_0.GO_SCENE, SCENE.NEW_EDUCATE_MAP)
			end,
			onNo = function()
				arg0_75:emit(NewEducateMainMediator.ON_CLEAR_NODE_CHAIN)
			end
		})

		return
	end

	arg0_75:ReqParallelData()
end

function var0_0.PlanHandler(arg0_78)
	if arg0_78.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_78:ContinuePlayNode()

		return
	end

	arg0_78:emit(NewEducateMainMediator.ON_NEXT_PLAN, true)
end

function var0_0.AssessHandler(arg0_79)
	if arg0_79.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_79:ContinuePlayNode()

		return
	end

	local var0_79 = arg0_79.contextData.char:GetAssessPreStory()
	local var1_79 = arg0_79.contextData.char:GetAssessRankIdx()

	seriesAsync({
		function(arg0_80)
			if not (arg0_79.contextData.char:GetFSM():GetSystemNo() == NewEducateFSM.SYSTEM.ASSESS) then
				arg0_79:emit(NewEducateMainMediator.ON_ENTER_ASSESS, arg0_80)
			else
				arg0_80()
			end
		end,
		function(arg0_81)
			if var0_79 and var0_79 ~= "" then
				NewEducateHelper.PlaySpecialStory(var0_79, arg0_81, true)
			else
				arg0_81()
			end
		end,
		function(arg0_82)
			if var1_79 ~= 0 then
				arg0_79.assessPanel:ExecuteAction("Show", arg0_82)
			else
				arg0_79.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.ASSESS):MarkFinish()
				arg0_82()
			end
		end
	}, function(arg0_83)
		arg0_79:SeriesCheck()
	end)
end

function var0_0.StageHandler(arg0_84)
	if arg0_84.assessPanel:isShowing() then
		arg0_84.assessPanel:ExecuteAction("Hide")
	end

	if arg0_84.contextData.char:GetFSM():GetCurNode() ~= 0 then
		arg0_84:ContinuePlayNode()

		return
	end

	arg0_84:emit(NewEducateMainMediator.ON_STAGE_CHANGE)
end

function var0_0.EndingHandler(arg0_85)
	if arg0_85.assessPanel:isShowing() then
		arg0_85.assessPanel:ExecuteAction("Hide")
	end

	local var0_85 = arg0_85.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.ENDING)
	local var1_85 = var0_85 and var0_85:IsFinish()

	setActive(arg0_85.resetBtns, var1_85)
	setActive(arg0_85.resetBtn, var1_85)
	setActive(arg0_85.endlessBtn, var1_85 and arg0_85.contextData.char:GetRoundData():ExistEndless())
	setActive(arg0_85.endingBtn, not var1_85)

	if var1_85 then
		local var2_85 = arg0_85.contextData.char:getConfig("special_memory").after_ending

		if not pg.NewStoryMgr.GetInstance():IsPlayed(var2_85) then
			NewEducateHelper.PlaySpecialStory(var2_85, function()
				if getProxy(EducateProxy):GetSelectInfo().gameCnt == 1 and CultivatingPlantTools.IsPopActivity(arg0_85.contextData.char.id) then
					arg0_85:emit(var0_0.GO_SUBLAYER, Context.New({
						mediator = CultivatingPlantMediator,
						viewComponent = CultivatingPlantScene,
						data = {
							id = arg0_85.contextData.char.id
						}
					}))
				end
			end)
		end
	else
		local var3_85 = arg0_85.contextData.char:getConfig("special_memory").pre_ending

		if var3_85 ~= "" then
			NewEducateHelper.PlaySpecialStory(var3_85, function()
				return
			end)
		end
	end
end

function var0_0.OnEndingClick(arg0_88)
	local var0_88 = arg0_88.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.ENDING)

	seriesAsync({
		function(arg0_89)
			if not var0_88 then
				arg0_88:emit(NewEducateMainMediator.ON_REQ_ENDINGS, arg0_89)
			else
				arg0_89()
			end
		end
	}, function()
		local var0_90 = arg0_88.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.ENDING):GetEndings()

		if #var0_90 == 1 then
			arg0_88:emit(NewEducateMainMediator.ON_SELECT_ENDING, var0_90[1])
		else
			arg0_88:emit(var0_0.GO_SUBLAYER, Context.New({
				mediator = NewEducateSelEndingMediator,
				viewComponent = NewEducateSelEndingLayer,
				data = {
					onExit = function()
						arg0_88:SeriesCheck()
					end
				}
			}))
		end
	end)
end

function var0_0.ChooseHandler(arg0_92)
	seriesAsync({
		function(arg0_93)
			arg0_92:emit(NewEducateMainMediator.ON_REQ_CHOOSE, arg0_93)
		end
	}, function()
		arg0_92:SeriesCheck()
	end)
end

function var0_0.FailHandler(arg0_95)
	if arg0_95.assessPanel:isShowing() then
		arg0_95.assessPanel:ExecuteAction("Hide")
	end

	setActive(arg0_95.resetBtns, true)
	setActive(arg0_95.resetBtn, true)
	setActive(arg0_95.endlessBtn, false)
	setActive(arg0_95.resetInEndlessBtn, false)
end

function var0_0.OnSelDone(arg0_96, arg1_96)
	local var0_96 = pg.child2_ending[arg1_96].performance

	NewEducateHelper.PlaySpecialStory(var0_96, function()
		arg0_96:SeriesCheck()
	end, true)
end

function var0_0.OnClickResetBtn(arg0_98)
	seriesAsync({
		function(arg0_99)
			arg0_98:emit(var0_0.ON_BOX, {
				content = i18n("child2_reset_sure_tip"),
				onYes = arg0_99
			})
		end,
		function(arg0_100)
			arg0_98:emit(NewEducateMainMediator.ON_RESET, arg0_100)
		end
	}, function()
		arg0_98:OnReset()
	end)
end

function var0_0.OnClickResetInEndlessBtn(arg0_102)
	seriesAsync({
		function(arg0_103)
			arg0_102:emit(var0_0.GO_SUBLAYER, Context.New({
				viewComponent = NewEducateMsgBoxLayer,
				mediator = NewEducateMsgBoxMediator,
				data = {
					type = NewEducateMsgBoxLayer.TYPE.RESET,
					onYes = arg0_103
				}
			}))
		end,
		function(arg0_104)
			arg0_102:emit(NewEducateMainMediator.ON_RESET, arg0_104)
		end
	}, function()
		arg0_102:OnReset()
	end)
end

function var0_0.OnClickEndlessBtn(arg0_106)
	seriesAsync({
		function(arg0_107)
			arg0_106:emit(var0_0.ON_BOX, {
				content = i18n("child2_endless_sure_tip"),
				onYes = arg0_107
			})
		end,
		function(arg0_108)
			arg0_106:emit(NewEducateMainMediator.ON_START_ENDLESS, arg0_108)
		end
	}, function()
		arg0_106:CheckFSM()
	end)
end

function var0_0.OnResUpdate(arg0_110)
	arg0_110.topPanel:ExecuteAction("FlushRes")
	arg0_110:CheckFavorUpgrade()
end

function var0_0.OnAttrUpdate(arg0_111)
	arg0_111.infoPanel:ExecuteAction("FlushAttrs")
	arg0_111.topPanel:ExecuteAction("FlushProgress")
end

function var0_0.OnPersonalityUpdate(arg0_112, arg1_112, arg2_112)
	arg0_112.personalityTipPanel:ExecuteAction("FlushPersonality", arg1_112, arg2_112)

	if arg0_112.contextData.char:GetPersonalityTag() ~= arg2_112 then
		arg0_112:UpdatePaintingUI()
		arg0_112:PlayBGM()
	end
end

function var0_0.OnTalentUpdate(arg0_113)
	arg0_113.infoPanel:ExecuteAction("FlushTalents")
end

function var0_0.OnStatusUpdate(arg0_114)
	arg0_114.infoPanel:ExecuteAction("FlushStatus")
end

function var0_0.OnTarotUpdate(arg0_115)
	arg0_115.infoPanel:ExecuteAction("FlushTarot")
end

function var0_0.UpdateUnlockUI(arg0_116)
	setActive(arg0_116.mapBtn:Find("lock"), not arg0_116.contextData.char:IsUnlock("out"))
end

function var0_0.OnNextRound(arg0_117)
	arg0_117.topPanel:ExecuteAction("Flush")
	arg0_117.infoPanel:ExecuteAction("Flush")
	arg0_117:UpdatePaintingUI()
	arg0_117:UpdateUnlockUI()
end

function var0_0.OnNodeStart(arg0_118, arg1_118)
	if arg1_118 == 0 then
		return
	end

	assert(pg.child2_node[arg1_118], "child2_node缺少id:" .. arg1_118)
	arg0_118.nodePanel:ExecuteAction("StartNode", arg1_118)

	if pg.child2_node[arg1_118].type == NewEducateNodePanel.NODE_TYPE.MAIN_TEXT then
		arg0_118:HideDialogueUI()
		arg0_118:UpdatePaintingFace(arg1_118)
	end
end

function var0_0.OnNextNode(arg0_119, arg1_119)
	arg0_119.nodePanel:ExecuteAction("ProceedNode", arg1_119.node, arg1_119.drop, arg1_119.noNextCb)

	if arg0_119.contextData.char:GetFSM():GetSystemNo() ~= NewEducateFSM.SYSTEM.PLAN then
		arg0_119:UpdatePaintingFace(arg1_119.node)
	end
end

function var0_0.UpdateCallName(arg0_120)
	arg0_120.nodePanel:ExecuteAction("UpdateCallName")
end

function var0_0.onBackPressed(arg0_121)
	if arg0_121.lockBackPressed then
		return
	end

	if arg0_121.assessPanel:isShowing() then
		return
	end

	if arg0_121.nodePanel:isShowing() then
		return
	end

	if arg0_121.roundTipPanel:isShowing() then
		return
	end

	arg0_121.super.onBackPressed(arg0_121)
end

function var0_0.willExit(arg0_122)
	arg0_122.contextData.isMainEnter = nil

	if arg0_122.topPanel then
		arg0_122.topPanel:Destroy()

		arg0_122.topPanel = nil
	end

	if arg0_122.infoPanel then
		arg0_122.infoPanel:Destroy()

		arg0_122.infoPanel = nil
	end

	if arg0_122.roundTipPanel then
		arg0_122.roundTipPanel:Destroy()

		arg0_122.roundTipPanel = nil
	end

	if arg0_122.assessPanel then
		arg0_122.assessPanel:Destroy()

		arg0_122.assessPanel = nil
	end

	if arg0_122.favorPanel then
		arg0_122.favorPanel:Destroy()

		arg0_122.favorPanel = nil
	end

	if arg0_122.personalityTipPanel then
		arg0_122.personalityTipPanel:Destroy()

		arg0_122.personalityTipPanel = nil
	end

	if arg0_122.nodePanel then
		arg0_122.nodePanel:Destroy()

		arg0_122.nodePanel = nil
	end

	if LeanTween.isTweening(arg0_122.dialogueTF) then
		LeanTween.cancel(arg0_122.dialogueTF)
	end
end

return var0_0
