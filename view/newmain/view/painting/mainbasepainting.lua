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
	if arg0_27.isPuase or arg0_27.isExited then
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

		arg0_29:_TriggerEvent(arg0_29.lastChatEvent)
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

		return
	end

	arg0_34:OnDisplayWorld(arg1_34)
	arg0_34:emit(MainWordView.SET_CONTENT, arg1_34, var2_34)
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

function var0_0.setReplaceWord(arg0_43, arg1_43)
	arg0_43.replaceWord = arg1_43
end

function var0_0.getReplaceWord(arg0_44)
	return arg0_44.replaceWord
end

function var0_0.StartChatAnimtion(arg0_45, arg1_45, arg2_45)
	local var0_45 = 0.3
	local var1_45 = arg1_45 > 0 and arg1_45 or 3

	arg0_45:emit(MainWordView.START_ANIMATION, var0_45, var1_45)
	arg0_45:AddCharTimer(function()
		if arg0_45:IsUnload() then
			return
		end

		arg2_45()
	end, var0_45 * 3 + var1_45)
end

function var0_0.AddCharTimer(arg0_47, arg1_47, arg2_47)
	arg0_47:RemoveChatTimer()

	arg0_47.chatTimer = Timer.New(arg1_47, arg2_47, 1)

	arg0_47.chatTimer:Start()
end

function var0_0.RemoveChatTimer(arg0_48)
	if arg0_48.chatTimer then
		arg0_48.chatTimer:Stop()

		arg0_48.chatTimer = nil
	end
end

function var0_0.StopChatAnimtion(arg0_49)
	arg0_49:emit(MainWordView.STOP_ANIMATION)
	arg0_49:OnEndChatting()
end

function var0_0.OnStopVoice(arg0_50)
	arg0_50.cvLoader:Stop()
end

function var0_0.CollectIdleEvents(arg0_51, arg1_51)
	local var0_51 = {}

	if getProxy(EventProxy):hasFinishState() and arg1_51 ~= "event_complete" then
		table.insert(var0_51, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1_51 ~= "mission_complete" then
			table.insert(var0_51, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1_51 ~= "mail" then
			table.insert(var0_51, "mail")
		end

		if #var0_51 == 0 then
			local var1_51 = arg0_51.ship:getCVIntimacy()

			var0_51 = var5_0.filterAssistantEvents(Clone(var5_0.IdleEvents), arg0_51.ship:getSkinId(), var1_51)

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1_51 ~= "mission" then
				table.insert(var0_51, "mission")
			end
		end
	end

	return var0_51
end

function var0_0.CollectTouchEvents(arg0_52)
	local var0_52 = arg0_52.ship:getCVIntimacy()

	return (var5_0.filterAssistantEvents(var5_0.PaintingTouchEvents, arg0_52.ship:getSkinId(), var0_52))
end

function var0_0.GetTouchEvent(arg0_53, arg1_53)
	return (var5_0.filterAssistantEvents(var5_0.getAssistantTouchEvents(arg1_53, arg0_53.ship:getSkinId()), arg0_53.ship:getSkinId(), 0))
end

function var0_0.GetIdleEvents(arg0_54)
	return (var5_0.filterAssistantEvents(var5_0.IdleEvents, arg0_54.ship:getSkinId(), 0))
end

function var0_0.GetEventConfig(arg0_55, arg1_55)
	return var5_0.assistantEvents[arg1_55]
end

function var0_0.GetSpecialTouchEvent(arg0_56, arg1_56)
	return var5_0.getPaintingTouchEvents(arg1_56)
end

function var0_0.RemoveTimer(arg0_57)
	if arg0_57.timer then
		arg0_57.timer:Stop()

		arg0_57.timer = nil
	end
end

function var0_0.IsExited(arg0_58)
	return arg0_58.isExited
end

function var0_0.Fold(arg0_59, arg1_59, arg2_59)
	arg0_59.isFoldState = arg1_59

	arg0_59:RemoveMoveTimer()
	arg0_59:OnFold(arg1_59)
end

function var0_0.RemoveMoveTimer(arg0_60)
	if arg0_60.moveTimer then
		arg0_60.moveTimer:Stop()

		arg0_60.moveTimer = nil
	end
end

function var0_0.EnableOrDisableMove(arg0_61, arg1_61)
	arg0_61.isDragAndZoomState = arg1_61

	arg0_61:RemoveMoveTimer()

	if arg1_61 then
		arg0_61:StopChatAnimtion()
		arg0_61:RemoveTimer()
		arg0_61.cvLoader:Stop()
	else
		arg0_61:TriggerNextEventAuto()
	end

	arg0_61:OnEnableOrDisableDragAndZoom(arg1_61)
end

function var0_0.GetOffset(arg0_62)
	return 0
end

function var0_0.IslimitYPos(arg0_63)
	return false
end

function var0_0.PlayChangeSkinActionIn(arg0_64, arg1_64)
	return
end

function var0_0.PlayChangeSkinActionOut(arg0_65, arg1_65)
	return
end

function var0_0.PauseForSilent(arg0_66)
	if SettingsMainScenePanel.IsEnableFlagShipInteraction() then
		return
	end

	if arg0_66:IsLoaded() then
		arg0_66:_Pause()
	end
end

function var0_0._Pause(arg0_67)
	arg0_67.isPuase = true

	arg0_67:RemoveMoveTimer()
	arg0_67:StopChatAnimtion()
	arg0_67:RemoveChatTimer()
	arg0_67:RemoveTimer()
	arg0_67.cvLoader:Stop()
end

function var0_0.Pause(arg0_68)
	arg0_68:_Pause()
	arg0_68:OnPause()
end

function var0_0.ResumeForSilent(arg0_69)
	if SettingsMainScenePanel.IsEnableFlagShipInteraction() then
		return
	end

	if arg0_69:IsLoaded() then
		arg0_69:_Resume()
	end
end

function var0_0._Resume(arg0_70)
	arg0_70.isPuase = false

	arg0_70:TriggerNextEventAuto()
end

function var0_0.Resume(arg0_71)
	arg0_71:_Resume()
	arg0_71:OnResume()
end

function var0_0.updateShip(arg0_72, arg1_72)
	if arg1_72 and arg0_72.ship.id == arg1_72.id then
		arg0_72.ship = arg1_72
	end

	arg0_72:OnUpdateShip(arg1_72)
end

function var0_0.OnUpdateShip(arg0_73, arg1_73)
	return
end

function var0_0.InitScalePart(arg0_74)
	local var0_74 = arg0_74:GetPartScaleData()

	if var0_74 and #var0_74 > 0 then
		arg0_74.partScaleList = {}
		arg0_74.partScaleSelectList = {}

		local var1_74 = arg0_74:GetPaintingTransform()

		if var1_74 then
			for iter0_74, iter1_74 in ipairs(var0_74) do
				local var2_74 = findTF(var1_74, iter1_74)

				if var2_74 then
					local var3_74 = GetOrAddComponent(var2_74, typeof(PinchZoom))

					var3_74.enabled = false

					PoolMgr.GetInstance():GetUI("mainuiscalepart", false, function(arg0_75)
						SetParent(arg0_75, var2_74)
						setActive(arg0_75, false)
						table.insert(arg0_74.partScaleSelectList, {
							tf = tf(arg0_75),
							name = iter1_74
						})
					end)
					onButton(arg0_74._event, var2_74, function()
						if arg0_74.partScaleFlag then
							arg0_74.selectPartName = iter1_74

							arg0_74:updateSelectPartScale()
						end
					end)
					arg0_74:ResetPartScale(true)
					table.insert(arg0_74.partScaleList, {
						name = iter1_74,
						tf = var2_74,
						com = var3_74
					})
				end
			end
		end
	end
end

function var0_0.updatePartCotent(arg0_77, arg1_77)
	for iter0_77 = 1, #arg0_77.partScaleSelectList do
		if arg1_77 then
			arg0_77:emit(NewMainScene.SET_SCALE_PART_CONTENT, arg0_77.partScaleSelectList[iter0_77].tf)
		else
			setParent(arg0_77.partScaleSelectList[iter0_77].tf, arg0_77:GetPaintingTransform(), true)
		end
	end
end

function var0_0.updateSelectPartScale(arg0_78)
	for iter0_78 = 1, #arg0_78.partScaleList do
		local var0_78 = arg0_78.partScaleList[iter0_78]
		local var1_78 = arg0_78.partScaleFlag and var0_78.name == arg0_78.selectPartName

		var0_78.com.enabled = var1_78

		setActive(arg0_78.partScaleSelectList[iter0_78].tf, arg0_78.partScaleFlag and arg0_78.partScaleSelectList[iter0_78].name == arg0_78.selectPartName)
	end
end

function var0_0.ClearScalePart(arg0_79)
	if arg0_79.partScaleList and #arg0_79.partScaleList > 0 then
		for iter0_79 = 1, #arg0_79.partScaleList do
			if arg0_79.partScaleList[iter0_79].tf then
				removeOnButton(arg0_79.partScaleList[iter0_79].tf)
			end
		end

		arg0_79.partScaleList = nil
	end

	if arg0_79.partScaleSelectList and #arg0_79.partScaleSelectList > 0 then
		for iter1_79 = 1, #arg0_79.partScaleSelectList do
			if arg0_79.partScaleSelectList[iter1_79].tf then
				PoolMgr.GetInstance():ReturnUI("mainuiscalepart", go(arg0_79.partScaleSelectList[iter1_79].tf))
			end
		end

		arg0_79.partScaleSelectList = nil
	end
end

function var0_0.OnEnablePartScale(arg0_80, arg1_80)
	if arg0_80.partScaleList then
		arg0_80.partScaleFlag = arg1_80
		arg0_80.selectPartName = nil

		for iter0_80 = 1, #arg0_80.partScaleList do
			local var0_80 = arg0_80.partScaleList[iter0_80].tf

			GetOrAddComponent(var0_80, typeof(CanvasGroup)).blocksRaycasts = arg1_80
		end

		arg0_80:updateSelectPartScale()
		arg0_80:updatePartCotent(arg1_80)

		if not arg1_80 then
			arg0_80:ResetPartScale(true)
		end
	end
end

function var0_0.ResetPartScale(arg0_81, arg1_81)
	if arg0_81.partScaleList and #arg0_81.partScaleList > 0 then
		for iter0_81 = 1, #arg0_81.partScaleList do
			local var0_81 = arg0_81.partScaleList[iter0_81].tf
			local var1_81 = arg0_81.partScaleList[iter0_81].name
			local var2_81 = arg1_81 and getProxy(SettingsProxy):getSkinScaleSetting(arg0_81.ship, arg0_81:GetPartStateType(), var1_81) or 1

			var0_81.localScale = Vector3(var2_81, var2_81, var2_81)
		end
	end
end

function var0_0.SavePartScaleData(arg0_82)
	if not arg0_82.partScaleList or #arg0_82.partScaleList == 0 then
		return
	end

	if not arg0_82.ship then
		return
	end

	for iter0_82 = 1, #arg0_82.partScaleList do
		local var0_82 = arg0_82.partScaleList[iter0_82]
		local var1_82 = arg0_82:GetPartStateType()
		local var2_82 = var0_82.name
		local var3_82 = var0_82.tf.localScale.x

		getProxy(SettingsProxy):setSkinScaleSetting(arg0_82.ship, var1_82, var2_82, var3_82)
	end
end

function var0_0.GetPaintingTransform(arg0_83)
	return nil
end

function var0_0.GetPartScaleData(arg0_84)
	return nil
end

function var0_0.GetPartStateType(arg0_85)
	return
end

function var0_0.Dispose(arg0_86)
	arg0_86:disposeEvent()

	arg0_86.isExited = true

	pg.DelegateInfo.Dispose(arg0_86)

	if arg0_86.state == var3_0 then
		arg0_86:UnLoad()
	end

	arg0_86.cvLoader:Dispose()

	arg0_86.cvLoader = nil
	arg0_86.triggerWhenLoaded = false

	arg0_86:RemoveTimer()
	arg0_86:RemoveMoveTimer()
	arg0_86:RemoveChatTimer()
	arg0_86:ClearScalePart()
end

function var0_0.OnLoad(arg0_87, arg1_87)
	arg1_87()
end

function var0_0.OnUnload(arg0_88)
	return
end

function var0_0.OnClick(arg0_89)
	return
end

function var0_0.OnLongPress(arg0_90)
	return
end

function var0_0.OnTriggerEvent(arg0_91)
	return
end

function var0_0.OnTriggerEventAuto(arg0_92)
	return
end

function var0_0.OnDisplayWorld(arg0_93, arg1_93)
	return
end

function var0_0.OnFold(arg0_94, arg1_94)
	return
end

function var0_0.OnEnableOrDisableDragAndZoom(arg0_95, arg1_95)
	return
end

function var0_0.OnPause(arg0_96)
	return
end

function var0_0.OnResume(arg0_97)
	return
end

return var0_0
