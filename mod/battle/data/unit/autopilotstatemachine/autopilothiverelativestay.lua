ys = ys or {}

local var0 = ys
local var1 = class("AutoPilotHiveRelativeStay", var0.Battle.IPilot)

var0.Battle.AutoPilotHiveRelativeStay = var1
var1.__name = "AutoPilotHiveRelativeStay"

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)
end

function var1.SetParameter(arg0, arg1, arg2)
	var1.super.SetParameter(arg0, arg1, arg2)

	arg0._distX = arg1.x
	arg0._distZ = arg1.z
end

function var1.GetDirection(arg0, arg1)
	local var0 = arg0._pilot:GetHiveUnit()

	if not var0:IsAlive() then
		arg0._pilot:OnHiveUnitDead()

		return Vector3.zero
	end

	local var1 = var0:GetPosition()
	local var2 = Vector3(var1.x + arg0._distX, arg1.y, var1.z + arg0._distZ) - arg1

	if arg0:IsExpired() then
		arg0:Finish()
	end

	if var2.magnitude < 0.4 then
		return Vector3.zero
	else
		var2.y = 0

		return var2:SetNormalize()
	end
end
