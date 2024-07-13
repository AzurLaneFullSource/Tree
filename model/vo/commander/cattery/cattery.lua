local var0_0 = class("Cattery", import("...BaseVO"))

var0_0.STATE_LOCK = 1
var0_0.STATE_EMPTY = 2
var0_0.STATE_OCCUPATION = 3
var0_0.OP_CLEAR = 1
var0_0.OP_FEED = 2
var0_0.OP_PLAY = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.home = arg1_1
	arg0_1.id = arg2_1.id
	arg0_1.op = arg2_1.op_flag or 0
	arg0_1.expSettlementTime = arg2_1.exp_time
	arg0_1.commanderId = arg2_1.commander_id or 0
	arg0_1.style = arg2_1.style or 1
	arg0_1.opClean = bit.band(arg0_1.op, var0_0.OP_CLEAR) > 0
	arg0_1.opFeed = bit.band(arg0_1.op, var0_0.OP_FEED) > 0
	arg0_1.opPlay = bit.band(arg0_1.op, var0_0.OP_PLAY) > 0
	arg0_1.cacheExp = arg2_1.cache_exp or 0
end

function var0_0.AddCommander(arg0_2, arg1_2, arg2_2)
	arg0_2.commanderId = arg1_2
	arg0_2.expSettlementTime = arg2_2

	arg0_2:ClearCacheExp()
end

function var0_0.ReplaceCommander(arg0_3, arg1_3)
	arg0_3.commanderId = arg1_3

	arg0_3:ClearCacheExp()
end

function var0_0.RemoveCommander(arg0_4)
	arg0_4.commanderId = 0

	arg0_4:ClearCacheExp()
end

function var0_0.ExistCommander(arg0_5)
	return arg0_5.commanderId ~= 0 and getProxy(CommanderProxy):RawGetCommanderById(arg0_5.commanderId) ~= nil
end

function var0_0.GetCommanderId(arg0_6)
	return arg0_6.commanderId
end

function var0_0.GetCommander(arg0_7)
	if arg0_7:ExistCommander() then
		return getProxy(CommanderProxy):getCommanderById(arg0_7.commanderId)
	end
end

function var0_0.CommanderCanClean(arg0_8)
	if arg0_8:ExistCommander() then
		return arg0_8:GetCommander():ExistCleanFlag()
	end

	return false
end

function var0_0.CommanderCanFeed(arg0_9)
	if arg0_9:ExistCommander() then
		return arg0_9:GetCommander():ExitFeedFlag()
	end

	return false
end

function var0_0.CommanderCanPlay(arg0_10)
	if arg0_10:ExistCommander() then
		return arg0_10:GetCommander():ExitPlayFlag()
	end

	return false
end

function var0_0.CommanderCanOP(arg0_11, arg1_11)
	if arg1_11 == 1 then
		return arg0_11:CommanderCanClean()
	elseif arg1_11 == 2 then
		return arg0_11:CommanderCanFeed()
	elseif arg1_11 == 3 then
		return arg0_11:CommanderCanPlay()
	end
end

function var0_0.GetStyle(arg0_12)
	return arg0_12.style
end

function var0_0._GetStyle_(arg0_13)
	return CatteryStyle.New({
		own = true,
		id = arg0_13.style
	})
end

function var0_0.UpdateStyle(arg0_14, arg1_14)
	arg0_14.style = arg1_14
end

function var0_0.IsDirty(arg0_15)
	return arg0_15.opClean == true
end

function var0_0.GetOP(arg0_16)
	return arg0_16.op
end

function var0_0.ExistCleanOP(arg0_17)
	return arg0_17.opClean
end

function var0_0.ClearCleanOP(arg0_18)
	arg0_18.opClean = false
end

function var0_0.ExiseFeedOP(arg0_19)
	return arg0_19.opFeed
end

function var0_0.ClearFeedOP(arg0_20)
	arg0_20.opFeed = false
end

function var0_0.ExistPlayOP(arg0_21)
	return arg0_21.opPlay
end

function var0_0.ClearPlayOP(arg0_22)
	arg0_22.opPlay = false
end

function var0_0.ExistOP(arg0_23, arg1_23)
	if arg1_23 == 1 then
		return arg0_23:ExistCleanOP()
	elseif arg1_23 == 2 then
		return arg0_23:ExiseFeedOP()
	elseif arg1_23 == 3 then
		return arg0_23:ExistPlayOP()
	end
end

function var0_0.ClearOP(arg0_24, arg1_24)
	if arg1_24 == 1 then
		arg0_24:ClearCleanOP()
	elseif arg1_24 == 2 then
		arg0_24:ClearFeedOP()
	elseif arg1_24 == 3 then
		arg0_24:ClearPlayOP()
	end
end

function var0_0.ResetOP(arg0_25)
	arg0_25.opPlay = true
	arg0_25.opFeed = true
	arg0_25.opClean = true
end

function var0_0.ResetCleanOP(arg0_26)
	arg0_26.opClean = true
end

function var0_0.ResetFeedOP(arg0_27)
	arg0_27.opFeed = true
end

function var0_0.ResetPlayOP(arg0_28)
	arg0_28.opPlay = true
end

function var0_0.IsLocked(arg0_29)
	if arg0_29.home:GetMaxCatteryCnt() >= arg0_29.id then
		return false
	end

	return true
end

function var0_0.GetState(arg0_30)
	if arg0_30:IsLocked() then
		return var0_0.STATE_LOCK
	end

	if arg0_30:ExistCommander() then
		return var0_0.STATE_OCCUPATION
	end

	return var0_0.STATE_EMPTY
end

function var0_0.GetCalcExpTime(arg0_31)
	return arg0_31.expSettlementTime
end

function var0_0.UpdateCalcExpTime(arg0_32, arg1_32)
	arg0_32.expSettlementTime = arg1_32
end

function var0_0.CanUse(arg0_33)
	return arg0_33:GetState() ~= var0_0.STATE_LOCK
end

function var0_0.GetCacheExp(arg0_34)
	return arg0_34.cacheExp
end

function var0_0.ClearCacheExp(arg0_35)
	arg0_35.cacheExp = 0
end

function var0_0.UpdateCacheExp(arg0_36, arg1_36)
	arg0_36.cacheExp = arg0_36.cacheExp + arg1_36
end

function var0_0.ExistCacheExp(arg0_37)
	return arg0_37.cacheExp > 0
end

function var0_0.GetCacheExpTime(arg0_38)
	if arg0_38:ExistCacheExp() then
		local var0_38 = arg0_38:GetCacheExp()
		local var1_38 = arg0_38.home:getConfig("exp_number") / 3600

		return (math.ceil(var0_38 / var1_38))
	else
		return 0
	end
end

return var0_0
