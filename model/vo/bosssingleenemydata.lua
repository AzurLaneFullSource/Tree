local var0 = class("BossSingleEnemyData", import("model.vo.baseVO"))

var0.ACTIVIRY_TYPE = {
	OTHERWORLD = 1
}
var0.TYPE = {
	HARD = 3,
	SP = 4,
	EAST = 1,
	NORMAL = 2,
	EX = 5
}

function var0.bindConfigTable(arg0)
	return pg.activity_single_enemy
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.fleetIdx = arg1.index
end

function var0.InTime(arg0)
	return pg.TimeMgr.GetInstance():inTime(arg0:getConfig("time"))
end

function var0.GetFleetIdx(arg0)
	return arg0.fleetIdx
end

function var0.IsContinuousType(arg0)
	return arg0:GetType() ~= var0.TYPE.SP
end

function var0.IsOilLimit(arg0)
	return arg0:GetOilLimit()[1] > 0 and arg0:GetOilLimit()[2] > 0
end

function var0.GetActiviryType(arg0)
	return arg0:getConfig("activity_type")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetExpeditionId(arg0)
	return arg0:getConfig("expedition_id")
end

function var0.GetPreChapterId(arg0)
	return arg0:getConfig("pre_chapter")
end

function var0.IsGuardianEffective(arg0)
	return arg0:getConfig("guardian_limit") == 1
end

function var0.GetCount(arg0)
	return arg0:getConfig("count")
end

function var0.GetOilLimit(arg0)
	return arg0:getConfig("use_oil_limit")
end

function var0.GetPropertyLimitation(arg0)
	return arg0:getConfig("property_limitation")
end

return var0
