ys = ys or {}

local var0 = ys

var0.Event = class("Event")
var0.Event.__name = "Event"

function var0.Event.Ctor(arg0, arg1, arg2, arg3)
	arg0.ID = arg1
	arg0.Data = arg2
	arg0.Dispatcher = arg3
end

return var0.Event
