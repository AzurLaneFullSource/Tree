ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleFormulas
local var4 = var1.WeaponSuppressType
local var5 = var1.WeaponSearchType
local var6 = var0.Battle.BattleDataFunction
local var7 = var0.Battle.BattleAttr
local var8 = var0.Battle.BattleTargetChoise
local var9 = class("BattleWeaponUnit")

var0.Battle.BattleWeaponUnit = var9
var9.__name = "BattleWeaponUnit"
var9.INTERNAL = "internal"
var9.EXTERNAL = "external"
var9.EMITTER_NORMAL = "BattleBulletEmitter"
var9.EMITTER_SHOTGUN = "BattleShotgunEmitter"
var9.STATE_DISABLE = "DISABLE"
var9.STATE_READY = "READY"
var9.STATE_PRECAST = "PRECAST"
var9.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var9.STATE_ATTACK = "ATTACK"
var9.STATE_OVER_HEAT = "OVER_HEAT"

function var9.Ctor(arg0)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._currentState = arg0.STATE_READY
	arg0._equipmentIndex = -1
	arg0._dataProxy = var0.Battle.BattleDataProxy.GetInstance()
	arg0._tempEmittersList = {}
	arg0._dumpedEmittersList = {}
	arg0._reloadFacotrList = {}
	arg0._diveEnabled = true
	arg0._comboIDList = {}
	arg0._jammingTime = 0
	arg0._reloadBoostList = {}
	arg0._CLDCount = 0
	arg0._damageSum = 0
	arg0._CTSum = 0
	arg0._ACCSum = 0
end

function var9.HostOnEnemy(arg0)
	arg0._hostOnEnemy = true
end

function var9.SetPotentialFactor(arg0, arg1)
	arg0._potential = arg1

	if arg0._correctedDMG then
		arg0._correctedDMG = var3.WeaponDamagePreCorrection(arg0)
	end
end

function var9.GetEquipmentLabel(arg0)
	return arg0._equipmentLabelList or {}
end

function var9.SetEquipmentLabel(arg0, arg1)
	arg0._equipmentLabelList = arg1
end

function var9.SetTemplateData(arg0, arg1)
	arg0._potential = arg0._potential or 1
	arg0._tmpData = arg1
	arg0._maxRangeSqr = arg1.range
	arg0._minRangeSqr = arg1.min_range
	arg0._fireFXFlag = arg1.fire_fx_loop_type
	arg0._oxyList = arg1.oxy_type
	arg0._bulletList = arg1.bullet_ID
	arg0._majorEmitterList = {}

	arg0:ShiftBarrage(arg1.barrage_ID)

	arg0._GCD = arg1.recover_time
	arg0._preCastInfo = arg1.precast_param
	arg0._correctedDMG = var3.WeaponDamagePreCorrection(arg0)
	arg0._convertedAtkAttr = var3.WeaponAtkAttrPreRatio(arg0)

	arg0:FlushReloadMax(1)
end

function var9.createMajorEmitter(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0(arg0, arg1, arg2, arg3, arg4)
		local var0 = arg0._emitBulletIDList[arg2]
		local var1 = arg0:Spawn(var0, arg4, var9.INTERNAL)

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)

		if arg0._tmpData.aim_type == var1.WeaponAimType.AIM and arg4 ~= nil then
			var1:SetRotateInfo(arg4:GetBeenAimedPosition(), arg0:GetBaseAngle(), arg2)
		else
			var1:SetRotateInfo(nil, arg0:GetBaseAngle(), arg2)
		end

		arg0:DispatchBulletEvent(var1)

		return var1
	end

	local function var1()
		for iter0, iter1 in ipairs(arg0._majorEmitterList) do
			if iter1:GetState() ~= iter1.STATE_STOP then
				return
			end
		end

		arg0:EnterCoolDown()
	end

	arg3 = arg3 or var9.EMITTER_NORMAL

	local var2 = var0.Battle[arg3].New(arg4 or var0, arg5 or var1, arg1)

	arg0._majorEmitterList[#arg0._majorEmitterList + 1] = var2

	return var2
end

function var9.interruptAllEmitter(arg0)
	if arg0._majorEmitterList then
		for iter0, iter1 in ipairs(arg0._majorEmitterList) do
			iter1:Interrupt()
		end
	end

	for iter2, iter3 in ipairs(arg0._tempEmittersList) do
		for iter4, iter5 in ipairs(iter3) do
			iter5:Interrupt()
		end
	end

	for iter6, iter7 in ipairs(arg0._dumpedEmittersList) do
		for iter8, iter9 in ipairs(iter7) do
			iter9:Interrupt()
		end
	end
end

function var9.cacheSectorData(arg0)
	local var0 = arg0:GetAttackAngle() / 2

	arg0._upperEdge = math.deg2Rad * var0
	arg0._lowerEdge = -1 * arg0._upperEdge

	local var1 = math.deg2Rad * arg0._tmpData.axis_angle

	if arg0:GetDirection() == var1.UnitDir.LEFT then
		arg0._normalizeOffset = math.pi - var1
	elseif arg0:GetDirection() == var1.UnitDir.RIGHT then
		arg0._normalizeOffset = var1
	end

	arg0._wholeCircle = math.pi - arg0._normalizeOffset
	arg0._negativeCircle = -math.pi - arg0._normalizeOffset
	arg0._wholeCircleNormalizeOffset = arg0._normalizeOffset - math.pi * 2
	arg0._negativeCircleNormalizeOffset = arg0._normalizeOffset + math.pi * 2
end

function var9.cacheSquareData(arg0)
	arg0._frontRange = arg0._tmpData.angle
	arg0._backRange = arg0._tmpData.axis_angle
	arg0._upperRange = arg0._tmpData.min_range
	arg0._lowerRange = arg0._tmpData.range
end

function var9.SetModelID(arg0, arg1)
	arg0._modelID = arg1
end

function var9.SetSkinData(arg0, arg1)
	arg0._skinID = arg1

	local var0, var1, var2, var3, var4, var5 = var6.GetEquipSkin(arg0._skinID)

	arg0:SetModelID(var0)

	if var4 ~= "" then
		arg0._skinFireFX = var4
	end

	if var5 ~= "" then
		arg0._skinHitFX = var5
	end

	local var6, var7 = var6.GetEquipSkinSFX(arg0._skinID)

	arg0._skinHixSFX = var6
	arg0._skinMissSFX = var7
end

function var9.SetDerivateSkin(arg0, arg1)
	arg0._derivateSkinID = arg1

	local var0, var1, var2, var3, var4, var5 = var6.GetEquipSkin(arg0._derivateSkinID)

	arg0._derivateBullet = var1
	arg0._derivateTorpedo = var2
	arg0._derivateBoom = var3
	arg0._derviateHitFX = var5

	local var6, var7 = var6.GetEquipSkinSFX(arg0._derivateSkinID)

	arg0._skinHixSFX = var6
	arg0._skinMissSFX = var7
end

function var9.GetSkinID(arg0)
	return arg0._skinID
end

function var9.setBulletSkin(arg0, arg1, arg2)
	if arg0._derivateSkinID then
		local var0 = var6.GetBulletTmpDataFromID(arg2).type

		if var0 == var1.BulletType.BOMB then
			arg1:SetModleID(arg0._derivateBoom, nil, arg0._derviateHitFX)
		elseif var0 == var1.BulletType.TORPEDO then
			arg1:SetModleID(arg0._derivateTorpedo, nil, arg0._derviateHitFX)
		else
			arg1:SetModleID(arg0._derivateBullet, nil, arg0._derviateHitFX)
		end

		arg1:SetSFXID(arg0._skinHixSFX, arg0._skinMissSFX)
	elseif arg0._modelID then
		local var1 = 0

		if arg0._skinID then
			var1 = var6.GetEquipSkinDataFromID(arg0._skinID).mirror
		end

		arg1:SetModleID(arg0._modelID, var1, arg0._skinHitFX)
		arg1:SetSFXID(arg0._skinHixSFX, arg0._skinMissSFX)
	end
end

function var9.SetSrcEquipmentID(arg0, arg1)
	arg0._srcEquipID = arg1
end

function var9.SetEquipmentIndex(arg0, arg1)
	arg0._equipmentIndex = arg1
end

function var9.GetEquipmentIndex(arg0)
	return arg0._equipmentIndex
end

function var9.SetHostData(arg0, arg1)
	arg0._host = arg1
	arg0._hostUnitType = arg0._host:GetUnitType()
	arg0._hostIFF = arg1:GetIFF()

	if arg0._tmpData.search_type == var5.SECTOR then
		arg0:cacheSectorData()

		arg0.outOfFireRange = arg0.IsOutOfAngle
		arg0.IsOutOfFireArea = arg0.IsOutOfSector
	elseif arg0._tmpData.search_type == var5.SQUARE then
		arg0:cacheSquareData()

		arg0.outOfFireRange = arg0.IsOutOfSquare
		arg0.IsOutOfFireArea = arg0.IsOutOfSquare
	end

	if arg0:GetDirection() == var1.UnitDir.RIGHT then
		arg0._baseAngle = 0
	else
		arg0._baseAngle = 180
	end
end

function var9.SetStandHost(arg0, arg1)
	arg0._standHost = arg1
end

function var9.OverrideGCD(arg0, arg1)
	arg0._GCD = arg1
end

function var9.updateMovementInfo(arg0)
	arg0._hostPos = arg0._host:GetPosition()
end

function var9.GetWeaponId(arg0)
	return arg0._tmpData.id
end

function var9.GetTemplateData(arg0)
	return arg0._tmpData
end

function var9.GetType(arg0)
	return arg0._tmpData.type
end

function var9.GetPotential(arg0)
	return arg0._potential or 1
end

function var9.GetSrcEquipmentID(arg0)
	return arg0._srcEquipID
end

function var9.SetFixedFlag(arg0)
	arg0._isFixedWeapon = true
end

function var9.IsFixedWeapon(arg0)
	return arg0._isFixedWeapon
end

function var9.IsAttacking(arg0)
	return arg0._currentState == var9.STATE_ATTACK or arg0._currentState == arg0.STATE_PRECAST
end

function var9.Update(arg0)
	arg0:UpdateReload()

	if not arg0._diveEnabled then
		return
	end

	if arg0._currentState == arg0.STATE_READY then
		arg0:updateMovementInfo()

		if arg0._tmpData.suppress == var4.SUPPRESSION or arg0:CheckPreCast() then
			if arg0._preCastInfo.time == nil or not arg0._hostOnEnemy then
				arg0._currentState = arg0.STATE_PRECAST_FINISH
			else
				arg0:PreCast()
			end
		end
	end

	if arg0._currentState == arg0.STATE_PRECAST_FINISH then
		arg0:updateMovementInfo()
		arg0:Fire(arg0:Tracking())
	end
end

function var9.CheckReloadTimeStamp(arg0)
	return arg0._CDstartTime and arg0:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime()
end

function var9.UpdateReload(arg0)
	if arg0._CDstartTime and not arg0._jammingStartTime then
		if arg0:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			arg0:handleCoolDown()
		else
			return
		end
	end
end

function var9.CheckPreCast(arg0)
	for iter0, iter1 in pairs(arg0:GetFilteredList()) do
		return true
	end

	return false
end

function var9.ChangeDiveState(arg0)
	if arg0._host:GetOxyState() then
		local var0 = arg0._host:GetOxyState():GetWeaponType()

		for iter0, iter1 in ipairs(arg0._oxyList) do
			if table.contains(var0, iter1) then
				arg0._diveEnabled = true

				return
			end
		end

		arg0._diveEnabled = false
	end
end

function var9.getTrackingHost(arg0)
	return arg0._host
end

var9.TrackingFunc = {
	farthest = var9.TrackingFarthest,
	leastHP = var9.TrackingLeastHP
}

function var9.Tracking(arg0)
	local var0 = var7.GetCurrentTargetSelect(arg0._host)
	local var1
	local var2 = arg0:GetFilteredList()

	if var0 then
		local var3 = var9.TrackingFunc[var0]

		if var3 then
			var1 = var3(arg0, var2)
		else
			var1 = arg0:TrackingTag(var2, var0)
		end
	else
		var1 = arg0:TrackingNearest(var2)
	end

	if var1 and var7.GetCurrentGuardianID(var1) then
		local var4 = var7.GetCurrentGuardianID(var1)

		for iter0, iter1 in ipairs(var2) do
			if iter1:GetUniqueID() == var4 then
				var1 = iter1

				break
			end
		end
	end

	return var1
end

function var9.GetFilteredList(arg0)
	local var0 = arg0:FilterTarget()

	if arg0._tmpData.search_type == var5.SECTOR then
		var0 = arg0:FilterRange(var0)
		var0 = arg0:FilterAngle(var0)
	elseif arg0._tmpData.search_type == var5.SQUARE then
		var0 = arg0:FilterSquare(var0)
	end

	return var0
end

function var9.FixWeaponRange(arg0, arg1, arg2, arg3, arg4)
	arg0._maxRangeSqr = arg1 or arg0._tmpData.range
	arg0._minRangeSqr = arg3 or arg0._tmpData.min_range
	arg0._fixBulletRange = arg2
	arg0._bulletRangeOffset = arg4
end

function var9.GetWeaponMaxRange(arg0)
	return arg0._maxRangeSqr
end

function var9.GetWeaponMinRange(arg0)
	return arg0._minRangeSqr
end

function var9.GetFixBulletRange(arg0)
	return arg0._fixBulletRange, arg0._bulletRangeOffset
end

function var9.TrackingNearest(arg0, arg1)
	local var0 = arg0._maxRangeSqr
	local var1

	for iter0, iter1 in ipairs(arg1) do
		local var2 = arg0:getTrackingHost():GetDistance(iter1)

		if var2 <= var0 then
			var0 = var2
			var1 = iter1
		end
	end

	return var1
end

function var9.TrackingFarthest(arg0, arg1)
	local var0 = 0
	local var1

	for iter0, iter1 in ipairs(arg1) do
		local var2 = arg0:getTrackingHost():GetDistance(iter1)

		if var0 < var2 then
			var0 = var2
			var1 = iter1
		end
	end

	return var1
end

function var9.TrackingLeastHP(arg0, arg1)
	local var0 = math.huge
	local var1

	for iter0, iter1 in ipairs(arg1) do
		local var2 = iter1:GetCurrentHP()

		if var2 < var0 then
			var1 = iter1
			var0 = var2
		end
	end

	return var1
end

function var9.TrackingRandom(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg1) do
		table.insert(var0, iter1)
	end

	local var1 = #var0

	if #var0 == 0 then
		return nil
	else
		return var0[math.random(#var0)]
	end
end

function var9.TrackingTag(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		if iter1:ContainsLabelTag({
			arg2
		}) then
			table.insert(var0, iter1)
		end
	end

	if #var0 == 0 then
		return arg0:TrackingNearest(arg1)
	else
		return var0[math.random(#var0)]
	end
end

function var9.FilterTarget(arg0)
	local var0 = var8.LegalWeaponTarget(arg0._host)
	local var1 = {}
	local var2 = 1
	local var3 = arg0._tmpData.search_condition

	for iter0, iter1 in pairs(var0) do
		local var4 = iter1:GetCurrentOxyState()

		if var7.IsCloak(iter1) then
			-- block empty
		elseif not table.contains(var3, var4) then
			-- block empty
		else
			local var5 = true

			if var4 == var1.OXY_STATE.FLOAT then
				-- block empty
			elseif var4 == var1.OXY_STATE.DIVE and not iter1:IsRunMode() and not iter1:GetDiveDetected() and iter1:GetDiveInvisible() then
				var5 = false
			end

			if var5 then
				var1[var2] = iter1
				var2 = var2 + 1
			end
		end
	end

	return var1
end

function var9.FilterAngle(arg0, arg1)
	if arg0:GetAttackAngle() >= 360 then
		return arg1
	end

	for iter0 = #arg1, 1, -1 do
		if arg0:IsOutOfAngle(arg1[iter0]) then
			table.remove(arg1, iter0)
		end
	end

	return arg1
end

function var9.FilterRange(arg0, arg1)
	for iter0 = #arg1, 1, -1 do
		if arg0:IsOutOfRange(arg1[iter0]) then
			table.remove(arg1, iter0)
		end
	end

	return arg1
end

function var9.FilterSquare(arg0, arg1)
	local var0 = arg0:GetDirection()
	local var1 = arg0._host:GetPosition().x + arg0._backRange * var0 * -1
	local var2 = {
		lineX = var1,
		dir = var0
	}
	local var3 = var8.TargetInsideArea(arg0._host, var2, arg1)
	local var4 = var8.TargetWeightiest(arg0._host, nil, var3)

	for iter0 = #arg1, 1, -1 do
		if arg0:IsOutOfSquare(arg1[iter0]) then
			table.remove(arg1, iter0)
		end
	end

	for iter1 = #arg1, 1, -1 do
		if not table.contains(var4, arg1[iter1]) then
			table.remove(arg1, iter1)
		end
	end

	return arg1
end

function var9.GetAttackAngle(arg0)
	return arg0._tmpData.angle
end

function var9.IsOutOfAngle(arg0, arg1)
	if arg0:GetAttackAngle() >= 360 then
		return false
	end

	local var0 = arg1:GetPosition()
	local var1 = math.atan2(var0.z - arg0._hostPos.z, var0.x - arg0._hostPos.x)

	if var1 > arg0._wholeCircle then
		var1 = var1 + arg0._wholeCircleNormalizeOffset
	elseif var1 < arg0._negativeCircle then
		var1 = var1 + arg0._negativeCircleNormalizeOffset
	else
		var1 = var1 + arg0._normalizeOffset
	end

	if var1 > arg0._lowerEdge and var1 < arg0._upperEdge then
		return false
	else
		return true
	end
end

function var9.IsOutOfRange(arg0, arg1)
	local var0 = arg0:getTrackingHost():GetDistance(arg1)

	return var0 > arg0._maxRangeSqr or var0 < arg0:GetMinimumRange()
end

function var9.IsOutOfSector(arg0, arg1)
	return arg0:IsOutOfRange(arg1) or arg0:IsOutOfAngle(arg1)
end

function var9.IsOutOfSquare(arg0, arg1)
	local var0 = arg1:GetPosition()
	local var1 = false
	local var2 = (var0.x - arg0._hostPos.x) * arg0:GetDirection()

	if arg0._backRange < 0 then
		if var2 > 0 and var2 <= arg0._frontRange and var2 >= math.abs(arg0._backRange) then
			var1 = true
		end
	elseif var2 > 0 and var2 <= arg0._frontRange or var2 < 0 and math.abs(var2) < arg0._backRange then
		var1 = true
	end

	if not var1 then
		return true
	else
		return false
	end
end

function var9.PreCast(arg0)
	arg0._currentState = arg0.STATE_PRECAST

	arg0:AddPreCastTimer()

	if arg0._preCastInfo.armor then
		arg0._precastArmor = arg0._preCastInfo.armor
	end

	local var0 = arg0._preCastInfo
	local var1 = var0.Event.New(var0.Battle.BattleUnitEvent.WEAPON_PRE_CAST, var0)

	arg0._host:SetWeaponPreCastBound(arg0._preCastInfo.isBound)
	arg0:DispatchEvent(var1)
end

function var9.Fire(arg0, arg1)
	if not arg0._host:IsCease() then
		arg0:DispatchGCD()

		arg0._currentState = arg0.STATE_ATTACK

		if arg0._tmpData.action_index == "" then
			arg0:DoAttack(arg1)
		else
			arg0:DispatchFireEvent(arg1, arg0._tmpData.action_index)
		end
	end

	return true
end

function var9.DoAttack(arg0, arg1)
	if arg1 == nil or not arg1:IsAlive() or arg0:outOfFireRange(arg1) then
		arg1 = nil
	end

	local var0 = arg0:GetDirection()
	local var1 = arg0:GetAttackAngle()

	arg0:cacheBulletID()
	arg0:TriggerBuffOnSteday()

	for iter0, iter1 in ipairs(arg0._majorEmitterList) do
		iter1:Ready()
	end

	for iter2, iter3 in ipairs(arg0._majorEmitterList) do
		iter3:Fire(arg1, var0, var1)
	end

	arg0._host:CloakExpose(arg0._tmpData.expose)
	var0.Battle.PlayBattleSFX(arg0._tmpData.fire_sfx)
	arg0:TriggerBuffOnFire()
	arg0:CheckAndShake()
end

function var9.TriggerBuffOnSteday(arg0)
	arg0._host:TriggerBuff(var1.BuffEffectType.ON_WEAPON_STEDAY, {
		equipIndex = arg0._equipmentIndex
	})
end

function var9.TriggerBuffOnFire(arg0)
	arg0._host:TriggerBuff(var1.BuffEffectType.ON_FIRE, {
		equipIndex = arg0._equipmentIndex
	})
end

function var9.TriggerBuffOnReady(arg0)
	return
end

function var9.UpdateCombo(arg0, arg1)
	if arg0._hostUnitType ~= var1.UnitType.PLAYER_UNIT or not arg0._host:IsAlive() then
		return
	end

	if #arg1 > 0 then
		local var0 = 0

		for iter0, iter1 in ipairs(arg1) do
			if table.contains(arg0._comboIDList, iter1) then
				var0 = var0 + 1
			end

			arg0._host:TriggerBuff(var1.BuffEffectType.ON_COMBO, {
				equipIndex = arg0._equipmentIndex,
				matchUnitCount = var0
			})

			break
		end

		arg0._comboIDList = arg1
	end
end

function var9.SingleFire(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	arg0._tempEmittersList[#arg0._tempEmittersList + 1] = var0

	if arg1 and arg1:IsAlive() then
		-- block empty
	else
		arg1 = nil
	end

	arg2 = arg2 or var9.EMITTER_NORMAL

	for iter0, iter1 in ipairs(arg0._barrageList) do
		local function var1(arg0, arg1, arg2, arg3)
			local var0 = (arg4 and arg0._tmpData.bullet_ID or arg0._bulletList)[iter0]
			local var1 = arg0:Spawn(var0, arg1, var9.EXTERNAL)

			var1:SetOffsetPriority(arg3)
			var1:SetShiftInfo(arg0, arg1)

			if arg1 ~= nil then
				var1:SetRotateInfo(arg1:GetBeenAimedPosition(), arg0:GetBaseAngle(), arg2)
			else
				var1:SetRotateInfo(nil, arg0:GetBaseAngle(), arg2)
			end

			arg0:DispatchBulletEvent(var1)
		end

		local function var2()
			for iter0, iter1 in ipairs(var0) do
				if iter1:GetState() ~= iter1.STATE_STOP then
					return
				end
			end

			for iter2, iter3 in ipairs(var0) do
				iter3:Destroy()
			end

			local var0

			for iter4, iter5 in ipairs(arg0._tempEmittersList) do
				if iter5 == var0 then
					var0 = iter4
				end
			end

			table.remove(arg0._tempEmittersList, var0)

			var0 = nil
			arg0._fireFXFlag = arg0._tmpData.fire_fx_loop_type

			if arg3 then
				arg3()
			end
		end

		local var3 = var0.Battle[arg2].New(var1, var2, iter1)

		var0[#var0 + 1] = var3
	end

	for iter2, iter3 in ipairs(var0) do
		iter3:Ready()
		iter3:Fire(arg1, arg0:GetDirection(), arg0:GetAttackAngle())
	end

	arg0._host:CloakExpose(arg0._tmpData.expose)
	arg0:CheckAndShake()
end

function var9.SetModifyInitialCD(arg0)
	arg0._modInitCD = true
end

function var9.GetModifyInitialCD(arg0)
	return arg0._modInitCD
end

function var9.InitialCD(arg0)
	if arg0._tmpData.initial_over_heat == 1 then
		arg0:AddCDTimer(arg0:GetReloadTime())
	end
end

function var9.EnterCoolDown(arg0)
	arg0._fireFXFlag = arg0._tmpData.fire_fx_loop_type

	arg0:AddCDTimer(arg0:GetReloadTime())
end

function var9.UpdatePrecastArmor(arg0, arg1)
	if arg0._currentState ~= var9.STATE_PRECAST or not arg0._precastArmor then
		return
	end

	arg0._precastArmor = arg0._precastArmor + arg1

	if arg0._precastArmor <= 0 then
		arg0:Interrupt()
	end
end

function var9.Interrupt(arg0)
	local var0 = arg0._preCastInfo
	local var1 = var0.Event.New(var0.Battle.BattleUnitEvent.WEAPON_PRE_CAST_FINISH, var0)

	arg0:DispatchEvent(var1)

	local var2 = var0.Event.New(var0.Battle.BattleUnitEvent.WEAPON_INTERRUPT, var0)

	arg0:DispatchEvent(var2)
	arg0:TriggerBuffWhenPrecastFinish(var1.BuffEffectType.ON_WEAPON_INTERRUPT)
	arg0:RemovePrecastTimer()
	arg0:EnterCoolDown()
end

function var9.Cease(arg0)
	if arg0._currentState == var9.STATE_ATTACK or arg0._currentState == var9.STATE_PRECAST or arg0._currentState == var9.STATE_PRECAST_FINISH then
		arg0:interruptAllEmitter()
		arg0:EnterCoolDown()
	end
end

function var9.AppendReloadBoost(arg0)
	return
end

function var9.DispatchGCD(arg0)
	if arg0._GCD > 0 then
		arg0._host:EnterGCD(arg0._GCD, arg0._tmpData.queue)
	end
end

function var9.Clear(arg0)
	arg0:RemovePrecastTimer()

	if arg0._majorEmitterList then
		for iter0, iter1 in ipairs(arg0._majorEmitterList) do
			iter1:Destroy()
		end
	end

	for iter2, iter3 in ipairs(arg0._tempEmittersList) do
		for iter4, iter5 in ipairs(iter3) do
			iter5:Destroy()
		end
	end

	for iter6, iter7 in ipairs(arg0._dumpedEmittersList) do
		for iter8, iter9 in ipairs(iter7) do
			iter9:Destroy()
		end
	end

	if arg0._currentState ~= arg0.STATE_OVER_HEAT then
		arg0._currentState = arg0.STATE_DISABLE
	end
end

function var9.Dispose(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
	arg0:RemovePrecastTimer()

	arg0._dataProxy = nil
end

function var9.AddCDTimer(arg0, arg1)
	arg0._currentState = arg0.STATE_OVER_HEAT
	arg0._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0._reloadRequire = arg1
end

function var9.GetCDStartTimeStamp(arg0)
	return arg0._CDstartTime
end

function var9.handleCoolDown(arg0)
	arg0._currentState = arg0.STATE_READY
	arg0._CDstartTime = nil
	arg0._jammingTime = 0
end

function var9.OverHeat(arg0)
	arg0._currentState = arg0.STATE_OVER_HEAT
end

function var9.RemovePrecastTimer(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._precastTimer)
	arg0._host:SetWeaponPreCastBound(false)

	arg0._precastArmor = nil
	arg0._precastTimer = nil
end

function var9.AddPreCastTimer(arg0)
	local var0 = function()
		arg0._currentState = arg0.STATE_PRECAST_FINISH

		arg0:RemovePrecastTimer()

		local var0 = arg0._preCastInfo
		local var1 = var0.Event.New(var0.Battle.BattleUnitEvent.WEAPON_PRE_CAST_FINISH, var0)

		arg0:DispatchEvent(var1)
		arg0:TriggerBuffWhenPrecastFinish(var1.BuffEffectType.ON_WEAPON_SUCCESS)
		arg0:Tracking()
	end

	arg0._precastTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponPrecastTimer", 0, arg0._preCastInfo.time, var0, true)
end

function var9.Spawn(arg0, arg1, arg2)
	local var0

	if arg2 == nil then
		var0 = Vector3.zero
	else
		var0 = arg2:GetBeenAimedPosition() or arg2:GetPosition()
	end

	local var1 = arg0._dataProxy:CreateBulletUnit(arg1, arg0._host, arg0, var0)

	arg0:setBulletSkin(var1, arg1)
	arg0:setBulletOrb(var1)
	arg0:TriggerBuffWhenSpawn(var1)

	return var1
end

function var9.FixAmmo(arg0, arg1)
	arg0._fixedAmmo = arg1
end

function var9.GetFixAmmo(arg0)
	return arg0._fixedAmmo
end

function var9.ShiftBullet(arg0, arg1)
	local var0 = {}

	for iter0 = 1, #arg0._bulletList do
		var0[iter0] = arg1
	end

	arg0._bulletList = var0
end

function var9.RevertBullet(arg0)
	arg0._bulletList = arg0._tmpData.bullet_ID
end

function var9.cacheBulletID(arg0)
	arg0._emitBulletIDList = arg0._bulletList
end

function var9.setBulletOrb(arg0, arg1)
	if not arg0._orbID then
		return
	end

	local var0 = {
		buff_id = arg0._orbID,
		rant = arg0._orbRant,
		level = arg0._orbLevel
	}

	arg1:AppendAttachBuff(var0)
end

function var9.SetBulletOrbData(arg0, arg1)
	arg0._orbID = arg1.buffID
	arg0._orbRant = arg1.rant
	arg0._orbLevel = arg1.level
end

function var9.ShiftBarrage(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._majorEmitterList) do
		table.insert(arg0._dumpedEmittersList, iter1)
	end

	arg0._majorEmitterList = {}

	if type(arg1) == "number" then
		local var0 = {}

		for iter2 = 1, #arg0._barrageList do
			var0[iter2] = arg1
		end

		arg0._barrageList = var0
	elseif type(arg1) == "table" then
		arg0._barrageList = arg1
	end

	for iter3, iter4 in ipairs(arg0._barrageList) do
		arg0:createMajorEmitter(iter4, iter3)
	end
end

function var9.RevertBarrage(arg0)
	arg0:ShiftBarrage(arg0._tmpData.barrage_ID)
end

function var9.GetPrimalAmmoType(arg0)
	return var6.GetBulletTmpDataFromID(arg0._tmpData.bullet_ID[1]).ammo_type
end

function var9.TriggerBuffWhenSpawn(arg0, arg1, arg2)
	local var0 = arg2 or var1.BuffEffectType.ON_BULLET_CREATE
	local var1 = {
		_bullet = arg1,
		equipIndex = arg0._equipmentIndex,
		bulletTag = arg1:GetExtraTag()
	}

	arg0._host:TriggerBuff(var0, var1)
end

function var9.TriggerBuffWhenPrecastFinish(arg0, arg1)
	if arg0._preCastInfo.armor then
		local var0 = {
			weaponID = arg0._tmpData.id
		}

		arg0._host:TriggerBuff(arg1, var0)
	end
end

function var9.DispatchBulletEvent(arg0, arg1, arg2)
	local var0 = arg2
	local var1 = arg0._tmpData
	local var2

	if arg0._fireFXFlag ~= 0 then
		var2 = arg0._skinFireFX or var1.fire_fx

		if arg0._fireFXFlag ~= -1 then
			arg0._fireFXFlag = arg0._fireFXFlag - 1
		end
	end

	if type(var1.spawn_bound) == "table" and not var0 then
		local var3 = arg0._dataProxy:GetStageInfo().mainUnitPosition

		if var3 and var3[arg0._hostIFF] then
			var0 = Clone(var3[arg0._hostIFF][var1.spawn_bound[1]])
		else
			var0 = Clone(var2.MAIN_UNIT_POS[arg0._hostIFF][var1.spawn_bound[1]])
		end
	end

	local var4 = {
		spawnBound = var1.spawn_bound,
		bullet = arg1,
		fireFxID = var2,
		position = var0
	}
	local var5 = var0.Event.New(var0.Battle.BattleUnitEvent.CREATE_BULLET, var4)

	arg0:DispatchEvent(var5)
end

function var9.DispatchFireEvent(arg0, arg1, arg2)
	local var0 = {
		target = arg1,
		actionIndex = arg2
	}
	local var1 = var0.Event.New(var0.Battle.BattleUnitEvent.FIRE, var0)

	arg0:DispatchEvent(var1)
end

function var9.CheckAndShake(arg0)
	if arg0._tmpData.shakescreen ~= 0 then
		var0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[arg0._tmpData.shakescreen])
	end
end

function var9.GetBaseAngle(arg0)
	return arg0._baseAngle
end

function var9.GetHost(arg0)
	return arg0._host
end

function var9.GetStandHost(arg0)
	return arg0._standHost
end

function var9.GetPosition(arg0)
	return arg0._hostPos
end

function var9.GetDirection(arg0)
	return arg0._host:GetDirection()
end

function var9.GetCurrentState(arg0)
	return arg0._currentState
end

function var9.GetReloadTime(arg0)
	local var0 = var7.GetCurrent(arg0._host, "loadSpeed")

	if arg0._reloadMax ~= arg0._cacheReloadMax or var0 ~= arg0._cacheHostReload then
		arg0._cacheReloadMax = arg0._reloadMax
		arg0._cacheHostReload = var0
		arg0._cacheReloadTime = var3.CalculateReloadTime(arg0._reloadMax, var7.GetCurrent(arg0._host, "loadSpeed"))
	end

	return arg0._cacheReloadTime
end

function var9.GetReloadTimeByRate(arg0, arg1)
	local var0 = var7.GetCurrent(arg0._host, "loadSpeed")
	local var1 = arg0._cacheReloadMax * arg1

	return (var3.CalculateReloadTime(var1, var0))
end

function var9.GetReloadFinishTimeStamp(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0._reloadBoostList) do
		var0 = var0 + iter1
	end

	return arg0._reloadRequire + arg0._CDstartTime + arg0._jammingTime + var0
end

function var9.AppendFactor(arg0, arg1)
	return
end

function var9.StartJamming(arg0)
	if arg0._currentState ~= var9.STATE_READY then
		arg0._jammingStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var9.JammingEliminate(arg0)
	if not arg0._jammingStartTime then
		return
	end

	arg0._jammingTime = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._jammingStartTime
	arg0._jammingStartTime = nil
end

function var9.FlushReloadMax(arg0, arg1)
	local var0 = arg0._tmpData.reload_max

	arg1 = arg1 or 1
	arg0._reloadMax = var0 * arg1

	if not arg0._CDstartTime or arg0._reloadRequire == 0 then
		return true
	end

	local var1 = var7.GetCurrent(arg0._host, "loadSpeed")

	arg0._reloadRequire = var9.FlushRequireByInverse(arg0, var1)
end

function var9.AppendReloadFactor(arg0, arg1, arg2)
	arg0._reloadFacotrList[arg1] = arg2
end

function var9.RemoveReloadFactor(arg0, arg1)
	if arg0._reloadFacotrList[arg1] then
		arg0._reloadFacotrList[arg1] = nil
	end
end

function var9.GetReloadFactorList(arg0)
	return arg0._reloadFacotrList
end

function var9.FlushReloadRequire(arg0)
	if not arg0._CDstartTime or arg0._reloadRequire == 0 then
		return true
	end

	local var0 = var3.CaclulateReloadAttr(arg0._reloadMax, arg0._reloadRequire)

	arg0._reloadRequire = var9.FlushRequireByInverse(arg0, var0)
end

function var9.GetMinimumRange(arg0)
	return arg0._minRangeSqr
end

function var9.GetCorrectedDMG(arg0)
	return arg0._correctedDMG
end

function var9.GetConvertedAtkAttr(arg0)
	return arg0._convertedAtkAttr
end

function var9.SetAtkAttrTrasnform(arg0, arg1, arg2, arg3)
	arg0._atkAttrTrans = arg1
	arg0._atkAttrTransA = arg2
	arg0._atkAttrTransB = arg3
end

function var9.GetAtkAttrTrasnform(arg0, arg1)
	local var0

	if arg0._atkAttrTrans then
		local var1 = arg1[arg0._atkAttrTrans] or 0

		var0 = math.min(var1 / arg0._atkAttrTransA, arg0._atkAttrTransB)
	end

	return var0
end

function var9.IsReady(arg0)
	return arg0._currentState == arg0.STATE_READY
end

function var9.FlushRequireByInverse(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._CDstartTime
	local var1 = var3.CaclulateReloaded(var0, arg1)
	local var2 = arg0._reloadMax - var1

	return var0 + var3.CalculateReloadTime(var2, var7.GetCurrent(arg0._host, "loadSpeed"))
end

function var9.SetCardPuzzleDamageEnhance(arg0, arg1)
	arg0._cardPuzzleEnhance = arg1
end

function var9.GetCardPuzzleDamageEnhance(arg0)
	return arg0._cardPuzzleEnhance or 1
end

function var9.GetReloadRate(arg0)
	if arg0._currentState == arg0.STATE_READY then
		return 0
	elseif arg0._CDstartTime then
		return (arg0:GetReloadFinishTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()) / arg0._reloadRequire
	else
		return 1
	end
end

function var9.WeaponStatistics(arg0, arg1, arg2, arg3)
	arg0._CLDCount = arg0._CLDCount + 1
	arg0._damageSum = arg1 + arg0._damageSum

	if arg2 then
		arg0._CTSum = arg0._CTSum + 1
	end

	if not arg3 then
		arg0._ACCSum = arg0._ACCSum + 1
	end
end

function var9.GetDamageSUM(arg0)
	return arg0._damageSum
end

function var9.GetCTRate(arg0)
	return arg0._CTSum / arg0._CLDCount
end

function var9.GetACCRate(arg0)
	return arg0._ACCSum / arg0._CLDCount
end
