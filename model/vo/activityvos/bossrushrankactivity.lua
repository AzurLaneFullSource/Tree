local var0 = class("BossRushRankActivity", import("model.vo.Activity"))

function var0.GetScore(arg0)
	return arg0.data1
end

function var0.Record(arg0, arg1)
	local var0 = getProxy(ActivityProxy):GetBossRushRuntime(arg0.id).record + arg1

	getProxy(ActivityProxy):GetBossRushRuntime(arg0.id).record = var0
	arg0.data1 = math.max(arg0.data1, var0)
end

function var0.ResetLast(arg0)
	getProxy(ActivityProxy):GetBossRushRuntime(arg0.id).record = 0
end

return var0
