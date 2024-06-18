local var0_0 = class("BossRushRankActivity", import("model.vo.Activity"))

function var0_0.GetScore(arg0_1)
	return arg0_1.data1
end

function var0_0.Record(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):GetBossRushRuntime(arg0_2.id).record + arg1_2

	getProxy(ActivityProxy):GetBossRushRuntime(arg0_2.id).record = var0_2
	arg0_2.data1 = math.max(arg0_2.data1, var0_2)
end

function var0_0.ResetLast(arg0_3)
	getProxy(ActivityProxy):GetBossRushRuntime(arg0_3.id).record = 0
end

return var0_0
