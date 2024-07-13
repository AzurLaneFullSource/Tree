ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleVariable
local var8_0 = var3_0.WeaponSearchType
local var9_0 = var3_0.WeaponSuppressType
local var10_0 = class("BattleFleetRangeAntiAirUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleFleetRangeAntiAirUnit = var10_0
var10_0.__name = "BattleFleetRangeAntiAirUnit"

function var10_0.Ctor(arg0_1)
	var10_0.super.Ctor(arg0_1)

	arg0_1._currentState = var10_0.STATE_DISABLE

	arg0_1:init()
end

function var10_0.init(arg0_2)
	arg0_2._crewUnitList = {}
	arg0_2._hitFXResIDList = {}
	arg0_2._range = 0
	arg0_2._majorEmitterList = {}
	arg0_2._GCD = 0.5
	arg0_2._tmpData = {}
	arg0_2._tmpData.bullet_ID = {
		var4_0.AntiAirConfig.RangeBulletID
	}
	arg0_2._tmpData.barrage_ID = {
		var4_0.AntiAirConfig.RangeBarrageID
	}
	arg0_2._tmpData.aim_type = var3_0.WeaponAimType.AIM
	arg0_2._tmpData.axis_angle = 0
	arg0_2._tmpData.search_type = var8_0.SECTOR
	arg0_2._tmpData.suppress = var9_0.NONE
	arg0_2._tmpData.queue = 0
	arg0_2._tmpData.action_index = ""
	arg0_2._tmpData.fire_sfx = "battle/cannon-air"
	arg0_2._tmpData.spawn_bound = var4_0.AntiAirConfig.RangeAntiAirBone
	arg0_2._tmpData.shakescreen = 0
	arg0_2._tmpData.fire_fx_loop_type = 0
	arg0_2._tmpData.attack_attribute = var3_0.WeaponDamageAttr.AIR
	arg0_2._tmpData.attack_attribute_ratio = 100
	arg0_2._tmpData.expose = 0
	arg0_2._fireFXFlag = arg0_2._tmpData.fire_fx_loop_type
	arg0_2._preCastInfo = {}
	arg0_2._convertedBulletVelocity = var2_0.ConvertBulletSpeed(var5_0.GetBulletTmpDataFromID(arg0_2._tmpData.bullet_ID[1]).velocity)
	arg0_2._bulletList = arg0_2._tmpData.bullet_ID

	arg0_2:ShiftBarrage(arg0_2._tmpData.barrage_ID)
end

function var10_0.AppendCrewUnit(arg0_3, arg1_3)
	local var0_3 = arg1_3:GetFleetRangeAntiAirList()

	if #var0_3 > 0 then
		arg0_3._currentState = var10_0.STATE_READY
		arg0_3._crewUnitList[arg1_3] = var0_3

		arg0_3:flush()
	end
end

function var10_0.RemoveCrewUnit(arg0_4, arg1_4)
	if arg0_4._crewUnitList[arg1_4] then
		if arg1_4 == arg0_4._host then
			arg0_4._host:DetachFleetRangeAAWeapon()
		end

		arg0_4._crewUnitList[arg1_4] = nil

		arg0_4:flush()
	end
end

function var10_0.FlushCrewUnit(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetFleetRangeAntiAirList()

	if #var0_5 <= 0 then
		arg0_5:RemoveCrewUnit(arg1_5)
	elseif arg0_5._crewUnitList[arg1_5] == nil then
		arg0_5:AppendCrewUnit(arg1_5)
	else
		arg0_5._crewUnitList[arg1_5] = var0_5

		arg0_5:flush()
	end
end

function var10_0.Spawn(arg0_6, arg1_6, arg2_6)
	local var0_6
	local var1_6 = arg0_6:getAimPoint(arg2_6)
	local var2_6 = arg0_6._dataProxy:CreateBulletUnit(arg1_6, arg0_6._host, arg0_6, var1_6)

	arg0_6:setBulletSkin(var2_6, arg1_6)
	arg0_6:TriggerBuffWhenSpawn(var2_6)

	return var2_6
end

function var10_0.getAimPoint(arg0_7, arg1_7)
	local var0_7

	if target then
		local var1_7 = arg1_7:GetPosition()

		var0_7 = Vector3(var1_7.x + arg0_7._aimOffset, 0, var1_7.z)
	else
		local var2_7 = arg0_7:GetHost():GetPosition()
		local var3_7 = var2_7.z
		local var4_7 = var2_7.x + arg0_7._maxRangeSqr * arg0_7._hostIFF + arg0_7._aimOffset

		var0_7 = Vector3(var4_7, 0, var3_7)
	end

	return var0_7
end

function var10_0.GetCrewUnitList(arg0_8)
	return arg0_8._crewUnitList
end

function var10_0.GetRange(arg0_9)
	return arg0_9._range
end

function var10_0.GetAttackAngle(arg0_10)
	return arg0_10._aimAngle
end

function var10_0.GetReloadTime(arg0_11)
	return arg0_11._interval
end

function var10_0.flush(arg0_12)
	arg0_12._range = 0
	arg0_12._interval = 0
	arg0_12._aimAngle = 0
	arg0_12._aimOffset = 0
	arg0_12._maxRangeSqr = 0
	arg0_12._minRangeSqr = 0
	arg0_12._hitFXResIDList = {}
	arg0_12._SFXID = nil
	arg0_12._exploRange = 0

	local var0_12 = {}
	local var1_12 = 0

	for iter0_12, iter1_12 in pairs(arg0_12._crewUnitList) do
		for iter2_12, iter3_12 in ipairs(iter1_12) do
			var1_12 = var1_12 + 1
			arg0_12._interval = arg0_12._interval + iter3_12:GetReloadTime()

			local var2_12 = iter3_12:GetTemplateData()

			arg0_12._range = arg0_12._range + var2_12.range
			arg0_12._SFXID = var2_12.fire_sfx
			arg0_12._aimAngle = arg0_12._aimAngle + iter3_12:GetAttackAngle()
			arg0_12._maxRangeSqr = arg0_12._maxRangeSqr + iter3_12:GetWeaponMaxRange()
			arg0_12._minRangeSqr = arg0_12._minRangeSqr + iter3_12:GetWeaponMinRange()

			local var3_12 = var5_0.GetBulletTmpDataFromID(iter3_12:GetTemplateData().bullet_ID[1])

			arg0_12._hitFXResIDList[iter3_12] = var3_12.hit_fx
			arg0_12._exploRange = arg0_12._exploRange + var3_12.hit_type.range
			arg0_12._aimOffset = arg0_12._aimOffset + (var3_12.extra_param.aim_offset or 0)
		end

		local var4_12 = iter0_12:GetAttrByName("antiAirPower")
		local var5_12 = var2_0.AntiAirPowerWeight(var4_12)
		local var6_12 = {
			weight = var5_12,
			rst = iter0_12
		}

		var0_12[#var0_12 + 1] = var6_12
	end

	if var1_12 == 0 then
		arg0_12._currentState = var10_0.STATE_DISABLE
	else
		arg0_12:SwitchHost()

		arg0_12._maxRangeSqr = arg0_12._maxRangeSqr / var1_12
		arg0_12._minRangeSqr = arg0_12._minRangeSqr / var1_12
		arg0_12._exploRange = arg0_12._exploRange / var1_12
		arg0_12._aimAngle = arg0_12._aimAngle / var1_12
		arg0_12._aimOffset = arg0_12._aimOffset / var1_12 * arg0_12._host:GetIFF()
		arg0_12._interval = arg0_12._interval / var1_12 + 0.5
		arg0_12._weightList, arg0_12._totalWeight = var2_0.GenerateWeightList(var0_12)
	end
end

function var10_0.DoAreaSplit(arg0_13, arg1_13)
	local function var0_13(arg0_14)
		local var0_14 = {}
		local var1_14 = arg0_13._dataProxy:GetAircraftList()

		for iter0_14, iter1_14 in ipairs(arg0_14) do
			if iter1_14.Active then
				local var2_14 = var1_14[iter1_14.UID]

				if var2_14 and var2_14:IsVisitable() then
					var0_14[#var0_14 + 1] = var2_14
				end
			end
		end

		local var3_14 = var2_0.CalculateFleetAntiAirTotalDamage(arg0_13)
		local var4_14 = var2_0.GetMeteoDamageRatio(#var0_14)

		for iter2_14, iter3_14 in ipairs(var0_14) do
			local var5_14 = math.max(1, math.floor(var3_14 * var4_14[iter2_14]))
			local var6_14 = var2_0.WeightListRandom(arg0_13._weightList, arg0_13._totalWeight)

			arg0_13._dataProxy:HandleDirectDamage(iter3_14, var5_14, var6_14)
		end
	end

	for iter0_13, iter1_13 in pairs(arg0_13._crewUnitList) do
		iter0_13:TriggerBuff(var3_0.BuffEffectType.ON_ANTIAIR_FIRE_FAR, {})
		iter0_13:PlayFX(iter1_13[1]:GetTemplateData().fire_fx, true)
	end

	for iter2_13, iter3_13 in pairs(arg0_13._hitFXResIDList) do
		local var1_13 = (math.random() * 2 - 1) * arg0_13._exploRange
		local var2_13 = (math.random() * 2 - 1) * arg0_13._exploRange
		local var3_13 = arg1_13:GetPosition() + Vector3(var1_13, 10, var2_13)
		local var4_13 = var0_0.Battle.BattleFXPool.GetInstance():GetFX(iter3_13)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var4_13, var3_13, true)
	end

	arg0_13._dataProxy:SpawnColumnArea(var3_0.BulletField.AIR, arg1_13:GetIFF(), arg1_13:GetPosition(), arg0_13._exploRange, -1, var0_13)

	if RANGE_ANTI_AREA then
		local var5_13 = var0_0.Battle.BattleFXPool.GetInstance():GetFX("AlertArea")

		var5_13.transform.localScale = Vector3(arg0_13._exploRange, 1, arg0_13._exploRange)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var5_13, arg1_13:GetPosition())
	end

	arg0_13._dataProxy:RemoveBulletUnit(arg1_13:GetUniqueID())
end

function var10_0.SwitchHost(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in pairs(arg0_15._crewUnitList) do
		table.insert(var0_15, iter0_15)
	end

	table.sort(var0_15, function(arg0_16, arg1_16)
		return arg0_16:GetMainUnitIndex() < arg1_16:GetMainUnitIndex()
	end)

	local var1_15 = var0_15[1]

	if arg0_15._host == var1_15 then
		return
	end

	arg0_15:SetHostData(var1_15)
	arg0_15._host:AttachFleetRangeAAWeapon(arg0_15)
end

function var10_0.GetFilteredList(arg0_17)
	local var0_17 = arg0_17:FilterTarget()
	local var1_17 = arg0_17:FilterRange(var0_17)

	return (arg0_17:FilterAngle(var1_17))
end

function var10_0.FilterTarget(arg0_18)
	local var0_18 = arg0_18._dataProxy:GetAircraftList()
	local var1_18 = {}
	local var2_18 = arg0_18._host:GetIFF()
	local var3_18 = 1

	for iter0_18, iter1_18 in pairs(var0_18) do
		if iter1_18:GetIFF() ~= var2_18 and iter1_18:IsVisitable() then
			var1_18[var3_18] = iter1_18
			var3_18 = var3_18 + 1
		end
	end

	return var1_18
end

function var10_0.Update(arg0_19)
	if arg0_19._currentState ~= var10_0.STATE_DISABLE then
		var10_0.super.Update(arg0_19)
	end
end

function var10_0.RemovePrecastTimer(arg0_20)
	return
end

function var10_0.Dispose(arg0_21)
	var10_0.super.Dispose(arg0_21)

	arg0_21._crewUnitList = nil
	arg0_21._weightList = nil
	arg0_21._hitFXResIDList = nil
	arg0_21._SFXID = nil
end
