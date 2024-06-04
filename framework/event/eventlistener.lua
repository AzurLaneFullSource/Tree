ys = ys or {}

local var0 = ys

var0.EventListener = class("EventListener")
var0.EventListener.__name = "EventListener"

function var0.EventListener.AttachEventListener(arg0)
	var0.EventListener.New(arg0)
end

function var0.EventListener.DetachEventListener(arg0)
	if arg0._eventListener_ == nil then
		return
	end

	arg0._eventListener_:_Destory_()

	arg0._eventListener_ = nil
end

function var0.EventListener.Ctor(arg0, arg1)
	arg0._target_ = arg1
	arg0._target_._eventListener_ = arg0
	arg0._routeMap_ = {}
end

function var0.EventListener._Destory_(arg0)
	arg0._routeMap_ = nil
	arg0._target_ = nil
end

function var0.EventListener._AddRoute_(arg0, arg1, arg2, arg3)
	if arg0._routeMap_[arg1] == nil then
		arg0._routeMap_[arg1] = {}
	end

	arg0._routeMap_[arg1][arg2] = arg3
end

function var0.EventListener._RemoveRoute_(arg0, arg1, arg2)
	arg0._routeMap_[arg1][arg2] = nil
end

function var0.EventListener._Handle_(arg0, arg1)
	local var0 = arg0._target_

	arg0._routeMap_[arg1.ID][arg1.Dispatcher](var0, arg1)
end
