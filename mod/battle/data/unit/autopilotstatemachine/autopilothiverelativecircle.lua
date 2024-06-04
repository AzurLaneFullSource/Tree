ys = ys or {}

local var0 = ys
local var1 = Vector3.up
local var2 = class("AutoPilotHiveRelativeCircle", var0.Battle.IPilot)

var0.Battle.AutoPilotHiveRelativeCircle = var2
var2.__name = "AutoPilotHiveRelativeCircle"

function var2.Ctor(arg0, ...)
	var2.super.Ctor(arg0, ...)
end

function var2.SetParameter(arg0, arg1, arg2)
	var2.super.SetParameter(arg0, arg1, arg2)

	arg0._radius = arg1.radius

	if arg1.antiClockWise == true then
		arg0.GetDirection = var2._antiClockWise
	else
		arg0.GetDirection = var2._clockWise
	end
end

function var2._clockWise(arg0, arg1)
	if arg0:IsExpired() then
		arg0:Finish()

		return Vector3.zero
	end

	local var0 = arg0._pilot:GetHiveUnit()

	if not var0:IsAlive() then
		arg0._pilot:OnHiveUnitDead()

		return Vector3.zero
	end

	local var1 = var0:GetPosition()

	if (arg1 - var1).magnitude > arg0._radius then
		return (var1 - arg1).normalized
	else
		local var2 = (var1 - arg1).normalized
		local var3 = -var2.z
		local var4 = var2.x

		return Vector3(var3, 0, var4)
	end
end

function var2._antiClockWise(arg0, arg1)
	if arg0._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0._startTime > arg0._duration then
		arg0:Finish()

		return Vector3.zero
	end

	local var0 = arg0._pilot:GetHiveUnit()

	if not var0:IsAlive() then
		arg0._pilot:OnHiveUnitDead()

		return Vector3.zero
	end

	local var1 = var0:GetPosition()

	if (arg1 - var1).magnitude > arg0._radius then
		return (var1 - arg1).normalized
	else
		local var2 = (var1 - arg1).normalized
		local var3 = var2.z
		local var4 = -var2.x

		return Vector3(var3, 0, var4)
	end
end
