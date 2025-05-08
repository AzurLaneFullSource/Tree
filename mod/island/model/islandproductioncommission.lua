local var0_0 = class("IslandProductionCommission", import("model.vo.BaseVO"))

var0_0.STATUS_EMPTY = 1
var0_0.STATUS_WORKING = 2
var0_0.STATUS_STOP = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.appoint_pos or arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.shipId = arg1_1.role_id
	arg0_1.formulaId = arg1_1.formula_id
	arg0_1.startTime = arg1_1.start_time or 0

	if arg0_1.startTime > 0 then
		arg0_1.status = var0_0.STATUS_WORKING

		local var0_1 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_1 = tonumber(pg.island_formula[arg0_1.formulaId].production_points)
		local var2_1 = (var0_1 - arg0_1.startTime) * 100 / var1_1

		arg0_1.num = math.min(var2_1, arg0_1:GetCapacity())
	else
		arg0_1.status = var0_0.STATUS_EMPTY
		arg0_1.num = 0
	end

	arg0_1.limit = 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_commission
end

function var0_0.IsUnlock(arg0_3)
	return true
end

function var0_0.GetOccupation(arg0_4)
	return arg0_4:getConfig("occupation")
end

function var0_0.GetCapacity(arg0_5)
	return arg0_5:getConfig("commission_temporary_storage")
end

function var0_0.GetName(arg0_6)
	return arg0_6:getConfig("name")
end

function var0_0.GetShipId(arg0_7)
	return arg0_7.shipId
end

function var0_0.SetShipId(arg0_8, arg1_8)
	arg0_8.shipId = arg1_8
end

function var0_0.GetFormulaId(arg0_9)
	return arg0_9.formulaId
end

function var0_0.SetFormulaId(arg0_10, arg1_10)
	arg0_10.formulaId = arg1_10
end

function var0_0.CheckStart(arg0_11, arg1_11)
	if arg0_11.shipId and arg0_11.formulaId then
		pg.m02:sendNotification(GAME.ISLAND_START_COMMISSION, {
			buildingId = arg0_11:getConfig("place_group"),
			commissionId = arg0_11.id,
			shipId = arg0_11.shipId,
			formulaId = arg0_11.formulaId,
			callback = arg1_11
		})
	elseif arg1_11 then
		arg1_11()
	end
end

function var0_0.GetStatus(arg0_12)
	return arg0_12.status
end

function var0_0.GetNum(arg0_13)
	return arg0_13.num
end

function var0_0.GetCurTime(arg0_14)
	return 0
end

function var0_0.GetOnceTime(arg0_15)
	return 60
end

function var0_0.GetNextRemainTime(arg0_16)
	return arg0_16:GetOnceTime() - arg0_16:GetCurTime()
end

function var0_0.IsLimit(arg0_17)
	return arg0_17.limit > 0
end

function var0_0.SetLimit(arg0_18, arg1_18)
	arg0_18.limit = arg1_18
end

function var0_0.GetLimit(arg0_19, arg1_19)
	return arg0_19.limit
end

function var0_0.Clear(arg0_20)
	arg0_20.shipId = 0
	arg0_20.formulaId = 0
	arg0_20.startTime = 0
end

return var0_0
