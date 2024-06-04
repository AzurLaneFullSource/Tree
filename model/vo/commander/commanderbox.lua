local var0 = class("CommanderBox", import("..BaseVO"))

var0.STATE_EMPTY = -1
var0.STATE_WAITING = 0
var0.STATE_STARTING = 1
var0.STATE_FINISHED = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg1.id
	arg0.index = arg2 or 99
	arg0.configId = arg0.id
	arg0.finishTime = arg1.finish_time or 0
	arg0.beginTime = arg1.begin_time or 0

	local var0 = arg1.poolId or 0

	if var0 and var0 > 0 then
		arg0.pool = getProxy(CommanderProxy):getPoolById(var0)
	end
end

function var0.getPool(arg0)
	return arg0.pool
end

function var0.getFinishTime(arg0)
	return arg0.finishTime
end

function var0.ReduceFinishTime(arg0, arg1)
	arg0.finishTime = math.max(arg0.beginTime, arg0.finishTime - arg1)
end

function var0.costTime(arg0)
	local var0 = arg0:getState()

	if var0 == var0.STATE_STARTING or var0 == var0.STATE_FINISHED then
		return arg0.finishTime - arg0.beginTime
	else
		return 0
	end
end

function var0.getState(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0.finishTime == 0 then
		return var0.STATE_EMPTY
	elseif var0 >= arg0.finishTime then
		return var0.STATE_FINISHED
	elseif arg0.finishTime > 0 and var0 < arg0.beginTime then
		return var0.STATE_WAITING
	elseif arg0.finishTime > 0 and var0 < arg0.finishTime then
		return var0.STATE_STARTING
	end
end

function var0.finish(arg0)
	arg0.finishTime = 0
	arg0.beginTime = 0
end

function var0.getPrefab(arg0)
	if not arg0.rarity2Str then
		arg0.rarity2Str = {
			"",
			"SR",
			"SSR"
		}
	end

	if arg0.pool then
		local var0 = arg0.rarity2Str[arg0.pool:getRarity()]
		local var1 = arg0:getState()

		if var1 == var0.STATE_WAITING then
			return var0 .. "NekoBox1"
		elseif var1 == var0.STATE_STARTING then
			return var0 .. "NekoBox2"
		elseif var1 == var0.STATE_FINISHED then
			return var0 .. "NekoBox3"
		end
	else
		return nil
	end
end

function var0.getFetchPrefab(arg0)
	if not arg0.rarity2Str then
		arg0.rarity2Str = {
			"",
			"SR",
			"SSR"
		}
	end

	assert(arg0.pool)

	return arg0.rarity2Str[arg0.pool:getRarity()] .. "NekoBox4"
end

function var0.IsSsr(arg0)
	return arg0.pool:getRarity() == 3
end

function var0.IsSr(arg0)
	return arg0.pool:getRarity() == 2
end

function var0.IsR(arg0)
	return arg0.pool:getRarity() == 1
end

return var0
