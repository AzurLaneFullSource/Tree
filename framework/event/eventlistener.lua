ys = ys or {}

local var0_0 = ys

var0_0.EventListener = class("EventListener")
var0_0.EventListener.__name = "EventListener"

function var0_0.EventListener.AttachEventListener(arg0_1)
	var0_0.EventListener.New(arg0_1)
end

function var0_0.EventListener.DetachEventListener(arg0_2)
	if arg0_2._eventListener_ == nil then
		return
	end

	arg0_2._eventListener_:_Destory_()

	arg0_2._eventListener_ = nil
end

function var0_0.EventListener.Ctor(arg0_3, arg1_3)
	arg0_3._target_ = arg1_3
	arg0_3._target_._eventListener_ = arg0_3
	arg0_3._routeMap_ = {}
end

function var0_0.EventListener._Destory_(arg0_4)
	arg0_4._routeMap_ = nil
	arg0_4._target_ = nil
end

function var0_0.EventListener._AddRoute_(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg0_5._routeMap_[arg1_5] == nil then
		arg0_5._routeMap_[arg1_5] = {}
	end

	arg0_5._routeMap_[arg1_5][arg2_5] = arg3_5
end

function var0_0.EventListener._RemoveRoute_(arg0_6, arg1_6, arg2_6)
	arg0_6._routeMap_[arg1_6][arg2_6] = nil
end

function var0_0.EventListener._Handle_(arg0_7, arg1_7)
	local var0_7 = arg0_7._target_

	arg0_7._routeMap_[arg1_7.ID][arg1_7.Dispatcher](var0_7, arg1_7)
end
