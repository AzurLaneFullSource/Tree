local var0_0 = class("AttireFrame", import("..BaseVO"))

var0_0.STATE_LOCK = 1
var0_0.STATE_UNLOCKABLE = 2
var0_0.STATE_UNLOCK = 3

function var0_0.attireFrameRes(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1 = arg0_1.attireInfo[arg2_1]

	if arg1_1 then
		local var1_1 = getProxy(PlayerProxy):getRawData()

		arg3_1 = arg3_1 and (not HXSet.isHxPropose() or var1_1:GetProposeShipId() == var1_1.character)
	else
		arg3_1 = arg3_1 and not HXSet.isHxPropose()
	end

	if arg2_1 == AttireConst.TYPE_ICON_FRAME and var0_1 == 0 and arg3_1 then
		local var2_1 = pg.ship_data_template[arg0_1.icon]

		if var2_1 and ShipGroup.IsMetaGroup(var2_1.group_type) then
			return "meta_propose"
		else
			return "propose"
		end
	elseif arg2_1 == AttireConst.TYPE_CHAT_FRAME then
		return arg1_1 and var0_1 .. "_self" or var0_1 .. "_other"
	else
		return var0_1
	end
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id

	arg0_2:updateData(arg1_2)
end

function var0_0.isNew(arg0_3)
	return arg0_3.new == true
end

function var0_0.clearNew(arg0_4)
	arg0_4.new = nil
end

function var0_0.updateData(arg0_5, arg1_5)
	arg0_5.endTime = arg1_5.end_time or arg1_5.time or -1
	arg0_5.new = arg1_5.isNew
end

function var0_0.getState(arg0_6)
	local var0_6 = var0_0.STATE_LOCK
	local var1_6 = arg0_6:isOwned()

	if var1_6 then
		var0_6 = var0_0.STATE_UNLOCK
	elseif not var1_6 and arg0_6:canUnlock() then
		var0_6 = var0_0.STATE_UNLOCKABLE
	end

	return var0_6
end

function var0_0.canUnlock(arg0_7)
	return false
end

function var0_0.isOwned(arg0_8)
	return arg0_8.endTime >= 0 and not arg0_8:isExpired()
end

function var0_0.isExpired(arg0_9)
	local var0_9 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_9:expiredType() and var0_9 >= arg0_9:getExpiredTime()
end

function var0_0.getExpiredTime(arg0_10)
	if arg0_10:expiredType() then
		return arg0_10.endTime
	end

	assert(false)
end

function var0_0.updateEndTime(arg0_11, arg1_11)
	arg0_11.endTime = arg1_11
end

function var0_0.expiredType(arg0_12)
	return arg0_12:getConfig("time_limit_type") == 1
end

function var0_0.getTimerKey(arg0_13)
	return arg0_13:getType() .. "_" .. arg0_13.id
end

function var0_0.getType(arg0_14)
	assert(false)
end

function var0_0.bindConfigTable(arg0_15)
	assert(false)
end

function var0_0.getDropType(arg0_16)
	assert(false)
end

return var0_0
