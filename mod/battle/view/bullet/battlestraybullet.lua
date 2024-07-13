ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleResourceManager

var0_0.Battle.BattleStrayBullet = class("BattleStrayBullet", var0_0.Battle.BattleBullet)
var0_0.Battle.BattleStrayBullet.__name = "BattleStrayBullet"

local var2_0 = var0_0.Battle.BattleStrayBullet

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var2_0.SetSpawn(arg0_2, arg1_2)
	var2_0.super.SetSpawn(arg0_2, arg1_2)

	arg0_2._targetPos = Clone(arg0_2._bulletData:GetExplodePostion())
	arg0_2._spawnDir = arg0_2._speed.normalized

	local var0_2 = 1 + var0_0.Battle.BattleAttr.GetCurrent(arg0_2._bulletData, "bulletSpeedRatio")

	arg0_2._velocity = arg0_2._bulletData:GetVelocity() * var0_2
	arg0_2._velocity = var0_0.Battle.BattleFormulas.ConvertBulletSpeed(arg0_2._velocity)
	arg0_2._step = Vector3.Distance(arg0_2._targetPos, arg0_2._spawnPos) / arg0_2._velocity
	arg0_2._count = math.random(600) - 300
	arg0_2.updateSpeed = var2_0._doStray
end

function var2_0._doStray(arg0_3)
	local var0_3 = arg0_3._targetPos

	if arg0_3._step > 0 and var0_3 and not var0_3:EqualZero() then
		arg0_3._count = arg0_3._count / 1.06
		arg0_3._step = arg0_3._step - 1

		local var1_3 = arg0_3._bulletData:GetPosition()
		local var2_3 = arg0_3._velocity

		arg0_3._speed = Vector3(var0_3.x - var1_3.x, 0, var0_3.z - var1_3.z).normalized
		arg0_3._speed = arg0_3._speed + Vector3(arg0_3._speed.z * arg0_3._count / 100, 0, -arg0_3._speed.x * arg0_3._count / 100)
		arg0_3._speed = arg0_3._speed.normalized
		arg0_3._speed = Vector3(arg0_3._speed.x * var2_3, 0, arg0_3._speed.z * var2_3)
	else
		arg0_3.updateSpeed = var2_0._updateSpeed
	end
end
