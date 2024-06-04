ys = ys or {}
pg = pg or {}

local var0 = ys
local var1 = pg
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleFormulas
local var4 = var0.Battle.BattleConfig
local var5 = class("BattleFleetMotionVO")

var0.Battle.BattleFleetMotionVO = var5
var5.__name = "BattleFleetMotionVO"

function var5.Ctor(arg0)
	arg0._pos = Vector3.zero
	arg0._speed = Vector3.zero
	arg0._lastDir = var2.NORMALIZE_FLEET_SPEED
	arg0._rotateAngle = Quaternion.identity
	arg0._isCalibrateAcc = false
end

function var5.GetPos(arg0)
	return arg0._pos
end

function var5.GetSpeed(arg0)
	return arg0._speed:Clone()
end

function var5.GetDirAngle(arg0)
	return arg0._rotateAngle
end

function var5.UpdatePos(arg0, arg1)
	arg0._pos = arg1:GetPosition()
end

function var5.UpdateVelocityAndDirection(arg0, arg1, arg2, arg3)
	local var0 = arg1
	local var1 = arg2
	local var2 = arg3
	local var3 = Vector3(var1, 0, var2):Mul(var0)

	arg0:UpdateSpeed(var3)
end

function var5.UpdateSpeed(arg0, arg1)
	if arg0._speed ~= arg1 then
		arg0._speed = arg1

		if not arg1:EqualZero() then
			arg0._lastDir = arg1
		end

		arg0._rotateAngle:SetFromToRotation1(var2.NORMALIZE_FLEET_SPEED, arg0._lastDir)
	end
end

function var5.CalibrateAcc(arg0, arg1)
	arg0._isCalibrateAcc = arg1
end

function var5.SetPos(arg0, arg1)
	arg0._pos = arg1
end
