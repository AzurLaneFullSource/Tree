local var0 = class("CourtYardEffectPool", import(".CourtYardPool"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.recycleTime = arg5 or 2

	pg.ViewUtils.SetLayer(tf(arg2), Layer.UI)
	var0.super.Ctor(arg0, arg1, arg2, arg3, arg4)

	arg0.timers = {}
end

function var0.Dequeue(arg0)
	local var0 = var0.super.Dequeue(arg0)

	arg0.timers[var0] = Timer.New(function()
		arg0:Enqueue(var0)
	end, arg0.recycleTime, 1)

	arg0.timers[var0]:Start()

	return var0
end

function var0.Dispose(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		arg0:Enqueue(iter0)
		iter1:Stop()
	end

	arg0.timers = nil

	var0.super.Dispose(arg0)
end

return var0
