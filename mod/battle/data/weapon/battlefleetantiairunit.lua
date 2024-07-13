ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleVariable
local var8_0 = class("BattleFleetAntiAirUnit")

var0_0.Battle.BattleFleetAntiAirUnit = var8_0
var8_0.__name = "BattleFleetAntiAirUnit"
var8_0.STATE_DISABLE = "DISABLE"
var8_0.STATE_READY = "READY"
var8_0.STATE_PRECAST = "PRECAST"
var8_0.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var8_0.STATE_ATTACK = "ATTACK"
var8_0.STATE_OVER_HEAT = "OVER_HEAT"

function var8_0.Ctor(arg0_1)
	arg0_1:init()
end

function var8_0.init(arg0_2)
	arg0_2._crewUnitList = {}
	arg0_2._hitFXResIDList = {}
	arg0_2._currentState = var8_0.STATE_DISABLE
	arg0_2._dataProxy = var0_0.Battle.BattleDataProxy.GetInstance()
	arg0_2._range = 0
end

function var8_0.AppendCrewUnit(arg0_3, arg1_3)
	local var0_3 = arg1_3:GetFleetAntiAirList()

	if #var0_3 > 0 then
		arg0_3._currentState = var8_0.STATE_READY
		arg0_3._crewUnitList[arg1_3] = var0_3

		arg0_3:flush()
	end
end

function var8_0.RemoveCrewUnit(arg0_4, arg1_4)
	if arg0_4._crewUnitList[arg1_4] then
		arg0_4._crewUnitList[arg1_4] = nil

		arg0_4:flush()
	end
end

function var8_0.FlushCrewUnit(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetFleetAntiAirList()

	if #var0_5 <= 0 then
		arg0_5:RemoveCrewUnit(arg1_5)
	elseif arg0_5._crewUnitList[arg1_5] == nil then
		arg0_5:AppendCrewUnit(arg1_5)
	else
		arg0_5._crewUnitList[arg1_5] = var0_5

		arg0_5:flush()
	end
end

function var8_0.SwitchHost(arg0_6, arg1_6)
	arg0_6._host = arg1_6
end

function var8_0.GetCrewUnitList(arg0_7)
	return arg0_7._crewUnitList
end

function var8_0.GetRange(arg0_8)
	return arg0_8._range
end

function var8_0.flush(arg0_9)
	arg0_9._range = 0
	arg0_9._interval = 0
	arg0_9._hitFXResIDList = {}
	arg0_9._SFXID = nil

	local var0_9 = {}
	local var1_9 = 0

	for iter0_9, iter1_9 in pairs(arg0_9._crewUnitList) do
		for iter2_9, iter3_9 in ipairs(iter1_9) do
			var1_9 = var1_9 + 1
			arg0_9._interval = arg0_9._interval + iter3_9:GetReloadTime()

			local var2_9 = iter3_9:GetTemplateData()

			arg0_9._range = arg0_9._range + var2_9.range
			arg0_9._hitFXResIDList[iter3_9] = var0_0.Battle.BattleDataFunction.GetBulletTmpDataFromID(var2_9.bullet_ID[1]).hit_fx
			arg0_9._SFXID = var2_9.fire_sfx
		end

		local var3_9 = iter0_9:GetAttrByName("antiAirPower")
		local var4_9 = var2_0.AntiAirPowerWeight(var3_9)
		local var5_9 = {
			weight = var4_9,
			rst = iter0_9
		}

		var0_9[#var0_9 + 1] = var5_9
	end

	if var1_9 == 0 then
		arg0_9._currentState = var8_0.STATE_DISABLE

		if arg0_9._precastTimer then
			arg0_9:RemovePrecastTimer()
		end
	else
		arg0_9._range = arg0_9._range / var1_9
		arg0_9._interval = arg0_9._interval / var1_9 + 0.5
		arg0_9._weightList, arg0_9._totalWeight = var2_0.GenerateWeightList(var0_9)
	end
end

function var8_0.Update(arg0_10)
	if arg0_10._currentState == var8_0.STATE_READY then
		local var0_10 = arg0_10:FilterTarget()

		if #arg0_10:FilterRange(var0_10) > 0 then
			arg0_10:AddPreCastTimer()
		end
	end
end

function var8_0.AddPreCastTimer(arg0_11)
	local function var0_11()
		arg0_11:RemovePrecastTimer()
		arg0_11:Fire()
	end

	arg0_11._currentState = var8_0.STATE_PRECAST
	arg0_11._precastTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 0, var4_0.AntiAirConfig.Precast_duration, var0_11, true)
end

function var8_0.RemovePrecastTimer(arg0_13)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_13._precastTimer)

	arg0_13._precastTimer = nil
end

function var8_0.FilterTarget(arg0_14)
	local var0_14 = arg0_14._dataProxy:GetAircraftList()
	local var1_14 = {}
	local var2_14 = arg0_14._host:GetIFF()
	local var3_14 = 1

	for iter0_14, iter1_14 in pairs(var0_14) do
		if iter1_14:GetIFF() ~= var2_14 and iter1_14:IsVisitable() then
			var1_14[var3_14] = iter1_14
			var3_14 = var3_14 + 1
		end
	end

	return var1_14
end

function var8_0.FilterRange(arg0_15, arg1_15)
	for iter0_15 = #arg1_15, 1, -1 do
		if arg0_15:IsOutOfRange(arg1_15[iter0_15]) then
			table.remove(arg1_15, iter0_15)
		end
	end

	return arg1_15
end

function var8_0.IsOutOfRange(arg0_16, arg1_16)
	return arg0_16:getTrackingHost():GetDistance(arg1_16) > arg0_16._range
end

function var8_0.getTrackingHost(arg0_17)
	return arg0_17._host
end

function var8_0.Fire(arg0_18)
	if arg0_18._currentState == arg0_18.DISABLE then
		return
	end

	local function var0_18(arg0_19)
		local var0_19 = {}
		local var1_19 = arg0_18._dataProxy:GetAircraftList()

		for iter0_19, iter1_19 in ipairs(arg0_19) do
			if iter1_19.Active then
				local var2_19 = var1_19[iter1_19.UID]

				if var2_19 and var2_19:IsVisitable() then
					var0_19[#var0_19 + 1] = var2_19
				end
			end
		end

		local var3_19 = var2_0.CalculateFleetAntiAirTotalDamage(arg0_18)
		local var4_19 = var2_0.GetMeteoDamageRatio(#var0_19)

		for iter2_19, iter3_19 in ipairs(var0_19) do
			local var5_19 = math.max(1, math.floor(var3_19 * var4_19[iter2_19]))
			local var6_19 = var2_0.WeightListRandom(arg0_18._weightList, arg0_18._totalWeight)

			arg0_18._dataProxy:HandleDirectDamage(iter3_19, var5_19, var6_19)
		end
	end

	arg0_18._dataProxy:SpawnColumnArea(var3_0.AOEField.AIR, arg0_18._host:GetIFF(), arg0_18._host:GetPosition(), arg0_18._range * 2, -1, var0_18)
	arg0_18:EnterCoolDown()

	for iter0_18, iter1_18 in pairs(arg0_18._crewUnitList) do
		iter0_18:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_ANTIAIR_FIRE_NEAR, {})
		iter0_18:PlayFX(iter1_18[1]:GetTemplateData().fire_fx, true)
	end

	for iter2_18, iter3_18 in pairs(arg0_18._hitFXResIDList) do
		local var1_18 = (math.random() * 2 - 1) * arg0_18._range
		local var2_18 = (math.random() * 2 - 1) * arg0_18._range
		local var3_18 = arg0_18._host:GetPosition() + Vector3(var1_18, 10, var2_18)
		local var4_18 = var0_0.Battle.BattleFXPool.GetInstance():GetFX(iter3_18)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var4_18, var3_18, true)
	end

	var0_0.Battle.PlayBattleSFX(arg0_18._SFXID)
end

function var8_0.EnterCoolDown(arg0_20)
	arg0_20._currentState = arg0_20.STATE_OVER_HEAT

	arg0_20:AddCDTimer(arg0_20._interval)
end

function var8_0.GetCurrentState(arg0_21)
	return arg0_21._currentState
end

function var8_0.AddCDTimer(arg0_22, arg1_22)
	local function var0_22()
		arg0_22._currentState = arg0_22.STATE_READY

		arg0_22:RemoveCDTimer()
	end

	arg0_22:RemoveCDTimer()

	arg0_22._cdTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponTimer", -1, arg1_22, var0_22, true)
end

function var8_0.RemoveCDTimer(arg0_24)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_24._cdTimer)

	arg0_24._cdTimer = nil
end

function var8_0.Dispose(arg0_25)
	arg0_25:RemoveCDTimer()
	arg0_25:RemovePrecastTimer()

	arg0_25._crewUnitList = nil
	arg0_25._weightList = nil
	arg0_25._hitFXResIDList = nil
	arg0_25._dataProxy = nil
	arg0_25._SFXID = nil
end
