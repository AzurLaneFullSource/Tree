local var0_0 = class("CourtYardEffectPool", import(".CourtYardPool"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.recycleTime = arg5_1 or 2

	pg.ViewUtils.SetLayer(tf(arg2_1), Layer.UI)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)

	arg0_1.timers = {}
end

function var0_0.Dequeue(arg0_2)
	local var0_2 = var0_0.super.Dequeue(arg0_2)

	arg0_2.timers[var0_2] = Timer.New(function()
		arg0_2:Enqueue(var0_2)
	end, arg0_2.recycleTime, 1)

	arg0_2.timers[var0_2]:Start()

	return var0_2
end

function var0_0.Dispose(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.timers) do
		arg0_4:Enqueue(iter0_4)
		iter1_4:Stop()
	end

	arg0_4.timers = nil

	var0_0.super.Dispose(arg0_4)
end

return var0_0
