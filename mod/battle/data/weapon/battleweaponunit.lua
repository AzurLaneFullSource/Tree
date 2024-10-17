ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var1_0.WeaponSuppressType
local var5_0 = var1_0.WeaponSearchType
local var6_0 = var0_0.Battle.BattleDataFunction
local var7_0 = var0_0.Battle.BattleAttr
local var8_0 = var0_0.Battle.BattleTargetChoise
local var9_0 = class("BattleWeaponUnit")

var0_0.Battle.BattleWeaponUnit = var9_0
var9_0.__name = "BattleWeaponUnit"
var9_0.INTERNAL = "internal"
var9_0.EXTERNAL = "external"
var9_0.EMITTER_NORMAL = "BattleBulletEmitter"
var9_0.EMITTER_SHOTGUN = "BattleShotgunEmitter"
var9_0.STATE_DISABLE = "DISABLE"
var9_0.STATE_READY = "READY"
var9_0.STATE_PRECAST = "PRECAST"
var9_0.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var9_0.STATE_ATTACK = "ATTACK"
var9_0.STATE_OVER_HEAT = "OVER_HEAT"

function var9_0.Ctor(arg0_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._currentState = arg0_1.STATE_READY
	arg0_1._equipmentIndex = -1
	arg0_1._dataProxy = var0_0.Battle.BattleDataProxy.GetInstance()
	arg0_1._tempEmittersList = {}
	arg0_1._dumpedEmittersList = {}
	arg0_1._reloadFacotrList = {}
	arg0_1._diveEnabled = true
	arg0_1._comboIDList = {}
	arg0_1._jammingTime = 0
	arg0_1._reloadBoostList = {}
	arg0_1._CLDCount = 0
	arg0_1._damageSum = 0
	arg0_1._CTSum = 0
	arg0_1._ACCSum = 0
end

function var9_0.HostOnEnemy(arg0_2)
	arg0_2._hostOnEnemy = true
end

function var9_0.SetPotentialFactor(arg0_3, arg1_3)
	arg0_3._potential = arg1_3

	if arg0_3._correctedDMG then
		arg0_3._correctedDMG = var3_0.WeaponDamagePreCorrection(arg0_3)
	end
end

function var9_0.GetEquipmentLabel(arg0_4)
	return arg0_4._equipmentLabelList or {}
end

function var9_0.SetEquipmentLabel(arg0_5, arg1_5)
	arg0_5._equipmentLabelList = arg1_5
end

function var9_0.SetTemplateData(arg0_6, arg1_6)
	arg0_6._potential = arg0_6._potential or 1
	arg0_6._tmpData = arg1_6
	arg0_6._maxRangeSqr = arg1_6.range
	arg0_6._minRangeSqr = arg1_6.min_range
	arg0_6._fireFXFlag = arg1_6.fire_fx_loop_type
	arg0_6._oxyList = arg1_6.oxy_type
	arg0_6._bulletList = arg1_6.bullet_ID
	arg0_6._majorEmitterList = {}

	arg0_6:ShiftBarrage(arg1_6.barrage_ID)

	arg0_6._GCD = arg1_6.recover_time
	arg0_6._preCastInfo = arg1_6.precast_param
	arg0_6._correctedDMG = var3_0.WeaponDamagePreCorrection(arg0_6)
	arg0_6._convertedAtkAttr = var3_0.WeaponAtkAttrPreRatio(arg0_6)

	arg0_6:FlushReloadMax(1)
end

function var9_0.createMajorEmitter(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7)
	local function var0_7(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
		local var0_8 = arg0_7._emitBulletIDList[arg2_7]
		local var1_8 = arg0_7:Spawn(var0_8, arg4_8, var9_0.INTERNAL)

		var1_8:SetOffsetPriority(arg3_8)
		var1_8:SetShiftInfo(arg0_8, arg1_8)

		if arg0_7._tmpData.aim_type == var1_0.WeaponAimType.AIM and arg4_8 ~= nil then
			var1_8:SetRotateInfo(arg4_8:GetBeenAimedPosition(), arg0_7:GetBaseAngle(), arg2_8)
		else
			var1_8:SetRotateInfo(nil, arg0_7:GetBaseAngle(), arg2_8)
		end

		arg0_7:DispatchBulletEvent(var1_8)

		return var1_8
	end

	local function var1_7()
		for iter0_9, iter1_9 in ipairs(arg0_7._majorEmitterList) do
			if iter1_9:GetState() ~= iter1_9.STATE_STOP then
				return
			end
		end

		arg0_7:EnterCoolDown()
	end

	arg3_7 = arg3_7 or var9_0.EMITTER_NORMAL

	local var2_7 = var0_0.Battle[arg3_7].New(arg4_7 or var0_7, arg5_7 or var1_7, arg1_7)

	arg0_7._majorEmitterList[#arg0_7._majorEmitterList + 1] = var2_7

	return var2_7
end

function var9_0.interruptAllEmitter(arg0_10)
	if arg0_10._majorEmitterList then
		for iter0_10, iter1_10 in ipairs(arg0_10._majorEmitterList) do
			iter1_10:Interrupt()
		end
	end

	for iter2_10, iter3_10 in ipairs(arg0_10._tempEmittersList) do
		for iter4_10, iter5_10 in ipairs(iter3_10) do
			iter5_10:Interrupt()
		end
	end

	for iter6_10, iter7_10 in ipairs(arg0_10._dumpedEmittersList) do
		for iter8_10, iter9_10 in ipairs(iter7_10) do
			iter9_10:Interrupt()
		end
	end
end

function var9_0.cacheSectorData(arg0_11)
	local var0_11 = arg0_11:GetAttackAngle() / 2

	arg0_11._upperEdge = math.deg2Rad * var0_11
	arg0_11._lowerEdge = -1 * arg0_11._upperEdge

	local var1_11 = math.deg2Rad * arg0_11._tmpData.axis_angle

	if arg0_11:GetDirection() == var1_0.UnitDir.LEFT then
		arg0_11._normalizeOffset = math.pi - var1_11
	elseif arg0_11:GetDirection() == var1_0.UnitDir.RIGHT then
		arg0_11._normalizeOffset = var1_11
	end

	arg0_11._wholeCircle = math.pi - arg0_11._normalizeOffset
	arg0_11._negativeCircle = -math.pi - arg0_11._normalizeOffset
	arg0_11._wholeCircleNormalizeOffset = arg0_11._normalizeOffset - math.pi * 2
	arg0_11._negativeCircleNormalizeOffset = arg0_11._normalizeOffset + math.pi * 2
end

function var9_0.cacheSquareData(arg0_12)
	arg0_12._frontRange = arg0_12._tmpData.angle
	arg0_12._backRange = arg0_12._tmpData.axis_angle
	arg0_12._upperRange = arg0_12._tmpData.min_range
	arg0_12._lowerRange = arg0_12._tmpData.range
end

function var9_0.SetModelID(arg0_13, arg1_13)
	arg0_13._modelID = arg1_13
end

function var9_0.SetSkinData(arg0_14, arg1_14)
	arg0_14._skinID = arg1_14

	local var0_14, var1_14, var2_14, var3_14, var4_14, var5_14 = var6_0.GetEquipSkin(arg0_14._skinID)

	arg0_14:SetModelID(var0_14)

	if var4_14 ~= "" then
		arg0_14._skinFireFX = var4_14
	end

	if var5_14 ~= "" then
		arg0_14._skinHitFX = var5_14
	end

	local var6_14, var7_14 = var6_0.GetEquipSkinSFX(arg0_14._skinID)

	arg0_14._skinHixSFX = var6_14
	arg0_14._skinMissSFX = var7_14
end

function var9_0.SetDerivateSkin(arg0_15, arg1_15)
	arg0_15._derivateSkinID = arg1_15

	local var0_15, var1_15, var2_15, var3_15, var4_15, var5_15 = var6_0.GetEquipSkin(arg0_15._derivateSkinID)

	arg0_15._derivateBullet = var1_15
	arg0_15._derivateTorpedo = var2_15
	arg0_15._derivateBoom = var3_15
	arg0_15._derviateHitFX = var5_15

	local var6_15, var7_15 = var6_0.GetEquipSkinSFX(arg0_15._derivateSkinID)

	arg0_15._skinHixSFX = var6_15
	arg0_15._skinMissSFX = var7_15
end

function var9_0.GetSkinID(arg0_16)
	return arg0_16._skinID
end

function var9_0.setBulletSkin(arg0_17, arg1_17, arg2_17)
	if arg0_17._derivateSkinID then
		local var0_17 = var6_0.GetBulletTmpDataFromID(arg2_17).type

		if var0_17 == var1_0.BulletType.BOMB and arg0_17._derivateBoom ~= "" then
			arg1_17:SetModleID(arg0_17._derivateBoom, nil, arg0_17._derviateHitFX)
		elseif var0_17 == var1_0.BulletType.TORPEDO and arg0_17._derivateTorpedo ~= "" then
			arg1_17:SetModleID(arg0_17._derivateTorpedo, nil, arg0_17._derviateHitFX)
		elseif arg0_17._derivateBullet ~= "" then
			arg1_17:SetModleID(arg0_17._derivateBullet, nil, arg0_17._derviateHitFX)
		end

		arg1_17:SetSFXID(arg0_17._skinHixSFX, arg0_17._skinMissSFX)
	elseif arg0_17._modelID then
		local var1_17 = 0

		if arg0_17._skinID then
			var1_17 = var6_0.GetEquipSkinDataFromID(arg0_17._skinID).mirror
		end

		arg1_17:SetModleID(arg0_17._modelID, var1_17, arg0_17._skinHitFX)
		arg1_17:SetSFXID(arg0_17._skinHixSFX, arg0_17._skinMissSFX)
	end
end

function var9_0.SetSrcEquipmentID(arg0_18, arg1_18)
	arg0_18._srcEquipID = arg1_18
end

function var9_0.SetEquipmentIndex(arg0_19, arg1_19)
	arg0_19._equipmentIndex = arg1_19
end

function var9_0.GetEquipmentIndex(arg0_20)
	return arg0_20._equipmentIndex
end

function var9_0.SetHostData(arg0_21, arg1_21)
	arg0_21._host = arg1_21
	arg0_21._hostUnitType = arg0_21._host:GetUnitType()
	arg0_21._hostIFF = arg1_21:GetIFF()

	if arg0_21._tmpData.search_type == var5_0.SECTOR then
		arg0_21:cacheSectorData()

		arg0_21.outOfFireRange = arg0_21.IsOutOfAngle
		arg0_21.IsOutOfFireArea = arg0_21.IsOutOfSector
	elseif arg0_21._tmpData.search_type == var5_0.SQUARE then
		arg0_21:cacheSquareData()

		arg0_21.outOfFireRange = arg0_21.IsOutOfSquare
		arg0_21.IsOutOfFireArea = arg0_21.IsOutOfSquare
	end

	if arg0_21:GetDirection() == var1_0.UnitDir.RIGHT then
		arg0_21._baseAngle = 0
	else
		arg0_21._baseAngle = 180
	end
end

function var9_0.SetStandHost(arg0_22, arg1_22)
	arg0_22._standHost = arg1_22
end

function var9_0.OverrideGCD(arg0_23, arg1_23)
	arg0_23._GCD = arg1_23
end

function var9_0.updateMovementInfo(arg0_24)
	arg0_24._hostPos = arg0_24._host:GetPosition()
end

function var9_0.GetWeaponId(arg0_25)
	return arg0_25._tmpData.id
end

function var9_0.GetTemplateData(arg0_26)
	return arg0_26._tmpData
end

function var9_0.GetType(arg0_27)
	return arg0_27._tmpData.type
end

function var9_0.GetPotential(arg0_28)
	return arg0_28._potential or 1
end

function var9_0.GetSrcEquipmentID(arg0_29)
	return arg0_29._srcEquipID
end

function var9_0.SetFixedFlag(arg0_30)
	arg0_30._isFixedWeapon = true
end

function var9_0.IsFixedWeapon(arg0_31)
	return arg0_31._isFixedWeapon
end

function var9_0.IsAttacking(arg0_32)
	return arg0_32._currentState == var9_0.STATE_ATTACK or arg0_32._currentState == arg0_32.STATE_PRECAST
end

function var9_0.Update(arg0_33)
	arg0_33:UpdateReload()

	if not arg0_33._diveEnabled then
		return
	end

	if arg0_33._currentState == arg0_33.STATE_READY then
		arg0_33:updateMovementInfo()

		if arg0_33._tmpData.suppress == var4_0.SUPPRESSION or arg0_33:CheckPreCast() then
			if arg0_33._preCastInfo.time == nil or not arg0_33._hostOnEnemy then
				arg0_33._currentState = arg0_33.STATE_PRECAST_FINISH
			else
				arg0_33:PreCast()
			end
		end
	end

	if arg0_33._currentState == arg0_33.STATE_PRECAST_FINISH then
		arg0_33:updateMovementInfo()
		arg0_33:Fire(arg0_33:Tracking())
	end
end

function var9_0.CheckReloadTimeStamp(arg0_34)
	return arg0_34._CDstartTime and arg0_34:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime()
end

function var9_0.UpdateReload(arg0_35)
	if arg0_35._CDstartTime and not arg0_35._jammingStartTime then
		if arg0_35:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			arg0_35:handleCoolDown()
		else
			return
		end
	end
end

function var9_0.CheckPreCast(arg0_36)
	for iter0_36, iter1_36 in pairs(arg0_36:GetFilteredList()) do
		return true
	end

	return false
end

function var9_0.ChangeDiveState(arg0_37)
	if arg0_37._host:GetOxyState() then
		local var0_37 = arg0_37._host:GetOxyState():GetWeaponType()

		for iter0_37, iter1_37 in ipairs(arg0_37._oxyList) do
			if table.contains(var0_37, iter1_37) then
				arg0_37._diveEnabled = true

				return
			end
		end

		arg0_37._diveEnabled = false
	end
end

function var9_0.getTrackingHost(arg0_38)
	return arg0_38._host
end

var9_0.TrackingFunc = {
	farthest = var9_0.TrackingFarthest,
	leastHP = var9_0.TrackingLeastHP
}

function var9_0.Tracking(arg0_39)
	local var0_39 = var7_0.GetCurrentTargetSelect(arg0_39._host)
	local var1_39
	local var2_39 = arg0_39:GetFilteredList()

	if var0_39 then
		local var3_39 = var9_0.TrackingFunc[var0_39]

		if var3_39 then
			var1_39 = var3_39(arg0_39, var2_39)
		else
			var1_39 = arg0_39:TrackingTag(var2_39, var0_39)
		end
	else
		var1_39 = arg0_39:TrackingNearest(var2_39)
	end

	if var1_39 and var7_0.GetCurrentGuardianID(var1_39) then
		local var4_39 = var7_0.GetCurrentGuardianID(var1_39)

		for iter0_39, iter1_39 in ipairs(var2_39) do
			if iter1_39:GetUniqueID() == var4_39 then
				var1_39 = iter1_39

				break
			end
		end
	end

	return var1_39
end

function var9_0.GetFilteredList(arg0_40)
	local var0_40 = arg0_40:FilterTarget()

	if arg0_40._tmpData.search_type == var5_0.SECTOR then
		var0_40 = arg0_40:FilterRange(var0_40)
		var0_40 = arg0_40:FilterAngle(var0_40)
	elseif arg0_40._tmpData.search_type == var5_0.SQUARE then
		var0_40 = arg0_40:FilterSquare(var0_40)
	end

	return var0_40
end

function var9_0.FixWeaponRange(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	arg0_41._maxRangeSqr = arg1_41 or arg0_41._tmpData.range
	arg0_41._minRangeSqr = arg3_41 or arg0_41._tmpData.min_range
	arg0_41._fixBulletRange = arg2_41
	arg0_41._bulletRangeOffset = arg4_41
end

function var9_0.GetWeaponMaxRange(arg0_42)
	return arg0_42._maxRangeSqr
end

function var9_0.GetWeaponMinRange(arg0_43)
	return arg0_43._minRangeSqr
end

function var9_0.GetFixBulletRange(arg0_44)
	return arg0_44._fixBulletRange, arg0_44._bulletRangeOffset
end

function var9_0.TrackingNearest(arg0_45, arg1_45)
	local var0_45 = arg0_45._maxRangeSqr
	local var1_45

	for iter0_45, iter1_45 in ipairs(arg1_45) do
		local var2_45 = arg0_45:getTrackingHost():GetDistance(iter1_45)

		if var2_45 <= var0_45 then
			var0_45 = var2_45
			var1_45 = iter1_45
		end
	end

	return var1_45
end

function var9_0.TrackingFarthest(arg0_46, arg1_46)
	local var0_46 = 0
	local var1_46

	for iter0_46, iter1_46 in ipairs(arg1_46) do
		local var2_46 = arg0_46:getTrackingHost():GetDistance(iter1_46)

		if var0_46 < var2_46 then
			var0_46 = var2_46
			var1_46 = iter1_46
		end
	end

	return var1_46
end

function var9_0.TrackingLeastHP(arg0_47, arg1_47)
	local var0_47 = math.huge
	local var1_47

	for iter0_47, iter1_47 in ipairs(arg1_47) do
		local var2_47 = iter1_47:GetCurrentHP()

		if var2_47 < var0_47 then
			var1_47 = iter1_47
			var0_47 = var2_47
		end
	end

	return var1_47
end

function var9_0.TrackingRandom(arg0_48, arg1_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg1_48) do
		table.insert(var0_48, iter1_48)
	end

	local var1_48 = #var0_48

	if #var0_48 == 0 then
		return nil
	else
		return var0_48[math.random(#var0_48)]
	end
end

function var9_0.TrackingTag(arg0_49, arg1_49, arg2_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in ipairs(arg1_49) do
		if iter1_49:ContainsLabelTag({
			arg2_49
		}) then
			table.insert(var0_49, iter1_49)
		end
	end

	if #var0_49 == 0 then
		return arg0_49:TrackingNearest(arg1_49)
	else
		return var0_49[math.random(#var0_49)]
	end
end

function var9_0.FilterTarget(arg0_50)
	local var0_50 = var8_0.LegalWeaponTarget(arg0_50._host)
	local var1_50 = {}
	local var2_50 = 1
	local var3_50 = arg0_50._tmpData.search_condition

	for iter0_50, iter1_50 in pairs(var0_50) do
		local var4_50 = iter1_50:GetCurrentOxyState()

		if var7_0.IsCloak(iter1_50) then
			-- block empty
		elseif not table.contains(var3_50, var4_50) then
			-- block empty
		else
			local var5_50 = true

			if var4_50 == var1_0.OXY_STATE.FLOAT then
				-- block empty
			elseif var4_50 == var1_0.OXY_STATE.DIVE and not iter1_50:IsRunMode() and not iter1_50:GetDiveDetected() and iter1_50:GetDiveInvisible() then
				var5_50 = false
			end

			if var5_50 then
				var1_50[var2_50] = iter1_50
				var2_50 = var2_50 + 1
			end
		end
	end

	return var1_50
end

function var9_0.FilterAngle(arg0_51, arg1_51)
	if arg0_51:GetAttackAngle() >= 360 then
		return arg1_51
	end

	for iter0_51 = #arg1_51, 1, -1 do
		if arg0_51:IsOutOfAngle(arg1_51[iter0_51]) then
			table.remove(arg1_51, iter0_51)
		end
	end

	return arg1_51
end

function var9_0.FilterRange(arg0_52, arg1_52)
	for iter0_52 = #arg1_52, 1, -1 do
		if arg0_52:IsOutOfRange(arg1_52[iter0_52]) then
			table.remove(arg1_52, iter0_52)
		end
	end

	return arg1_52
end

function var9_0.FilterSquare(arg0_53, arg1_53)
	local var0_53 = arg0_53:GetDirection()
	local var1_53 = arg0_53._host:GetPosition().x + arg0_53._backRange * var0_53 * -1
	local var2_53 = {
		lineX = var1_53,
		dir = var0_53
	}
	local var3_53 = var8_0.TargetInsideArea(arg0_53._host, var2_53, arg1_53)
	local var4_53 = var8_0.TargetWeightiest(arg0_53._host, nil, var3_53)

	for iter0_53 = #arg1_53, 1, -1 do
		if arg0_53:IsOutOfSquare(arg1_53[iter0_53]) then
			table.remove(arg1_53, iter0_53)
		end
	end

	for iter1_53 = #arg1_53, 1, -1 do
		if not table.contains(var4_53, arg1_53[iter1_53]) then
			table.remove(arg1_53, iter1_53)
		end
	end

	return arg1_53
end

function var9_0.GetAttackAngle(arg0_54)
	return arg0_54._tmpData.angle
end

function var9_0.IsOutOfAngle(arg0_55, arg1_55)
	if arg0_55:GetAttackAngle() >= 360 then
		return false
	end

	local var0_55 = arg1_55:GetPosition()
	local var1_55 = math.atan2(var0_55.z - arg0_55._hostPos.z, var0_55.x - arg0_55._hostPos.x)

	if var1_55 > arg0_55._wholeCircle then
		var1_55 = var1_55 + arg0_55._wholeCircleNormalizeOffset
	elseif var1_55 < arg0_55._negativeCircle then
		var1_55 = var1_55 + arg0_55._negativeCircleNormalizeOffset
	else
		var1_55 = var1_55 + arg0_55._normalizeOffset
	end

	if var1_55 > arg0_55._lowerEdge and var1_55 < arg0_55._upperEdge then
		return false
	else
		return true
	end
end

function var9_0.IsOutOfRange(arg0_56, arg1_56)
	local var0_56 = arg0_56:getTrackingHost():GetDistance(arg1_56)

	return var0_56 > arg0_56._maxRangeSqr or var0_56 < arg0_56:GetMinimumRange()
end

function var9_0.IsOutOfSector(arg0_57, arg1_57)
	return arg0_57:IsOutOfRange(arg1_57) or arg0_57:IsOutOfAngle(arg1_57)
end

function var9_0.IsOutOfSquare(arg0_58, arg1_58)
	local var0_58 = arg1_58:GetPosition()
	local var1_58 = false
	local var2_58 = (var0_58.x - arg0_58._hostPos.x) * arg0_58:GetDirection()

	if arg0_58._backRange < 0 then
		if var2_58 > 0 and var2_58 <= arg0_58._frontRange and var2_58 >= math.abs(arg0_58._backRange) then
			var1_58 = true
		end
	elseif var2_58 > 0 and var2_58 <= arg0_58._frontRange or var2_58 < 0 and math.abs(var2_58) < arg0_58._backRange then
		var1_58 = true
	end

	if not var1_58 then
		return true
	else
		return false
	end
end

function var9_0.PreCast(arg0_59)
	arg0_59._currentState = arg0_59.STATE_PRECAST

	arg0_59:AddPreCastTimer()

	if arg0_59._preCastInfo.armor then
		arg0_59._precastArmor = arg0_59._preCastInfo.armor
	end

	local var0_59 = arg0_59._preCastInfo
	local var1_59 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.WEAPON_PRE_CAST, var0_59)

	arg0_59._host:SetWeaponPreCastBound(arg0_59._preCastInfo.isBound)
	arg0_59:DispatchEvent(var1_59)
end

function var9_0.Fire(arg0_60, arg1_60)
	if arg0_60._host:IsCease() then
		return false
	else
		arg0_60:DispatchGCD()

		arg0_60._currentState = arg0_60.STATE_ATTACK

		if arg0_60._tmpData.action_index == "" then
			arg0_60:DoAttack(arg1_60)
		else
			arg0_60:DispatchFireEvent(arg1_60, arg0_60._tmpData.action_index)
		end
	end

	return true
end

function var9_0.DoAttack(arg0_61, arg1_61)
	if arg1_61 == nil or not arg1_61:IsAlive() or arg0_61:outOfFireRange(arg1_61) then
		arg1_61 = nil
	end

	local var0_61 = arg0_61:GetDirection()
	local var1_61 = arg0_61:GetAttackAngle()

	arg0_61:cacheBulletID()
	arg0_61:TriggerBuffOnSteday()

	for iter0_61, iter1_61 in ipairs(arg0_61._majorEmitterList) do
		iter1_61:Ready()
	end

	for iter2_61, iter3_61 in ipairs(arg0_61._majorEmitterList) do
		iter3_61:Fire(arg1_61, var0_61, var1_61)
	end

	arg0_61._host:CloakExpose(arg0_61._tmpData.expose)
	var0_0.Battle.PlayBattleSFX(arg0_61._tmpData.fire_sfx)
	arg0_61:TriggerBuffOnFire()
	arg0_61:CheckAndShake()
end

function var9_0.TriggerBuffOnSteday(arg0_62)
	arg0_62._host:TriggerBuff(var1_0.BuffEffectType.ON_WEAPON_STEDAY, {
		equipIndex = arg0_62._equipmentIndex
	})
end

function var9_0.TriggerBuffOnFire(arg0_63)
	arg0_63._host:TriggerBuff(var1_0.BuffEffectType.ON_FIRE, {
		equipIndex = arg0_63._equipmentIndex
	})
end

function var9_0.TriggerBuffOnReady(arg0_64)
	return
end

function var9_0.UpdateCombo(arg0_65, arg1_65)
	if arg0_65._hostUnitType ~= var1_0.UnitType.PLAYER_UNIT or not arg0_65._host:IsAlive() then
		return
	end

	if #arg1_65 > 0 then
		local var0_65 = 0

		for iter0_65, iter1_65 in ipairs(arg1_65) do
			if table.contains(arg0_65._comboIDList, iter1_65) then
				var0_65 = var0_65 + 1
			end

			arg0_65._host:TriggerBuff(var1_0.BuffEffectType.ON_COMBO, {
				equipIndex = arg0_65._equipmentIndex,
				matchUnitCount = var0_65
			})

			break
		end

		arg0_65._comboIDList = arg1_65
	end
end

function var9_0.SingleFire(arg0_66, arg1_66, arg2_66, arg3_66, arg4_66)
	local var0_66 = {}

	arg0_66._tempEmittersList[#arg0_66._tempEmittersList + 1] = var0_66

	if arg1_66 and arg1_66:IsAlive() then
		-- block empty
	else
		arg1_66 = nil
	end

	arg2_66 = arg2_66 or var9_0.EMITTER_NORMAL

	for iter0_66, iter1_66 in ipairs(arg0_66._barrageList) do
		local function var1_66(arg0_67, arg1_67, arg2_67, arg3_67)
			local var0_67 = (arg4_66 and arg0_66._tmpData.bullet_ID or arg0_66._bulletList)[iter0_66]
			local var1_67 = arg0_66:Spawn(var0_67, arg1_66, var9_0.EXTERNAL)

			var1_67:SetOffsetPriority(arg3_67)
			var1_67:SetShiftInfo(arg0_67, arg1_67)

			if arg1_66 ~= nil then
				var1_67:SetRotateInfo(arg1_66:GetBeenAimedPosition(), arg0_66:GetBaseAngle(), arg2_67)
			else
				var1_67:SetRotateInfo(nil, arg0_66:GetBaseAngle(), arg2_67)
			end

			arg0_66:DispatchBulletEvent(var1_67)
		end

		local function var2_66()
			for iter0_68, iter1_68 in ipairs(var0_66) do
				if iter1_68:GetState() ~= iter1_68.STATE_STOP then
					return
				end
			end

			for iter2_68, iter3_68 in ipairs(var0_66) do
				iter3_68:Destroy()
			end

			local var0_68

			for iter4_68, iter5_68 in ipairs(arg0_66._tempEmittersList) do
				if iter5_68 == var0_66 then
					var0_68 = iter4_68
				end
			end

			table.remove(arg0_66._tempEmittersList, var0_68)

			var0_66 = nil
			arg0_66._fireFXFlag = arg0_66._tmpData.fire_fx_loop_type

			if arg3_66 then
				arg3_66()
			end
		end

		local var3_66 = var0_0.Battle[arg2_66].New(var1_66, var2_66, iter1_66)

		var0_66[#var0_66 + 1] = var3_66
	end

	for iter2_66, iter3_66 in ipairs(var0_66) do
		iter3_66:Ready()
		iter3_66:Fire(arg1_66, arg0_66:GetDirection(), arg0_66:GetAttackAngle())
	end

	arg0_66._host:CloakExpose(arg0_66._tmpData.expose)
	arg0_66:CheckAndShake()
end

function var9_0.SetModifyInitialCD(arg0_69)
	arg0_69._modInitCD = true
end

function var9_0.GetModifyInitialCD(arg0_70)
	return arg0_70._modInitCD
end

function var9_0.InitialCD(arg0_71)
	if arg0_71._tmpData.initial_over_heat == 1 then
		arg0_71:AddCDTimer(arg0_71:GetReloadTime())
	end
end

function var9_0.EnterCoolDown(arg0_72)
	arg0_72._fireFXFlag = arg0_72._tmpData.fire_fx_loop_type

	arg0_72:AddCDTimer(arg0_72:GetReloadTime())
end

function var9_0.UpdatePrecastArmor(arg0_73, arg1_73)
	if arg0_73._currentState ~= var9_0.STATE_PRECAST or not arg0_73._precastArmor then
		return
	end

	arg0_73._precastArmor = arg0_73._precastArmor + arg1_73

	if arg0_73._precastArmor <= 0 then
		arg0_73:Interrupt()
	end
end

function var9_0.Interrupt(arg0_74)
	local var0_74 = arg0_74._preCastInfo
	local var1_74 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.WEAPON_PRE_CAST_FINISH, var0_74)

	arg0_74:DispatchEvent(var1_74)

	local var2_74 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.WEAPON_INTERRUPT, var0_74)

	arg0_74:DispatchEvent(var2_74)
	arg0_74:TriggerBuffWhenPrecastFinish(var1_0.BuffEffectType.ON_WEAPON_INTERRUPT)
	arg0_74:RemovePrecastTimer()
	arg0_74:EnterCoolDown()
end

function var9_0.Cease(arg0_75)
	if arg0_75._currentState == var9_0.STATE_ATTACK or arg0_75._currentState == var9_0.STATE_PRECAST or arg0_75._currentState == var9_0.STATE_PRECAST_FINISH then
		arg0_75:interruptAllEmitter()
		arg0_75:EnterCoolDown()
	end
end

function var9_0.AppendReloadBoost(arg0_76)
	return
end

function var9_0.DispatchGCD(arg0_77)
	if arg0_77._GCD > 0 then
		arg0_77._host:EnterGCD(arg0_77._GCD, arg0_77._tmpData.queue)
	end
end

function var9_0.Clear(arg0_78)
	arg0_78:RemovePrecastTimer()

	if arg0_78._majorEmitterList then
		for iter0_78, iter1_78 in ipairs(arg0_78._majorEmitterList) do
			iter1_78:Destroy()
		end
	end

	for iter2_78, iter3_78 in ipairs(arg0_78._tempEmittersList) do
		for iter4_78, iter5_78 in ipairs(iter3_78) do
			iter5_78:Destroy()
		end
	end

	for iter6_78, iter7_78 in ipairs(arg0_78._dumpedEmittersList) do
		for iter8_78, iter9_78 in ipairs(iter7_78) do
			iter9_78:Destroy()
		end
	end

	if arg0_78._currentState ~= arg0_78.STATE_OVER_HEAT then
		arg0_78._currentState = arg0_78.STATE_DISABLE
	end
end

function var9_0.Dispose(arg0_79)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_79)
	arg0_79:RemovePrecastTimer()

	arg0_79._dataProxy = nil
end

function var9_0.AddCDTimer(arg0_80, arg1_80)
	arg0_80._currentState = arg0_80.STATE_OVER_HEAT
	arg0_80._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_80._reloadRequire = arg1_80
end

function var9_0.GetCDStartTimeStamp(arg0_81)
	return arg0_81._CDstartTime
end

function var9_0.handleCoolDown(arg0_82)
	arg0_82._currentState = arg0_82.STATE_READY
	arg0_82._CDstartTime = nil
	arg0_82._jammingTime = 0
end

function var9_0.OverHeat(arg0_83)
	arg0_83._currentState = arg0_83.STATE_OVER_HEAT
end

function var9_0.RemovePrecastTimer(arg0_84)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_84._precastTimer)
	arg0_84._host:SetWeaponPreCastBound(false)

	arg0_84._precastArmor = nil
	arg0_84._precastTimer = nil
end

function var9_0.AddPreCastTimer(arg0_85)
	local function var0_85()
		arg0_85._currentState = arg0_85.STATE_PRECAST_FINISH

		arg0_85:RemovePrecastTimer()

		local var0_86 = arg0_85._preCastInfo
		local var1_86 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.WEAPON_PRE_CAST_FINISH, var0_86)

		arg0_85:DispatchEvent(var1_86)
		arg0_85:TriggerBuffWhenPrecastFinish(var1_0.BuffEffectType.ON_WEAPON_SUCCESS)
		arg0_85:Tracking()
	end

	arg0_85._precastTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponPrecastTimer", 0, arg0_85._preCastInfo.time, var0_85, true)
end

function var9_0.Spawn(arg0_87, arg1_87, arg2_87)
	local var0_87

	if arg2_87 == nil then
		var0_87 = Vector3.zero
	else
		var0_87 = arg2_87:GetBeenAimedPosition() or arg2_87:GetPosition()
	end

	local var1_87 = arg0_87._dataProxy:CreateBulletUnit(arg1_87, arg0_87._host, arg0_87, var0_87)

	arg0_87:setBulletSkin(var1_87, arg1_87)
	arg0_87:setBulletOrb(var1_87)
	arg0_87:TriggerBuffWhenSpawn(var1_87)

	return var1_87
end

function var9_0.FixAmmo(arg0_88, arg1_88)
	arg0_88._fixedAmmo = arg1_88
end

function var9_0.GetFixAmmo(arg0_89)
	return arg0_89._fixedAmmo
end

function var9_0.ShiftBullet(arg0_90, arg1_90)
	local var0_90 = {}

	for iter0_90 = 1, #arg0_90._bulletList do
		var0_90[iter0_90] = arg1_90
	end

	arg0_90._bulletList = var0_90
end

function var9_0.RevertBullet(arg0_91)
	arg0_91._bulletList = arg0_91._tmpData.bullet_ID
end

function var9_0.cacheBulletID(arg0_92)
	arg0_92._emitBulletIDList = arg0_92._bulletList
end

function var9_0.setBulletOrb(arg0_93, arg1_93)
	if not arg0_93._orbID then
		return
	end

	local var0_93 = {
		buff_id = arg0_93._orbID,
		rant = arg0_93._orbRant,
		level = arg0_93._orbLevel
	}

	arg1_93:AppendAttachBuff(var0_93)
end

function var9_0.SetBulletOrbData(arg0_94, arg1_94)
	arg0_94._orbID = arg1_94.buffID
	arg0_94._orbRant = arg1_94.rant
	arg0_94._orbLevel = arg1_94.level
end

function var9_0.ShiftBarrage(arg0_95, arg1_95)
	for iter0_95, iter1_95 in ipairs(arg0_95._majorEmitterList) do
		table.insert(arg0_95._dumpedEmittersList, iter1_95)
	end

	arg0_95._majorEmitterList = {}

	if type(arg1_95) == "number" then
		local var0_95 = {}

		for iter2_95 = 1, #arg0_95._barrageList do
			var0_95[iter2_95] = arg1_95
		end

		arg0_95._barrageList = var0_95
	elseif type(arg1_95) == "table" then
		arg0_95._barrageList = arg1_95
	end

	for iter3_95, iter4_95 in ipairs(arg0_95._barrageList) do
		arg0_95:createMajorEmitter(iter4_95, iter3_95)
	end
end

function var9_0.RevertBarrage(arg0_96)
	arg0_96:ShiftBarrage(arg0_96._tmpData.barrage_ID)
end

function var9_0.GetPrimalAmmoType(arg0_97)
	return var6_0.GetBulletTmpDataFromID(arg0_97._tmpData.bullet_ID[1]).ammo_type
end

function var9_0.TriggerBuffWhenSpawn(arg0_98, arg1_98, arg2_98)
	local var0_98 = arg2_98 or var1_0.BuffEffectType.ON_BULLET_CREATE
	local var1_98 = {
		_bullet = arg1_98,
		equipIndex = arg0_98._equipmentIndex,
		bulletTag = arg1_98:GetExtraTag()
	}

	arg0_98._host:TriggerBuff(var0_98, var1_98)
end

function var9_0.TriggerBuffWhenPrecastFinish(arg0_99, arg1_99)
	if arg0_99._preCastInfo.armor then
		local var0_99 = {
			weaponID = arg0_99._tmpData.id
		}

		arg0_99._host:TriggerBuff(arg1_99, var0_99)
	end
end

function var9_0.DispatchBulletEvent(arg0_100, arg1_100, arg2_100)
	local var0_100 = arg2_100
	local var1_100 = arg0_100._tmpData
	local var2_100

	if arg0_100._fireFXFlag ~= 0 then
		var2_100 = arg0_100._skinFireFX or var1_100.fire_fx

		if arg0_100._fireFXFlag ~= -1 then
			arg0_100._fireFXFlag = arg0_100._fireFXFlag - 1
		end
	end

	if type(var1_100.spawn_bound) == "table" and not var0_100 then
		local var3_100 = arg0_100._dataProxy:GetStageInfo().mainUnitPosition

		if var3_100 and var3_100[arg0_100._hostIFF] then
			var0_100 = Clone(var3_100[arg0_100._hostIFF][var1_100.spawn_bound[1]])
		else
			var0_100 = Clone(var2_0.MAIN_UNIT_POS[arg0_100._hostIFF][var1_100.spawn_bound[1]])
		end
	end

	local var4_100 = {
		spawnBound = var1_100.spawn_bound,
		bullet = arg1_100,
		fireFxID = var2_100,
		position = var0_100
	}
	local var5_100 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CREATE_BULLET, var4_100)

	arg0_100:DispatchEvent(var5_100)
end

function var9_0.DispatchFireEvent(arg0_101, arg1_101, arg2_101)
	local var0_101 = {
		target = arg1_101,
		actionIndex = arg2_101
	}
	local var1_101 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.FIRE, var0_101)

	arg0_101:DispatchEvent(var1_101)
end

function var9_0.CheckAndShake(arg0_102)
	if arg0_102._tmpData.shakescreen ~= 0 then
		var0_0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[arg0_102._tmpData.shakescreen])
	end
end

function var9_0.GetBaseAngle(arg0_103)
	return arg0_103._baseAngle
end

function var9_0.GetHost(arg0_104)
	return arg0_104._host
end

function var9_0.GetStandHost(arg0_105)
	return arg0_105._standHost
end

function var9_0.GetPosition(arg0_106)
	return arg0_106._hostPos
end

function var9_0.GetDirection(arg0_107)
	return arg0_107._host:GetDirection()
end

function var9_0.GetCurrentState(arg0_108)
	return arg0_108._currentState
end

function var9_0.GetReloadTime(arg0_109)
	local var0_109 = var7_0.GetCurrent(arg0_109._host, "loadSpeed")

	if arg0_109._reloadMax ~= arg0_109._cacheReloadMax or var0_109 ~= arg0_109._cacheHostReload then
		arg0_109._cacheReloadMax = arg0_109._reloadMax
		arg0_109._cacheHostReload = var0_109
		arg0_109._cacheReloadTime = var3_0.CalculateReloadTime(arg0_109._reloadMax, var7_0.GetCurrent(arg0_109._host, "loadSpeed"))
	end

	return arg0_109._cacheReloadTime
end

function var9_0.GetReloadTimeByRate(arg0_110, arg1_110)
	local var0_110 = var7_0.GetCurrent(arg0_110._host, "loadSpeed")
	local var1_110 = arg0_110._cacheReloadMax * arg1_110

	return (var3_0.CalculateReloadTime(var1_110, var0_110))
end

function var9_0.GetReloadFinishTimeStamp(arg0_111)
	local var0_111 = 0

	for iter0_111, iter1_111 in ipairs(arg0_111._reloadBoostList) do
		var0_111 = var0_111 + iter1_111
	end

	return arg0_111._reloadRequire + arg0_111._CDstartTime + arg0_111._jammingTime + var0_111
end

function var9_0.AppendFactor(arg0_112, arg1_112)
	return
end

function var9_0.StartJamming(arg0_113)
	if arg0_113._currentState ~= var9_0.STATE_READY then
		arg0_113._jammingStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var9_0.JammingEliminate(arg0_114)
	if not arg0_114._jammingStartTime then
		return
	end

	arg0_114._jammingTime = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_114._jammingStartTime
	arg0_114._jammingStartTime = nil
end

function var9_0.FlushReloadMax(arg0_115, arg1_115)
	local var0_115 = arg0_115._tmpData.reload_max

	arg1_115 = arg1_115 or 1
	arg0_115._reloadMax = var0_115 * arg1_115

	if not arg0_115._CDstartTime or arg0_115._reloadRequire == 0 then
		return true
	end

	local var1_115 = var7_0.GetCurrent(arg0_115._host, "loadSpeed")

	arg0_115._reloadRequire = var9_0.FlushRequireByInverse(arg0_115, var1_115)
end

function var9_0.AppendReloadFactor(arg0_116, arg1_116, arg2_116)
	arg0_116._reloadFacotrList[arg1_116] = arg2_116
end

function var9_0.RemoveReloadFactor(arg0_117, arg1_117)
	if arg0_117._reloadFacotrList[arg1_117] then
		arg0_117._reloadFacotrList[arg1_117] = nil
	end
end

function var9_0.GetReloadFactorList(arg0_118)
	return arg0_118._reloadFacotrList
end

function var9_0.FlushReloadRequire(arg0_119)
	if not arg0_119._CDstartTime or arg0_119._reloadRequire == 0 then
		return true
	end

	local var0_119 = var3_0.CaclulateReloadAttr(arg0_119._reloadMax, arg0_119._reloadRequire)

	arg0_119._reloadRequire = var9_0.FlushRequireByInverse(arg0_119, var0_119)
end

function var9_0.GetMinimumRange(arg0_120)
	return arg0_120._minRangeSqr
end

function var9_0.GetCorrectedDMG(arg0_121)
	return arg0_121._correctedDMG
end

function var9_0.GetConvertedAtkAttr(arg0_122)
	return arg0_122._convertedAtkAttr
end

function var9_0.SetAtkAttrTrasnform(arg0_123, arg1_123, arg2_123, arg3_123)
	arg0_123._atkAttrTrans = arg1_123
	arg0_123._atkAttrTransA = arg2_123
	arg0_123._atkAttrTransB = arg3_123
end

function var9_0.GetAtkAttrTrasnform(arg0_124, arg1_124)
	local var0_124

	if arg0_124._atkAttrTrans then
		local var1_124 = arg1_124[arg0_124._atkAttrTrans] or 0

		var0_124 = math.min(var1_124 / arg0_124._atkAttrTransA, arg0_124._atkAttrTransB)
	end

	return var0_124
end

function var9_0.IsReady(arg0_125)
	return arg0_125._currentState == arg0_125.STATE_READY
end

function var9_0.FlushRequireByInverse(arg0_126, arg1_126)
	local var0_126 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_126._CDstartTime
	local var1_126 = var3_0.CaclulateReloaded(var0_126, arg1_126)
	local var2_126 = arg0_126._reloadMax - var1_126

	return var0_126 + var3_0.CalculateReloadTime(var2_126, var7_0.GetCurrent(arg0_126._host, "loadSpeed"))
end

function var9_0.SetCardPuzzleDamageEnhance(arg0_127, arg1_127)
	arg0_127._cardPuzzleEnhance = arg1_127
end

function var9_0.GetCardPuzzleDamageEnhance(arg0_128)
	return arg0_128._cardPuzzleEnhance or 1
end

function var9_0.GetReloadRate(arg0_129)
	if arg0_129._currentState == arg0_129.STATE_READY then
		return 0
	elseif arg0_129._CDstartTime then
		return (arg0_129:GetReloadFinishTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()) / arg0_129._reloadRequire
	else
		return 1
	end
end

function var9_0.WeaponStatistics(arg0_130, arg1_130, arg2_130, arg3_130)
	arg0_130._CLDCount = arg0_130._CLDCount + 1
	arg0_130._damageSum = arg1_130 + arg0_130._damageSum

	if arg2_130 then
		arg0_130._CTSum = arg0_130._CTSum + 1
	end

	if not arg3_130 then
		arg0_130._ACCSum = arg0_130._ACCSum + 1
	end
end

function var9_0.GetDamageSUM(arg0_131)
	return arg0_131._damageSum
end

function var9_0.GetCTRate(arg0_132)
	return arg0_132._CTSum / arg0_132._CLDCount
end

function var9_0.GetACCRate(arg0_133)
	return arg0_133._ACCSum / arg0_133._CLDCount
end
