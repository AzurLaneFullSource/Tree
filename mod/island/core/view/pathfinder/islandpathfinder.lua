local var0_0 = class("IslandPathFinder", import("..IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.unitList = arg0_1:GetView():GetAllUnits()
	arg0_1.starting = false

	arg0_1:Init()
end

function var0_0.Start(arg0_2, arg1_2, arg2_2)
	local var0_2 = BuildVector3(arg1_2.position)
	local var1_2 = arg1_2.unitId or 0
	local var2_2 = arg1_2.speed or 1.5
	local var3_2 = arg1_2.unitType or IslandConst.UNIT_LIST_OBJ

	arg0_2.hideFlag = defaultValue(arg1_2.hide, false)

	local var4_2 = arg0_2:FindUnit(var1_2, var3_2)

	var4_2:Enable()
	assert(var4_2, "unit is nil" .. var1_2)

	arg0_2.unit = var4_2
	arg0_2.callback = arg2_2

	var4_2:SetNavAgentStopDistance(0.001)
	var4_2:SetDestination(var0_2, var2_2)

	arg0_2.starting = true
end

function var0_0.FindUnit(arg0_3, arg1_3, arg2_3)
	if arg1_3 == 0 then
		for iter0_3, iter1_3 in ipairs(arg0_3.unitList) do
			if isa(iter1_3, IslandPlayerUnit) then
				return iter1_3
			end
		end
	end

	for iter2_3, iter3_3 in ipairs(arg0_3.unitList) do
		if iter3_3:GetUnitType() == arg2_3 and iter3_3.id == arg1_3 then
			return iter3_3
		end
	end

	return nil
end

function var0_0.OnUpdate(arg0_4)
	if not arg0_4.starting then
		return
	end

	local var0_4 = arg0_4.unit.agent

	if not var0_4.pathPending and var0_4.remainingDistance <= var0_4.stoppingDistance then
		arg0_4:EndAction()
	end
end

function var0_0.EndAction(arg0_5)
	arg0_5.unit:SetNavAgentStopDistance(2)
	arg0_5.unit:StopMove()

	if arg0_5.hideFlag then
		arg0_5.unit:Disable()
	end

	arg0_5.callback()

	arg0_5.starting = false
end

function var0_0.OnDispose(arg0_6)
	arg0_6.starting = nil
	arg0_6.callback = nil
	arg0_6.unitList = nil
end

return var0_0
