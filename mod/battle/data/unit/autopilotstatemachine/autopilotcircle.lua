ys = ys or {}

local var0_0 = ys
local var1_0 = Vector3.up
local var2_0 = class("AutoPilotCircle", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotCircle = var2_0
var2_0.__name = "AutoPilotCircle"

function var2_0.Ctor(arg0_1, ...)
	var2_0.super.Ctor(arg0_1, ...)
end

function var2_0.SetParameter(arg0_2, arg1_2, arg2_2)
	var2_0.super.SetParameter(arg0_2, arg1_2, arg2_2)

	arg0_2._referencePoint = Vector3(arg1_2.x, 0, arg1_2.z)
	arg0_2._radius = arg1_2.radius

	if arg1_2.antiClockWise == true then
		arg0_2.GetDirection = var2_0._antiClockWise
	else
		arg0_2.GetDirection = var2_0._clockWise
	end
end

function var2_0._clockWise(arg0_3, arg1_3)
	if arg0_3:IsExpired() then
		arg0_3:Finish()

		return Vector3.zero
	end

	if (arg1_3 - arg0_3._referencePoint).magnitude > arg0_3._radius then
		return (arg0_3._referencePoint - arg1_3).normalized
	else
		local var0_3 = (arg0_3._referencePoint - arg1_3).normalized
		local var1_3 = -var0_3.z
		local var2_3 = var0_3.x

		return Vector3(var1_3, 0, var2_3)
	end
end

function var2_0._antiClockWise(arg0_4, arg1_4)
	if arg0_4._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0_4._startTime > arg0_4._duration then
		arg0_4:Finish()

		return Vector3.zero
	end

	if (arg1_4 - arg0_4._referencePoint).magnitude > arg0_4._radius then
		return (arg0_4._referencePoint - arg1_4).normalized
	else
		local var0_4 = (arg0_4._referencePoint - arg1_4).normalized
		local var1_4 = var0_4.z
		local var2_4 = -var0_4.x

		return Vector3(var1_4, 0, var2_4)
	end
end
