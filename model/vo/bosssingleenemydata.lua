local var0_0 = class("BossSingleEnemyData", import("model.vo.baseVO"))

var0_0.ACTIVIRY_TYPE = {
	OTHERWORLD = 1
}
var0_0.TYPE = {
	HARD = 3,
	SP = 4,
	EAST = 1,
	NORMAL = 2,
	EX = 5
}

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_single_enemy
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.fleetIdx = arg1_2.index
end

function var0_0.InTime(arg0_3)
	return pg.TimeMgr.GetInstance():inTime(arg0_3:getConfig("time"))
end

function var0_0.GetFleetIdx(arg0_4)
	return arg0_4.fleetIdx
end

function var0_0.IsContinuousType(arg0_5)
	return arg0_5:GetType() ~= var0_0.TYPE.SP
end

function var0_0.IsOilLimit(arg0_6)
	return arg0_6:GetOilLimit()[1] > 0 and arg0_6:GetOilLimit()[2] > 0
end

function var0_0.GetActiviryType(arg0_7)
	return arg0_7:getConfig("activity_type")
end

function var0_0.GetType(arg0_8)
	return arg0_8:getConfig("type")
end

function var0_0.GetExpeditionId(arg0_9)
	return arg0_9:getConfig("expedition_id")
end

function var0_0.GetPreChapterId(arg0_10)
	return arg0_10:getConfig("pre_chapter")
end

function var0_0.IsGuardianEffective(arg0_11)
	return arg0_11:getConfig("guardian_limit") == 1
end

function var0_0.GetCount(arg0_12)
	return arg0_12:getConfig("count")
end

function var0_0.GetOilLimit(arg0_13)
	return arg0_13:getConfig("use_oil_limit")
end

function var0_0.GetPropertyLimitation(arg0_14)
	return arg0_14:getConfig("property_limitation")
end

return var0_0
