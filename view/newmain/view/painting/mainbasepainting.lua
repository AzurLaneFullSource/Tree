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
	local function var0_20(arg0_21)
		arg0_20:PrepareTriggerAction(arg0_21)
	end

	if getProxy(PlayerProxy):getFlag("login") then
		getProxy(PlayerProxy):setFlag("login", nil)
		var0_20("event_login")
	elseif getProxy(PlayerProxy):getFlag("battle") then
		getProxy(PlayerProxy):setFlag("battle", nil)
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
	local var0_24 = var5_0.assistantEvents[arg1_24]

	if var0_24.dialog ~= "" then
		arg0_24:DisplayWord(var0_24.dialog)
	else
		arg0_24:TriggerNextEventAuto()
	end
end

function var0_0.TriggerEvent(arg0_25, arg1_25)
	if arg0_25.isDragAndZoomState then
		return
	end

	if arg0_25.chatting then
		return
	end

	arg0_25:RemoveTimer()
	arg0_25:PrepareTriggerAction(arg1_25)
	arg0_25:OnTriggerEvent()
end

function var0_0.TriggerNextEventAuto(arg0_26)
	if arg0_26.isPuase or arg0_26.isExited then
		return
	end

	arg0_26:OnEndChatting()
	arg0_26:RemoveTimer()

	arg0_26.timer = Timer.New(function()
		arg0_26:OnTimerTriggerEvent()
	end, 30, 1, true)

	arg0_26.timer:Start()
end

function var0_0.OnTimerTriggerEvent(arg0_28)
	if arg0_28:OnEnableTimerEvent() then
		local var0_28 = arg0_28:CollectIdleEvents(arg0_28.lastChatEvent)

		arg0_28.lastChatEvent = var0_28[math.ceil(math.random(#var0_28))]

		arg0_28:_TriggerEvent(arg0_28.lastChatEvent)
		arg0_28:OnTriggerEventAuto()
		arg0_28:RemoveTimer()
	end
end

function var0_0.OnEnableTimerEvent(arg0_29)
	return true
end

function var0_0.OnStartChatting(arg0_30)
	arg0_30.chatting = true
end

function var0_0.OnEndChatting(arg0_31)
	arg0_31.chatting = false
end

function var0_0.GetWordAndCv(arg0_32, arg1_32, arg2_32)
	local var0_32, var1_32, var2_32, var3_32, var4_32, var5_32 = ShipWordHelper.GetCvDataForShip(arg0_32.ship, arg2_32)

	return var0_32, var1_32, var2_32, var3_32, var4_32, var5_32
end

function var0_0.DisplayWord(arg0_33, arg1_33)
	arg0_33:OnStartChatting()

	local var0_33, var1_33, var2_33, var3_33, var4_33, var5_33 = arg0_33:GetWordAndCv(arg0_33.ship, arg1_33)

	if not var2_33 or var2_33 == nil or var2_33 == "" or var2_33 == "nil" then
		arg0_33:OnEndChatting()

		return
	end

	arg0_33:OnDisplayWorld(arg1_33)
	arg0_33:emit(MainWordView.SET_CONTENT, arg1_33, var2_33)
	arg0_33:PlayCvAndAnimation(var4_33, var3_33, var1_33)
end

function var0_0.PlayCvAndAnimation(arg0_34, arg1_34, arg2_34, arg3_34)
	if getProxy(ContextProxy):getContextByMediator(NewShipMediator) then
		arg0_34:OnEndChatting()

		return
	end

	local var0_34 = -1

	seriesAsync({
		function(arg0_35)
			if not arg3_34 or not not pg.NewStoryMgr.GetInstance():IsRunning() then
				arg0_35()

				return
			end

			arg0_34:PlayCV(arg1_34, arg2_34, arg3_34, function(arg0_36)
				var0_34 = arg0_36

				arg0_35()
			end)
		end,
		function(arg0_37)
			arg0_34:StartChatAnimtion(var0_34, arg0_37)
		end
	}, function()
		arg0_34:OnDisplayWordEnd()
	end)
end

function var0_0.OnDisplayWordEnd(arg0_39)
	arg0_39:TriggerNextEventAuto()
end

function var0_0.PlayCV(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40)
	local var0_40 = ShipWordHelper.RawGetCVKey(arg0_40.ship:getSkinId())
	local var1_40 = pg.CriMgr.GetCVBankName(var0_40)

	arg0_40.cvLoader:Load(var1_40, arg3_40, 0, arg4_40)
end

function var0_0.setReplaceWord(arg0_41, arg1_41)
	arg0_41.replaceWord = arg1_41
end

function var0_0.getReplaceWord(arg0_42)
	return arg0_42.replaceWord
end

function var0_0.StartChatAnimtion(arg0_43, arg1_43, arg2_43)
	local var0_43 = 0.3
	local var1_43 = arg1_43 > 0 and arg1_43 or 3

	arg0_43:emit(MainWordView.START_ANIMATION, var0_43, var1_43)
	arg0_43:AddCharTimer(function()
		if arg0_43:IsUnload() then
			return
		end

		arg2_43()
	end, var0_43 * 3 + var1_43)
end

function var0_0.AddCharTimer(arg0_45, arg1_45, arg2_45)
	arg0_45:RemoveChatTimer()

	arg0_45.chatTimer = Timer.New(arg1_45, arg2_45, 1)

	arg0_45.chatTimer:Start()
end

function var0_0.RemoveChatTimer(arg0_46)
	if arg0_46.chatTimer then
		arg0_46.chatTimer:Stop()

		arg0_46.chatTimer = nil
	end
end

function var0_0.StopChatAnimtion(arg0_47)
	arg0_47:emit(MainWordView.STOP_ANIMATION)
	arg0_47:OnEndChatting()
end

function var0_0.OnStopVoice(arg0_48)
	arg0_48.cvLoader:Stop()
end

function var0_0.CollectIdleEvents(arg0_49, arg1_49)
	local var0_49 = {}

	if getProxy(EventProxy):hasFinishState() and arg1_49 ~= "event_complete" then
		table.insert(var0_49, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1_49 ~= "mission_complete" then
			table.insert(var0_49, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1_49 ~= "mail" then
			table.insert(var0_49, "mail")
		end

		if #var0_49 == 0 then
			local var1_49 = arg0_49.ship:getCVIntimacy()

			var0_49 = var5_0.filterAssistantEvents(Clone(var5_0.IdleEvents), arg0_49.ship:getSkinId(), var1_49)

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1_49 ~= "mission" then
				table.insert(var0_49, "mission")
			end
		end
	end

	return var0_49
end

function var0_0.CollectTouchEvents(arg0_50)
	local var0_50 = arg0_50.ship:getCVIntimacy()

	return (var5_0.filterAssistantEvents(var5_0.PaintingTouchEvents, arg0_50.ship:getSkinId(), var0_50))
end

function var0_0.GetTouchEvent(arg0_51, arg1_51)
	return (var5_0.filterAssistantEvents(var5_0.getAssistantTouchEvents(arg1_51, arg0_51.ship:getSkinId()), arg0_51.ship:getSkinId(), 0))
end

function var0_0.GetIdleEvents(arg0_52)
	return (var5_0.filterAssistantEvents(var5_0.IdleEvents, arg0_52.ship:getSkinId(), 0))
end

function var0_0.GetEventConfig(arg0_53, arg1_53)
	return var5_0.assistantEvents[arg1_53]
end

function var0_0.GetSpecialTouchEvent(arg0_54, arg1_54)
	return var5_0.getPaintingTouchEvents(arg1_54)
end

function var0_0.RemoveTimer(arg0_55)
	if arg0_55.timer then
		arg0_55.timer:Stop()

		arg0_55.timer = nil
	end
end

function var0_0.IsExited(arg0_56)
	return arg0_56.isExited
end

function var0_0.Fold(arg0_57, arg1_57, arg2_57)
	arg0_57.isFoldState = arg1_57

	arg0_57:RemoveMoveTimer()
	arg0_57:OnFold(arg1_57)
end

function var0_0.RemoveMoveTimer(arg0_58)
	if arg0_58.moveTimer then
		arg0_58.moveTimer:Stop()

		arg0_58.moveTimer = nil
	end
end

function var0_0.EnableOrDisableMove(arg0_59, arg1_59)
	arg0_59.isDragAndZoomState = arg1_59

	arg0_59:RemoveMoveTimer()

	if arg1_59 then
		arg0_59:StopChatAnimtion()
		arg0_59:RemoveTimer()
		arg0_59.cvLoader:Stop()
	else
		arg0_59:TriggerNextEventAuto()
	end

	arg0_59:OnEnableOrDisableDragAndZoom(arg1_59)
end

function var0_0.GetOffset(arg0_60)
	return 0
end

function var0_0.IslimitYPos(arg0_61)
	return false
end

function var0_0.PlayChangeSkinActionIn(arg0_62, arg1_62)
	return
end

function var0_0.PlayChangeSkinActionOut(arg0_63, arg1_63)
	return
end

function var0_0.PauseForSilent(arg0_64)
	if SettingsMainScenePanel.IsEnableFlagShipInteraction() then
		return
	end

	if arg0_64:IsLoaded() then
		arg0_64:_Pause()
	end
end

function var0_0._Pause(arg0_65)
	arg0_65.isPuase = true

	arg0_65:RemoveMoveTimer()
	arg0_65:StopChatAnimtion()
	arg0_65:RemoveChatTimer()
	arg0_65:RemoveTimer()
	arg0_65.cvLoader:Stop()
end

function var0_0.Pause(arg0_66)
	arg0_66:_Pause()
	arg0_66:OnPause()
end

function var0_0.ResumeForSilent(arg0_67)
	if SettingsMainScenePanel.IsEnableFlagShipInteraction() then
		return
	end

	if arg0_67:IsLoaded() then
		arg0_67:_Resume()
	end
end

function var0_0._Resume(arg0_68)
	arg0_68.isPuase = false

	arg0_68:TriggerNextEventAuto()
end

function var0_0.Resume(arg0_69)
	arg0_69:_Resume()
	arg0_69:OnResume()
end

function var0_0.updateShip(arg0_70, arg1_70)
	if arg1_70 and arg0_70.ship.id == arg1_70.id then
		arg0_70.ship = arg1_70
	end

	arg0_70:OnUpdateShip(arg1_70)
end

function var0_0.OnUpdateShip(arg0_71, arg1_71)
	return
end

function var0_0.InitScalePart(arg0_72)
	local var0_72 = arg0_72:GetPartScaleData()

	if var0_72 and #var0_72 > 0 then
		arg0_72.partScaleList = {}
		arg0_72.partScaleSelectList = {}

		local var1_72 = arg0_72:GetPaintingTransform()

		if var1_72 then
			for iter0_72, iter1_72 in ipairs(var0_72) do
				local var2_72 = findTF(var1_72, iter1_72)

				if var2_72 then
					local var3_72 = GetOrAddComponent(var2_72, typeof(PinchZoom))

					var3_72.enabled = false

					PoolMgr.GetInstance():GetUI("mainuiscalepart", false, function(arg0_73)
						SetParent(arg0_73, var2_72)
						setActive(arg0_73, false)
						table.insert(arg0_72.partScaleSelectList, {
							tf = tf(arg0_73),
							name = iter1_72
						})
					end)
					onButton(arg0_72._event, var2_72, function()
						if arg0_72.partScaleFlag then
							arg0_72.selectPartName = iter1_72

							arg0_72:updateSelectPartScale()
						end
					end)
					arg0_72:ResetPartScale(true)
					table.insert(arg0_72.partScaleList, {
						name = iter1_72,
						tf = var2_72,
						com = var3_72
					})
				end
			end
		end
	end
end

function var0_0.updatePartCotent(arg0_75, arg1_75)
	for iter0_75 = 1, #arg0_75.partScaleSelectList do
		if arg1_75 then
			arg0_75:emit(NewMainScene.SET_SCALE_PART_CONTENT, arg0_75.partScaleSelectList[iter0_75].tf)
		else
			setParent(arg0_75.partScaleSelectList[iter0_75].tf, arg0_75:GetPaintingTransform(), true)
		end
	end
end

function var0_0.updateSelectPartScale(arg0_76)
	for iter0_76 = 1, #arg0_76.partScaleList do
		local var0_76 = arg0_76.partScaleList[iter0_76]
		local var1_76 = arg0_76.partScaleFlag and var0_76.name == arg0_76.selectPartName

		var0_76.com.enabled = var1_76

		setActive(arg0_76.partScaleSelectList[iter0_76].tf, arg0_76.partScaleFlag and arg0_76.partScaleSelectList[iter0_76].name == arg0_76.selectPartName)
	end
end

function var0_0.ClearScalePart(arg0_77)
	if arg0_77.partScaleList and #arg0_77.partScaleList > 0 then
		for iter0_77 = 1, #arg0_77.partScaleList do
			if arg0_77.partScaleList[iter0_77].tf then
				removeOnButton(arg0_77.partScaleList[iter0_77].tf)
			end
		end

		arg0_77.partScaleList = nil
	end

	if arg0_77.partScaleSelectList and #arg0_77.partScaleSelectList > 0 then
		for iter1_77 = 1, #arg0_77.partScaleSelectList do
			if arg0_77.partScaleSelectList[iter1_77].tf then
				PoolMgr.GetInstance():ReturnUI("mainuiscalepart", go(arg0_77.partScaleSelectList[iter1_77].tf))
			end
		end

		arg0_77.partScaleSelectList = nil
	end
end

function var0_0.OnEnablePartScale(arg0_78, arg1_78)
	if arg0_78.partScaleList then
		arg0_78.partScaleFlag = arg1_78
		arg0_78.selectPartName = nil

		for iter0_78 = 1, #arg0_78.partScaleList do
			local var0_78 = arg0_78.partScaleList[iter0_78].tf

			GetOrAddComponent(var0_78, typeof(CanvasGroup)).blocksRaycasts = arg1_78
		end

		arg0_78:updateSelectPartScale()
		arg0_78:updatePartCotent(arg1_78)

		if not arg1_78 then
			arg0_78:ResetPartScale(true)
		end
	end
end

function var0_0.ResetPartScale(arg0_79, arg1_79)
	if arg0_79.partScaleList and #arg0_79.partScaleList > 0 then
		for iter0_79 = 1, #arg0_79.partScaleList do
			local var0_79 = arg0_79.partScaleList[iter0_79].tf
			local var1_79 = arg0_79.partScaleList[iter0_79].name
			local var2_79 = arg1_79 and getProxy(SettingsProxy):getSkinScaleSetting(arg0_79.ship, arg0_79:GetPartStateType(), var1_79) or 1

			var0_79.localScale = Vector3(var2_79, var2_79, var2_79)
		end
	end
end

function var0_0.SavePartScaleData(arg0_80)
	if not arg0_80.partScaleList or #arg0_80.partScaleList == 0 then
		return
	end

	if not arg0_80.ship then
		return
	end

	for iter0_80 = 1, #arg0_80.partScaleList do
		local var0_80 = arg0_80.partScaleList[iter0_80]
		local var1_80 = arg0_80:GetPartStateType()
		local var2_80 = var0_80.name
		local var3_80 = var0_80.tf.localScale.x

		getProxy(SettingsProxy):setSkinScaleSetting(arg0_80.ship, var1_80, var2_80, var3_80)
	end
end

function var0_0.GetPaintingTransform(arg0_81)
	return nil
end

function var0_0.GetPartScaleData(arg0_82)
	return nil
end

function var0_0.GetPartStateType(arg0_83)
	return
end

function var0_0.Dispose(arg0_84)
	arg0_84:disposeEvent()

	arg0_84.isExited = true

	pg.DelegateInfo.Dispose(arg0_84)

	if arg0_84.state == var3_0 then
		arg0_84:UnLoad()
	end

	arg0_84.cvLoader:Dispose()

	arg0_84.cvLoader = nil
	arg0_84.triggerWhenLoaded = false

	arg0_84:RemoveTimer()
	arg0_84:RemoveMoveTimer()
	arg0_84:RemoveChatTimer()
	arg0_84:ClearScalePart()
end

function var0_0.OnLoad(arg0_85, arg1_85)
	arg1_85()
end

function var0_0.OnUnload(arg0_86)
	return
end

function var0_0.OnClick(arg0_87)
	return
end

function var0_0.OnLongPress(arg0_88)
	return
end

function var0_0.OnTriggerEvent(arg0_89)
	return
end

function var0_0.OnTriggerEventAuto(arg0_90)
	return
end

function var0_0.OnDisplayWorld(arg0_91, arg1_91)
	return
end

function var0_0.OnFold(arg0_92, arg1_92)
	return
end

function var0_0.OnEnableOrDisableDragAndZoom(arg0_93, arg1_93)
	return
end

function var0_0.OnPause(arg0_94)
	return
end

function var0_0.OnResume(arg0_95)
	return
end

return var0_0
