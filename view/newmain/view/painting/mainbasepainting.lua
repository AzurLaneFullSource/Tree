local var0_0 = class("MainBasePainting", import("view.base.BaseEventLogic"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.container = arg1_1
	arg0_1.state = var1_0
	var5_0 = pg.AssistantInfo
	arg0_1.wordPosition = arg1_1:Find("live2d")
	arg0_1.cvLoader = MainCVLoader.New()
	arg0_1.longPressEvent = arg1_1:GetComponent("UILongPressTrigger").onLongPressed
	arg0_1.replaceWord = false
	arg0_1._asmrFlag = false
end

function var0_0.IsUnload(arg0_2)
	return arg0_2.state == var4_0
end

function var0_0.GetCenterPos(arg0_3)
	return arg0_3.wordPosition.position
end

function var0_0.IsLoading(arg0_4)
	return arg0_4.state == var2_0
end

function var0_0.IsLoaded(arg0_5)
	return arg0_5.state == var3_0
end

function var0_0.SetOnceLoadedCall(arg0_6, arg1_6)
	arg0_6.loadedCallback = arg1_6
end

function var0_0.Load(arg0_7, arg1_7)
	arg0_7.isPuase = false
	arg0_7.isExited = false
	arg0_7.state = var2_0
	arg0_7.ship = arg1_7
	arg0_7.paintingName = arg1_7:getPainting()

	arg0_7:OnLoad(function()
		arg0_7.state = var3_0

		if arg0_7.triggerWhenLoaded then
			arg0_7:TriggerEventAtFirstTime()
		else
			arg0_7:TriggerNextEventAuto()
		end

		arg0_7:InitClickEvent()
	end)
end

function var0_0.Unload(arg0_9)
	arg0_9.state = var4_0

	removeOnButton(arg0_9.container)
	arg0_9.longPressEvent:RemoveAllListeners()
	arg0_9:StopChatAnimtion()
	arg0_9.cvLoader:Stop()
	arg0_9:RemoveTimer()
	arg0_9:OnUnload()

	arg0_9.paintingName = nil

	LeanTween.cancel(arg0_9.container.gameObject)
end

function var0_0.UnloadOnlyPainting(arg0_10)
	arg0_10.state = var4_0

	removeOnButton(arg0_10.container)
	arg0_10.longPressEvent:RemoveAllListeners()
	arg0_10:RemoveTimer()
	arg0_10:OnUnload()

	arg0_10.paintingName = nil
end

function var0_0.InitClickEvent(arg0_11)
	onButton(arg0_11, arg0_11.container, function()
		arg0_11:OnClick()
		arg0_11:TriggerPersonalTask(arg0_11.ship.groupId)
	end)
	arg0_11.longPressEvent:RemoveAllListeners()
	arg0_11.longPressEvent:AddListener(function()
		if arg0_11._asmrFlag then
			return
		end

		if getProxy(ContextProxy):getCurrentContext().viewComponent.__cname == "NewMainScene" then
			arg0_11:OnLongPress()
		end
	end)
end

function var0_0.TriggerPersonalTask(arg0_14, arg1_14)
	if arg0_14.isFoldState then
		return
	end

	arg0_14:TriggerInterActionTask()

	local var0_14 = getProxy(TaskProxy)

	for iter0_14, iter1_14 in ipairs(pg.task_data_trigger.all) do
		local var1_14 = pg.task_data_trigger[iter1_14]

		if var1_14.group_id == arg1_14 then
			local var2_14 = var1_14.task_id

			if not var0_14:getFinishTaskById(var2_14) then
				arg0_14:CheckStoryDownload(var2_14, function()
					pg.m02:sendNotification(GAME.TRIGGER_TASK, var2_14)
				end)

				break
			end
		end
	end
end

function var0_0.TriggerInterActionTask(arg0_16)
	local var0_16 = getProxy(TaskProxy):GetFlagShipInterActionTaskList()

	if var0_16 and #var0_16 > 0 then
		for iter0_16, iter1_16 in ipairs(var0_16) do
			pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
				taskId = iter1_16.id
			})
		end
	end
end

function var0_0.CheckStoryDownload(arg0_17, arg1_17, arg2_17)
	local var0_17 = {}
	local var1_17 = arg1_17

	while true do
		local var2_17 = pg.task_data_template[var1_17]

		if var2_17.story_id ~= "" then
			table.insert(var0_17, var2_17.story_id)
		end

		if var2_17.next_task == "" or var2_17.next_task == "0" then
			break
		end

		var1_17 = var1_17 + 1
	end

	local var3_17 = pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var0_17)
	local var4_17 = _.map(var3_17, function(arg0_18)
		return "painting/" .. arg0_18
	end)

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var4_17,
		finishFunc = arg2_17
	})
end

function var0_0.TriggerEventAtFirstTime(arg0_19)
	if not arg0_19:IsLoaded() then
		arg0_19.triggerWhenLoaded = true

		return
	end

	arg0_19.triggerWhenLoaded = false

	arg0_19:OnFirstTimeTriggerEvent()
end

function var0_0.OnFirstTimeTriggerEvent(arg0_20)
	arg0_20._loginAction = getProxy(PlayerProxy):getFlag("login")
	arg0_20._battleAction = getProxy(PlayerProxy):getFlag("battle")

	getProxy(PlayerProxy):setFlag("login", false)
	getProxy(PlayerProxy):setFlag("battle", false)

	local function var0_20(arg0_21)
		arg0_20:PrepareTriggerAction(arg0_21)
	end

	if arg0_20._loginAction then
		arg0_20._loginAction = false

		var0_20("event_login")
	elseif arg0_20._battleAction then
		arg0_20._battleAction = false

		var0_20("home")
	else
		arg0_20:TriggerNextEventAuto()
	end
end

function var0_0.PrepareTriggerAction(arg0_22, arg1_22)
	arg0_22:TryToTriggerEvent(arg1_22)
end

function var0_0.TryToTriggerEvent(arg0_23, arg1_23)
	arg0_23:_TriggerEvent(arg1_23)
end

function var0_0._TriggerEvent(arg0_24, arg1_24)
	local var0_24 = pg.AssistantInfo.GetAssistantEvents(arg1_24)

	if var0_24.dialog ~= "" then
		arg0_24:DisplayWord(var0_24.dialog)
	else
		arg0_24:TriggerNextEventAuto()
	end
end

function var0_0.SetShift(arg0_25, arg1_25)
	arg0_25._shift = arg1_25
end

function var0_0.TriggerEvent(arg0_26, arg1_26)
	if arg0_26.isDragAndZoomState then
		return
	end

	if arg0_26.chatting then
		return
	end

	arg0_26:RemoveTimer()
	arg0_26:PrepareTriggerAction(arg1_26)
	arg0_26:OnTriggerEvent()
end

function var0_0.TriggerNextEventAuto(arg0_27)
	if arg0_27.isPuase or arg0_27.isExited and arg0_27._asmrFlag then
		return
	end

	arg0_27:OnEndChatting()
	arg0_27:RemoveTimer()

	arg0_27.timer = Timer.New(function()
		arg0_27:OnTimerTriggerEvent()
	end, 30, 1, true)

	arg0_27.timer:Start()
end

function var0_0.OnTimerTriggerEvent(arg0_29)
	if arg0_29:OnEnableTimerEvent() then
		local var0_29 = arg0_29:CollectIdleEvents(arg0_29.lastChatEvent)

		arg0_29.lastChatEvent = var0_29[math.ceil(math.random(#var0_29))]

		arg0_29:PrepareTriggerAction(arg0_29.lastChatEvent)
		arg0_29:OnTriggerEventAuto()
		arg0_29:RemoveTimer()
	end
end

function var0_0.OnEnableTimerEvent(arg0_30)
	return true
end

function var0_0.OnStartChatting(arg0_31)
	arg0_31.chatting = true
end

function var0_0.OnEndChatting(arg0_32)
	arg0_32.chatting = false
end

function var0_0.GetWordAndCv(arg0_33, arg1_33, arg2_33)
	local var0_33, var1_33, var2_33, var3_33, var4_33, var5_33 = ShipWordHelper.GetCvDataForShip(arg0_33.ship, arg2_33)

	return var0_33, var1_33, var2_33, var3_33, var4_33, var5_33
end

function var0_0.DisplayWord(arg0_34, arg1_34)
	arg0_34:OnStartChatting()

	local var0_34, var1_34, var2_34, var3_34, var4_34, var5_34 = arg0_34:GetWordAndCv(arg0_34.ship, arg1_34)

	if not var2_34 or var2_34 == nil or var2_34 == "" or var2_34 == "nil" then
		arg0_34:OnEndChatting()
		arg0_34:OnDisplayWordEnd()

		return
	end

	arg0_34:OnDisplayWorld(arg1_34)

	if arg0_34._asmrFlag then
		arg0_34:emit(MainAsmrChatView.SET_CONTENT, arg1_34, var2_34)
	else
		arg0_34:emit(MainWordView.SET_CONTENT, arg1_34, var2_34)
	end

	arg0_34:PlayCvAndAnimation(var4_34, var3_34, var1_34)
end

function var0_0.PlayCvAndAnimation(arg0_35, arg1_35, arg2_35, arg3_35)
	if getProxy(ContextProxy):getContextByMediator(NewShipMediator) then
		arg0_35:OnEndChatting()

		return
	end

	local var0_35 = -1

	seriesAsync({
		function(arg0_36)
			if not arg3_35 or not not pg.NewStoryMgr.GetInstance():IsRunning() then
				arg0_36()

				return
			end

			arg0_35:PlayCV(arg1_35, arg2_35, arg3_35, function(arg0_37)
				var0_35 = arg0_37

				arg0_36()
			end)
		end,
		function(arg0_38)
			arg0_35:StartChatAnimtion(var0_35, arg0_38)
		end
	}, function()
		arg0_35:OnDisplayWordEnd()
	end)
end

function var0_0.OnDisplayWordEnd(arg0_40)
	arg0_40:TriggerNextEventAuto()
end

function var0_0.PlayCV(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	local var0_41 = ShipWordHelper.RawGetCVKey(arg0_41.ship:getSkinId())
	local var1_41 = pg.CriMgr.GetCVBankName(var0_41)

	arg0_41.cvLoader:Load(var1_41, arg3_41, 0, arg4_41)
end

function var0_0.preloadCv(arg0_42, arg1_42)
	local var0_42 = ShipWordHelper.RawGetCVKey(arg0_42.ship:getSkinId())
	local var1_42 = pg.CriMgr.GetCVBankName(var0_42)

	arg0_42.cvLoader:preloadCv(var1_42, arg1_42)
end

function var0_0.OnAsmrTurnning(arg0_43, arg1_43)
	arg0_43._asmrFlag = arg1_43
end

function var0_0.setReplaceWord(arg0_44, arg1_44)
	arg0_44.replaceWord = arg1_44
end

function var0_0.getReplaceWord(arg0_45)
	return arg0_45.replaceWord
end

function var0_0.StartChatAnimtion(arg0_46, arg1_46, arg2_46)
	local var0_46 = 0.3
	local var1_46 = arg1_46 > 0 and arg1_46 or 3

	if arg0_46._asmrFlag then
		arg0_46:emit(MainAsmrChatView.START_CHAT, var0_46, var1_46)
	else
		arg0_46:emit(MainWordView.START_ANIMATION, var0_46, var1_46)
	end

	arg0_46:AddCharTimer(function()
		if arg0_46:IsUnload() then
			return
		end

		arg2_46()
	end, var0_46 * 3 + var1_46)
end

function var0_0.AddCharTimer(arg0_48, arg1_48, arg2_48)
	arg0_48:RemoveChatTimer()

	arg0_48.chatTimer = Timer.New(arg1_48, arg2_48, 1)

	arg0_48.chatTimer:Start()
end

function var0_0.RemoveChatTimer(arg0_49)
	if arg0_49.chatTimer then
		arg0_49.chatTimer:Stop()

		arg0_49.chatTimer = nil
	end
end

function var0_0.StopChatAnimtion(arg0_50)
	if not arg0_50._asmrFlag then
		arg0_50:emit(MainWordView.STOP_ANIMATION)
	end

	arg0_50:OnEndChatting()
end

function var0_0.OnStopVoice(arg0_51)
	arg0_51.cvLoader:Stop()
end

function var0_0.CollectIdleEvents(arg0_52, arg1_52)
	local var0_52 = {}

	if getProxy(EventProxy):hasFinishState() and arg1_52 ~= "event_complete" then
		table.insert(var0_52, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1_52 ~= "mission_complete" then
			table.insert(var0_52, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1_52 ~= "mail" then
			table.insert(var0_52, "mail")
		end

		if #var0_52 == 0 then
			var0_52 = var5_0.GetShipMainEvents(arg0_52.ship:getSkinId(), arg0_52.ship:getCVIntimacy())

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1_52 ~= "mission" then
				table.insert(var0_52, "mission")
			end
		end
	end

	return var0_52
end

function var0_0.CollectTouchEvents(arg0_53)
	local var0_53 = arg0_53.ship:getCVIntimacy()

	return (var5_0.filterAssistantEvents(var5_0.GetShipTouchEvents(arg0_53.ship:getSkinId(), var0_53), arg0_53.ship:getSkinId(), var0_53))
end

function var0_0.GetTouchEvent(arg0_54, arg1_54)
	local var0_54 = arg0_54.ship:getCVIntimacy()

	return (var5_0.filterAssistantEvents(var5_0.getAssistantTouchEvents(arg1_54, arg0_54.ship:getSkinId()), arg0_54.ship:getSkinId(), 0))
end

function var0_0.GetIdleEvents(arg0_55)
	local var0_55 = arg0_55.ship:getCVIntimacy()

	return (var5_0.filterAssistantEvents(var5_0.GetShipMainEvents(arg0_55.ship:getSkinId(), 0), arg0_55.ship:getSkinId(), 0))
end

function var0_0.GetEventConfig(arg0_56, arg1_56)
	return pg.AssistantInfo.GetAssistantEvents(arg1_56)
end

function var0_0.GetSpecialTouchEvent(arg0_57, arg1_57)
	return var5_0.getPaintingTouchEvents(arg1_57)
end

function var0_0.RemoveTimer(arg0_58)
	if arg0_58.timer then
		arg0_58.timer:Stop()

		arg0_58.timer = nil
	end
end

function var0_0.IsExited(arg0_59)
	return arg0_59.isExited
end

function var0_0.Fold(arg0_60, arg1_60, arg2_60)
	arg0_60.isFoldState = arg1_60

	arg0_60:RemoveMoveTimer()
	arg0_60:OnFold(arg1_60)
end

function var0_0.RemoveMoveTimer(arg0_61)
	if arg0_61.moveTimer then
		arg0_61.moveTimer:Stop()

		arg0_61.moveTimer = nil
	end
end

function var0_0.EnableOrDisableMove(arg0_62, arg1_62)
	arg0_62.isDragAndZoomState = arg1_62

	arg0_62:RemoveMoveTimer()

	if arg1_62 then
		arg0_62:StopChatAnimtion()
		arg0_62:RemoveTimer()
		arg0_62.cvLoader:Stop()
	else
		arg0_62:TriggerNextEventAuto()
	end

	arg0_62:OnEnableOrDisableDragAndZoom(arg1_62)
end

function var0_0.GetOffset(arg0_63)
	return 0
end

function var0_0.UpdateBound(arg0_64)
	return
end

function var0_0.IslimitYPos(arg0_65)
	return false
end

function var0_0.PlayChangeSkinActionIn(arg0_66, arg1_66)
	return
end

function var0_0.PlayChangeSkinActionOut(arg0_67, arg1_67)
	return
end

function var0_0.PauseForSilent(arg0_68)
	if SettingsMainScenePanel.IsEnableFlagShipInteraction() then
		return
	end

	if arg0_68:IsLoaded() then
		arg0_68:_Pause()
	end
end

function var0_0._Pause(arg0_69)
	arg0_69.isPuase = true

	arg0_69:RemoveMoveTimer()
	arg0_69:StopChatAnimtion()
	arg0_69:RemoveChatTimer()
	arg0_69:RemoveTimer()
	arg0_69.cvLoader:Stop()
end

function var0_0.Pause(arg0_70)
	arg0_70:_Pause()
	arg0_70:OnPause()
end

function var0_0.ResumeForSilent(arg0_71)
	if SettingsMainScenePanel.IsEnableFlagShipInteraction() then
		return
	end

	if arg0_71:IsLoaded() then
		arg0_71:_Resume()
	end
end

function var0_0._Resume(arg0_72)
	arg0_72.isPuase = false

	arg0_72:TriggerNextEventAuto()
end

function var0_0.Resume(arg0_73)
	arg0_73:_Resume()
	arg0_73:OnResume()
end

function var0_0.updateShip(arg0_74, arg1_74)
	if arg1_74 and arg0_74.ship.id == arg1_74.id then
		arg0_74.ship = arg1_74
	end

	arg0_74:OnUpdateShip(arg1_74)
end

function var0_0.OnUpdateShip(arg0_75, arg1_75)
	return
end

function var0_0.InitScalePart(arg0_76)
	local var0_76 = arg0_76:GetPartScaleData()

	if var0_76 and #var0_76 > 0 then
		arg0_76.partScaleList = {}
		arg0_76.partScaleSelectList = {}

		local var1_76 = arg0_76:GetPaintingTransform()

		if var1_76 then
			for iter0_76, iter1_76 in ipairs(var0_76) do
				local var2_76 = findTF(var1_76, iter1_76)

				if var2_76 then
					local var3_76 = GetOrAddComponent(var2_76, typeof(PinchZoom))

					var3_76.enabled = false

					PoolMgr.GetInstance():GetUI("mainuiscalepart", false, function(arg0_77)
						SetParent(arg0_77, var2_76)
						setActive(arg0_77, false)
						table.insert(arg0_76.partScaleSelectList, {
							tf = tf(arg0_77),
							name = iter1_76
						})
					end)
					onButton(arg0_76._event, var2_76, function()
						if arg0_76.partScaleFlag then
							arg0_76.selectPartName = iter1_76

							arg0_76:updateSelectPartScale()
						end
					end)
					arg0_76:ResetPartScale(true)
					table.insert(arg0_76.partScaleList, {
						name = iter1_76,
						tf = var2_76,
						com = var3_76
					})
				end
			end
		end
	end
end

function var0_0.updatePartCotent(arg0_79, arg1_79)
	for iter0_79 = 1, #arg0_79.partScaleSelectList do
		if arg1_79 then
			arg0_79:emit(NewMainScene.SET_SCALE_PART_CONTENT, arg0_79.partScaleSelectList[iter0_79].tf)
		else
			setParent(arg0_79.partScaleSelectList[iter0_79].tf, arg0_79:GetPaintingTransform(), true)
		end
	end
end

function var0_0.updateSelectPartScale(arg0_80)
	for iter0_80 = 1, #arg0_80.partScaleList do
		local var0_80 = arg0_80.partScaleList[iter0_80]
		local var1_80 = arg0_80.partScaleFlag and var0_80.name == arg0_80.selectPartName

		var0_80.com.enabled = var1_80

		setActive(arg0_80.partScaleSelectList[iter0_80].tf, arg0_80.partScaleFlag and arg0_80.partScaleSelectList[iter0_80].name == arg0_80.selectPartName)
	end
end

function var0_0.ClearScalePart(arg0_81)
	if arg0_81.partScaleList and #arg0_81.partScaleList > 0 then
		for iter0_81 = 1, #arg0_81.partScaleList do
			if arg0_81.partScaleList[iter0_81].tf then
				removeOnButton(arg0_81.partScaleList[iter0_81].tf)
			end
		end

		arg0_81.partScaleList = nil
	end

	if arg0_81.partScaleSelectList and #arg0_81.partScaleSelectList > 0 then
		for iter1_81 = 1, #arg0_81.partScaleSelectList do
			if arg0_81.partScaleSelectList[iter1_81].tf then
				PoolMgr.GetInstance():ReturnUI("mainuiscalepart", go(arg0_81.partScaleSelectList[iter1_81].tf))
			end
		end

		arg0_81.partScaleSelectList = nil
	end
end

function var0_0.OnEnablePartScale(arg0_82, arg1_82)
	if arg0_82.partScaleList then
		arg0_82.partScaleFlag = arg1_82
		arg0_82.selectPartName = nil

		for iter0_82 = 1, #arg0_82.partScaleList do
			local var0_82 = arg0_82.partScaleList[iter0_82].tf

			GetOrAddComponent(var0_82, typeof(CanvasGroup)).blocksRaycasts = arg1_82
		end

		arg0_82:updateSelectPartScale()
		arg0_82:updatePartCotent(arg1_82)

		if not arg1_82 then
			arg0_82:ResetPartScale(true)
		end
	end
end

function var0_0.ResetPartScale(arg0_83, arg1_83)
	if arg0_83.partScaleList and #arg0_83.partScaleList > 0 then
		for iter0_83 = 1, #arg0_83.partScaleList do
			local var0_83 = arg0_83.partScaleList[iter0_83].tf
			local var1_83 = arg0_83.partScaleList[iter0_83].name
			local var2_83 = arg1_83 and getProxy(SettingsProxy):getSkinScaleSetting(arg0_83.ship, arg0_83:GetPartStateType(), var1_83) or 1

			var0_83.localScale = Vector3(var2_83, var2_83, var2_83)
		end
	end
end

function var0_0.SavePartScaleData(arg0_84)
	if not arg0_84.partScaleList or #arg0_84.partScaleList == 0 then
		return
	end

	if not arg0_84.ship then
		return
	end

	for iter0_84 = 1, #arg0_84.partScaleList do
		local var0_84 = arg0_84.partScaleList[iter0_84]
		local var1_84 = arg0_84:GetPartStateType()
		local var2_84 = var0_84.name
		local var3_84 = var0_84.tf.localScale.x

		getProxy(SettingsProxy):setSkinScaleSetting(arg0_84.ship, var1_84, var2_84, var3_84)
	end
end

function var0_0.GetPaintingTransform(arg0_85)
	return nil
end

function var0_0.GetPartScaleData(arg0_86)
	return nil
end

function var0_0.GetPartStateType(arg0_87)
	return
end

function var0_0.Dispose(arg0_88)
	arg0_88:disposeEvent()

	arg0_88.isExited = true

	pg.DelegateInfo.Dispose(arg0_88)

	if arg0_88.state == var3_0 then
		arg0_88:UnLoad()
	end

	arg0_88.cvLoader:Dispose()

	arg0_88.cvLoader = nil
	arg0_88.triggerWhenLoaded = false

	arg0_88:RemoveTimer()
	arg0_88:RemoveMoveTimer()
	arg0_88:RemoveChatTimer()
	arg0_88:ClearScalePart()
end

function var0_0.OnLoad(arg0_89, arg1_89)
	arg1_89()
end

function var0_0.OnUnload(arg0_90)
	return
end

function var0_0.OnClick(arg0_91)
	return
end

function var0_0.OnLongPress(arg0_92)
	return
end

function var0_0.OnTriggerEvent(arg0_93)
	return
end

function var0_0.OnTriggerEventAuto(arg0_94)
	return
end

function var0_0.OnDisplayWorld(arg0_95, arg1_95)
	return
end

function var0_0.OnFold(arg0_96, arg1_96)
	return
end

function var0_0.OnEnableOrDisableDragAndZoom(arg0_97, arg1_97)
	return
end

function var0_0.OnPause(arg0_98)
	return
end

function var0_0.OnResume(arg0_99)
	return
end

return var0_0
