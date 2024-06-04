local var0 = class("MainBasePainting", import("view.base.BaseEventLogic"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.container = arg1
	arg0.state = var1
	var5 = pg.AssistantInfo
	arg0.wordPosition = arg1:Find("live2d")
	arg0.cvLoader = MainCVLoader.New()
	arg0.longPressEvent = arg1:GetComponent("UILongPressTrigger").onLongPressed
end

function var0.IsUnload(arg0)
	return arg0.state == var4
end

function var0.GetCenterPos(arg0)
	return arg0.wordPosition.position
end

function var0.IsLoading(arg0)
	return arg0.state == var2
end

function var0.IsLoaded(arg0)
	return arg0.state == var3
end

function var0.Load(arg0, arg1)
	arg0.isPuase = false
	arg0.isExited = false
	arg0.state = var2
	arg0.ship = arg1
	arg0.paintingName = arg1:getPainting()

	arg0:OnLoad(function()
		arg0.state = var3

		if arg0.triggerWhenLoaded then
			arg0:TriggerEventAtFirstTime()
		end

		arg0:InitClickEvent()
	end)
end

function var0.Unload(arg0)
	arg0.state = var4

	removeOnButton(arg0.container)
	arg0.longPressEvent:RemoveAllListeners()
	arg0:StopChatAnimtion()
	arg0.cvLoader:Stop()
	arg0:RemoveTimer()
	arg0:OnUnload()

	arg0.paintingName = nil

	LeanTween.cancel(arg0.container.gameObject)
end

function var0.UnloadOnlyPainting(arg0)
	arg0.state = var4

	removeOnButton(arg0.container)
	arg0.longPressEvent:RemoveAllListeners()
	arg0:RemoveTimer()
	arg0:OnUnload()

	arg0.paintingName = nil
end

function var0.InitClickEvent(arg0)
	onButton(arg0, arg0.container, function()
		arg0:OnClick()
		arg0:TriggerPersonalTask(arg0.ship.groupId)
	end)
	arg0.longPressEvent:RemoveAllListeners()
	arg0.longPressEvent:AddListener(function()
		if getProxy(ContextProxy):getCurrentContext().viewComponent.__cname == "NewMainScene" then
			arg0:OnLongPress()
		end
	end)
end

function var0.TriggerPersonalTask(arg0, arg1)
	if arg0.isFoldState then
		return
	end

	arg0:TriggerInterActionTask()

	local var0 = getProxy(TaskProxy)

	for iter0, iter1 in ipairs(pg.task_data_trigger.all) do
		local var1 = pg.task_data_trigger[iter1]

		if var1.group_id == arg1 then
			local var2 = var1.task_id

			if not var0:getFinishTaskById(var2) then
				arg0:CheckStoryDownload(var2, function()
					pg.m02:sendNotification(GAME.TRIGGER_TASK, var2)
				end)

				break
			end
		end
	end
end

function var0.TriggerInterActionTask(arg0)
	local var0 = getProxy(TaskProxy):GetFlagShipInterActionTaskList()

	if var0 and #var0 > 0 then
		for iter0, iter1 in ipairs(var0) do
			pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
				taskId = iter1.id
			})
		end
	end
end

function var0.CheckStoryDownload(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1

	while true do
		local var2 = pg.task_data_template[var1]

		if var2.story_id ~= "" then
			table.insert(var0, var2.story_id)
		end

		if var2.next_task == "" or var2.next_task == "0" then
			break
		end

		var1 = var1 + 1
	end

	local var3 = pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var0)
	local var4 = _.map(var3, function(arg0)
		return "painting/" .. arg0
	end)

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var4,
		finishFunc = arg2
	})
end

function var0.TriggerEventAtFirstTime(arg0)
	if not arg0:IsLoaded() then
		arg0.triggerWhenLoaded = true

		return
	end

	arg0.triggerWhenLoaded = false

	arg0:OnFirstTimeTriggerEvent()
end

function var0.OnFirstTimeTriggerEvent(arg0)
	local function var0(arg0)
		arg0:_TriggerEvent(arg0)
	end

	if getProxy(PlayerProxy):getFlag("login") then
		getProxy(PlayerProxy):setFlag("login", nil)
		var0("event_login")
	elseif getProxy(PlayerProxy):getFlag("battle") then
		getProxy(PlayerProxy):setFlag("battle", nil)
		var0("home")
	else
		arg0:TriggerNextEventAuto()
	end
end

function var0._TriggerEvent(arg0, arg1)
	local var0 = var5.assistantEvents[arg1]

	if var0.dialog ~= "" then
		arg0:DisplayWord(var0.dialog)
	else
		arg0:TriggerNextEventAuto()
	end
end

function var0.TriggerEvent(arg0, arg1)
	if arg0.isDragAndZoomState then
		return
	end

	if arg0.chatting then
		return
	end

	arg0:RemoveTimer()
	arg0:_TriggerEvent(arg1)
	arg0:OnTriggerEvent()
end

function var0.TriggerNextEventAuto(arg0)
	if arg0.isPuase or arg0.isExited then
		return
	end

	arg0:OnEndChatting()
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		local var0 = arg0:CollectIdleEvents(arg0.lastChatEvent)

		arg0.lastChatEvent = var0[math.ceil(math.random(#var0))]

		arg0:_TriggerEvent(arg0.lastChatEvent)
		arg0:OnTriggerEventAuto()
		arg0:RemoveTimer()
	end, 30, 1, true)

	arg0.timer:Start()
end

function var0.OnStartChatting(arg0)
	arg0.chatting = true
end

function var0.OnEndChatting(arg0)
	arg0.chatting = false
end

function var0.GetWordAndCv(arg0, arg1, arg2)
	local var0, var1, var2, var3, var4, var5 = ShipWordHelper.GetCvDataForShip(arg0.ship, arg2)

	return var0, var1, var2, var3, var4, var5
end

function var0.DisplayWord(arg0, arg1)
	arg0:OnStartChatting()

	local var0, var1, var2, var3, var4, var5 = arg0:GetWordAndCv(arg0.ship, arg1)

	if not var2 or var2 == nil or var2 == "" or var2 == "nil" then
		arg0:OnEndChatting()

		return
	end

	arg0:OnDisplayWorld(arg1)
	arg0:emit(MainWordView.SET_CONTENT, arg1, var2)
	arg0:PlayCvAndAnimation(var4, var3, var1)
end

function var0.PlayCvAndAnimation(arg0, arg1, arg2, arg3)
	if getProxy(ContextProxy):getContextByMediator(NewShipMediator) then
		arg0:OnEndChatting()

		return
	end

	local var0 = -1

	seriesAsync({
		function(arg0)
			if not arg3 or not not pg.NewStoryMgr.GetInstance():IsRunning() then
				arg0()

				return
			end

			arg0:PlayCV(arg1, arg2, arg3, function(arg0)
				var0 = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0:StartChatAnimtion(var0, arg0)
		end
	}, function()
		arg0:OnDisplayWordEnd()
	end)
end

function var0.OnDisplayWordEnd(arg0)
	arg0:TriggerNextEventAuto()
end

function var0.PlayCV(arg0, arg1, arg2, arg3, arg4)
	local var0 = ShipWordHelper.RawGetCVKey(arg0.ship.skinId)
	local var1 = pg.CriMgr.GetCVBankName(var0)

	arg0.cvLoader:Load(var1, arg3, 0, arg4)
end

function var0.StartChatAnimtion(arg0, arg1, arg2)
	local var0 = 0.3
	local var1 = arg1 > 0 and arg1 or 3

	arg0:emit(MainWordView.START_ANIMATION, var0, var1)
	arg0:AddCharTimer(function()
		if arg0:IsUnload() then
			return
		end

		arg2()
	end, var0 * 3 + var1)
end

function var0.AddCharTimer(arg0, arg1, arg2)
	arg0:RemoveChatTimer()

	arg0.chatTimer = Timer.New(arg1, arg2, 1)

	arg0.chatTimer:Start()
end

function var0.RemoveChatTimer(arg0)
	if arg0.chatTimer then
		arg0.chatTimer:Stop()

		arg0.chatTimer = nil
	end
end

function var0.StopChatAnimtion(arg0)
	arg0:emit(MainWordView.STOP_ANIMATION)
	arg0:OnEndChatting()
end

function var0.OnStopVoice(arg0)
	arg0.cvLoader:Stop()
end

function var0.CollectIdleEvents(arg0, arg1)
	local var0 = {}

	if getProxy(EventProxy):hasFinishState() and arg1 ~= "event_complete" then
		table.insert(var0, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1 ~= "mission_complete" then
			table.insert(var0, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1 ~= "mail" then
			table.insert(var0, "mail")
		end

		if #var0 == 0 then
			local var1 = arg0.ship:getCVIntimacy()

			var0 = var5.filterAssistantEvents(Clone(var5.IdleEvents), arg0.ship.skinId, var1)

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1 ~= "mission" then
				table.insert(var0, "mission")
			end
		end
	end

	return var0
end

function var0.CollectTouchEvents(arg0)
	local var0 = arg0.ship:getCVIntimacy()

	return (var5.filterAssistantEvents(var5.PaintingTouchEvents, arg0.ship.skinId, var0))
end

function var0.GetTouchEvent(arg0, arg1)
	return (var5.filterAssistantEvents(var5.getAssistantTouchEvents(arg1, arg0.ship.skinId), arg0.ship.skinId, 0))
end

function var0.GetIdleEvents(arg0)
	return (var5.filterAssistantEvents(var5.IdleEvents, arg0.ship.skinId, 0))
end

function var0.GetEventConfig(arg0, arg1)
	return var5.assistantEvents[arg1]
end

function var0.GetSpecialTouchEvent(arg0, arg1)
	return var5.getPaintingTouchEvents(arg1)
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.IsExited(arg0)
	return arg0.isExited
end

function var0.Fold(arg0, arg1, arg2)
	arg0.isFoldState = arg1

	arg0:RemoveMoveTimer()
	arg0:OnFold(arg1)
end

function var0.RemoveMoveTimer(arg0)
	if arg0.moveTimer then
		arg0.moveTimer:Stop()

		arg0.moveTimer = nil
	end
end

function var0.EnableOrDisableMove(arg0, arg1)
	arg0.isDragAndZoomState = arg1

	arg0:RemoveMoveTimer()

	if arg1 then
		arg0:StopChatAnimtion()
		arg0:RemoveTimer()
		arg0.cvLoader:Stop()
	else
		arg0:TriggerNextEventAuto()
	end

	arg0:OnEnableOrDisableDragAndZoom(arg1)
end

function var0.GetOffset(arg0)
	return 0
end

function var0.IslimitYPos(arg0)
	return false
end

function var0.PauseForSilent(arg0)
	if arg0:IsLoaded() then
		arg0:_Pause()
	end
end

function var0._Pause(arg0)
	arg0.isPuase = true

	arg0:RemoveMoveTimer()
	arg0:StopChatAnimtion()
	arg0:RemoveChatTimer()
	arg0:RemoveTimer()
	arg0.cvLoader:Stop()
end

function var0.Puase(arg0)
	arg0:_Pause()
	arg0:OnPuase()
end

function var0.ResumeForSilent(arg0)
	if arg0:IsLoaded() then
		arg0:_Resume()
	end
end

function var0._Resume(arg0)
	arg0.isPuase = false

	arg0:TriggerNextEventAuto()
end

function var0.Resume(arg0)
	arg0:_Resume()
	arg0:OnResume()
end

function var0.updateShip(arg0, arg1)
	if arg1 and arg0.ship.id == arg1.id then
		arg0.ship = arg1
	end

	arg0:OnUpdateShip(arg1)
end

function var0.OnUpdateShip(arg0, arg1)
	return
end

function var0.Dispose(arg0)
	arg0:disposeEvent()

	arg0.isExited = true

	pg.DelegateInfo.Dispose(arg0)

	if arg0.state == var3 then
		arg0:UnLoad()
	end

	arg0.cvLoader:Dispose()

	arg0.cvLoader = nil
	arg0.triggerWhenLoaded = false

	arg0:RemoveTimer()
	arg0:RemoveMoveTimer()
	arg0:RemoveChatTimer()
end

function var0.OnLoad(arg0, arg1)
	arg1()
end

function var0.OnUnload(arg0)
	return
end

function var0.OnClick(arg0)
	return
end

function var0.OnLongPress(arg0)
	return
end

function var0.OnTriggerEvent(arg0)
	return
end

function var0.OnTriggerEventAuto(arg0)
	return
end

function var0.OnDisplayWorld(arg0, arg1)
	return
end

function var0.OnFold(arg0, arg1)
	return
end

function var0.OnEnableOrDisableDragAndZoom(arg0, arg1)
	return
end

function var0.OnPuase(arg0)
	return
end

function var0.OnResume(arg0)
	return
end

return var0
