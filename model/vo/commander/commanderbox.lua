local var0_0 = class("CommanderBox", import("..BaseVO"))

var0_0.STATE_EMPTY = -1
var0_0.STATE_WAITING = 0
var0_0.STATE_STARTING = 1
var0_0.STATE_FINISHED = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.id
	arg0_1.index = arg2_1 or 99
	arg0_1.configId = arg0_1.id
	arg0_1.finishTime = arg1_1.finish_time or 0
	arg0_1.beginTime = arg1_1.begin_time or 0

	local var0_1 = arg1_1.poolId or 0

	if var0_1 and var0_1 > 0 then
		arg0_1.pool = getProxy(CommanderProxy):getPoolById(var0_1)
	end
end

function var0_0.getPool(arg0_2)
	return arg0_2.pool
end

function var0_0.getFinishTime(arg0_3)
	return arg0_3.finishTime
end

function var0_0.ReduceFinishTime(arg0_4, arg1_4)
	arg0_4.finishTime = math.max(arg0_4.beginTime, arg0_4.finishTime - arg1_4)
end

function var0_0.costTime(arg0_5)
	local var0_5 = arg0_5:getState()

	if var0_5 == var0_0.STATE_STARTING or var0_5 == var0_0.STATE_FINISHED then
		return arg0_5.finishTime - arg0_5.beginTime
	else
		return 0
	end
end

function var0_0.getState(arg0_6)
	local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_6.finishTime == 0 then
		return var0_0.STATE_EMPTY
	elseif var0_6 >= arg0_6.finishTime then
		return var0_0.STATE_FINISHED
	elseif arg0_6.finishTime > 0 and var0_6 < arg0_6.beginTime then
		return var0_0.STATE_WAITING
	elseif arg0_6.finishTime > 0 and var0_6 < arg0_6.finishTime then
		return var0_0.STATE_STARTING
	end
end

function var0_0.finish(arg0_7)
	arg0_7.finishTime = 0
	arg0_7.beginTime = 0
end

function var0_0.getPrefab(arg0_8)
	if not arg0_8.rarity2Str then
		arg0_8.rarity2Str = {
			"",
			"SR",
			"SSR"
		}
	end

	if arg0_8.pool then
		local var0_8 = arg0_8.rarity2Str[arg0_8.pool:getRarity()]
		local var1_8 = arg0_8:getState()

		if var1_8 == var0_0.STATE_WAITING then
			return var0_8 .. "NekoBox1"
		elseif var1_8 == var0_0.STATE_STARTING then
			return var0_8 .. "NekoBox2"
		elseif var1_8 == var0_0.STATE_FINISHED then
			return var0_8 .. "NekoBox3"
		end
	else
		return nil
	end
end

function var0_0.getFetchPrefab(arg0_9)
	if not arg0_9.rarity2Str then
		arg0_9.rarity2Str = {
			"",
			"SR",
			"SSR"
		}
	end

	assert(arg0_9.pool)

	return arg0_9.rarity2Str[arg0_9.pool:getRarity()] .. "NekoBox4"
end

function var0_0.IsSsr(arg0_10)
	return arg0_10.pool:getRarity() == 3
end

function var0_0.IsSr(arg0_11)
	return arg0_11.pool:getRarity() == 2
end

function var0_0.IsR(arg0_12)
	return arg0_12.pool:getRarity() == 1
end

return var0_0
