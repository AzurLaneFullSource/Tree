ys = ys or {}

local var0 = ys
local var1 = class("AutoPilotMoveRelative", var0.Battle.IPilot)

var0.Battle.AutoPilotMoveRelative = var1
var1.__name = "AutoPilotMoveRelative"

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)
end

function var1.SetParameter(arg0, arg1, arg2)
	var1.super.SetParameter(arg0, arg1, arg2)

	arg0._distX = arg1.x
	arg0._distZ = arg1.z
end

function var1.Active(arg0, arg1)
	local var0 = arg0._distX * arg1:GetDirection()

	arg0._targetPos = Vector3(var0, 0, arg0._distZ):Add(arg1:GetPosition())

	var1.super.Active(arg0, arg1)
end

function var1.GetDirection(arg0, arg1)
	local var0 = arg0._targetPos - arg1

	var0.y = 0

	if var0.magnitude < arg0._valve then
		var0 = Vector3.zero

		if arg0._duration == -1 or arg0:IsExpired() then
			arg0:Finish()
		end
	end

	return var0:SetNormalize()
end
