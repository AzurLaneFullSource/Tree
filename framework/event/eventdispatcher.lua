ys = ys or {}

local var0 = ys
local var1 = class("EventDispatcher")

var0.EventDispatcher = var1
var1.__name = "EventDispatcher"
var1.FUNC_NAME_REGISTER = "RegisterEventListener"
var1.FUNC_NAME_UNREGISTER = "UnregisterEventListener"
var1.FUNC_NAME_DISPATCH = "DispatchEvent"

function var1.AttachEventDispatcher(arg0)
	var1.New(arg0)
end

function var1.DetachEventDispatcher(arg0)
	if arg0._dispatcher_ == nil then
		return
	end

	arg0._dispatcher_:_Destory_()

	arg0._dispatcher_ = nil
end

function var1.Ctor(arg0, arg1)
	arg0._target_ = arg1

	arg0:_Init_()
end

function var1._Init_(arg0)
	arg0._listenerMap_ = {}
	arg0._target_[var1.FUNC_NAME_REGISTER] = var1._RegisterEventListener_
	arg0._target_[var1.FUNC_NAME_UNREGISTER] = var1._UnregisterEventListener_
	arg0._target_[var1.FUNC_NAME_DISPATCH] = var1._DispatchEvent_
	arg0._target_._dispatcher_ = arg0
end

function var1._Destory_(arg0)
	arg0._listenerMap_ = nil
	arg0._target_ = nil
end

function var1._DispatchEvent_(arg0, arg1)
	local var0 = arg0._dispatcher_

	arg1.Dispatcher = arg1.Dispatcher or var0._target_

	local var1 = arg1.ID
	local var2 = var0._listenerMap_[var1]

	if var2 then
		for iter0, iter1 in ipairs(var2) do
			iter1:_Handle_(arg1)
		end
	end
end

function var1._RegisterEventListener_(arg0, arg1, arg2, arg3)
	local var0 = arg0._dispatcher_

	assert(arg1._eventListener_ ~= nil, "EventDispatcher ERROR" .. arg1.__cname)

	if var0._listenerMap_[arg2] == nil then
		var0._listenerMap_[arg2] = {}
	end

	local var1 = var0._listenerMap_[arg2]

	var1[#var1 + 1] = arg1._eventListener_

	arg1._eventListener_:_AddRoute_(arg2, arg0, arg3)
end

function var1._UnregisterEventListener_(arg0, arg1, arg2)
	local var0 = arg0._dispatcher_

	arg1 = arg1._eventListener_

	if var0._listenerMap_[arg2] == nil then
		return
	end

	local var1 = var0._listenerMap_[arg2]

	arg1:_RemoveRoute_(arg2, arg0)

	for iter0, iter1 in ipairs(var1) do
		if iter1 == arg1 then
			local var2 = iter0

			for iter2 = #var1, 1, -1 do
				var1[iter2] = nil
			end

			var1[#var1] = nil

			break
		end
	end

	if #var1 == 0 then
		var0._listenerMap_[arg2] = nil
	end
end
