ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleBulletEvent
local var4 = pg.bfConsts
local var5 = var0.Battle.BattleFormulas
local var6 = var0.Battle.BattleConfig
local var7 = class("BattleMissileUnit", var0.Battle.BattleBulletUnit)

var7.__name = "BattleMissileUnit"
var0.Battle.BattleMissileUnit = var7
var7.STATE_LAUNCH = "Launch"
var7.STATE_ATTACK = "Attack"
var7.TYPE_COORD = 1
var7.TYPE_RANGE = 2
var7.TYPE_TARGET = 3

function var7.Ctor(arg0, ...)
	var7.super.Ctor(arg0, ...)

	arg0._state = arg0.STATE_LAUNCH
end

function var7.SetTemplateData(arg0, arg1)
	var7.super.SetTemplateData(arg0, arg1)
	arg0:ResetVelocity(0)

	local var0 = arg0:GetTemplate().extra_param

	arg0._gravity = var0.gravity or var0.Battle.BattleConfig.GRAVITY
	arg0._targetType = var0.aimType or var7.TYPE_TARGET
end

function var7.GetPierceCount(arg0)
	return 1
end

function var7.RegisterOnTheAir(arg0, arg1)
	arg0._onTheHighest = arg1
end

function var7.SetExplodePosition(arg0, arg1)
	arg0._explodePos = arg1:Clone()
	arg0._explodePos.y = var1.BombDetonateHeight
end

function var7.GetExplodePostion(arg0)
	return arg0._explodePos
end

local var8 = 1 / var6.viewFPS

function var7.SetSpawnPosition(arg0, arg1)
	var7.super.SetSpawnPosition(arg0, arg1)

	arg0._verticalSpeed = arg0:GetTemplate().extra_param.launchVrtSpeed
end

function var7.Update(arg0, arg1)
	var7.super.Update(arg0, arg1)

	if arg0._state == arg0.STATE_LAUNCH and arg1 > arg0:GetTemplate().extra_param.launchRiseTime + arg0._timeStamp then
		arg0:CompleteRise()
	end
end

function var7.CompleteRise(arg0)
	arg0._state = arg0.STATE_ATTACK
	arg0._gravity = 0

	if arg0._onTheHighest then
		arg0._onTheHighest()
	end

	local var0 = arg0:GetTemplate().extra_param.fallTime

	arg0._targetPos = arg0._explodePos
	arg0._yAngle = math.rad2Deg * math.atan2(arg0._explodePos.z - arg0._spawnPos.z, arg0._explodePos.x - arg0._spawnPos.x)
	arg0._verticalSpeed = -(arg0._position.y / var0) * var8

	local var1 = pg.Tool.FilterY(arg0._explodePos - arg0._position):Magnitude()

	arg0:ResetVelocity(var5.ConvertBulletDataSpeed(var1 / var0 * var8))
	arg0:calcSpeed()
end

function var7.IsOutRange(arg0)
	return arg0._state == arg0.STATE_ATTACK and arg0._position.y <= var1.BombDetonateHeight
end

function var7.OutRange(arg0, arg1)
	local var0 = {
		UID = arg1
	}

	arg0:DispatchEvent(var0.Event.New(var3.EXPLODE, var0))
	var7.super.OutRange(arg0)
end

function var7.GetMissileTargetPosition(arg0)
	if arg0._targetType == var7.TYPE_RANGE then
		return arg0:aimRange()
	elseif arg0._targetType == var7.TYPE_COORD then
		return arg0:aimCoord()
	elseif arg0._targetType == var7.TYPE_TARGET then
		return arg0:aimTarget()
	end
end

function var7.aimRange(arg0)
	local var0 = arg0._range
	local var1 = arg0._range * arg0:GetIFF()

	return (Vector3(arg0._spawnPos.x + var1, 0, 0))
end

function var7.aimCoord(arg0)
	local var0 = arg0:GetTemplate().extra_param
	local var1 = var0.missileX
	local var2 = var0.missileZ

	if not var1 or not var2 then
		return arg0:aimRange()
	end

	return (Vector3(var1, 0, var2))
end

function var7.aimTarget(arg0)
	local var0 = arg0:GetWeapon()
	local var1 = var0:GetHost()

	if not var1 or not var1:IsAlive() then
		return arg0:aimCoord()
	end

	local var2 = var0:Tracking()

	return var0:GetTemplateData().aim_type == var2.WeaponAimType.AIM and var2 and var0:CalculateRandTargetPosition(arg0, var2) or var0:CalculateFixedExplodePosition(arg0)
end
