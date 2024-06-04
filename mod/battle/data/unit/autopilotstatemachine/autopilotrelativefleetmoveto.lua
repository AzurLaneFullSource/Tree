ys = ys or {}

local var0 = ys
local var1 = class("AutoPilotRelativeFleetMoveTo", var0.Battle.IPilot)

var0.Battle.AutoPilotRelativeFleetMoveTo = var1
var1.__name = "AutoPilotRelativeFleetMoveTo"

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)
end

function var1.SetParameter(arg0, arg1, arg2)
	var1.super.SetParameter(arg0, arg1, arg2)

	arg0._offsetX = arg1.offsetX
	arg0._offsetZ = arg1.offsetZ
	arg0._fixX = arg1.X
	arg0._fixZ = arg1.Z
	arg0._targetFleetVO = var0.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)
end

function var1.GetDirection(arg0, arg1)
	if arg0:IsExpired() then
		arg0:Finish()

		return Vector3.zero
	end

	local var0
	local var1
	local var2 = arg0._targetFleetVO:GetMotion():GetPos()

	if arg0._offsetX then
		var0 = var2.x + arg0._offsetX
	elseif arg0._fixX then
		var0 = arg0._fixX
	else
		var0 = arg1.x
	end

	if arg0._offsetZ then
		var1 = var2.z + arg0._offsetZ
	elseif arg0._fixZ then
		var1 = arg0._fixZ
	else
		var1 = arg1.z
	end

	local var3 = Vector3.New(var0, 0, var1) - arg1

	var3.y = 0

	if var3.magnitude < arg0._valve then
		var3 = Vector3.zero
	end

	return var3.normalized
end
