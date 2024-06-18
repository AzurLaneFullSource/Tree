local var0_0 = class("MainSilentChecker", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.inactivityTimeout = pg.gameset.main_scene_silent_time.key_value
end

function var0_0.SetUp(arg0_2)
	arg0_2:Clear()

	arg0_2.lastActivityTime = Time.time

	if not arg0_2.handle then
		arg0_2.handle = UpdateBeat:CreateListener(arg0_2.Update, arg0_2)
	end

	UpdateBeat:AddListener(arg0_2.handle)

	arg0_2.isFoldState = false

	arg0_2:bind(NewMainScene.FOLD, function(arg0_3, arg1_3)
		arg0_2.isFoldState = arg1_3
	end)
end

function var0_0.Update(arg0_4)
	if IsUnityEditor then
		if Input.anyKeyDown then
			arg0_4.lastActivityTime = Time.time
		end
	elseif Input.touchCount > 0 then
		arg0_4.lastActivityTime = Time.time
	end

	if Time.time - arg0_4.lastActivityTime > arg0_4.inactivityTimeout then
		arg0_4:EnterState()
	end
end

function var0_0.EnterState(arg0_5)
	if arg0_5:AnyOverlayShowing() then
		arg0_5.lastActivityTime = Time.time

		return
	end

	arg0_5:Clear()
	arg0_5:emit(NewMainScene.ENTER_SILENT_VIEW)
end

function var0_0.AnyOverlayShowing(arg0_6)
	local var0_6 = getProxy(ContextProxy):getCurrentContext()
	local var1_6 = pg.LayerWeightMgr.GetInstance().uiOrigin

	return pg.NewStoryMgr.GetInstance():IsRunning() or pg.NewGuideMgr.GetInstance():IsBusy() or isActive(pg.MsgboxMgr.GetInstance()._tf) or var0_6:hasChild() or var1_6.childCount > 0 or arg0_6.isFoldState
end

function var0_0.Clear(arg0_7)
	if arg0_7.handle then
		UpdateBeat:RemoveListener(arg0_7.handle)

		arg0_7.handle = nil
	end

	arg0_7:disposeEvent()

	arg0_7.isFoldState = false
end

function var0_0.Disable(arg0_8)
	arg0_8:Clear()
end

function var0_0.Dispose(arg0_9)
	arg0_9:Disable()
end

return var0_0
