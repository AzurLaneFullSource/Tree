ys = ys or {}

local var0_0 = ys

var0_0.Event = class("Event")
var0_0.Event.__name = "Event"

function var0_0.Event.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.ID = arg1_1
	arg0_1.Data = arg2_1
	arg0_1.Dispatcher = arg3_1
end

return var0_0.Event
