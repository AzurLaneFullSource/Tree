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

	if not var4_2 then
		onNextTick(arg2_2)

		return
	end

	var4_2:Enable()
	var4_2:WarpAgent()
	assert(var4_2, "unit is nil" .. var1_2)

	arg0_2.unit = var4_2
	arg0_2.callback = arg2_2

	var4_2:SetNavAgentStopDistance(0.26)
	var4_2:SetDestination(var0_2, var2_2, arg1_2.radius, arg1_2.charaRadius)
	var4_2:CheckMovement()

	arg0_2.starting = true
end

function var0_0.IsSameUnit(arg0_3, arg1_3)
	if not arg0_3.unit then
		return false
	end

	return arg1_3.id == arg0_3.unit.id and arg1_3.unitType == arg0_3.unit.unitType
end

function var0_0.FindUnit(arg0_4, arg1_4, arg2_4)
	if arg1_4 == 0 then
		return arg0_4:GetView().player
	end

	for iter0_4, iter1_4 in ipairs(arg0_4.unitList) do
		if iter1_4:GetUnitType() == arg2_4 and iter1_4.id == arg1_4 then
			return iter1_4
		end
	end

	return nil
end

function var0_0.OnUpdate(arg0_5)
	if not arg0_5.starting then
		return
	end

	local var0_5 = arg0_5.unit.agent

	if not var0_5.pathPending and var0_5.remainingDistance <= var0_5.stoppingDistance then
		arg0_5:EndAction()
	end
end

function var0_0.EndAction(arg0_6)
	arg0_6.unit:SetNavAgentStopDistance(2)
	arg0_6.unit:StopMove()

	if arg0_6.hideFlag then
		arg0_6.unit:Disable()
	end

	arg0_6.callback()

	arg0_6.starting = false
end

function var0_0.Stop(arg0_7)
	arg0_7:EndAction()
end

function var0_0.OnDispose(arg0_8)
	arg0_8.starting = nil
	arg0_8.callback = nil
	arg0_8.unitList = nil
end

return var0_0
