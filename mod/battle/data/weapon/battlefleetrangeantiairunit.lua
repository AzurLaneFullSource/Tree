ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleDataFunction
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleVariable
local var8 = var3.WeaponSearchType
local var9 = var3.WeaponSuppressType
local var10 = class("BattleFleetRangeAntiAirUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleFleetRangeAntiAirUnit = var10
var10.__name = "BattleFleetRangeAntiAirUnit"

function var10.Ctor(arg0)
	var10.super.Ctor(arg0)

	arg0._currentState = var10.STATE_DISABLE

	arg0:init()
end

function var10.init(arg0)
	arg0._crewUnitList = {}
	arg0._hitFXResIDList = {}
	arg0._range = 0
	arg0._majorEmitterList = {}
	arg0._GCD = 0.5
	arg0._tmpData = {}
	arg0._tmpData.bullet_ID = {
		var4.AntiAirConfig.RangeBulletID
	}
	arg0._tmpData.barrage_ID = {
		var4.AntiAirConfig.RangeBarrageID
	}
	arg0._tmpData.aim_type = var3.WeaponAimType.AIM
	arg0._tmpData.axis_angle = 0
	arg0._tmpData.search_type = var8.SECTOR
	arg0._tmpData.suppress = var9.NONE
	arg0._tmpData.queue = 0
	arg0._tmpData.action_index = ""
	arg0._tmpData.fire_sfx = "battle/cannon-air"
	arg0._tmpData.spawn_bound = var4.AntiAirConfig.RangeAntiAirBone
	arg0._tmpData.shakescreen = 0
	arg0._tmpData.fire_fx_loop_type = 0
	arg0._tmpData.attack_attribute = var3.WeaponDamageAttr.AIR
	arg0._tmpData.attack_attribute_ratio = 100
	arg0._tmpData.expose = 0
	arg0._fireFXFlag = arg0._tmpData.fire_fx_loop_type
	arg0._preCastInfo = {}
	arg0._convertedBulletVelocity = var2.ConvertBulletSpeed(var5.GetBulletTmpDataFromID(arg0._tmpData.bullet_ID[1]).velocity)
	arg0._bulletList = arg0._tmpData.bullet_ID

	arg0:ShiftBarrage(arg0._tmpData.barrage_ID)
end

function var10.AppendCrewUnit(arg0, arg1)
	local var0 = arg1:GetFleetRangeAntiAirList()

	if #var0 > 0 then
		arg0._currentState = var10.STATE_READY
		arg0._crewUnitList[arg1] = var0

		arg0:flush()
	end
end

function var10.RemoveCrewUnit(arg0, arg1)
	if arg0._crewUnitList[arg1] then
		if arg1 == arg0._host then
			arg0._host:DetachFleetRangeAAWeapon()
		end

		arg0._crewUnitList[arg1] = nil

		arg0:flush()
	end
end

function var10.FlushCrewUnit(arg0, arg1)
	local var0 = arg1:GetFleetRangeAntiAirList()

	if #var0 <= 0 then
		arg0:RemoveCrewUnit(arg1)
	elseif arg0._crewUnitList[arg1] == nil then
		arg0:AppendCrewUnit(arg1)
	else
		arg0._crewUnitList[arg1] = var0

		arg0:flush()
	end
end

function var10.Spawn(arg0, arg1, arg2)
	local var0
	local var1 = arg0:getAimPoint(arg2)
	local var2 = arg0._dataProxy:CreateBulletUnit(arg1, arg0._host, arg0, var1)

	arg0:setBulletSkin(var2, arg1)
	arg0:TriggerBuffWhenSpawn(var2)

	return var2
end

function var10.getAimPoint(arg0, arg1)
	local var0

	if target then
		local var1 = arg1:GetPosition()

		var0 = Vector3(var1.x + arg0._aimOffset, 0, var1.z)
	else
		local var2 = arg0:GetHost():GetPosition()
		local var3 = var2.z
		local var4 = var2.x + arg0._maxRangeSqr * arg0._hostIFF + arg0._aimOffset

		var0 = Vector3(var4, 0, var3)
	end

	return var0
end

function var10.GetCrewUnitList(arg0)
	return arg0._crewUnitList
end

function var10.GetRange(arg0)
	return arg0._range
end

function var10.GetAttackAngle(arg0)
	return arg0._aimAngle
end

function var10.GetReloadTime(arg0)
	return arg0._interval
end

function var10.flush(arg0)
	arg0._range = 0
	arg0._interval = 0
	arg0._aimAngle = 0
	arg0._aimOffset = 0
	arg0._maxRangeSqr = 0
	arg0._minRangeSqr = 0
	arg0._hitFXResIDList = {}
	arg0._SFXID = nil
	arg0._exploRange = 0

	local var0 = {}
	local var1 = 0

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		for iter2, iter3 in ipairs(iter1) do
			var1 = var1 + 1
			arg0._interval = arg0._interval + iter3:GetReloadTime()

			local var2 = iter3:GetTemplateData()

			arg0._range = arg0._range + var2.range
			arg0._SFXID = var2.fire_sfx
			arg0._aimAngle = arg0._aimAngle + iter3:GetAttackAngle()
			arg0._maxRangeSqr = arg0._maxRangeSqr + iter3:GetWeaponMaxRange()
			arg0._minRangeSqr = arg0._minRangeSqr + iter3:GetWeaponMinRange()

			local var3 = var5.GetBulletTmpDataFromID(iter3:GetTemplateData().bullet_ID[1])

			arg0._hitFXResIDList[iter3] = var3.hit_fx
			arg0._exploRange = arg0._exploRange + var3.hit_type.range
			arg0._aimOffset = arg0._aimOffset + (var3.extra_param.aim_offset or 0)
		end

		local var4 = iter0:GetAttrByName("antiAirPower")
		local var5 = var2.AntiAirPowerWeight(var4)
		local var6 = {
			weight = var5,
			rst = iter0
		}

		var0[#var0 + 1] = var6
	end

	if var1 == 0 then
		arg0._currentState = var10.STATE_DISABLE
	else
		arg0:SwitchHost()

		arg0._maxRangeSqr = arg0._maxRangeSqr / var1
		arg0._minRangeSqr = arg0._minRangeSqr / var1
		arg0._exploRange = arg0._exploRange / var1
		arg0._aimAngle = arg0._aimAngle / var1
		arg0._aimOffset = arg0._aimOffset / var1 * arg0._host:GetIFF()
		arg0._interval = arg0._interval / var1 + 0.5
		arg0._weightList, arg0._totalWeight = var2.GenerateWeightList(var0)
	end
end

function var10.DoAreaSplit(arg0, arg1)
	local function var0(arg0)
		local var0 = {}
		local var1 = arg0._dataProxy:GetAircraftList()

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var2 = var1[iter1.UID]

				if var2 and var2:IsVisitable() then
					var0[#var0 + 1] = var2
				end
			end
		end

		local var3 = var2.CalculateFleetAntiAirTotalDamage(arg0)
		local var4 = var2.GetMeteoDamageRatio(#var0)

		for iter2, iter3 in ipairs(var0) do
			local var5 = math.max(1, math.floor(var3 * var4[iter2]))
			local var6 = var2.WeightListRandom(arg0._weightList, arg0._totalWeight)

			arg0._dataProxy:HandleDirectDamage(iter3, var5, var6)
		end
	end

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		iter0:TriggerBuff(var3.BuffEffectType.ON_ANTIAIR_FIRE_FAR, {})
		iter0:PlayFX(iter1[1]:GetTemplateData().fire_fx, true)
	end

	for iter2, iter3 in pairs(arg0._hitFXResIDList) do
		local var1 = (math.random() * 2 - 1) * arg0._exploRange
		local var2 = (math.random() * 2 - 1) * arg0._exploRange
		local var3 = arg1:GetPosition() + Vector3(var1, 10, var2)
		local var4 = var0.Battle.BattleFXPool.GetInstance():GetFX(iter3)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var4, var3, true)
	end

	arg0._dataProxy:SpawnColumnArea(var3.BulletField.AIR, arg1:GetIFF(), arg1:GetPosition(), arg0._exploRange, -1, var0)

	if RANGE_ANTI_AREA then
		local var5 = var0.Battle.BattleFXPool.GetInstance():GetFX("AlertArea")

		var5.transform.localScale = Vector3(arg0._exploRange, 1, arg0._exploRange)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var5, arg1:GetPosition())
	end

	arg0._dataProxy:RemoveBulletUnit(arg1:GetUniqueID())
end

function var10.SwitchHost(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		table.insert(var0, iter0)
	end

	table.sort(var0, function(arg0, arg1)
		return arg0:GetMainUnitIndex() < arg1:GetMainUnitIndex()
	end)

	local var1 = var0[1]

	if arg0._host == var1 then
		return
	end

	arg0:SetHostData(var1)
	arg0._host:AttachFleetRangeAAWeapon(arg0)
end

function var10.GetFilteredList(arg0)
	local var0 = arg0:FilterTarget()
	local var1 = arg0:FilterRange(var0)

	return (arg0:FilterAngle(var1))
end

function var10.FilterTarget(arg0)
	local var0 = arg0._dataProxy:GetAircraftList()
	local var1 = {}
	local var2 = arg0._host:GetIFF()
	local var3 = 1

	for iter0, iter1 in pairs(var0) do
		if iter1:GetIFF() ~= var2 and iter1:IsVisitable() then
			var1[var3] = iter1
			var3 = var3 + 1
		end
	end

	return var1
end

function var10.Update(arg0)
	if arg0._currentState ~= var10.STATE_DISABLE then
		var10.super.Update(arg0)
	end
end

function var10.RemovePrecastTimer(arg0)
	return
end

function var10.Dispose(arg0)
	var10.super.Dispose(arg0)

	arg0._crewUnitList = nil
	arg0._weightList = nil
	arg0._hitFXResIDList = nil
	arg0._SFXID = nil
end
