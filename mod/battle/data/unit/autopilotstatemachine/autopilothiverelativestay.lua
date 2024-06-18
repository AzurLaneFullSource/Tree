ys = ys or {}

local var0_0 = ys
local var1_0 = class("AutoPilotHiveRelativeStay", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotHiveRelativeStay = var1_0
var1_0.__name = "AutoPilotHiveRelativeStay"

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)
end

function var1_0.SetParameter(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetParameter(arg0_2, arg1_2, arg2_2)

	arg0_2._distX = arg1_2.x
	arg0_2._distZ = arg1_2.z
end

function var1_0.GetDirection(arg0_3, arg1_3)
	local var0_3 = arg0_3._pilot:GetHiveUnit()

	if not var0_3:IsAlive() then
		arg0_3._pilot:OnHiveUnitDead()

		return Vector3.zero
	end

	local var1_3 = var0_3:GetPosition()
	local var2_3 = Vector3(var1_3.x + arg0_3._distX, arg1_3.y, var1_3.z + arg0_3._distZ) - arg1_3

	if arg0_3:IsExpired() then
		arg0_3:Finish()
	end

	if var2_3.magnitude < 0.4 then
		return Vector3.zero
	else
		var2_3.y = 0

		return var2_3:SetNormalize()
	end
end
