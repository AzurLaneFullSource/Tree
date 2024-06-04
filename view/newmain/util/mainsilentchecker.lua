local var0 = class("MainSilentChecker", import("view.base.BaseEventLogic"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.inactivityTimeout = pg.gameset.main_scene_silent_time.key_value
end

function var0.SetUp(arg0)
	arg0:Clear()

	arg0.lastActivityTime = Time.time

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)

	arg0.isFoldState = false

	arg0:bind(NewMainScene.FOLD, function(arg0, arg1)
		arg0.isFoldState = arg1
	end)
end

function var0.Update(arg0)
	if IsUnityEditor then
		if Input.anyKeyDown then
			arg0.lastActivityTime = Time.time
		end
	elseif Input.touchCount > 0 then
		arg0.lastActivityTime = Time.time
	end

	if Time.time - arg0.lastActivityTime > arg0.inactivityTimeout then
		arg0:EnterState()
	end
end

function var0.EnterState(arg0)
	if arg0:AnyOverlayShowing() then
		arg0.lastActivityTime = Time.time

		return
	end

	arg0:Clear()
	arg0:emit(NewMainScene.ENTER_SILENT_VIEW)
end

function var0.AnyOverlayShowing(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext()
	local var1 = pg.LayerWeightMgr.GetInstance().uiOrigin

	return pg.NewStoryMgr.GetInstance():IsRunning() or pg.NewGuideMgr.GetInstance():IsBusy() or isActive(pg.MsgboxMgr.GetInstance()._tf) or var0:hasChild() or var1.childCount > 0 or arg0.isFoldState
end

function var0.Clear(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)

		arg0.handle = nil
	end

	arg0:disposeEvent()

	arg0.isFoldState = false
end

function var0.Disable(arg0)
	arg0:Clear()
end

function var0.Dispose(arg0)
	arg0:Disable()
end

return var0
