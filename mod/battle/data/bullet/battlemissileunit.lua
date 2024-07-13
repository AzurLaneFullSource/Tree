ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleBulletEvent
local var4_0 = pg.bfConsts
local var5_0 = var0_0.Battle.BattleFormulas
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = class("BattleMissileUnit", var0_0.Battle.BattleBulletUnit)

var7_0.__name = "BattleMissileUnit"
var0_0.Battle.BattleMissileUnit = var7_0
var7_0.STATE_LAUNCH = "Launch"
var7_0.STATE_ATTACK = "Attack"
var7_0.TYPE_COORD = 1
var7_0.TYPE_RANGE = 2
var7_0.TYPE_TARGET = 3

function var7_0.Ctor(arg0_1, ...)
	var7_0.super.Ctor(arg0_1, ...)

	arg0_1._state = arg0_1.STATE_LAUNCH
end

function var7_0.SetTemplateData(arg0_2, arg1_2)
	var7_0.super.SetTemplateData(arg0_2, arg1_2)
	arg0_2:ResetVelocity(0)

	local var0_2 = arg0_2:GetTemplate().extra_param

	arg0_2._gravity = var0_2.gravity or var0_0.Battle.BattleConfig.GRAVITY
	arg0_2._targetType = var0_2.aimType or var7_0.TYPE_TARGET
end

function var7_0.GetPierceCount(arg0_3)
	return 1
end

function var7_0.RegisterOnTheAir(arg0_4, arg1_4)
	arg0_4._onTheHighest = arg1_4
end

function var7_0.SetExplodePosition(arg0_5, arg1_5)
	arg0_5._explodePos = arg1_5:Clone()
	arg0_5._explodePos.y = var1_0.BombDetonateHeight
end

function var7_0.GetExplodePostion(arg0_6)
	return arg0_6._explodePos
end

local var8_0 = 1 / var6_0.viewFPS

function var7_0.SetSpawnPosition(arg0_7, arg1_7)
	var7_0.super.SetSpawnPosition(arg0_7, arg1_7)

	arg0_7._verticalSpeed = arg0_7:GetTemplate().extra_param.launchVrtSpeed
end

function var7_0.Update(arg0_8, arg1_8)
	var7_0.super.Update(arg0_8, arg1_8)

	if arg0_8._state == arg0_8.STATE_LAUNCH and arg1_8 > arg0_8:GetTemplate().extra_param.launchRiseTime + arg0_8._timeStamp then
		arg0_8:CompleteRise()
	end
end

function var7_0.CompleteRise(arg0_9)
	arg0_9._state = arg0_9.STATE_ATTACK
	arg0_9._gravity = 0

	if arg0_9._onTheHighest then
		arg0_9._onTheHighest()
	end

	local var0_9 = arg0_9:GetTemplate().extra_param.fallTime

	arg0_9._targetPos = arg0_9._explodePos
	arg0_9._yAngle = math.rad2Deg * math.atan2(arg0_9._explodePos.z - arg0_9._spawnPos.z, arg0_9._explodePos.x - arg0_9._spawnPos.x)
	arg0_9._verticalSpeed = -(arg0_9._position.y / var0_9) * var8_0

	local var1_9 = pg.Tool.FilterY(arg0_9._explodePos - arg0_9._position):Magnitude()

	arg0_9:ResetVelocity(var5_0.ConvertBulletDataSpeed(var1_9 / var0_9 * var8_0))
	arg0_9:calcSpeed()
end

function var7_0.IsOutRange(arg0_10)
	return arg0_10._state == arg0_10.STATE_ATTACK and arg0_10._position.y <= var1_0.BombDetonateHeight
end

function var7_0.OutRange(arg0_11, arg1_11)
	local var0_11 = {
		UID = arg1_11
	}

	arg0_11:DispatchEvent(var0_0.Event.New(var3_0.EXPLODE, var0_11))
	var7_0.super.OutRange(arg0_11)
end

function var7_0.GetMissileTargetPosition(arg0_12)
	if arg0_12._targetType == var7_0.TYPE_RANGE then
		return arg0_12:aimRange()
	elseif arg0_12._targetType == var7_0.TYPE_COORD then
		return arg0_12:aimCoord()
	elseif arg0_12._targetType == var7_0.TYPE_TARGET then
		return arg0_12:aimTarget()
	end
end

function var7_0.aimRange(arg0_13)
	local var0_13 = arg0_13._range
	local var1_13 = arg0_13._range * arg0_13:GetIFF()

	return (Vector3(arg0_13._spawnPos.x + var1_13, 0, 0))
end

function var7_0.aimCoord(arg0_14)
	local var0_14 = arg0_14:GetTemplate().extra_param
	local var1_14 = var0_14.missileX
	local var2_14 = var0_14.missileZ

	if not var1_14 or not var2_14 then
		return arg0_14:aimRange()
	end

	return (Vector3(var1_14, 0, var2_14))
end

function var7_0.aimTarget(arg0_15)
	local var0_15 = arg0_15:GetWeapon()
	local var1_15 = var0_15:GetHost()

	if not var1_15 or not var1_15:IsAlive() then
		return arg0_15:aimCoord()
	end

	local var2_15 = var0_15:Tracking()

	return var0_15:GetTemplateData().aim_type == var2_0.WeaponAimType.AIM and var2_15 and var0_15:CalculateRandTargetPosition(arg0_15, var2_15) or var0_15:CalculateFixedExplodePosition(arg0_15)
end
