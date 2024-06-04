local var0 = class("Cattery", import("...BaseVO"))

var0.STATE_LOCK = 1
var0.STATE_EMPTY = 2
var0.STATE_OCCUPATION = 3
var0.OP_CLEAR = 1
var0.OP_FEED = 2
var0.OP_PLAY = 4

function var0.Ctor(arg0, arg1, arg2)
	arg0.home = arg1
	arg0.id = arg2.id
	arg0.op = arg2.op_flag or 0
	arg0.expSettlementTime = arg2.exp_time
	arg0.commanderId = arg2.commander_id or 0
	arg0.style = arg2.style or 1
	arg0.opClean = bit.band(arg0.op, var0.OP_CLEAR) > 0
	arg0.opFeed = bit.band(arg0.op, var0.OP_FEED) > 0
	arg0.opPlay = bit.band(arg0.op, var0.OP_PLAY) > 0
	arg0.cacheExp = arg2.cache_exp or 0
end

function var0.AddCommander(arg0, arg1, arg2)
	arg0.commanderId = arg1
	arg0.expSettlementTime = arg2

	arg0:ClearCacheExp()
end

function var0.ReplaceCommander(arg0, arg1)
	arg0.commanderId = arg1

	arg0:ClearCacheExp()
end

function var0.RemoveCommander(arg0)
	arg0.commanderId = 0

	arg0:ClearCacheExp()
end

function var0.ExistCommander(arg0)
	return arg0.commanderId ~= 0 and getProxy(CommanderProxy):RawGetCommanderById(arg0.commanderId) ~= nil
end

function var0.GetCommanderId(arg0)
	return arg0.commanderId
end

function var0.GetCommander(arg0)
	if arg0:ExistCommander() then
		return getProxy(CommanderProxy):getCommanderById(arg0.commanderId)
	end
end

function var0.CommanderCanClean(arg0)
	if arg0:ExistCommander() then
		return arg0:GetCommander():ExistCleanFlag()
	end

	return false
end

function var0.CommanderCanFeed(arg0)
	if arg0:ExistCommander() then
		return arg0:GetCommander():ExitFeedFlag()
	end

	return false
end

function var0.CommanderCanPlay(arg0)
	if arg0:ExistCommander() then
		return arg0:GetCommander():ExitPlayFlag()
	end

	return false
end

function var0.CommanderCanOP(arg0, arg1)
	if arg1 == 1 then
		return arg0:CommanderCanClean()
	elseif arg1 == 2 then
		return arg0:CommanderCanFeed()
	elseif arg1 == 3 then
		return arg0:CommanderCanPlay()
	end
end

function var0.GetStyle(arg0)
	return arg0.style
end

function var0._GetStyle_(arg0)
	return CatteryStyle.New({
		own = true,
		id = arg0.style
	})
end

function var0.UpdateStyle(arg0, arg1)
	arg0.style = arg1
end

function var0.IsDirty(arg0)
	return arg0.opClean == true
end

function var0.GetOP(arg0)
	return arg0.op
end

function var0.ExistCleanOP(arg0)
	return arg0.opClean
end

function var0.ClearCleanOP(arg0)
	arg0.opClean = false
end

function var0.ExiseFeedOP(arg0)
	return arg0.opFeed
end

function var0.ClearFeedOP(arg0)
	arg0.opFeed = false
end

function var0.ExistPlayOP(arg0)
	return arg0.opPlay
end

function var0.ClearPlayOP(arg0)
	arg0.opPlay = false
end

function var0.ExistOP(arg0, arg1)
	if arg1 == 1 then
		return arg0:ExistCleanOP()
	elseif arg1 == 2 then
		return arg0:ExiseFeedOP()
	elseif arg1 == 3 then
		return arg0:ExistPlayOP()
	end
end

function var0.ClearOP(arg0, arg1)
	if arg1 == 1 then
		arg0:ClearCleanOP()
	elseif arg1 == 2 then
		arg0:ClearFeedOP()
	elseif arg1 == 3 then
		arg0:ClearPlayOP()
	end
end

function var0.ResetOP(arg0)
	arg0.opPlay = true
	arg0.opFeed = true
	arg0.opClean = true
end

function var0.ResetCleanOP(arg0)
	arg0.opClean = true
end

function var0.ResetFeedOP(arg0)
	arg0.opFeed = true
end

function var0.ResetPlayOP(arg0)
	arg0.opPlay = true
end

function var0.IsLocked(arg0)
	if arg0.home:GetMaxCatteryCnt() >= arg0.id then
		return false
	end

	return true
end

function var0.GetState(arg0)
	if arg0:IsLocked() then
		return var0.STATE_LOCK
	end

	if arg0:ExistCommander() then
		return var0.STATE_OCCUPATION
	end

	return var0.STATE_EMPTY
end

function var0.GetCalcExpTime(arg0)
	return arg0.expSettlementTime
end

function var0.UpdateCalcExpTime(arg0, arg1)
	arg0.expSettlementTime = arg1
end

function var0.CanUse(arg0)
	return arg0:GetState() ~= var0.STATE_LOCK
end

function var0.GetCacheExp(arg0)
	return arg0.cacheExp
end

function var0.ClearCacheExp(arg0)
	arg0.cacheExp = 0
end

function var0.UpdateCacheExp(arg0, arg1)
	arg0.cacheExp = arg0.cacheExp + arg1
end

function var0.ExistCacheExp(arg0)
	return arg0.cacheExp > 0
end

function var0.GetCacheExpTime(arg0)
	if arg0:ExistCacheExp() then
		local var0 = arg0:GetCacheExp()
		local var1 = arg0.home:getConfig("exp_number") / 3600

		return (math.ceil(var0 / var1))
	else
		return 0
	end
end

return var0
