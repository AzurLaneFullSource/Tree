ys = ys or {}
pg = pg or {}

local var0_0 = ys
local var1_0 = pg
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = class("BattleFleetMotionVO")

var0_0.Battle.BattleFleetMotionVO = var5_0
var5_0.__name = "BattleFleetMotionVO"

function var5_0.Ctor(arg0_1)
	arg0_1._pos = Vector3.zero
	arg0_1._speed = Vector3.zero
	arg0_1._lastDir = var2_0.NORMALIZE_FLEET_SPEED
	arg0_1._rotateAngle = Quaternion.identity
	arg0_1._isCalibrateAcc = false
end

function var5_0.GetPos(arg0_2)
	return arg0_2._pos
end

function var5_0.GetSpeed(arg0_3)
	return arg0_3._speed:Clone()
end

function var5_0.GetDirAngle(arg0_4)
	return arg0_4._rotateAngle
end

function var5_0.UpdatePos(arg0_5, arg1_5)
	arg0_5._pos = arg1_5:GetPosition()
end

function var5_0.UpdateVelocityAndDirection(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg1_6
	local var1_6 = arg2_6
	local var2_6 = arg3_6
	local var3_6 = Vector3(var1_6, 0, var2_6):Mul(var0_6)

	arg0_6:UpdateSpeed(var3_6)
end

function var5_0.UpdateSpeed(arg0_7, arg1_7)
	if arg0_7._speed ~= arg1_7 then
		arg0_7._speed = arg1_7

		if not arg1_7:EqualZero() then
			arg0_7._lastDir = arg1_7
		end

		arg0_7._rotateAngle:SetFromToRotation1(var2_0.NORMALIZE_FLEET_SPEED, arg0_7._lastDir)
	end
end

function var5_0.CalibrateAcc(arg0_8, arg1_8)
	arg0_8._isCalibrateAcc = arg1_8
end

function var5_0.SetPos(arg0_9, arg1_9)
	arg0_9._pos = arg1_9
end
