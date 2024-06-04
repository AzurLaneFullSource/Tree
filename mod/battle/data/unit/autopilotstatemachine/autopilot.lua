ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.AIStepType
local var2 = class("AutoPilot")

var0.Battle.AutoPilot = var2
var2.__name = "AutoPilot"
var2.PILOT_VALVE = 0.5

function var2.Ctor(arg0, arg1, arg2)
	arg0._aiCfg = arg2
	arg0._target = arg1

	arg1._move:SetAutoMoveAI(arg0, arg1)
	arg0:generateList()

	arg0._currentStep = arg0._stepList[arg0._aiCfg.default]

	arg0._currentStep:Active(arg0._target)
end

function var2.GetDirection(arg0)
	local var0 = arg0._target:GetPosition()

	return (arg0._currentStep:GetDirection(var0))
end

function var2.GetTarget(arg0)
	return arg0._target
end

function var2.InputWeaponStateChange(arg0)
	return
end

function var2.SetHiveUnit(arg0, arg1)
	arg0._hiveUnit = arg1
end

function var2.GetHiveUnit(arg0)
	return arg0._hiveUnit
end

function var2.OnHiveUnitDead(arg0)
	arg0._target:OnMotherDead()
end

function var2.NextStep(arg0)
	local var0 = arg0._currentStep:GetToIndex()

	if arg0._stepList[var0] == nil then
		var0 = arg0._aiCfg.default
	end

	arg0._currentStep = arg0._stepList[var0]

	arg0._currentStep:Active(arg0._target)
end

function var2.generateList(arg0)
	arg0._stepList = {}

	for iter0, iter1 in ipairs(arg0._aiCfg.list) do
		local var0
		local var1 = iter1.index
		local var2 = iter1.to
		local var3 = iter1.type
		local var4 = iter1.param

		if var3 == var1.STAY then
			var0 = var0.Battle.AutoPilotStay.New(var1, arg0)
		elseif var3 == var1.MOVE_TO then
			var0 = var0.Battle.AutoPilotMoveTo.New(var1, arg0)
		elseif var3 == var1.MOVE then
			var0 = var0.Battle.AutoPilotMove.New(var1, arg0)
		elseif var3 == var1.MOVE_RELATIVE then
			var0 = var0.Battle.AutoPilotMoveRelative.New(var1, arg0)
		elseif var3 == var1.BROWNIAN then
			var0 = var0.Battle.AutoPilotBrownian.New(var1, arg0)
		elseif var3 == var1.CIRCLE then
			var0 = var0.Battle.AutoPilotCircle.New(var1, arg0)
		elseif var3 == var1.RELATIVE_BROWNIAN then
			var0 = var0.Battle.AutoPilotRelativeBrownian.New(var1, arg0)
		elseif var3 == var1.RELATIVE_FLEET_MOVE_TO then
			var0 = var0.Battle.AutoPilotRelativeFleetMoveTo.New(var1, arg0)
		elseif var3 == var1.HIVE_STAY then
			var0 = var0.Battle.AutoPilotHiveRelativeStay.New(var1, arg0)
		elseif var3 == var1.HIVE_CIRCLE then
			var0 = var0.Battle.AutoPilotHiveRelativeCircle.New(var1, arg0)
		elseif var3 == var1.MINION_STAY then
			var0 = var0.Battle.AutoPilotMinionRelativeStay.New(var1, arg0)
		elseif var3 == var1.MINION_CIRCLE then
			var0 = var0.Battle.AutoPilotMinionRelativeCircle.New(var1, arg0)
		end

		var0:SetParameter(var4, var2)

		arg0._stepList[var0:GetIndex()] = var0
	end
end
