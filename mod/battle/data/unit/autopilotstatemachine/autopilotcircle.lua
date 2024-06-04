ys = ys or {}

local var0 = ys
local var1 = Vector3.up
local var2 = class("AutoPilotCircle", var0.Battle.IPilot)

var0.Battle.AutoPilotCircle = var2
var2.__name = "AutoPilotCircle"

function var2.Ctor(arg0, ...)
	var2.super.Ctor(arg0, ...)
end

function var2.SetParameter(arg0, arg1, arg2)
	var2.super.SetParameter(arg0, arg1, arg2)

	arg0._referencePoint = Vector3(arg1.x, 0, arg1.z)
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

	if (arg1 - arg0._referencePoint).magnitude > arg0._radius then
		return (arg0._referencePoint - arg1).normalized
	else
		local var0 = (arg0._referencePoint - arg1).normalized
		local var1 = -var0.z
		local var2 = var0.x

		return Vector3(var1, 0, var2)
	end
end

function var2._antiClockWise(arg0, arg1)
	if arg0._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0._startTime > arg0._duration then
		arg0:Finish()

		return Vector3.zero
	end

	if (arg1 - arg0._referencePoint).magnitude > arg0._radius then
		return (arg0._referencePoint - arg1).normalized
	else
		local var0 = (arg0._referencePoint - arg1).normalized
		local var1 = var0.z
		local var2 = -var0.x

		return Vector3(var1, 0, var2)
	end
end
