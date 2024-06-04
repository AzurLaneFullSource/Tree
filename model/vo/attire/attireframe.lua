local var0 = class("AttireFrame", import("..BaseVO"))

var0.STATE_LOCK = 1
var0.STATE_UNLOCKABLE = 2
var0.STATE_UNLOCK = 3

function var0.attireFrameRes(arg0, arg1, arg2, arg3)
	local var0 = arg0.attireInfo[arg2]

	if arg1 then
		local var1 = getProxy(PlayerProxy):getRawData()

		arg3 = arg3 and (not HXSet.isHxPropose() or var1:GetProposeShipId() == var1.character)
	else
		arg3 = arg3 and not HXSet.isHxPropose()
	end

	if arg2 == AttireConst.TYPE_ICON_FRAME and var0 == 0 and arg3 then
		local var2 = pg.ship_data_template[arg0.icon]

		if var2 and ShipGroup.IsMetaGroup(var2.group_type) then
			return "meta_propose"
		else
			return "propose"
		end
	elseif arg2 == AttireConst.TYPE_CHAT_FRAME then
		return arg1 and var0 .. "_self" or var0 .. "_other"
	else
		return var0
	end
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id

	arg0:updateData(arg1)
end

function var0.isNew(arg0)
	return arg0.new == true
end

function var0.clearNew(arg0)
	arg0.new = nil
end

function var0.updateData(arg0, arg1)
	arg0.endTime = arg1.end_time or arg1.time or -1
	arg0.new = arg1.isNew
end

function var0.getState(arg0)
	local var0 = var0.STATE_LOCK
	local var1 = arg0:isOwned()

	if var1 then
		var0 = var0.STATE_UNLOCK
	elseif not var1 and arg0:canUnlock() then
		var0 = var0.STATE_UNLOCKABLE
	end

	return var0
end

function var0.canUnlock(arg0)
	return false
end

function var0.isOwned(arg0)
	return arg0.endTime >= 0 and not arg0:isExpired()
end

function var0.isExpired(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0:expiredType() and var0 >= arg0:getExpiredTime()
end

function var0.getExpiredTime(arg0)
	if arg0:expiredType() then
		return arg0.endTime
	end

	assert(false)
end

function var0.updateEndTime(arg0, arg1)
	arg0.endTime = arg1
end

function var0.expiredType(arg0)
	return arg0:getConfig("time_limit_type") == 1
end

function var0.getTimerKey(arg0)
	return arg0:getType() .. "_" .. arg0.id
end

function var0.getType(arg0)
	assert(false)
end

function var0.bindConfigTable(arg0)
	assert(false)
end

function var0.getDropType(arg0)
	assert(false)
end

return var0
