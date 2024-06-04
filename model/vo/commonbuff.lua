local var0 = class("CommonBuff", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.timestamp = arg1.timestamp
end

function var0.IsActiveType(arg0)
	return false
end

function var0.bindConfigTable(arg0)
	return pg.benefit_buff_template
end

function var0.checkShow(arg0)
	return arg0:getConfig("hide") ~= 1
end

function var0.BackYardExpUsage(arg0)
	return arg0:getConfig("benefit_type") == BuffUsageConst.DORM_EXP
end

function var0.BattleUsage(arg0)
	return arg0:getConfig("benefit_type") == BuffUsageConst.BATTLE
end

function var0.RookieBattleExpUsage(arg0)
	return arg0:getConfig("benefit_type") == BuffUsageConst.ROOKIEBATTLEEXP
end

function var0.ShipModExpUsage(arg0)
	return arg0:getConfig("benefit_type") == BuffUsageConst.SHIP_MOD_EXP
end

function var0.BackyardEnergyUsage(arg0)
	return arg0:getConfig("benefit_type") == BuffUsageConst.DORM_ENERGY
end

function var0.GetRookieBattleExpMaxLevel(arg0)
	return arg0:getConfig("benefit_condition")[3]
end

function var0.isActivate(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() <= arg0.timestamp
end

function var0.getLeftTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.timestamp - var0
end

return var0
