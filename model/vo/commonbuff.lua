local var0_0 = class("CommonBuff", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.timestamp = arg1_1.timestamp
end

function var0_0.IsActiveType(arg0_2)
	return false
end

function var0_0.bindConfigTable(arg0_3)
	return pg.benefit_buff_template
end

function var0_0.checkShow(arg0_4)
	return arg0_4:getConfig("hide") ~= 1
end

function var0_0.BackYardExpUsage(arg0_5)
	return arg0_5:getConfig("benefit_type") == BuffUsageConst.DORM_EXP
end

function var0_0.BattleUsage(arg0_6)
	return arg0_6:getConfig("benefit_type") == BuffUsageConst.BATTLE
end

function var0_0.RookieBattleExpUsage(arg0_7)
	return arg0_7:getConfig("benefit_type") == BuffUsageConst.ROOKIEBATTLEEXP
end

function var0_0.ShipModExpUsage(arg0_8)
	return arg0_8:getConfig("benefit_type") == BuffUsageConst.SHIP_MOD_EXP
end

function var0_0.BackyardEnergyUsage(arg0_9)
	return arg0_9:getConfig("benefit_type") == BuffUsageConst.DORM_ENERGY
end

function var0_0.GetRookieBattleExpMaxLevel(arg0_10)
	return arg0_10:getConfig("benefit_condition")[3]
end

function var0_0.isActivate(arg0_11)
	return pg.TimeMgr.GetInstance():GetServerTime() <= arg0_11.timestamp
end

function var0_0.getLeftTime(arg0_12)
	local var0_12 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_12.timestamp - var0_12
end

return var0_0
