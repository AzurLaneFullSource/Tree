ys = ys or {}

local var0_0 = ys
local var1_0 = class("AutoPilotRelativeFleetMoveTo", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotRelativeFleetMoveTo = var1_0
var1_0.__name = "AutoPilotRelativeFleetMoveTo"

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)
end

function var1_0.SetParameter(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetParameter(arg0_2, arg1_2, arg2_2)

	arg0_2._offsetX = arg1_2.offsetX
	arg0_2._offsetZ = arg1_2.offsetZ
	arg0_2._fixX = arg1_2.X
	arg0_2._fixZ = arg1_2.Z
	arg0_2._targetFleetVO = var0_0.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
end

function var1_0.GetDirection(arg0_3, arg1_3)
	if arg0_3:IsExpired() then
		arg0_3:Finish()

		return Vector3.zero
	end

	local var0_3
	local var1_3
	local var2_3 = arg0_3._targetFleetVO:GetMotion():GetPos()

	if arg0_3._offsetX then
		var0_3 = var2_3.x + arg0_3._offsetX
	elseif arg0_3._fixX then
		var0_3 = arg0_3._fixX
	else
		var0_3 = arg1_3.x
	end

	if arg0_3._offsetZ then
		var1_3 = var2_3.z + arg0_3._offsetZ
	elseif arg0_3._fixZ then
		var1_3 = arg0_3._fixZ
	else
		var1_3 = arg1_3.z
	end

	local var3_3 = Vector3.New(var0_3, 0, var1_3) - arg1_3

	var3_3.y = 0

	if var3_3.magnitude < arg0_3._valve then
		var3_3 = Vector3.zero
	end

	return var3_3.normalized
end
