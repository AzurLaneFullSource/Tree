ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleBombBulletUnit = class("BattleBombBulletUnit", var0_0.Battle.BattleBulletUnit)
var0_0.Battle.BattleBombBulletUnit.__name = "BattleBombBulletUnit"

local var3_0 = var0_0.Battle.BattleBombBulletUnit

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	var3_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._randomOffset = Vector3.zero
end

function var3_0.InitSpeed(arg0_2)
	if arg0_2._barrageLowPriority then
		arg0_2._yAngle = arg0_2._baseAngle + arg0_2._barrageAngle
	else
		arg0_2._yAngle = math.rad2Deg * math.atan2(arg0_2._explodePos.z - arg0_2._spawnPos.z, arg0_2._explodePos.x - arg0_2._spawnPos.x)
	end

	arg0_2:calcSpeed()

	arg0_2.updateSpeed = var3_0.doNothing
end

function var3_0.Update(arg0_3)
	if arg0_3._exist then
		var3_0.super.Update(arg0_3)
	end
end

function var3_0.GetPierceCount(arg0_4)
	return 1
end

function var3_0.IsOutRange(arg0_5, arg1_5)
	if not arg0_5._exist then
		return false
	end

	if arg0_5._explodeTime and arg1_5 >= arg0_5._explodeTime then
		return true
	end

	if arg0_5._reachDestFlag and not arg0_5._explodeTime then
		return true
	else
		return false
	end
end

function var3_0.OutRange(arg0_6)
	local var0_6 = {
		UID = unitUniqueID
	}

	arg0_6:DispatchEvent(var0_0.Event.New(var1_0.EXPLODE, var0_6))
	var3_0.super.OutRange(arg0_6)
end

function var3_0.SetSpawnPosition(arg0_7, arg1_7)
	var3_0.super.SetSpawnPosition(arg0_7, arg1_7)

	if arg0_7._barragePriority then
		arg0_7._explodePos = arg0_7._explodePos + Vector3(arg0_7._offsetX, 0, arg0_7._offsetZ)

		local var0_7 = Quaternion.Euler(0, arg0_7._barrageAngle, 0)
		local var1_7 = pg.Tool.FilterY(arg0_7._spawnPos)

		arg0_7._explodePos = var0_7 * (arg0_7._explodePos - var1_7) + var1_7
	end

	if arg0_7._fixToRange and Vector3.BattleDistance(arg0_7._explodePos, arg0_7._spawnPos) > arg0_7._range then
		local var2_7 = pg.Tool.FilterY(arg0_7._explodePos - arg0_7._spawnPos)

		arg0_7._explodePos = Vector3.Normalize(var2_7) * arg0_7._range + arg0_7._spawnPos
	end

	if arg0_7._convertedVelocity ~= 0 then
		local var3_7 = pg.Tool.FilterY(arg0_7._spawnPos)
		local var4_7 = Vector3.Distance(var3_7, arg0_7._explodePos) / arg0_7._convertedVelocity
		local var5_7 = arg0_7._explodePos.y - arg0_7._spawnPos.y

		arg0_7._verticalSpeed = arg0_7:GetTemplate().extra_param.launchVrtSpeed or var5_7 / var4_7 - 0.5 * arg0_7._gravity * var4_7
	end
end

function var3_0.SetExplodePosition(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetTemplate().extra_param

	if var0_8.targetFixX and var0_8.targetFixZ then
		arg0_8._explodePos = Vector3(var0_8.targetFixX, 0, var0_8.targetFixZ)
	else
		arg0_8._explodePos = arg1_8:Clone()
	end

	if not arg0_8._barragePriority then
		arg0_8._explodePos = arg0_8._explodePos + arg0_8._randomOffset
	end

	arg0_8._explodePos.y = var2_0.BombDetonateHeight
end

function var3_0.SetTemplateData(arg0_9, arg1_9)
	var3_0.super.SetTemplateData(arg0_9, arg1_9)

	local var0_9 = arg0_9:GetTemplate().extra_param

	arg0_9._barragePriority = var0_9.barragePriority
	arg0_9._barrageLowPriority = var0_9.barrageLowPriority
	arg0_9._fixToRange = var0_9.fixToRange

	if var0_9.barragePriority then
		arg0_9._randomOffset = Vector3.zero
	else
		local var1_9 = var0_9.accuracy
		local var2_9 = 0

		if var1_9 then
			var2_9 = arg0_9:GetAttrByName(var1_9)
		end

		local var3_9 = var0_9.randomOffsetX or 0
		local var4_9 = var0_9.randomOffsetZ or 0
		local var5_9 = math.max(0, var3_9 - var2_9)
		local var6_9 = math.max(0, var4_9 - var2_9)
		local var7_9 = var0_9.offsetX or 0
		local var8_9 = var0_9.offsetZ or 0

		if var5_9 ~= 0 then
			var5_9 = var5_9 * (math.random() - 0.5) + var7_9
		end

		if var6_9 ~= 0 then
			var6_9 = var6_9 * (math.random() - 0.5) + var8_9
		end

		local var9_9 = var0_9.targetOffsetX or 0
		local var10_9 = var0_9.targetOffsetZ or 0

		arg0_9._randomOffset = Vector3(var5_9 + var9_9, 0, var6_9 + var10_9)
	end

	if var0_9.timeToExplode then
		arg0_9._explodeTime = pg.TimeMgr.GetInstance():GetCombatTime() + var0_9.timeToExplode
	end

	arg0_9._gravity = var0_9.gravity or var0_0.Battle.BattleConfig.GRAVITY
	arg0_9._hitInterval = arg1_9.hit_type.interval or 0.2
end

function var3_0.DealDamage(arg0_10)
	arg0_10._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_10._hitInterval
end

function var3_0.CanDealDamage(arg0_11)
	if not arg0_11._nextDamageTime then
		arg0_11._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_11._tempData.extra_param.alert_duration

		return false
	else
		return arg0_11._nextDamageTime < pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var3_0.HideBullet(arg0_12)
	arg0_12._position.x = 0
	arg0_12._position.y = 100
	arg0_12._position.z = 0
end

function var3_0.GetExplodePostion(arg0_13)
	return arg0_13._explodePos
end
