ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = var0.Battle.BattleConfig

var0.Battle.BattleBombBulletUnit = class("BattleBombBulletUnit", var0.Battle.BattleBulletUnit)
var0.Battle.BattleBombBulletUnit.__name = "BattleBombBulletUnit"

local var3 = var0.Battle.BattleBombBulletUnit

function var3.Ctor(arg0, arg1, arg2)
	var3.super.Ctor(arg0, arg1, arg2)

	arg0._randomOffset = Vector3.zero
end

function var3.InitSpeed(arg0)
	if arg0._barrageLowPriority then
		arg0._yAngle = arg0._baseAngle + arg0._barrageAngle
	else
		arg0._yAngle = math.rad2Deg * math.atan2(arg0._explodePos.z - arg0._spawnPos.z, arg0._explodePos.x - arg0._spawnPos.x)
	end

	arg0:calcSpeed()

	arg0.updateSpeed = var3.doNothing
end

function var3.Update(arg0)
	if arg0._exist then
		var3.super.Update(arg0)
	end
end

function var3.GetPierceCount(arg0)
	return 1
end

function var3.IsOutRange(arg0, arg1)
	if not arg0._exist then
		return false
	end

	if arg0._explodeTime and arg1 >= arg0._explodeTime then
		return true
	end

	if arg0._reachDestFlag and not arg0._explodeTime then
		return true
	else
		return false
	end
end

function var3.OutRange(arg0)
	local var0 = {
		UID = unitUniqueID
	}

	arg0:DispatchEvent(var0.Event.New(var1.EXPLODE, var0))
	var3.super.OutRange(arg0)
end

function var3.SetSpawnPosition(arg0, arg1)
	var3.super.SetSpawnPosition(arg0, arg1)

	if arg0._barragePriority then
		arg0._explodePos = arg0._explodePos + Vector3(arg0._offsetX, 0, arg0._offsetZ)

		local var0 = Quaternion.Euler(0, arg0._barrageAngle, 0)
		local var1 = pg.Tool.FilterY(arg0._spawnPos)

		arg0._explodePos = var0 * (arg0._explodePos - var1) + var1
	end

	if arg0._fixToRange and Vector3.BattleDistance(arg0._explodePos, arg0._spawnPos) > arg0._range then
		local var2 = pg.Tool.FilterY(arg0._explodePos - arg0._spawnPos)

		arg0._explodePos = Vector3.Normalize(var2) * arg0._range + arg0._spawnPos
	end

	if arg0._convertedVelocity ~= 0 then
		local var3 = pg.Tool.FilterY(arg0._spawnPos)
		local var4 = Vector3.Distance(var3, arg0._explodePos) / arg0._convertedVelocity
		local var5 = arg0._explodePos.y - arg0._spawnPos.y

		arg0._verticalSpeed = arg0:GetTemplate().extra_param.launchVrtSpeed or var5 / var4 - 0.5 * arg0._gravity * var4
	end
end

function var3.SetExplodePosition(arg0, arg1)
	local var0 = arg0:GetTemplate().extra_param

	if var0.targetFixX and var0.targetFixZ then
		arg0._explodePos = Vector3(var0.targetFixX, 0, var0.targetFixZ)
	else
		arg0._explodePos = arg1:Clone()
	end

	if not arg0._barragePriority then
		arg0._explodePos = arg0._explodePos + arg0._randomOffset
	end

	arg0._explodePos.y = var2.BombDetonateHeight
end

function var3.SetTemplateData(arg0, arg1)
	var3.super.SetTemplateData(arg0, arg1)

	local var0 = arg0:GetTemplate().extra_param

	arg0._barragePriority = var0.barragePriority
	arg0._barrageLowPriority = var0.barrageLowPriority
	arg0._fixToRange = var0.fixToRange

	if var0.barragePriority then
		arg0._randomOffset = Vector3.zero
	else
		local var1 = var0.accuracy
		local var2 = 0

		if var1 then
			var2 = arg0:GetAttrByName(var1)
		end

		local var3 = var0.randomOffsetX or 0
		local var4 = var0.randomOffsetZ or 0
		local var5 = math.max(0, var3 - var2)
		local var6 = math.max(0, var4 - var2)
		local var7 = var0.offsetX or 0
		local var8 = var0.offsetZ or 0

		if var5 ~= 0 then
			var5 = var5 * (math.random() - 0.5) + var7
		end

		if var6 ~= 0 then
			var6 = var6 * (math.random() - 0.5) + var8
		end

		local var9 = var0.targetOffsetX or 0
		local var10 = var0.targetOffsetZ or 0

		arg0._randomOffset = Vector3(var5 + var9, 0, var6 + var10)
	end

	if var0.timeToExplode then
		arg0._explodeTime = pg.TimeMgr.GetInstance():GetCombatTime() + var0.timeToExplode
	end

	arg0._gravity = var0.gravity or var0.Battle.BattleConfig.GRAVITY
	arg0._hitInterval = arg1.hit_type.interval or 0.2
end

function var3.DealDamage(arg0)
	arg0._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._hitInterval
end

function var3.CanDealDamage(arg0)
	if not arg0._nextDamageTime then
		arg0._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._tempData.extra_param.alert_duration

		return false
	else
		return arg0._nextDamageTime < pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var3.HideBullet(arg0)
	arg0._position.x = 0
	arg0._position.y = 100
	arg0._position.z = 0
end

function var3.GetExplodePostion(arg0)
	return arg0._explodePos
end
