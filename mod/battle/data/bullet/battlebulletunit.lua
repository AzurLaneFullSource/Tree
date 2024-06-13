ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = var0.Battle.BattleFormulas
local var3 = Vector3.up
local var4 = var0.Battle.BattleVariable
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleTargetChoise
local var7 = 1 / var0.Battle.BattleConfig.viewFPS
local var8 = var0.Battle.BattleConst

var0.Battle.BattleBulletUnit = class("BattleBulletUnit")
var0.Battle.BattleBulletUnit.__name = "BattleBulletUnit"

local var9 = var0.Battle.BattleBulletUnit

var9.ACC_INTERVAL = var5.calcInterval
var9.TRACKER_ANGLE = math.cos(math.deg2Rad * 10)
var9.MIRROR_RES = "_mirror"

function var9.doAccelerate(arg0, arg1)
	local var0, var1 = arg0:GetAcceleration(arg1)

	if var0 == 0 and var1 == 0 then
		return
	end

	if var0 < 0 and arg0._speedLength + var0 < 0 then
		arg0:reverseAcceleration()
	end

	arg0._speed:Set(arg0._speed.x + arg0._speedNormal.x * var0 + arg0._speedCross.x * var1, arg0._speed.y + arg0._speedNormal.y * var0 + arg0._speedCross.y * var1, arg0._speed.z + arg0._speedNormal.z * var0 + arg0._speedCross.z * var1)

	arg0._speedLength = arg0._speed:Magnitude()

	if arg0._speedLength ~= 0 then
		arg0._speedNormal:Copy(arg0._speed):Div(arg0._speedLength)
	end

	arg0._speedCross:Copy(arg0._speedNormal):Cross2(var3)
end

function var9.doTrack(arg0)
	if arg0:getTrackingTarget() == nil then
		local var0 = var6.TargetHarmNearest(arg0)[1]

		if var0 ~= nil and arg0:GetDistance(var0) <= arg0._trackRange then
			arg0:setTrackingTarget(var0)
		end
	end

	local var1 = arg0:getTrackingTarget()

	if var1 == nil or var1 == -1 then
		return
	elseif not var1:IsAlive() then
		arg0:setTrackingTarget(-1)

		return
	elseif arg0:GetDistance(var1) > arg0._trackRange then
		arg0:setTrackingTarget(-1)

		return
	end

	local var2 = var1:GetBeenAimedPosition()

	if not var2 then
		return
	end

	local var3 = var2 - arg0:GetPosition()

	var3:SetNormalize()

	local var4 = Vector3.Normalize(arg0._speed)
	local var5 = Vector3.Dot(var4, var3)
	local var6 = var4.z * var3.x - var4.x * var3.z

	if var5 >= var9.TRACKER_ANGLE then
		return
	end

	local var7 = arg0:GetSpeedRatio()
	local var8 = math.cos(arg0._cosAngularSpeed * var7)
	local var9 = math.sin(arg0._sinAngularSpeed * var7)
	local var10 = var5
	local var11 = var6

	if var5 < var8 then
		var10 = var8
		var11 = var9 * (var11 >= 0 and 1 or -1)
	end

	local var12 = arg0._speed.x * var10 + arg0._speed.z * var11
	local var13 = arg0._speed.z * var10 - arg0._speed.x * var11

	arg0._speed:Set(var12, 0, var13)
end

function var9.doOrbit(arg0)
	local var0 = pg.Tool.FilterY(arg0._weapon:GetPosition())
	local var1 = pg.Tool.FilterY(arg0:GetPosition())
	local var2 = (var1 - var0).magnitude
	local var3 = (var0 - var1).normalized
	local var4

	if var2 > 10 then
		var4 = (var3 + arg0._speed.normalized).normalized
	else
		var4 = (Vector3(-var3.z, 0, var3.x) + arg0._speed.normalized).normalized
	end

	arg0._speed = var4
end

function var9.RotateY(arg0, arg1)
	local var0 = math.cos(arg1)
	local var1 = math.sin(arg1)

	return Vector3(arg0.x * var0 + arg0.z * var1, arg0.y, arg0.z * var0 - arg0.x * var1)
end

function var9.doCircle(arg0)
	if not arg0._originPos then
		return
	end

	local var0 = arg0:GetSpeedRatio() * (1 + var0.Battle.BattleAttr.GetCurrent(arg0, "bulletSpeedRatio"))
	local var1 = pg.Tool.FilterY(arg0._position - arg0._originPos)
	local var2 = arg0._convertedVelocity
	local var3 = var1:Magnitude()
	local var4 = var3 - arg0._centripetalSpeed * var0 * arg0._inverseFlag

	arg0._inverseFlag = var4 < 0 and -arg0._inverseFlag or arg0._inverseFlag

	if var3 <= 1e-05 then
		return
	end

	local var5 = arg0._circleAntiClockwise
	local var6 = var2 / var3 * (var5 and 1 or -1) * var0

	arg0._speed = arg0.RotateY(var1, var6):Mul(var4 / var3):Sub(var1)
end

function var9.doNothing(arg0)
	if arg0._gravity ~= 0 then
		arg0._verticalSpeed = arg0._verticalSpeed + arg0._gravity * arg0:GetSpeedRatio()
	end
end

function var9.Ctor(arg0, arg1, arg2)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._battleProxy = var0.Battle.BattleDataProxy.GetInstance()
	arg0._uniqueID = arg1
	arg0._speedExemptKey = "bullet_" .. arg1
	arg0._IFF = arg2
	arg0._collidedList = {}
	arg0._speed = Vector3.zero
	arg0._exist = true
	arg0._timeStamp = 0
	arg0._dmgEnhanceRate = 1
	arg0._frame = 0
	arg0._reachDestFlag = false
	arg0._verticalSpeed = 0
	arg0._damageList = {}
end

function var9.Update(arg0, arg1)
	local var0 = arg0:GetSpeedRatio()

	arg0:updateSpeed(arg1)
	arg0:updateBarrageTransform(arg1)
	arg0._position:Set(arg0._position.x + arg0._speed.x * var0, arg0._position.y + arg0._speed.y * var0, arg0._position.z + arg0._speed.z * var0)

	arg0._position.y = arg0._position.y + arg0._verticalSpeed * var0

	if arg0._gravity == 0 then
		arg0._reachDestFlag = Vector3.SqrDistance(arg0._spawnPos, arg0._position) > arg0._sqrRange
	else
		if arg0._fieldSwitchHeight ~= 0 and arg0._position.y <= arg0._fieldSwitchHeight then
			arg0._field = var8.BulletField.SURFACE
		end

		arg0._reachDestFlag = arg0._position.y <= var5.BombDetonateHeight
	end
end

function var9.ActiveCldBox(arg0)
	arg0._cldComponent:SetActive(true)
end

function var9.DeactiveCldBox(arg0)
	arg0._cldComponent:SetActive(false)
end

function var9.SetStartTimeStamp(arg0, arg1)
	arg0._timeStamp = arg1
end

function var9.Hit(arg0, arg1, arg2)
	arg0._collidedList[arg1] = true

	local var0 = {
		UID = arg1,
		type = arg2
	}

	arg0:DispatchEvent(var0.Event.New(var1.HIT, var0))
end

function var9.Intercepted(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.INTERCEPTED, {}))
end

function var9.Reflected(arg0)
	arg0._speed.x = -arg0._speed.x
end

function var9.ResetVelocity(arg0, arg1)
	local var0 = arg0._tempData
	local var1 = arg0:GetTemplate().extra_param

	if not arg1 then
		arg1 = var0.velocity

		if var1.velocity_offset then
			arg1 = math.random(arg1 - var1.velocity_offset, arg1 + var1.velocity_offset)
		elseif var1.velocity_offsetF then
			arg1 = arg1 + math.random() * 2 * var1.velocity_offsetF - var1.velocity_offsetF
		end
	end

	arg0._velocity = arg1
	arg0._convertedVelocity = var2.ConvertBulletSpeed(arg0._velocity)
end

function var9.SetTemplateData(arg0, arg1)
	arg0._tempData = setmetatable({}, {
		__index = arg1
	})

	local var0 = arg0:GetTemplate().extra_param

	arg0:SetModleID(arg1.modle_ID, var9.ORIGNAL_RES)
	arg0:SetSFXID(arg0._tempData.hit_sfx, arg0._tempData.miss_sfx)
	arg0:ResetVelocity()

	arg0._pierceCount = arg1.pierce_count

	arg0:FixRange()
	arg0:InitCldComponent()

	arg0._accTable = Clone(arg0._tempData.acceleration)

	table.sort(arg0._accTable, function(arg0, arg1)
		return arg0.t < arg1.t
	end)

	arg0._field = arg1.effect_type
	arg0._gravity = var0.gravity or 0
	arg0._fieldSwitchHeight = var0.effectSwitchHeight or 0
	arg0._ignoreShield = arg0._tempData.extra_param.ignoreShield == true
	arg0._autoRotate = arg0._tempData.extra_param.dontRotate ~= true

	arg0:SetDiverFilter()
end

function var9.GetModleID(arg0)
	local var0 = arg0:GetTemplate().extra_param
	local var1

	if arg0._IFF == var5.FOE_CODE then
		if arg0._mirrorSkin == var9.MIRROR_SKIN_RES then
			var1 = arg0._modleID .. var9.MIRROR_RES
		elseif arg0._mirrorSkin == var9.ORIGNAL_RES and var0.mirror == true then
			var1 = arg0._modleID .. var9.MIRROR_RES
		else
			var1 = arg0._modleID
		end
	else
		var1 = arg0._modleID
	end

	return var1
end

var9.ORIGNAL_RES = -1
var9.SKIN_RES = 0
var9.MIRROR_SKIN_RES = 1

function var9.SetModleID(arg0, arg1, arg2, arg3)
	arg0._modleID = arg1
	arg0._mirrorSkin = arg2

	if arg3 and arg3 ~= "" then
		arg0._tempData.hit_fx = arg3
	end
end

function var9.SetSFXID(arg0, arg1, arg2)
	if arg1 then
		arg0._hitSFX = arg1
	end

	if arg2 then
		arg0._missSFX = arg2
	end
end

function var9.SetShiftInfo(arg0, arg1, arg2)
	local var0 = 0
	local var1 = 0
	local var2 = arg0:GetTemplate().extra_param

	if var2.randomLaunchOffsetX then
		var0 = math.random() * var2.randomLaunchOffsetX * 2 - var2.randomLaunchOffsetX
	end

	if var2.randomLaunchOffsetZ then
		var1 = math.random() * var2.randomLaunchOffsetZ * 2 - var2.randomLaunchOffsetZ
	end

	arg0._offsetX = arg1 + var0
	arg0._offsetZ = arg2 + var1
end

function var9.SetRotateInfo(arg0, arg1, arg2, arg3)
	arg0._targetPos = arg1
	arg0._baseAngle = arg2
	arg0._barrageAngle = arg3

	local var0 = arg0._barrageAngle % 360

	if var0 > 0 and var0 < 180 then
		for iter0, iter1 in ipairs(arg0._accTable) do
			if iter1.flip then
				iter1.v = iter1.v * -1
			end
		end
	end
end

function var9.SetBarrageTransformTempate(arg0, arg1)
	if #arg1 > 0 then
		arg0._barrageTransData = arg1
	end
end

function var9.SetAttr(arg0, arg1)
	var0.Battle.BattleAttr.SetAttr(arg0, arg1)
end

function var9.GetAttr(arg0)
	return var0.Battle.BattleAttr.GetAttr(arg0)
end

function var9.SetStandHostAttr(arg0, arg1)
	arg0._standUnit = {}

	var0.Battle.BattleAttr.SetAttr(arg0._standUnit, arg1)
end

function var9.GetWeaponHostAttr(arg0)
	if arg0._standUnit then
		return var0.Battle.BattleAttr.GetAttr(arg0._standUnit)
	else
		return arg0:GetAttr()
	end
end

function var9.GetWeaponAtkAttr(arg0)
	local var0 = arg0:GetWeaponHostAttr()
	local var1
	local var2 = arg0._weapon:GetAtkAttrTrasnform(var0)

	if var2 then
		var1 = var2
	else
		local var3 = arg0:GetWeaponTempData().attack_attribute

		var1 = var0.Battle.BattleAttr.GetAtkAttrByType(var0, var3)
	end

	return var1
end

function var9.GetWeaponCardPuzzleEnhance(arg0)
	return arg0._weapon:GetCardPuzzleDamageEnhance()
end

function var9.SetDamageEnhance(arg0, arg1)
	arg0._dmgEnhanceRate = arg1
end

function var9.GetDamageEnhance(arg0)
	return arg0._dmgEnhanceRate
end

function var9.GetAttrByName(arg0, arg1)
	return var0.Battle.BattleAttr.GetCurrent(arg0, arg1)
end

function var9.GetVerticalSpeed(arg0)
	return arg0._verticalSpeed
end

function var9.IsGravitate(arg0)
	return arg0._gravity ~= 0
end

function var9.SetBuffTrigger(arg0, arg1)
	arg0._host = arg1
	arg0._buffTriggerFun = {}
end

function var9.SetBuffFun(arg0, arg1, arg2)
	local var0 = arg0._buffTriggerFun[arg1] or {}

	var0[#var0 + 1] = arg2
	arg0._buffTriggerFun[arg1] = var0
end

function var9.BuffTrigger(arg0, arg1, arg2)
	local var0 = arg0._host

	if var0 and var0:IsAlive() then
		arg0._host:TriggerBuff(arg1, arg2)

		local var1 = arg0._buffTriggerFun[arg1]

		if var1 then
			for iter0, iter1 in ipairs(var1) do
				iter1(arg0._host, arg2)
			end
		end
	end
end

function var9.SetIsCld(arg0, arg1)
	arg0._needCld = arg1
end

function var9.GetIsCld(arg0)
	return arg0._needCld
end

function var9.IsIngoreCld(arg0)
	return arg0._tempData.extra_param.ingoreCld
end

function var9.IsFragile(arg0)
	return arg0._tempData.extra_param.fragile
end

function var9.IsIndiscriminate(arg0)
	return arg0._tempData.extra_param.indiscriminate
end

function var9.GetExtraTag(arg0)
	return arg0._tempData.extra_param.tag
end

function var9.AppendDamageUnit(arg0, arg1)
	arg0._damageList[#arg0._damageList + 1] = arg1
end

function var9.DamageUnitListWriteback(arg0)
	arg0._weapon:UpdateCombo(arg0._damageList)
end

function var9.HasAcceleration(arg0)
	return #arg0._accTable ~= 0
end

function var9.IsTracker(arg0)
	return arg0._accTable.tracker
end

function var9.IsOrbit(arg0)
	return arg0._accTable.orbit
end

function var9.IsCircle(arg0)
	return arg0._accTable.circle
end

function var9.GetAcceleration(arg0, arg1)
	arg0._lastAccTime = arg0._lastAccTime or arg0._timeStamp

	local var0 = math.modf((arg1 - arg0._lastAccTime) / var9.ACC_INTERVAL)

	arg0._lastAccTime = arg0._lastAccTime + var9.ACC_INTERVAL * var0

	local var1 = arg1 - arg0._timeStamp
	local var2 = #arg0._accTable

	while var2 > 0 do
		local var3 = arg0._accTable[var2]

		if var1 + var9.ACC_INTERVAL < var3.t then
			var2 = var2 - 1
		else
			return var3.u * var0, var3.v * var0
		end
	end

	return 0, 0
end

function var9.reverseAcceleration(arg0)
	for iter0, iter1 in ipairs(arg0._accTable) do
		iter1.u = iter1.u * -1
	end
end

function var9.GetDistance(arg0, arg1)
	local var0 = arg0._battleProxy.FrameIndex

	if arg0._frame ~= var0 then
		arg0._distanceBackup = {}
		arg0._frame = var0
	end

	local var1 = arg0._distanceBackup[arg1]

	if var1 == nil then
		var1 = Vector3.Distance(arg0:GetPosition(), arg1:GetPosition())
		arg0._distanceBackup[arg1] = var1

		arg1:backupDistance(arg0, var1)
	end

	return var1
end

function var9.backupDistance(arg0, arg1, arg2)
	local var0 = arg0._battleProxy.FrameIndex

	if arg0._frame ~= var0 then
		arg0._distanceBackup = {}
		arg0._frame = var0
	end

	arg0._distanceBackup[arg1] = arg2
end

function var9.getTrackingTarget(arg0)
	return arg0._tarckingTarget
end

function var9.setTrackingTarget(arg0, arg1)
	arg0._tarckingTarget = arg1
end

function var9.SetWeapon(arg0, arg1)
	arg0._weapon = arg1

	if arg1 then
		arg0._correctedDMG = arg0._weapon:GetCorrectedDMG()
	end
end

function var9.GetWeapon(arg0)
	return arg0._weapon
end

function var9.GetCorrectedDMG(arg0)
	return arg0._correctedDMG
end

function var9.OverrideCorrectedDMG(arg0, arg1)
	arg0._correctedDMG = var2.WeaponDamagePreCorrection(arg0._weapon, arg1)
end

function var9.GetWeaponTempData(arg0)
	return arg0._weapon:GetTemplateData()
end

function var9.GetPosition(arg0)
	return arg0._position or Vector3.zero
end

function var9.SetSpawnPosition(arg0, arg1)
	arg0._spawnPos = arg1
	arg0._position = arg1:Clone()

	if arg0._gravity ~= 0 then
		local var0 = math.atan2(arg0._speed.x, arg0._speed.z)

		if var0 == 0 then
			arg0._verticalSpeed = 0
		else
			local var1 = Vector3(math.cos(var0) * 60, math.sin(var0) * 60)
			local var2 = 60 / arg0._convertedVelocity

			arg0._verticalSpeed = -0.5 * arg0._gravity * var2
		end
	end
end

function var9.GetSpawnPosition(arg0)
	return arg0._spawnPos
end

function var9.GetTemplate(arg0)
	return arg0._tempData
end

function var9.GetType(arg0)
	return arg0._tempData.type
end

function var9.GetHitSFX(arg0)
	return arg0._hitSFX
end

function var9.GetMissSFX(arg0)
	return arg0._missSFX
end

function var9.GetOutBound(arg0)
	return arg0._tempData.out_bound
end

function var9.GetUniqueID(arg0)
	return arg0._uniqueID
end

function var9.GetOffset(arg0)
	return arg0._offsetX, arg0._offsetZ, arg0._isOffsetPriority
end

function var9.GetRotateInfo(arg0)
	return arg0._targetPos, arg0._baseAngle, arg0._barrageAngle
end

function var9.IsOutRange(arg0)
	return arg0._reachDestFlag
end

function var9.SetYAngle(arg0, arg1)
	arg0._yAngle = arg1
end

function var9.SetOffsetPriority(arg0, arg1)
	arg0._isOffsetPriority = arg1 or false
end

function var9.GetOffsetPriority(arg0)
	return arg0._isOffsetPriority
end

function var9.GetYAngle(arg0)
	return arg0._yAngle
end

function var9.GetCurrentYAngle(arg0)
	local var0 = Vector3.Normalize(arg0._speed)
	local var1 = math.acos(var0.x) / math.deg2Rad

	if var0.z < 0 then
		var1 = 360 - var1
	end

	return var1
end

function var9.GetIFF(arg0)
	return arg0._IFF
end

function var9.GetHost(arg0)
	return arg0._host
end

function var9.GetPierceCount(arg0)
	return arg0._pierceCount
end

function var9.AppendAttachBuff(arg0, arg1)
	arg0._attachBuffList = arg0._attachBuffList or arg0:generateAttachBuffList()

	table.insert(arg0._attachBuffList, arg1)
end

function var9.GetAttachBuff(arg0)
	arg0._attachBuffList = arg0._attachBuffList or arg0:generateAttachBuffList()

	return arg0._attachBuffList
end

function var9.generateAttachBuffList(arg0)
	local var0 = {}

	if not arg0:GetTemplate().attach_buff then
		local var1 = {}
	end

	for iter0, iter1 in ipairs(arg0:GetTemplate().attach_buff) do
		local var2 = {
			buff_id = iter1.buff_id,
			level = iter1.buff_level,
			rant = iter1.rant,
			hit_ignore = iter1.hit_ignore
		}

		table.insert(var0, var2)
	end

	return var0
end

function var9.GetEffectField(arg0)
	return arg0._field
end

function var9.SetDiverFilter(arg0, arg1)
	if arg1 == nil then
		arg0._diveFilter = arg0._tempData.extra_param.diveFilter or {
			2
		}
	else
		arg0._diveFilter = arg1
	end
end

function var9.GetDiveFilter(arg0)
	return arg0._diveFilter
end

function var9.GetVelocity(arg0)
	return arg0._velocity
end

function var9.GetConvertedVelocity(arg0)
	return arg0._convertedVelocity
end

function var9.GetSpeedExemptKey(arg0)
	return arg0._speedExemptKey
end

function var9.IsCollided(arg0, arg1)
	return arg0._collidedList[arg1]
end

function var9.GetExist(arg0)
	return arg0._exist
end

function var9.SetExist(arg0, arg1)
	arg0._exist = arg1
end

function var9.GetIgnoreShield(arg0)
	return arg0._ignoreShield
end

function var9.SetIgnoreShield(arg0, arg1)
	arg0._ignoreShield = arg1
end

function var9.IsAutoRotate(arg0)
	return arg0._autoRotate
end

function var9.Dispose(arg0)
	arg0._dataProxy = nil

	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var9.InitCldComponent(arg0)
	local var0 = arg0:GetTemplate().cld_box
	local var1 = arg0:GetTemplate().cld_offset
	local var2 = var1[1]

	if arg0:GetIFF() == var5.FOE_CODE then
		var2 = var2 * -1
	end

	arg0._cldComponent = var0.Battle.BattleCubeCldComponent.New(var0[1], var0[2], var0[3], var2, var1[3])

	local var3 = {
		type = var8.CldType.BULLET,
		IFF = arg0:GetIFF(),
		UID = arg0:GetUniqueID()
	}

	arg0._cldComponent:SetCldData(var3)
end

function var9.ResetCldSurface(arg0)
	local var0 = arg0:GetDiveFilter()

	if var0 and #var0 == 0 then
		arg0:GetCldData().Surface = var8.OXY_STATE.DIVE
	else
		arg0:GetCldData().Surface = var8.OXY_STATE.FLOAT
	end
end

function var9.GetBoxSize(arg0)
	return arg0._cldComponent:GetCldBoxSize()
end

function var9.GetCldBox(arg0)
	return arg0._cldComponent:GetCldBox(arg0:GetPosition())
end

function var9.GetCldData(arg0)
	return arg0._cldComponent:GetCldData()
end

function var9.GetSpeed(arg0)
	return arg0._speed
end

function var9.GetSpeedRatio(arg0)
	return var4.GetSpeedRatio(arg0._speedExemptKey, arg0._IFF)
end

function var9.InitSpeed(arg0, arg1)
	if arg0._yAngle == nil then
		arg0._yAngle = (arg1 or arg0._baseAngle) + arg0._barrageAngle
	end

	arg0:calcSpeed()

	if arg0:HasAcceleration() then
		arg0._speedLength = arg0._speed:Magnitude()

		local var0 = math.deg2Rad * arg0._yAngle

		arg0._speedNormal = Vector3(math.cos(var0), 0, math.sin(var0))
		arg0._speedCross = Vector3.Cross(arg0._speedNormal, var3)
		arg0.updateSpeed = var9.doAccelerate
	elseif arg0:IsTracker() then
		local var1 = arg0._accTable.tracker

		arg0._trackRange = var1.range
		arg0._cosAngularSpeed = math.deg2Rad * var1.angular
		arg0._sinAngularSpeed = math.deg2Rad * var1.angular
		arg0._negativeCosAngularSpeed = math.deg2Rad * var1.angular * -1
		arg0._negativeSinAngularSpeed = math.deg2Rad * var1.angular * -1
		arg0.updateSpeed = var9.doTrack
	elseif arg0:IsCircle() then
		local var2 = arg0._accTable.circle

		arg0._originPos = var2.center or arg0._targetPos
		arg0._circleAntiClockwise = tobool(var2.antiClockWise)
		arg0._centripetalSpeed = (var2.centripetalSpeed or 0) * var7
		arg0._inverseFlag = 1
		arg0.updateSpeed = var9.doCircle
	else
		arg0.updateSpeed = var9.doNothing
	end
end

function var9.calcSpeed(arg0)
	local var0 = 1 + var0.Battle.BattleAttr.GetCurrent(arg0, "bulletSpeedRatio")
	local var1 = arg0._velocity * var0
	local var2 = var2.ConvertBulletSpeed(var1)
	local var3 = math.deg2Rad * arg0._yAngle

	arg0._speed = Vector3(var2 * math.cos(var3), 0, var2 * math.sin(var3))
end

function var9.updateBarrageTransform(arg0, arg1)
	if not arg0._barrageTransData or #arg0._barrageTransData == 0 then
		return
	end

	local var0 = arg1 - arg0._timeStamp
	local var1 = arg0._barrageTransData[1]

	if var0 >= var1.transStartDelay then
		if var1.transAimAngle then
			arg0._yAngle = var1.transAimAngle
		else
			arg0._yAngle = math.rad2Deg * math.atan2(var1.transAimPosZ - arg0._position.z, var1.transAimPosX - arg0._position.x)
		end

		arg0:calcSpeed()
		table.remove(arg0._barrageTransData, 1)

		local var2 = arg0._barrageTransData[1]

		if var2 then
			var2.transStartDelay = var2.transStartDelay + var1.transStartDelay
		end
	end
end

function var9.GetCurrentDistance(arg0)
	return Vector3.Distance(arg0._spawnPos, arg0._position)
end

function var9.SetOutRangeCallback(arg0, arg1)
	arg0._outRangeFunc = arg1
end

function var9.OutRange(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.OUT_RANGE, {}))
	arg0._outRangeFunc(arg0)
end

function var9.FixRange(arg0, arg1, arg2)
	arg1 = arg1 or arg0._tempData.range
	arg2 = arg2 or 0

	local var0 = arg0._tempData.range_offset

	if var0 == 0 then
		arg0._range = arg1
	else
		arg0._range = arg1 + var0 * (math.random() - 0.5)
	end

	arg0._range = math.max(0, arg0._range + arg2)
	arg0._sqrRange = arg0._range * arg0._range
end

function var9.ImmuneBombCLS(arg0)
	return arg0:GetTemplate().extra_param.ignoreB
end

function var9.ImmuneCLS(arg0)
	return arg0._immuneCLS
end

function var9.SetImmuneCLS(arg0, arg1)
	arg0._immuneCLS = arg1
end
