ys = ys or {}

local var0_0 = ys
local var1_0 = class("AutoPilotMoveTo", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotMoveTo = var1_0
var1_0.__name = "AutoPilotMoveTo"

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)
end

function var1_0.SetParameter(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetParameter(arg0_2, arg1_2, arg2_2)

	arg0_2._targetPos = Vector3(arg1_2.x, 0, arg1_2.z)
end

function var1_0.GetDirection(arg0_3, arg1_3)
	local var0_3 = arg0_3._targetPos - arg1_3

	var0_3.y = 0

	if var0_3.magnitude < arg0_3._valve then
		var0_3 = Vector3.zero

		if arg0_3._duration == -1 or arg0_3:IsExpired() then
			arg0_3:Finish()
		end
	end

	return var0_3.normalized
end
