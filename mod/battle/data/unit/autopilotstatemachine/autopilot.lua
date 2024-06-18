ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.AIStepType
local var2_0 = class("AutoPilot")

var0_0.Battle.AutoPilot = var2_0
var2_0.__name = "AutoPilot"
var2_0.PILOT_VALVE = 0.5

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._aiCfg = arg2_1
	arg0_1._target = arg1_1

	arg1_1._move:SetAutoMoveAI(arg0_1, arg1_1)
	arg0_1:generateList()

	arg0_1._currentStep = arg0_1._stepList[arg0_1._aiCfg.default]

	arg0_1._currentStep:Active(arg0_1._target)
end

function var2_0.GetDirection(arg0_2)
	local var0_2 = arg0_2._target:GetPosition()

	return (arg0_2._currentStep:GetDirection(var0_2))
end

function var2_0.GetTarget(arg0_3)
	return arg0_3._target
end

function var2_0.InputWeaponStateChange(arg0_4)
	return
end

function var2_0.SetHiveUnit(arg0_5, arg1_5)
	arg0_5._hiveUnit = arg1_5
end

function var2_0.GetHiveUnit(arg0_6)
	return arg0_6._hiveUnit
end

function var2_0.OnHiveUnitDead(arg0_7)
	arg0_7._target:OnMotherDead()
end

function var2_0.NextStep(arg0_8)
	local var0_8 = arg0_8._currentStep:GetToIndex()

	if arg0_8._stepList[var0_8] == nil then
		var0_8 = arg0_8._aiCfg.default
	end

	arg0_8._currentStep = arg0_8._stepList[var0_8]

	arg0_8._currentStep:Active(arg0_8._target)
end

function var2_0.generateList(arg0_9)
	arg0_9._stepList = {}

	for iter0_9, iter1_9 in ipairs(arg0_9._aiCfg.list) do
		local var0_9
		local var1_9 = iter1_9.index
		local var2_9 = iter1_9.to
		local var3_9 = iter1_9.type
		local var4_9 = iter1_9.param

		if var3_9 == var1_0.STAY then
			var0_9 = var0_0.Battle.AutoPilotStay.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.MOVE_TO then
			var0_9 = var0_0.Battle.AutoPilotMoveTo.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.MOVE then
			var0_9 = var0_0.Battle.AutoPilotMove.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.MOVE_RELATIVE then
			var0_9 = var0_0.Battle.AutoPilotMoveRelative.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.BROWNIAN then
			var0_9 = var0_0.Battle.AutoPilotBrownian.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.CIRCLE then
			var0_9 = var0_0.Battle.AutoPilotCircle.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.RELATIVE_BROWNIAN then
			var0_9 = var0_0.Battle.AutoPilotRelativeBrownian.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.RELATIVE_FLEET_MOVE_TO then
			var0_9 = var0_0.Battle.AutoPilotRelativeFleetMoveTo.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.HIVE_STAY then
			var0_9 = var0_0.Battle.AutoPilotHiveRelativeStay.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.HIVE_CIRCLE then
			var0_9 = var0_0.Battle.AutoPilotHiveRelativeCircle.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.MINION_STAY then
			var0_9 = var0_0.Battle.AutoPilotMinionRelativeStay.New(var1_9, arg0_9)
		elseif var3_9 == var1_0.MINION_CIRCLE then
			var0_9 = var0_0.Battle.AutoPilotMinionRelativeCircle.New(var1_9, arg0_9)
		end

		var0_9:SetParameter(var4_9, var2_9)

		arg0_9._stepList[var0_9:GetIndex()] = var0_9
	end
end
