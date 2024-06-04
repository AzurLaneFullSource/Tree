ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleResourceManager

var0.Battle.BattleStrayBullet = class("BattleStrayBullet", var0.Battle.BattleBullet)
var0.Battle.BattleStrayBullet.__name = "BattleStrayBullet"

local var2 = var0.Battle.BattleStrayBullet

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)
end

function var2.SetSpawn(arg0, arg1)
	var2.super.SetSpawn(arg0, arg1)

	arg0._targetPos = Clone(arg0._bulletData:GetExplodePostion())
	arg0._spawnDir = arg0._speed.normalized

	local var0 = 1 + var0.Battle.BattleAttr.GetCurrent(arg0._bulletData, "bulletSpeedRatio")

	arg0._velocity = arg0._bulletData:GetVelocity() * var0
	arg0._velocity = var0.Battle.BattleFormulas.ConvertBulletSpeed(arg0._velocity)
	arg0._step = Vector3.Distance(arg0._targetPos, arg0._spawnPos) / arg0._velocity
	arg0._count = math.random(600) - 300
	arg0.updateSpeed = var2._doStray
end

function var2._doStray(arg0)
	local var0 = arg0._targetPos

	if arg0._step > 0 and var0 and not var0:EqualZero() then
		arg0._count = arg0._count / 1.06
		arg0._step = arg0._step - 1

		local var1 = arg0._bulletData:GetPosition()
		local var2 = arg0._velocity

		arg0._speed = Vector3(var0.x - var1.x, 0, var0.z - var1.z).normalized
		arg0._speed = arg0._speed + Vector3(arg0._speed.z * arg0._count / 100, 0, -arg0._speed.x * arg0._count / 100)
		arg0._speed = arg0._speed.normalized
		arg0._speed = Vector3(arg0._speed.x * var2, 0, arg0._speed.z * var2)
	else
		arg0.updateSpeed = var2._updateSpeed
	end
end
