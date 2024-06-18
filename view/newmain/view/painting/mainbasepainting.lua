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
		local var0_24 = arg0_23:CollectIdleEvents(arg0_23.lastChatEvent)

		arg0_23.lastChatEvent = var0_24[math.ceil(math.random(#var0_24))]

		arg0_23:_TriggerEvent(arg0_23.lastChatEvent)
		arg0_23:OnTriggerEventAuto()
		arg0_23:RemoveTimer()
	end, 30, 1, true)

	arg0_23.timer:Start()
end

function var0_0.OnStartChatting(arg0_25)
	arg0_25.chatting = true
end

function var0_0.OnEndChatting(arg0_26)
	arg0_26.chatting = false
end

function var0_0.GetWordAndCv(arg0_27, arg1_27, arg2_27)
	local var0_27, var1_27, var2_27, var3_27, var4_27, var5_27 = ShipWordHelper.GetCvDataForShip(arg0_27.ship, arg2_27)

	return var0_27, var1_27, var2_27, var3_27, var4_27, var5_27
end

function var0_0.DisplayWord(arg0_28, arg1_28)
	arg0_28:OnStartChatting()

	local var0_28, var1_28, var2_28, var3_28, var4_28, var5_28 = arg0_28:GetWordAndCv(arg0_28.ship, arg1_28)

	if not var2_28 or var2_28 == nil or var2_28 == "" or var2_28 == "nil" then
		arg0_28:OnEndChatting()

		return
	end

	arg0_28:OnDisplayWorld(arg1_28)
	arg0_28:emit(MainWordView.SET_CONTENT, arg1_28, var2_28)
	arg0_28:PlayCvAndAnimation(var4_28, var3_28, var1_28)
end

function var0_0.PlayCvAndAnimation(arg0_29, arg1_29, arg2_29, arg3_29)
	if getProxy(ContextProxy):getContextByMediator(NewShipMediator) then
		arg0_29:OnEndChatting()

		return
	end

	local var0_29 = -1

	seriesAsync({
		function(arg0_30)
			if not arg3_29 or not not pg.NewStoryMgr.GetInstance():IsRunning() then
				arg0_30()

				return
			end

			arg0_29:PlayCV(arg1_29, arg2_29, arg3_29, function(arg0_31)
				var0_29 = arg0_31

				arg0_30()
			end)
		end,
		function(arg0_32)
			arg0_29:StartChatAnimtion(var0_29, arg0_32)
		end
	}, function()
		arg0_29:OnDisplayWordEnd()
	end)
end

function var0_0.OnDisplayWordEnd(arg0_34)
	arg0_34:TriggerNextEventAuto()
end

function var0_0.PlayCV(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	local var0_35 = ShipWordHelper.RawGetCVKey(arg0_35.ship.skinId)
	local var1_35 = pg.CriMgr.GetCVBankName(var0_35)

	arg0_35.cvLoader:Load(var1_35, arg3_35, 0, arg4_35)
end

function var0_0.StartChatAnimtion(arg0_36, arg1_36, arg2_36)
	local var0_36 = 0.3
	local var1_36 = arg1_36 > 0 and arg1_36 or 3

	arg0_36:emit(MainWordView.START_ANIMATION, var0_36, var1_36)
	arg0_36:AddCharTimer(function()
		if arg0_36:IsUnload() then
			return
		end

		arg2_36()
	end, var0_36 * 3 + var1_36)
end

function var0_0.AddCharTimer(arg0_38, arg1_38, arg2_38)
	arg0_38:RemoveChatTimer()

	arg0_38.chatTimer = Timer.New(arg1_38, arg2_38, 1)

	arg0_38.chatTimer:Start()
end

function var0_0.RemoveChatTimer(arg0_39)
	if arg0_39.chatTimer then
		arg0_39.chatTimer:Stop()

		arg0_39.chatTimer = nil
	end
end

function var0_0.StopChatAnimtion(arg0_40)
	arg0_40:emit(MainWordView.STOP_ANIMATION)
	arg0_40:OnEndChatting()
end

function var0_0.OnStopVoice(arg0_41)
	arg0_41.cvLoader:Stop()
end

function var0_0.CollectIdleEvents(arg0_42, arg1_42)
	local var0_42 = {}

	if getProxy(EventProxy):hasFinishState() and arg1_42 ~= "event_complete" then
		table.insert(var0_42, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1_42 ~= "mission_complete" then
			table.insert(var0_42, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1_42 ~= "mail" then
			table.insert(var0_42, "mail")
		end

		if #var0_42 == 0 then
			local var1_42 = arg0_42.ship:getCVIntimacy()

			var0_42 = var5_0.filterAssistantEvents(Clone(var5_0.IdleEvents), arg0_42.ship.skinId, var1_42)

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1_42 ~= "mission" then
				table.insert(var0_42, "mission")
			end
		end
	end

	return var0_42
end

function var0_0.CollectTouchEvents(arg0_43)
	local var0_43 = arg0_43.ship:getCVIntimacy()

	return (var5_0.filterAssistantEvents(var5_0.PaintingTouchEvents, arg0_43.ship.skinId, var0_43))
end

function var0_0.GetTouchEvent(arg0_44, arg1_44)
	return (var5_0.filterAssistantEvents(var5_0.getAssistantTouchEvents(arg1_44, arg0_44.ship.skinId), arg0_44.ship.skinId, 0))
end

function var0_0.GetIdleEvents(arg0_45)
	return (var5_0.filterAssistantEvents(var5_0.IdleEvents, arg0_45.ship.skinId, 0))
end

function var0_0.GetEventConfig(arg0_46, arg1_46)
	return var5_0.assistantEvents[arg1_46]
end

function var0_0.GetSpecialTouchEvent(arg0_47, arg1_47)
	return var5_0.getPaintingTouchEvents(arg1_47)
end

function var0_0.RemoveTimer(arg0_48)
	if arg0_48.timer then
		arg0_48.timer:Stop()

		arg0_48.timer = nil
	end
end

function var0_0.IsExited(arg0_49)
	return arg0_49.isExited
end

function var0_0.Fold(arg0_50, arg1_50, arg2_50)
	arg0_50.isFoldState = arg1_50

	arg0_50:RemoveMoveTimer()
	arg0_50:OnFold(arg1_50)
end

function var0_0.RemoveMoveTimer(arg0_51)
	if arg0_51.moveTimer then
		arg0_51.moveTimer:Stop()

		arg0_51.moveTimer = nil
	end
end

function var0_0.EnableOrDisableMove(arg0_52, arg1_52)
	arg0_52.isDragAndZoomState = arg1_52

	arg0_52:RemoveMoveTimer()

	if arg1_52 then
		arg0_52:StopChatAnimtion()
		arg0_52:RemoveTimer()
		arg0_52.cvLoader:Stop()
	else
		arg0_52:TriggerNextEventAuto()
	end

	arg0_52:OnEnableOrDisableDragAndZoom(arg1_52)
end

function var0_0.GetOffset(arg0_53)
	return 0
end

function var0_0.IslimitYPos(arg0_54)
	return false
end

function var0_0.PauseForSilent(arg0_55)
	if arg0_55:IsLoaded() then
		arg0_55:_Pause()
	end
end

function var0_0._Pause(arg0_56)
	arg0_56.isPuase = true

	arg0_56:RemoveMoveTimer()
	arg0_56:StopChatAnimtion()
	arg0_56:RemoveChatTimer()
	arg0_56:RemoveTimer()
	arg0_56.cvLoader:Stop()
end

function var0_0.Puase(arg0_57)
	arg0_57:_Pause()
	arg0_57:OnPuase()
end

function var0_0.ResumeForSilent(arg0_58)
	if arg0_58:IsLoaded() then
		arg0_58:_Resume()
	end
end

function var0_0._Resume(arg0_59)
	arg0_59.isPuase = false

	arg0_59:TriggerNextEventAuto()
end

function var0_0.Resume(arg0_60)
	arg0_60:_Resume()
	arg0_60:OnResume()
end

function var0_0.updateShip(arg0_61, arg1_61)
	if arg1_61 and arg0_61.ship.id == arg1_61.id then
		arg0_61.ship = arg1_61
	end

	arg0_61:OnUpdateShip(arg1_61)
end

function var0_0.OnUpdateShip(arg0_62, arg1_62)
	return
end

function var0_0.Dispose(arg0_63)
	arg0_63:disposeEvent()

	arg0_63.isExited = true

	pg.DelegateInfo.Dispose(arg0_63)

	if arg0_63.state == var3_0 then
		arg0_63:UnLoad()
	end

	arg0_63.cvLoader:Dispose()

	arg0_63.cvLoader = nil
	arg0_63.triggerWhenLoaded = false

	arg0_63:RemoveTimer()
	arg0_63:RemoveMoveTimer()
	arg0_63:RemoveChatTimer()
end

function var0_0.OnLoad(arg0_64, arg1_64)
	arg1_64()
end

function var0_0.OnUnload(arg0_65)
	return
end

function var0_0.OnClick(arg0_66)
	return
end

function var0_0.OnLongPress(arg0_67)
	return
end

function var0_0.OnTriggerEvent(arg0_68)
	return
end

function var0_0.OnTriggerEventAuto(arg0_69)
	return
end

function var0_0.OnDisplayWorld(arg0_70, arg1_70)
	return
end

function var0_0.OnFold(arg0_71, arg1_71)
	return
end

function var0_0.OnEnableOrDisableDragAndZoom(arg0_72, arg1_72)
	return
end

function var0_0.OnPuase(arg0_73)
	return
end

function var0_0.OnResume(arg0_74)
	return
end

return var0_0
