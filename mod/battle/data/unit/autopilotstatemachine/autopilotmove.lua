ys = ys or {}

local var0_0 = ys
local var1_0 = class("AutoPilotMove", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotMove = var1_0
var1_0.__name = "AutoPilotMove"

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)
end

function var1_0.SetParameter(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetParameter(arg0_2, arg1_2, arg2_2)

	arg0_2._distX = arg1_2.x
	arg0_2._distZ = arg1_2.z
end

function var1_0.Active(arg0_3, arg1_3)
	arg0_3._targetPos = Vector3(arg0_3._distX, 0, arg0_3._distZ):Add(arg1_3:GetPosition())

	var1_0.super.Active(arg0_3, arg1_3)
end

function var1_0.GetDirection(arg0_4, arg1_4)
	local var0_4 = arg0_4._targetPos - arg1_4

	var0_4.y = 0

	if var0_4.magnitude < arg0_4._valve then
		var0_4 = Vector3.zero

		if arg0_4._duration == -1 or arg0_4:IsExpired() then
			arg0_4:Finish()
		end
	end

	return var0_4:SetNormalize()
end
