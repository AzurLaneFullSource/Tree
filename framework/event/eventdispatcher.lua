ys = ys or {}

local var0_0 = ys
local var1_0 = class("EventDispatcher")

var0_0.EventDispatcher = var1_0
var1_0.__name = "EventDispatcher"
var1_0.FUNC_NAME_REGISTER = "RegisterEventListener"
var1_0.FUNC_NAME_UNREGISTER = "UnregisterEventListener"
var1_0.FUNC_NAME_DISPATCH = "DispatchEvent"

function var1_0.AttachEventDispatcher(arg0_1)
	var1_0.New(arg0_1)
end

function var1_0.DetachEventDispatcher(arg0_2)
	if arg0_2._dispatcher_ == nil then
		return
	end

	arg0_2._dispatcher_:_Destory_()

	arg0_2._dispatcher_ = nil
end

function var1_0.Ctor(arg0_3, arg1_3)
	arg0_3._target_ = arg1_3

	arg0_3:_Init_()
end

function var1_0._Init_(arg0_4)
	arg0_4._listenerMap_ = {}
	arg0_4._target_[var1_0.FUNC_NAME_REGISTER] = var1_0._RegisterEventListener_
	arg0_4._target_[var1_0.FUNC_NAME_UNREGISTER] = var1_0._UnregisterEventListener_
	arg0_4._target_[var1_0.FUNC_NAME_DISPATCH] = var1_0._DispatchEvent_
	arg0_4._target_._dispatcher_ = arg0_4
end

function var1_0._Destory_(arg0_5)
	arg0_5._listenerMap_ = nil
	arg0_5._target_ = nil
end

function var1_0._DispatchEvent_(arg0_6, arg1_6)
	local var0_6 = arg0_6._dispatcher_

	arg1_6.Dispatcher = arg1_6.Dispatcher or var0_6._target_

	local var1_6 = arg1_6.ID
	local var2_6 = var0_6._listenerMap_[var1_6]

	if var2_6 then
		for iter0_6, iter1_6 in ipairs(var2_6) do
			iter1_6:_Handle_(arg1_6)
		end
	end
end

function var1_0._RegisterEventListener_(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg0_7._dispatcher_

	assert(arg1_7._eventListener_ ~= nil, "EventDispatcher ERROR" .. arg1_7.__cname)

	if var0_7._listenerMap_[arg2_7] == nil then
		var0_7._listenerMap_[arg2_7] = {}
	end

	local var1_7 = var0_7._listenerMap_[arg2_7]

	var1_7[#var1_7 + 1] = arg1_7._eventListener_

	arg1_7._eventListener_:_AddRoute_(arg2_7, arg0_7, arg3_7)
end

function var1_0._UnregisterEventListener_(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8._dispatcher_

	arg1_8 = arg1_8._eventListener_

	if var0_8._listenerMap_[arg2_8] == nil then
		return
	end

	local var1_8 = var0_8._listenerMap_[arg2_8]

	arg1_8:_RemoveRoute_(arg2_8, arg0_8)

	for iter0_8, iter1_8 in ipairs(var1_8) do
		if iter1_8 == arg1_8 then
			local var2_8 = iter0_8

			for iter2_8 = #var1_8, 1, -1 do
				var1_8[iter2_8] = nil
			end

			var1_8[#var1_8] = nil

			break
		end
	end

	if #var1_8 == 0 then
		var0_8._listenerMap_[arg2_8] = nil
	end
end
