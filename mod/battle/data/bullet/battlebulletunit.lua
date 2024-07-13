ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = Vector3.up
local var4_0 = var0_0.Battle.BattleVariable
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleTargetChoise
local var7_0 = 1 / var0_0.Battle.BattleConfig.viewFPS
local var8_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleBulletUnit = class("BattleBulletUnit")
var0_0.Battle.BattleBulletUnit.__name = "BattleBulletUnit"

local var9_0 = var0_0.Battle.BattleBulletUnit

var9_0.ACC_INTERVAL = var5_0.calcInterval
var9_0.TRACKER_ANGLE = math.cos(math.deg2Rad * 10)
var9_0.MIRROR_RES = "_mirror"

function var9_0.doAccelerate(arg0_1, arg1_1)
	local var0_1, var1_1 = arg0_1:GetAcceleration(arg1_1)

	if var0_1 == 0 and var1_1 == 0 then
		return
	end

	if var0_1 < 0 and arg0_1._speedLength + var0_1 < 0 then
		arg0_1:reverseAcceleration()
	end

	arg0_1._speed:Set(arg0_1._speed.x + arg0_1._speedNormal.x * var0_1 + arg0_1._speedCross.x * var1_1, arg0_1._speed.y + arg0_1._speedNormal.y * var0_1 + arg0_1._speedCross.y * var1_1, arg0_1._speed.z + arg0_1._speedNormal.z * var0_1 + arg0_1._speedCross.z * var1_1)

	arg0_1._speedLength = arg0_1._speed:Magnitude()

	if arg0_1._speedLength ~= 0 then
		arg0_1._speedNormal:Copy(arg0_1._speed):Div(arg0_1._speedLength)
	end

	arg0_1._speedCross:Copy(arg0_1._speedNormal):Cross2(var3_0)
end

function var9_0.doTrack(arg0_2)
	if arg0_2:getTrackingTarget() == nil then
		local var0_2 = var6_0.TargetHarmNearest(arg0_2)[1]

		if var0_2 ~= nil and arg0_2:GetDistance(var0_2) <= arg0_2._trackRange then
			arg0_2:setTrackingTarget(var0_2)
		end
	end

	local var1_2 = arg0_2:getTrackingTarget()

	if var1_2 == nil or var1_2 == -1 then
		return
	elseif not var1_2:IsAlive() then
		arg0_2:setTrackingTarget(-1)

		return
	elseif arg0_2:GetDistance(var1_2) > arg0_2._trackRange then
		arg0_2:setTrackingTarget(-1)

		return
	end

	local var2_2 = var1_2:GetBeenAimedPosition()

	if not var2_2 then
		return
	end

	local var3_2 = var2_2 - arg0_2:GetPosition()

	var3_2:SetNormalize()

	local var4_2 = Vector3.Normalize(arg0_2._speed)
	local var5_2 = Vector3.Dot(var4_2, var3_2)
	local var6_2 = var4_2.z * var3_2.x - var4_2.x * var3_2.z

	if var5_2 >= var9_0.TRACKER_ANGLE then
		return
	end

	local var7_2 = arg0_2:GetSpeedRatio()
	local var8_2 = math.cos(arg0_2._cosAngularSpeed * var7_2)
	local var9_2 = math.sin(arg0_2._sinAngularSpeed * var7_2)
	local var10_2 = var5_2
	local var11_2 = var6_2

	if var5_2 < var8_2 then
		var10_2 = var8_2
		var11_2 = var9_2 * (var11_2 >= 0 and 1 or -1)
	end

	local var12_2 = arg0_2._speed.x * var10_2 + arg0_2._speed.z * var11_2
	local var13_2 = arg0_2._speed.z * var10_2 - arg0_2._speed.x * var11_2

	arg0_2._speed:Set(var12_2, 0, var13_2)
end

function var9_0.doOrbit(arg0_3)
	local var0_3 = pg.Tool.FilterY(arg0_3._weapon:GetPosition())
	local var1_3 = pg.Tool.FilterY(arg0_3:GetPosition())
	local var2_3 = (var1_3 - var0_3).magnitude
	local var3_3 = (var0_3 - var1_3).normalized
	local var4_3

	if var2_3 > 10 then
		var4_3 = (var3_3 + arg0_3._speed.normalized).normalized
	else
		var4_3 = (Vector3(-var3_3.z, 0, var3_3.x) + arg0_3._speed.normalized).normalized
	end

	arg0_3._speed = var4_3
end

function var9_0.RotateY(arg0_4, arg1_4)
	local var0_4 = math.cos(arg1_4)
	local var1_4 = math.sin(arg1_4)

	return Vector3(arg0_4.x * var0_4 + arg0_4.z * var1_4, arg0_4.y, arg0_4.z * var0_4 - arg0_4.x * var1_4)
end

function var9_0.doCircle(arg0_5)
	if not arg0_5._originPos then
		return
	end

	local var0_5 = arg0_5:GetSpeedRatio() * (1 + var0_0.Battle.BattleAttr.GetCurrent(arg0_5, "bulletSpeedRatio"))
	local var1_5 = pg.Tool.FilterY(arg0_5._position - arg0_5._originPos)
	local var2_5 = arg0_5._convertedVelocity
	local var3_5 = var1_5:Magnitude()
	local var4_5 = var3_5 - arg0_5._centripetalSpeed * var0_5 * arg0_5._inverseFlag

	arg0_5._inverseFlag = var4_5 < 0 and -arg0_5._inverseFlag or arg0_5._inverseFlag

	if var3_5 <= 1e-05 then
		return
	end

	local var5_5 = arg0_5._circleAntiClockwise
	local var6_5 = var2_5 / var3_5 * (var5_5 and 1 or -1) * var0_5

	arg0_5._speed = arg0_5.RotateY(var1_5, var6_5):Mul(var4_5 / var3_5):Sub(var1_5)
end

function var9_0.doNothing(arg0_6)
	if arg0_6._gravity ~= 0 then
		arg0_6._verticalSpeed = arg0_6._verticalSpeed + arg0_6._gravity * arg0_6:GetSpeedRatio()
	end
end

function var9_0.Ctor(arg0_7, arg1_7, arg2_7)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_7)

	arg0_7._battleProxy = var0_0.Battle.BattleDataProxy.GetInstance()
	arg0_7._uniqueID = arg1_7
	arg0_7._speedExemptKey = "bullet_" .. arg1_7
	arg0_7._IFF = arg2_7
	arg0_7._collidedList = {}
	arg0_7._speed = Vector3.zero
	arg0_7._exist = true
	arg0_7._timeStamp = 0
	arg0_7._dmgEnhanceRate = 1
	arg0_7._frame = 0
	arg0_7._reachDestFlag = false
	arg0_7._verticalSpeed = 0
	arg0_7._damageList = {}
end

function var9_0.Update(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetSpeedRatio()

	arg0_8:updateSpeed(arg1_8)
	arg0_8:updateBarrageTransform(arg1_8)
	arg0_8._position:Set(arg0_8._position.x + arg0_8._speed.x * var0_8, arg0_8._position.y + arg0_8._speed.y * var0_8, arg0_8._position.z + arg0_8._speed.z * var0_8)

	arg0_8._position.y = arg0_8._position.y + arg0_8._verticalSpeed * var0_8

	if arg0_8._gravity == 0 then
		arg0_8._reachDestFlag = Vector3.SqrDistance(arg0_8._spawnPos, arg0_8._position) > arg0_8._sqrRange
	else
		if arg0_8._fieldSwitchHeight ~= 0 and arg0_8._position.y <= arg0_8._fieldSwitchHeight then
			arg0_8._field = var8_0.BulletField.SURFACE
		end

		arg0_8._reachDestFlag = arg0_8._position.y <= var5_0.BombDetonateHeight
	end
end

function var9_0.ActiveCldBox(arg0_9)
	arg0_9._cldComponent:SetActive(true)
end

function var9_0.DeactiveCldBox(arg0_10)
	arg0_10._cldComponent:SetActive(false)
end

function var9_0.SetStartTimeStamp(arg0_11, arg1_11)
	arg0_11._timeStamp = arg1_11
end

function var9_0.Hit(arg0_12, arg1_12, arg2_12)
	arg0_12._collidedList[arg1_12] = true

	local var0_12 = {
		UID = arg1_12,
		type = arg2_12
	}

	arg0_12:DispatchEvent(var0_0.Event.New(var1_0.HIT, var0_12))
end

function var9_0.Intercepted(arg0_13)
	arg0_13:DispatchEvent(var0_0.Event.New(var1_0.INTERCEPTED, {}))
end

function var9_0.Reflected(arg0_14)
	arg0_14._speed.x = -arg0_14._speed.x
end

function var9_0.ResetVelocity(arg0_15, arg1_15)
	local var0_15 = arg0_15._tempData
	local var1_15 = arg0_15:GetTemplate().extra_param

	if not arg1_15 then
		arg1_15 = var0_15.velocity

		if var1_15.velocity_offset then
			arg1_15 = math.random(arg1_15 - var1_15.velocity_offset, arg1_15 + var1_15.velocity_offset)
		elseif var1_15.velocity_offsetF then
			arg1_15 = arg1_15 + math.random() * 2 * var1_15.velocity_offsetF - var1_15.velocity_offsetF
		end
	end

	arg0_15._velocity = arg1_15
	arg0_15._convertedVelocity = var2_0.ConvertBulletSpeed(arg0_15._velocity)
end

function var9_0.SetTemplateData(arg0_16, arg1_16)
	arg0_16._tempData = setmetatable({}, {
		__index = arg1_16
	})

	local var0_16 = arg0_16:GetTemplate().extra_param

	arg0_16:SetModleID(arg1_16.modle_ID, var9_0.ORIGNAL_RES)
	arg0_16:SetSFXID(arg0_16._tempData.hit_sfx, arg0_16._tempData.miss_sfx)
	arg0_16:ResetVelocity()

	arg0_16._pierceCount = arg1_16.pierce_count

	arg0_16:FixRange()
	arg0_16:InitCldComponent()

	arg0_16._accTable = Clone(arg0_16._tempData.acceleration)

	table.sort(arg0_16._accTable, function(arg0_17, arg1_17)
		return arg0_17.t < arg1_17.t
	end)

	arg0_16._field = arg1_16.effect_type
	arg0_16._gravity = var0_16.gravity or 0
	arg0_16._fieldSwitchHeight = var0_16.effectSwitchHeight or 0
	arg0_16._ignoreShield = arg0_16._tempData.extra_param.ignoreShield == true
	arg0_16._autoRotate = arg0_16._tempData.extra_param.dontRotate ~= true

	arg0_16:SetDiverFilter()
end

function var9_0.GetModleID(arg0_18)
	local var0_18 = arg0_18:GetTemplate().extra_param
	local var1_18

	if arg0_18._IFF == var5_0.FOE_CODE then
		if arg0_18._mirrorSkin == var9_0.MIRROR_SKIN_RES then
			var1_18 = arg0_18._modleID .. var9_0.MIRROR_RES
		elseif arg0_18._mirrorSkin == var9_0.ORIGNAL_RES and var0_18.mirror == true then
			var1_18 = arg0_18._modleID .. var9_0.MIRROR_RES
		else
			var1_18 = arg0_18._modleID
		end
	else
		var1_18 = arg0_18._modleID
	end

	return var1_18
end

var9_0.ORIGNAL_RES = -1
var9_0.SKIN_RES = 0
var9_0.MIRROR_SKIN_RES = 1

function var9_0.SetModleID(arg0_19, arg1_19, arg2_19, arg3_19)
	arg0_19._modleID = arg1_19
	arg0_19._mirrorSkin = arg2_19

	if arg3_19 and arg3_19 ~= "" then
		arg0_19._tempData.hit_fx = arg3_19
	end
end

function var9_0.SetSFXID(arg0_20, arg1_20, arg2_20)
	if arg1_20 then
		arg0_20._hitSFX = arg1_20
	end

	if arg2_20 then
		arg0_20._missSFX = arg2_20
	end
end

function var9_0.SetShiftInfo(arg0_21, arg1_21, arg2_21)
	local var0_21 = 0
	local var1_21 = 0
	local var2_21 = arg0_21:GetTemplate().extra_param

	if var2_21.randomLaunchOffsetX then
		var0_21 = math.random() * var2_21.randomLaunchOffsetX * 2 - var2_21.randomLaunchOffsetX
	end

	if var2_21.randomLaunchOffsetZ then
		var1_21 = math.random() * var2_21.randomLaunchOffsetZ * 2 - var2_21.randomLaunchOffsetZ
	end

	arg0_21._offsetX = arg1_21 + var0_21
	arg0_21._offsetZ = arg2_21 + var1_21
end

function var9_0.SetRotateInfo(arg0_22, arg1_22, arg2_22, arg3_22)
	arg0_22._targetPos = arg1_22
	arg0_22._baseAngle = arg2_22
	arg0_22._barrageAngle = arg3_22

	local var0_22 = arg0_22._barrageAngle % 360

	if var0_22 > 0 and var0_22 < 180 then
		for iter0_22, iter1_22 in ipairs(arg0_22._accTable) do
			if iter1_22.flip then
				iter1_22.v = iter1_22.v * -1
			end
		end
	end
end

function var9_0.SetBarrageTransformTempate(arg0_23, arg1_23)
	if #arg1_23 > 0 then
		arg0_23._barrageTransData = arg1_23
	end
end

function var9_0.SetAttr(arg0_24, arg1_24)
	var0_0.Battle.BattleAttr.SetAttr(arg0_24, arg1_24)
end

function var9_0.GetAttr(arg0_25)
	return var0_0.Battle.BattleAttr.GetAttr(arg0_25)
end

function var9_0.SetStandHostAttr(arg0_26, arg1_26)
	arg0_26._standUnit = {}

	var0_0.Battle.BattleAttr.SetAttr(arg0_26._standUnit, arg1_26)
end

function var9_0.GetWeaponHostAttr(arg0_27)
	if arg0_27._standUnit then
		return var0_0.Battle.BattleAttr.GetAttr(arg0_27._standUnit)
	else
		return arg0_27:GetAttr()
	end
end

function var9_0.GetWeaponAtkAttr(arg0_28)
	local var0_28 = arg0_28:GetWeaponHostAttr()
	local var1_28
	local var2_28 = arg0_28._weapon:GetAtkAttrTrasnform(var0_28)

	if var2_28 then
		var1_28 = var2_28
	else
		local var3_28 = arg0_28:GetWeaponTempData().attack_attribute

		var1_28 = var0_0.Battle.BattleAttr.GetAtkAttrByType(var0_28, var3_28)
	end

	return var1_28
end

function var9_0.GetWeaponCardPuzzleEnhance(arg0_29)
	return arg0_29._weapon:GetCardPuzzleDamageEnhance()
end

function var9_0.SetDamageEnhance(arg0_30, arg1_30)
	arg0_30._dmgEnhanceRate = arg1_30
end

function var9_0.GetDamageEnhance(arg0_31)
	return arg0_31._dmgEnhanceRate
end

function var9_0.GetAttrByName(arg0_32, arg1_32)
	return var0_0.Battle.BattleAttr.GetCurrent(arg0_32, arg1_32)
end

function var9_0.GetVerticalSpeed(arg0_33)
	return arg0_33._verticalSpeed
end

function var9_0.IsGravitate(arg0_34)
	return arg0_34._gravity ~= 0
end

function var9_0.SetBuffTrigger(arg0_35, arg1_35)
	arg0_35._host = arg1_35
	arg0_35._buffTriggerFun = {}
end

function var9_0.SetBuffFun(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36._buffTriggerFun[arg1_36] or {}

	var0_36[#var0_36 + 1] = arg2_36
	arg0_36._buffTriggerFun[arg1_36] = var0_36
end

function var9_0.BuffTrigger(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37._host

	if var0_37 and var0_37:IsAlive() then
		arg0_37._host:TriggerBuff(arg1_37, arg2_37)

		local var1_37 = arg0_37._buffTriggerFun[arg1_37]

		if var1_37 then
			for iter0_37, iter1_37 in ipairs(var1_37) do
				iter1_37(arg0_37._host, arg2_37)
			end
		end
	end
end

function var9_0.SetIsCld(arg0_38, arg1_38)
	arg0_38._needCld = arg1_38
end

function var9_0.GetIsCld(arg0_39)
	return arg0_39._needCld
end

function var9_0.IsIngoreCld(arg0_40)
	return arg0_40._tempData.extra_param.ingoreCld
end

function var9_0.IsFragile(arg0_41)
	return arg0_41._tempData.extra_param.fragile
end

function var9_0.IsIndiscriminate(arg0_42)
	return arg0_42._tempData.extra_param.indiscriminate
end

function var9_0.GetExtraTag(arg0_43)
	return arg0_43._tempData.extra_param.tag
end

function var9_0.AppendDamageUnit(arg0_44, arg1_44)
	arg0_44._damageList[#arg0_44._damageList + 1] = arg1_44
end

function var9_0.DamageUnitListWriteback(arg0_45)
	arg0_45._weapon:UpdateCombo(arg0_45._damageList)
end

function var9_0.HasAcceleration(arg0_46)
	return #arg0_46._accTable ~= 0
end

function var9_0.IsTracker(arg0_47)
	return arg0_47._accTable.tracker
end

function var9_0.IsOrbit(arg0_48)
	return arg0_48._accTable.orbit
end

function var9_0.IsCircle(arg0_49)
	return arg0_49._accTable.circle
end

function var9_0.GetAcceleration(arg0_50, arg1_50)
	arg0_50._lastAccTime = arg0_50._lastAccTime or arg0_50._timeStamp

	local var0_50 = math.modf((arg1_50 - arg0_50._lastAccTime) / var9_0.ACC_INTERVAL)

	arg0_50._lastAccTime = arg0_50._lastAccTime + var9_0.ACC_INTERVAL * var0_50

	local var1_50 = arg1_50 - arg0_50._timeStamp
	local var2_50 = #arg0_50._accTable

	while var2_50 > 0 do
		local var3_50 = arg0_50._accTable[var2_50]

		if var1_50 + var9_0.ACC_INTERVAL < var3_50.t then
			var2_50 = var2_50 - 1
		else
			return var3_50.u * var0_50, var3_50.v * var0_50
		end
	end

	return 0, 0
end

function var9_0.reverseAcceleration(arg0_51)
	for iter0_51, iter1_51 in ipairs(arg0_51._accTable) do
		iter1_51.u = iter1_51.u * -1
	end
end

function var9_0.GetDistance(arg0_52, arg1_52)
	local var0_52 = arg0_52._battleProxy.FrameIndex

	if arg0_52._frame ~= var0_52 then
		arg0_52._distanceBackup = {}
		arg0_52._frame = var0_52
	end

	local var1_52 = arg0_52._distanceBackup[arg1_52]

	if var1_52 == nil then
		var1_52 = Vector3.Distance(arg0_52:GetPosition(), arg1_52:GetPosition())
		arg0_52._distanceBackup[arg1_52] = var1_52

		arg1_52:backupDistance(arg0_52, var1_52)
	end

	return var1_52
end

function var9_0.backupDistance(arg0_53, arg1_53, arg2_53)
	local var0_53 = arg0_53._battleProxy.FrameIndex

	if arg0_53._frame ~= var0_53 then
		arg0_53._distanceBackup = {}
		arg0_53._frame = var0_53
	end

	arg0_53._distanceBackup[arg1_53] = arg2_53
end

function var9_0.getTrackingTarget(arg0_54)
	return arg0_54._tarckingTarget
end

function var9_0.setTrackingTarget(arg0_55, arg1_55)
	arg0_55._tarckingTarget = arg1_55
end

function var9_0.SetWeapon(arg0_56, arg1_56)
	arg0_56._weapon = arg1_56

	if arg1_56 then
		arg0_56._correctedDMG = arg0_56._weapon:GetCorrectedDMG()
	end
end

function var9_0.GetWeapon(arg0_57)
	return arg0_57._weapon
end

function var9_0.GetCorrectedDMG(arg0_58)
	return arg0_58._correctedDMG
end

function var9_0.OverrideCorrectedDMG(arg0_59, arg1_59)
	arg0_59._correctedDMG = var2_0.WeaponDamagePreCorrection(arg0_59._weapon, arg1_59)
end

function var9_0.GetWeaponTempData(arg0_60)
	return arg0_60._weapon:GetTemplateData()
end

function var9_0.GetPosition(arg0_61)
	return arg0_61._position or Vector3.zero
end

function var9_0.SetSpawnPosition(arg0_62, arg1_62)
	arg0_62._spawnPos = arg1_62
	arg0_62._position = arg1_62:Clone()

	if arg0_62._gravity ~= 0 then
		local var0_62 = math.atan2(arg0_62._speed.x, arg0_62._speed.z)

		if var0_62 == 0 then
			arg0_62._verticalSpeed = 0
		else
			local var1_62 = Vector3(math.cos(var0_62) * 60, math.sin(var0_62) * 60)
			local var2_62 = 60 / arg0_62._convertedVelocity

			arg0_62._verticalSpeed = -0.5 * arg0_62._gravity * var2_62
		end
	end
end

function var9_0.GetSpawnPosition(arg0_63)
	return arg0_63._spawnPos
end

function var9_0.GetTemplate(arg0_64)
	return arg0_64._tempData
end

function var9_0.GetType(arg0_65)
	return arg0_65._tempData.type
end

function var9_0.GetHitSFX(arg0_66)
	return arg0_66._hitSFX
end

function var9_0.GetMissSFX(arg0_67)
	return arg0_67._missSFX
end

function var9_0.GetOutBound(arg0_68)
	return arg0_68._tempData.out_bound
end

function var9_0.GetUniqueID(arg0_69)
	return arg0_69._uniqueID
end

function var9_0.GetOffset(arg0_70)
	return arg0_70._offsetX, arg0_70._offsetZ, arg0_70._isOffsetPriority
end

function var9_0.GetRotateInfo(arg0_71)
	return arg0_71._targetPos, arg0_71._baseAngle, arg0_71._barrageAngle
end

function var9_0.IsOutRange(arg0_72)
	return arg0_72._reachDestFlag
end

function var9_0.SetYAngle(arg0_73, arg1_73)
	arg0_73._yAngle = arg1_73
end

function var9_0.SetOffsetPriority(arg0_74, arg1_74)
	arg0_74._isOffsetPriority = arg1_74 or false
end

function var9_0.GetOffsetPriority(arg0_75)
	return arg0_75._isOffsetPriority
end

function var9_0.GetYAngle(arg0_76)
	return arg0_76._yAngle
end

function var9_0.GetCurrentYAngle(arg0_77)
	local var0_77 = Vector3.Normalize(arg0_77._speed)
	local var1_77 = math.acos(var0_77.x) / math.deg2Rad

	if var0_77.z < 0 then
		var1_77 = 360 - var1_77
	end

	return var1_77
end

function var9_0.GetIFF(arg0_78)
	return arg0_78._IFF
end

function var9_0.GetHost(arg0_79)
	return arg0_79._host
end

function var9_0.GetPierceCount(arg0_80)
	return arg0_80._pierceCount
end

function var9_0.AppendAttachBuff(arg0_81, arg1_81)
	arg0_81._attachBuffList = arg0_81._attachBuffList or arg0_81:generateAttachBuffList()

	table.insert(arg0_81._attachBuffList, arg1_81)
end

function var9_0.GetAttachBuff(arg0_82)
	arg0_82._attachBuffList = arg0_82._attachBuffList or arg0_82:generateAttachBuffList()

	return arg0_82._attachBuffList
end

function var9_0.generateAttachBuffList(arg0_83)
	local var0_83 = {}

	if not arg0_83:GetTemplate().attach_buff then
		local var1_83 = {}
	end

	for iter0_83, iter1_83 in ipairs(arg0_83:GetTemplate().attach_buff) do
		local var2_83 = {
			buff_id = iter1_83.buff_id,
			level = iter1_83.buff_level,
			rant = iter1_83.rant,
			hit_ignore = iter1_83.hit_ignore
		}

		table.insert(var0_83, var2_83)
	end

	return var0_83
end

function var9_0.GetEffectField(arg0_84)
	return arg0_84._field
end

function var9_0.SetDiverFilter(arg0_85, arg1_85)
	if arg1_85 == nil then
		arg0_85._diveFilter = arg0_85._tempData.extra_param.diveFilter or {
			2
		}
	else
		arg0_85._diveFilter = arg1_85
	end
end

function var9_0.GetDiveFilter(arg0_86)
	return arg0_86._diveFilter
end

function var9_0.GetVelocity(arg0_87)
	return arg0_87._velocity
end

function var9_0.GetConvertedVelocity(arg0_88)
	return arg0_88._convertedVelocity
end

function var9_0.GetSpeedExemptKey(arg0_89)
	return arg0_89._speedExemptKey
end

function var9_0.IsCollided(arg0_90, arg1_90)
	return arg0_90._collidedList[arg1_90]
end

function var9_0.GetExist(arg0_91)
	return arg0_91._exist
end

function var9_0.SetExist(arg0_92, arg1_92)
	arg0_92._exist = arg1_92
end

function var9_0.GetIgnoreShield(arg0_93)
	return arg0_93._ignoreShield
end

function var9_0.SetIgnoreShield(arg0_94, arg1_94)
	arg0_94._ignoreShield = arg1_94
end

function var9_0.IsAutoRotate(arg0_95)
	return arg0_95._autoRotate
end

function var9_0.Dispose(arg0_96)
	arg0_96._dataProxy = nil

	var0_0.EventDispatcher.DetachEventDispatcher(arg0_96)
end

function var9_0.InitCldComponent(arg0_97)
	local var0_97 = arg0_97:GetTemplate().cld_box
	local var1_97 = arg0_97:GetTemplate().cld_offset
	local var2_97 = var1_97[1]

	if arg0_97:GetIFF() == var5_0.FOE_CODE then
		var2_97 = var2_97 * -1
	end

	arg0_97._cldComponent = var0_0.Battle.BattleCubeCldComponent.New(var0_97[1], var0_97[2], var0_97[3], var2_97, var1_97[3])

	local var3_97 = {
		type = var8_0.CldType.BULLET,
		IFF = arg0_97:GetIFF(),
		UID = arg0_97:GetUniqueID()
	}

	arg0_97._cldComponent:SetCldData(var3_97)
end

function var9_0.ResetCldSurface(arg0_98)
	local var0_98 = arg0_98:GetDiveFilter()

	if var0_98 and #var0_98 == 0 then
		arg0_98:GetCldData().Surface = var8_0.OXY_STATE.DIVE
	else
		arg0_98:GetCldData().Surface = var8_0.OXY_STATE.FLOAT
	end
end

function var9_0.GetBoxSize(arg0_99)
	return arg0_99._cldComponent:GetCldBoxSize()
end

function var9_0.GetCldBox(arg0_100)
	return arg0_100._cldComponent:GetCldBox(arg0_100:GetPosition())
end

function var9_0.GetCldData(arg0_101)
	return arg0_101._cldComponent:GetCldData()
end

function var9_0.GetSpeed(arg0_102)
	return arg0_102._speed
end

function var9_0.GetSpeedRatio(arg0_103)
	return var4_0.GetSpeedRatio(arg0_103._speedExemptKey, arg0_103._IFF)
end

function var9_0.InitSpeed(arg0_104, arg1_104)
	if arg0_104._yAngle == nil then
		arg0_104._yAngle = (arg1_104 or arg0_104._baseAngle) + arg0_104._barrageAngle
	end

	arg0_104:calcSpeed()

	if arg0_104:HasAcceleration() then
		arg0_104._speedLength = arg0_104._speed:Magnitude()

		local var0_104 = math.deg2Rad * arg0_104._yAngle

		arg0_104._speedNormal = Vector3(math.cos(var0_104), 0, math.sin(var0_104))
		arg0_104._speedCross = Vector3.Cross(arg0_104._speedNormal, var3_0)
		arg0_104.updateSpeed = var9_0.doAccelerate
	elseif arg0_104:IsTracker() then
		local var1_104 = arg0_104._accTable.tracker

		arg0_104._trackRange = var1_104.range
		arg0_104._cosAngularSpeed = math.deg2Rad * var1_104.angular
		arg0_104._sinAngularSpeed = math.deg2Rad * var1_104.angular
		arg0_104._negativeCosAngularSpeed = math.deg2Rad * var1_104.angular * -1
		arg0_104._negativeSinAngularSpeed = math.deg2Rad * var1_104.angular * -1
		arg0_104.updateSpeed = var9_0.doTrack
	elseif arg0_104:IsCircle() then
		local var2_104 = arg0_104._accTable.circle

		arg0_104._originPos = var2_104.center or arg0_104._targetPos
		arg0_104._circleAntiClockwise = tobool(var2_104.antiClockWise)
		arg0_104._centripetalSpeed = (var2_104.centripetalSpeed or 0) * var7_0
		arg0_104._inverseFlag = 1
		arg0_104.updateSpeed = var9_0.doCircle
	else
		arg0_104.updateSpeed = var9_0.doNothing
	end
end

function var9_0.calcSpeed(arg0_105)
	local var0_105 = 1 + var0_0.Battle.BattleAttr.GetCurrent(arg0_105, "bulletSpeedRatio")
	local var1_105 = arg0_105._velocity * var0_105
	local var2_105 = var2_0.ConvertBulletSpeed(var1_105)
	local var3_105 = math.deg2Rad * arg0_105._yAngle

	arg0_105._speed = Vector3(var2_105 * math.cos(var3_105), 0, var2_105 * math.sin(var3_105))
end

function var9_0.updateBarrageTransform(arg0_106, arg1_106)
	if not arg0_106._barrageTransData or #arg0_106._barrageTransData == 0 then
		return
	end

	local var0_106 = arg1_106 - arg0_106._timeStamp
	local var1_106 = arg0_106._barrageTransData[1]

	if var0_106 >= var1_106.transStartDelay then
		if var1_106.transAimAngle then
			arg0_106._yAngle = var1_106.transAimAngle
		else
			arg0_106._yAngle = math.rad2Deg * math.atan2(var1_106.transAimPosZ - arg0_106._position.z, var1_106.transAimPosX - arg0_106._position.x)
		end

		arg0_106:calcSpeed()
		table.remove(arg0_106._barrageTransData, 1)

		local var2_106 = arg0_106._barrageTransData[1]

		if var2_106 then
			var2_106.transStartDelay = var2_106.transStartDelay + var1_106.transStartDelay
		end
	end
end

function var9_0.GetCurrentDistance(arg0_107)
	return Vector3.Distance(arg0_107._spawnPos, arg0_107._position)
end

function var9_0.SetOutRangeCallback(arg0_108, arg1_108)
	arg0_108._outRangeFunc = arg1_108
end

function var9_0.OutRange(arg0_109)
	arg0_109:DispatchEvent(var0_0.Event.New(var1_0.OUT_RANGE, {}))
	arg0_109._outRangeFunc(arg0_109)
end

function var9_0.FixRange(arg0_110, arg1_110, arg2_110)
	arg1_110 = arg1_110 or arg0_110._tempData.range
	arg2_110 = arg2_110 or 0

	local var0_110 = arg0_110._tempData.range_offset

	if var0_110 == 0 then
		arg0_110._range = arg1_110
	else
		arg0_110._range = arg1_110 + var0_110 * (math.random() - 0.5)
	end

	arg0_110._range = math.max(0, arg0_110._range + arg2_110)
	arg0_110._sqrRange = arg0_110._range * arg0_110._range
end

function var9_0.ImmuneBombCLS(arg0_111)
	return arg0_111:GetTemplate().extra_param.ignoreB
end

function var9_0.ImmuneCLS(arg0_112)
	return arg0_112._immuneCLS
end

function var9_0.SetImmuneCLS(arg0_113, arg1_113)
	arg0_113._immuneCLS = arg1_113
end
