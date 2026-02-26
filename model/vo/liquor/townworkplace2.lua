local var0_0 = class("TownWorkplace2", import("model.vo.BaseVO"))

var0_0.TYPE = {
	ROLE = 3,
	RATIO = 2,
	NUMBER = 1
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.startTime = arg2_1
	arg0_1.storedGold = 0
	arg0_1.gold_time_limit = pg.activity_town_2[ActivityConst.LiquorFloor_ACT_ID].gold_time_limit
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_town_work_level_2
end

function var0_0.GetType(arg0_3)
	return arg0_3:getConfig("type")
end

function var0_0.GetGoldUnit(arg0_4)
	return arg0_4:GetType() == var0_0.TYPE.NUMBER and arg0_4:GetTypeParam() or 0
end

function var0_0.GetGoldRatio(arg0_5)
	return arg0_5:GetType() == var0_0.TYPE.UPPER and arg0_5:GetTypeParam() or 0
end

function var0_0.GetEffectStr(arg0_6)
	return arg0_6:GetType() == TownWorkplace2.TYPE.NUMBER and string.format("+%s/H", TownActivity2.GoldToShow(arg0_6:GetGoldUnit() * 3600)) or string.format("+%d%%", arg0_6:GetGoldRatio() / 100)
end

function var0_0.GetNextId(arg0_7)
	return underscore.detect(arg0_7:bindConfigTable().all, function(arg0_8)
		local var0_8 = arg0_7:bindConfigTable()[arg0_8]

		return var0_8.group == arg0_7:GetGroup() and var0_8.level == arg0_7:GetLevel() + 1
	end)
end

function var0_0.GetLastId(arg0_9)
	if arg0_9:GetLevel() == 0 then
		return nil
	end

	return underscore.detect(arg0_9:bindConfigTable().all, function(arg0_10)
		local var0_10 = arg0_9:bindConfigTable()[arg0_10]

		return var0_10.group == arg0_9:GetGroup() and var0_10.level == arg0_9:GetLevel() - 1
	end)
end

function var0_0.GetId(arg0_11)
	return arg0_11:getConfig("id")
end

function var0_0.GetDesc(arg0_12)
	return arg0_12:getConfig("desc")
end

function var0_0.GetIcon(arg0_13)
	return arg0_13:getConfig("pic")
end

function var0_0.GetGroup(arg0_14)
	return arg0_14:getConfig("group")
end

function var0_0.GetName(arg0_15)
	return arg0_15:getConfig("name")
end

function var0_0.GetLevel(arg0_16)
	return arg0_16:getConfig("level")
end

function var0_0.GetNeedTownLv(arg0_17)
	return arg0_17:getConfig("town_level")
end

function var0_0.GetTypeParam(arg0_18)
	return arg0_18:getConfig("type_param")
end

function var0_0.GetUpgrade(arg0_19)
	return arg0_19:getConfig("upgrade")
end

function var0_0.OnUpdateTime(arg0_20, arg1_20)
	arg0_20.storedGold = arg0_20:GetGoldUnit() * (arg1_20 - arg0_20.startTime)
end

function var0_0.GetStoredGold(arg0_21)
	return arg0_21.storedGold
end

function var0_0.ResetStartTime(arg0_22, arg1_22)
	local var0_22 = arg1_22 - arg0_22.startTime

	arg0_22.startTime = arg1_22
	arg0_22.gold_time_limit = arg0_22.gold_time_limit - arg1_22

	return arg0_22:GetGoldUnit() * var0_22
end

function var0_0.OnStartTime(arg0_23)
	local var0_23 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_23.startTime

	if var0_23 >= arg0_23.gold_time_limit then
		var0_23 = arg0_23.gold_time_limit
	end

	return arg0_23:GetGoldUnit() * var0_23
end

return var0_0
