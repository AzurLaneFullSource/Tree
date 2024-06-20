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

function var0_0.Load(arg0_6, arg1_6)
	arg0_6.isPuase = false
	arg0_6.isExited = false
	arg0_6.state = var2_0
	arg0_6.ship = arg1_6
	arg0_6.paintingName = arg1_6:getPainting()

	arg0_6:OnLoad(function()
		arg0_6.state = var3_0

		if arg0_6.triggerWhenLoaded then
			arg0_6:TriggerEventAtFirstTime()
		end

		arg0_6:InitClickEvent()
	end)
end

function var0_0.Unload(arg0_8)
	arg0_8.state = var4_0

	removeOnButton(arg0_8.container)
	arg0_8.longPressEvent:RemoveAllListeners()
	arg0_8:StopChatAnimtion()
	arg0_8.cvLoader:Stop()
	arg0_8:RemoveTimer()
	arg0_8:OnUnload()

	arg0_8.paintingName = nil

	LeanTween.cancel(arg0_8.container.gameObject)
end

function var0_0.UnloadOnlyPainting(arg0_9)
	arg0_9.state = var4_0

	removeOnButton(arg0_9.container)
	arg0_9.longPressEvent:RemoveAllListeners()
	arg0_9:RemoveTimer()
	arg0_9:OnUnload()

	arg0_9.paintingName = nil
end

function var0_0.InitClickEvent(arg0_10)
	onButton(arg0_10, arg0_10.container, function()
		arg0_10:OnClick()
		arg0_10:TriggerPersonalTask(arg0_10.ship.groupId)
	end)
	arg0_10.longPressEvent:RemoveAllListeners()
	arg0_10.longPressEvent:AddListener(function()
		if getProxy(ContextProxy):getCurrentContext().viewComponent.__cname == "NewMainScene" then
			arg0_10:OnLongPress()
		end
	end)
end

function var0_0.TriggerPersonalTask(arg0_13, arg1_13)
	if arg0_13.isFoldState then
		return
	end

	arg0_13:TriggerInterActionTask()

	local var0_13 = getProxy(TaskProxy)

	for iter0_13, iter1_13 in ipairs(pg.task_data_trigger.all) do
		local var1_13 = pg.task_data_trigger[iter1_13]

		if var1_13.group_id == arg1_13 then
			local var2_13 = var1_13.task_id

			if not var0_13:getFinishTaskById(var2_13) then
				arg0_13:CheckStoryDownload(var2_13, function()
					pg.m02:sendNotification(GAME.TRIGGER_TASK, var2_13)
				end)

				break
			end
		end
	end
end

function var0_0.TriggerInterActionTask(arg0_15)
	local var0_15 = getProxy(TaskProxy):GetFlagShipInterActionTaskList()

	if var0_15 and #var0_15 > 0 then
		for iter0_15, iter1_15 in ipairs(var0_15) do
			pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
				taskId = iter1_15.id
			})
		end
	end
end

function var0_0.CheckStoryDownload(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}
	local var1_16 = arg1_16

	while true do
		local var2_16 = pg.task_data_template[var1_16]

		if var2_16.story_id ~= "" then
			table.insert(var0_16, var2_16.story_id)
		end

		if var2_16.next_task == "" or var2_16.next_task == "0" then
			break
		end

		var1_16 = var1_16 + 1
	end

	local var3_16 = pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var0_16)
	local var4_16 = _.map(var3_16, function(arg0_17)
		return "painting/" .. arg0_17
	end)

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var4_16,
		finishFunc = arg2_16
	})
end

function var0_0.TriggerEventAtFirstTime(arg0_18)
	if not arg0_18:IsLoaded() then
		arg0_18.triggerWhenLoaded = true

		return
	end

	arg0_18.triggerWhenLoaded = false

	arg0_18:OnFirstTimeTriggerEvent()
end

function var0_0.OnFirstTimeTriggerEvent(arg0_19)
	local function var0_19(arg0_20)
		arg0_19:_TriggerEvent(arg0_20)
	end

	if getProxy(PlayerProxy):getFlag("login") then
		getProxy(PlayerProxy):setFlag("login", nil)
		var0_19("event_login")
	elseif getProxy(PlayerProxy):getFlag("battle") then
		getProxy(PlayerProxy):setFlag("battle", nil)
		var0_19("home")
	else
		arg0_19:TriggerNextEventAuto()
	end
end

function var0_0._TriggerEvent(arg0_21, arg1_21)
	local var0_21 = var5_0.assistantEvents[arg1_21]

	if var0_21.dialog ~= "" then
		arg0_21:DisplayWord(var0_21.dialog)
	else
		arg0_21:TriggerNextEventAuto()
	end
end

function var0_0.TriggerEvent(arg0_22, arg1_22)
	if arg0_22.isDragAndZoomState then
		return
	end

	if arg0_22.chatting then
		return
	end

	arg0_22:RemoveTimer()
	arg0_22:_TriggerEvent(arg1_22)
	arg0_22:OnTriggerEvent()
end

function var0_0.TriggerNextEventAuto(arg0_23)
	if arg0_23.isPuase or arg0_23.isExited then
		return
	end

	arg0_23:OnEndChatting()
	arg0_23:RemoveTimer()

	arg0_23.timer = Timer.New(function()
		arg0_23:OnTimerTriggerEvent()
	end, 30, 1, true)

	arg0_23.timer:Start()
end

function var0_0.OnTimerTriggerEvent(arg0_25)
	if arg0_25:OnEnableTimerEvent() then
		local var0_25 = arg0_25:CollectIdleEvents(arg0_25.lastChatEvent)

		arg0_25.lastChatEvent = var0_25[math.ceil(math.random(#var0_25))]

		arg0_25:_TriggerEvent(arg0_25.lastChatEvent)
		arg0_25:OnTriggerEventAuto()
		arg0_25:RemoveTimer()
	end
end

function var0_0.OnEnableTimerEvent(arg0_26)
	return true
end

function var0_0.OnStartChatting(arg0_27)
	arg0_27.chatting = true
end

function var0_0.OnEndChatting(arg0_28)
	arg0_28.chatting = false
end

function var0_0.GetWordAndCv(arg0_29, arg1_29, arg2_29)
	local var0_29, var1_29, var2_29, var3_29, var4_29, var5_29 = ShipWordHelper.GetCvDataForShip(arg0_29.ship, arg2_29)

	return var0_29, var1_29, var2_29, var3_29, var4_29, var5_29
end

function var0_0.DisplayWord(arg0_30, arg1_30)
	arg0_30:OnStartChatting()

	local var0_30, var1_30, var2_30, var3_30, var4_30, var5_30 = arg0_30:GetWordAndCv(arg0_30.ship, arg1_30)

	if not var2_30 or var2_30 == nil or var2_30 == "" or var2_30 == "nil" then
		arg0_30:OnEndChatting()

		return
	end

	arg0_30:OnDisplayWorld(arg1_30)
	arg0_30:emit(MainWordView.SET_CONTENT, arg1_30, var2_30)
	arg0_30:PlayCvAndAnimation(var4_30, var3_30, var1_30)
end

function var0_0.PlayCvAndAnimation(arg0_31, arg1_31, arg2_31, arg3_31)
	if getProxy(ContextProxy):getContextByMediator(NewShipMediator) then
		arg0_31:OnEndChatting()

		return
	end

	local var0_31 = -1

	seriesAsync({
		function(arg0_32)
			if not arg3_31 or not not pg.NewStoryMgr.GetInstance():IsRunning() then
				arg0_32()

				return
			end

			arg0_31:PlayCV(arg1_31, arg2_31, arg3_31, function(arg0_33)
				var0_31 = arg0_33

				arg0_32()
			end)
		end,
		function(arg0_34)
			arg0_31:StartChatAnimtion(var0_31, arg0_34)
		end
	}, function()
		arg0_31:OnDisplayWordEnd()
	end)
end

function var0_0.OnDisplayWordEnd(arg0_36)
	arg0_36:TriggerNextEventAuto()
end

function var0_0.PlayCV(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	local var0_37 = ShipWordHelper.RawGetCVKey(arg0_37.ship.skinId)
	local var1_37 = pg.CriMgr.GetCVBankName(var0_37)

	arg0_37.cvLoader:Load(var1_37, arg3_37, 0, arg4_37)
end

function var0_0.StartChatAnimtion(arg0_38, arg1_38, arg2_38)
	local var0_38 = 0.3
	local var1_38 = arg1_38 > 0 and arg1_38 or 3

	arg0_38:emit(MainWordView.START_ANIMATION, var0_38, var1_38)
	arg0_38:AddCharTimer(function()
		if arg0_38:IsUnload() then
			return
		end

		arg2_38()
	end, var0_38 * 3 + var1_38)
end

function var0_0.AddCharTimer(arg0_40, arg1_40, arg2_40)
	arg0_40:RemoveChatTimer()

	arg0_40.chatTimer = Timer.New(arg1_40, arg2_40, 1)

	arg0_40.chatTimer:Start()
end

function var0_0.RemoveChatTimer(arg0_41)
	if arg0_41.chatTimer then
		arg0_41.chatTimer:Stop()

		arg0_41.chatTimer = nil
	end
end

function var0_0.StopChatAnimtion(arg0_42)
	arg0_42:emit(MainWordView.STOP_ANIMATION)
	arg0_42:OnEndChatting()
end

function var0_0.OnStopVoice(arg0_43)
	arg0_43.cvLoader:Stop()
end

function var0_0.CollectIdleEvents(arg0_44, arg1_44)
	local var0_44 = {}

	if getProxy(EventProxy):hasFinishState() and arg1_44 ~= "event_complete" then
		table.insert(var0_44, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1_44 ~= "mission_complete" then
			table.insert(var0_44, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1_44 ~= "mail" then
			table.insert(var0_44, "mail")
		end

		if #var0_44 == 0 then
			local var1_44 = arg0_44.ship:getCVIntimacy()

			var0_44 = var5_0.filterAssistantEvents(Clone(var5_0.IdleEvents), arg0_44.ship.skinId, var1_44)

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1_44 ~= "mission" then
				table.insert(var0_44, "mission")
			end
		end
	end

	return var0_44
end

function var0_0.CollectTouchEvents(arg0_45)
	local var0_45 = arg0_45.ship:getCVIntimacy()

	return (var5_0.filterAssistantEvents(var5_0.PaintingTouchEvents, arg0_45.ship.skinId, var0_45))
end

function var0_0.GetTouchEvent(arg0_46, arg1_46)
	return (var5_0.filterAssistantEvents(var5_0.getAssistantTouchEvents(arg1_46, arg0_46.ship.skinId), arg0_46.ship.skinId, 0))
end

function var0_0.GetIdleEvents(arg0_47)
	return (var5_0.filterAssistantEvents(var5_0.IdleEvents, arg0_47.ship.skinId, 0))
end

function var0_0.GetEventConfig(arg0_48, arg1_48)
	return var5_0.assistantEvents[arg1_48]
end

function var0_0.GetSpecialTouchEvent(arg0_49, arg1_49)
	return var5_0.getPaintingTouchEvents(arg1_49)
end

function var0_0.RemoveTimer(arg0_50)
	if arg0_50.timer then
		arg0_50.timer:Stop()

		arg0_50.timer = nil
	end
end

function var0_0.IsExited(arg0_51)
	return arg0_51.isExited
end

function var0_0.Fold(arg0_52, arg1_52, arg2_52)
	arg0_52.isFoldState = arg1_52

	arg0_52:RemoveMoveTimer()
	arg0_52:OnFold(arg1_52)
end

function var0_0.RemoveMoveTimer(arg0_53)
	if arg0_53.moveTimer then
		arg0_53.moveTimer:Stop()

		arg0_53.moveTimer = nil
	end
end

function var0_0.EnableOrDisableMove(arg0_54, arg1_54)
	arg0_54.isDragAndZoomState = arg1_54

	arg0_54:RemoveMoveTimer()

	if arg1_54 then
		arg0_54:StopChatAnimtion()
		arg0_54:RemoveTimer()
		arg0_54.cvLoader:Stop()
	else
		arg0_54:TriggerNextEventAuto()
	end

	arg0_54:OnEnableOrDisableDragAndZoom(arg1_54)
end

function var0_0.GetOffset(arg0_55)
	return 0
end

function var0_0.IslimitYPos(arg0_56)
	return false
end

function var0_0.PauseForSilent(arg0_57)
	if arg0_57:IsLoaded() then
		arg0_57:_Pause()
	end
end

function var0_0._Pause(arg0_58)
	arg0_58.isPuase = true

	arg0_58:RemoveMoveTimer()
	arg0_58:StopChatAnimtion()
	arg0_58:RemoveChatTimer()
	arg0_58:RemoveTimer()
	arg0_58.cvLoader:Stop()
end

function var0_0.Puase(arg0_59)
	arg0_59:_Pause()
	arg0_59:OnPuase()
end

function var0_0.ResumeForSilent(arg0_60)
	if arg0_60:IsLoaded() then
		arg0_60:_Resume()
	end
end

function var0_0._Resume(arg0_61)
	arg0_61.isPuase = false

	arg0_61:TriggerNextEventAuto()
end

function var0_0.Resume(arg0_62)
	arg0_62:_Resume()
	arg0_62:OnResume()
end

function var0_0.updateShip(arg0_63, arg1_63)
	if arg1_63 and arg0_63.ship.id == arg1_63.id then
		arg0_63.ship = arg1_63
	end

	arg0_63:OnUpdateShip(arg1_63)
end

function var0_0.OnUpdateShip(arg0_64, arg1_64)
	return
end

function var0_0.Dispose(arg0_65)
	arg0_65:disposeEvent()

	arg0_65.isExited = true

	pg.DelegateInfo.Dispose(arg0_65)

	if arg0_65.state == var3_0 then
		arg0_65:UnLoad()
	end

	arg0_65.cvLoader:Dispose()

	arg0_65.cvLoader = nil
	arg0_65.triggerWhenLoaded = false

	arg0_65:RemoveTimer()
	arg0_65:RemoveMoveTimer()
	arg0_65:RemoveChatTimer()
end

function var0_0.OnLoad(arg0_66, arg1_66)
	arg1_66()
end

function var0_0.OnUnload(arg0_67)
	return
end

function var0_0.OnClick(arg0_68)
	return
end

function var0_0.OnLongPress(arg0_69)
	return
end

function var0_0.OnTriggerEvent(arg0_70)
	return
end

function var0_0.OnTriggerEventAuto(arg0_71)
	return
end

function var0_0.OnDisplayWorld(arg0_72, arg1_72)
	return
end

function var0_0.OnFold(arg0_73, arg1_73)
	return
end

function var0_0.OnEnableOrDisableDragAndZoom(arg0_74, arg1_74)
	return
end

function var0_0.OnPuase(arg0_75)
	return
end

function var0_0.OnResume(arg0_76)
	return
end

return var0_0
