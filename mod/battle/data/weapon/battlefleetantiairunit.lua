ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleDataFunction
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleVariable
local var8 = class("BattleFleetAntiAirUnit")

var0.Battle.BattleFleetAntiAirUnit = var8
var8.__name = "BattleFleetAntiAirUnit"
var8.STATE_DISABLE = "DISABLE"
var8.STATE_READY = "READY"
var8.STATE_PRECAST = "PRECAST"
var8.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var8.STATE_ATTACK = "ATTACK"
var8.STATE_OVER_HEAT = "OVER_HEAT"

function var8.Ctor(arg0)
	arg0:init()
end

function var8.init(arg0)
	arg0._crewUnitList = {}
	arg0._hitFXResIDList = {}
	arg0._currentState = var8.STATE_DISABLE
	arg0._dataProxy = var0.Battle.BattleDataProxy.GetInstance()
	arg0._range = 0
end

function var8.AppendCrewUnit(arg0, arg1)
	local var0 = arg1:GetFleetAntiAirList()

	if #var0 > 0 then
		arg0._currentState = var8.STATE_READY
		arg0._crewUnitList[arg1] = var0

		arg0:flush()
	end
end

function var8.RemoveCrewUnit(arg0, arg1)
	if arg0._crewUnitList[arg1] then
		arg0._crewUnitList[arg1] = nil

		arg0:flush()
	end
end

function var8.FlushCrewUnit(arg0, arg1)
	local var0 = arg1:GetFleetAntiAirList()

	if #var0 <= 0 then
		arg0:RemoveCrewUnit(arg1)
	elseif arg0._crewUnitList[arg1] == nil then
		arg0:AppendCrewUnit(arg1)
	else
		arg0._crewUnitList[arg1] = var0

		arg0:flush()
	end
end

function var8.SwitchHost(arg0, arg1)
	arg0._host = arg1
end

function var8.GetCrewUnitList(arg0)
	return arg0._crewUnitList
end

function var8.GetRange(arg0)
	return arg0._range
end

function var8.flush(arg0)
	arg0._range = 0
	arg0._interval = 0
	arg0._hitFXResIDList = {}
	arg0._SFXID = nil

	local var0 = {}
	local var1 = 0

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		for iter2, iter3 in ipairs(iter1) do
			var1 = var1 + 1
			arg0._interval = arg0._interval + iter3:GetReloadTime()

			local var2 = iter3:GetTemplateData()

			arg0._range = arg0._range + var2.range
			arg0._hitFXResIDList[iter3] = var0.Battle.BattleDataFunction.GetBulletTmpDataFromID(var2.bullet_ID[1]).hit_fx
			arg0._SFXID = var2.fire_sfx
		end

		local var3 = iter0:GetAttrByName("antiAirPower")
		local var4 = var2.AntiAirPowerWeight(var3)
		local var5 = {
			weight = var4,
			rst = iter0
		}

		var0[#var0 + 1] = var5
	end

	if var1 == 0 then
		arg0._currentState = var8.STATE_DISABLE

		if arg0._precastTimer then
			arg0:RemovePrecastTimer()
		end
	else
		arg0._range = arg0._range / var1
		arg0._interval = arg0._interval / var1 + 0.5
		arg0._weightList, arg0._totalWeight = var2.GenerateWeightList(var0)
	end
end

function var8.Update(arg0)
	if arg0._currentState == var8.STATE_READY then
		local var0 = arg0:FilterTarget()

		if #arg0:FilterRange(var0) > 0 then
			arg0:AddPreCastTimer()
		end
	end
end

function var8.AddPreCastTimer(arg0)
	local function var0()
		arg0:RemovePrecastTimer()
		arg0:Fire()
	end

	arg0._currentState = var8.STATE_PRECAST
	arg0._precastTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 0, var4.AntiAirConfig.Precast_duration, var0, true)
end

function var8.RemovePrecastTimer(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._precastTimer)

	arg0._precastTimer = nil
end

function var8.FilterTarget(arg0)
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

function var8.FilterRange(arg0, arg1)
	for iter0 = #arg1, 1, -1 do
		if arg0:IsOutOfRange(arg1[iter0]) then
			table.remove(arg1, iter0)
		end
	end

	return arg1
end

function var8.IsOutOfRange(arg0, arg1)
	return arg0:getTrackingHost():GetDistance(arg1) > arg0._range
end

function var8.getTrackingHost(arg0)
	return arg0._host
end

function var8.Fire(arg0)
	if arg0._currentState == arg0.DISABLE then
		return
	end

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

	arg0._dataProxy:SpawnColumnArea(var3.AOEField.AIR, arg0._host:GetIFF(), arg0._host:GetPosition(), arg0._range * 2, -1, var0)
	arg0:EnterCoolDown()

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		iter0:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_ANTIAIR_FIRE_NEAR, {})
		iter0:PlayFX(iter1[1]:GetTemplateData().fire_fx, true)
	end

	for iter2, iter3 in pairs(arg0._hitFXResIDList) do
		local var1 = (math.random() * 2 - 1) * arg0._range
		local var2 = (math.random() * 2 - 1) * arg0._range
		local var3 = arg0._host:GetPosition() + Vector3(var1, 10, var2)
		local var4 = var0.Battle.BattleFXPool.GetInstance():GetFX(iter3)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var4, var3, true)
	end

	var0.Battle.PlayBattleSFX(arg0._SFXID)
end

function var8.EnterCoolDown(arg0)
	arg0._currentState = arg0.STATE_OVER_HEAT

	arg0:AddCDTimer(arg0._interval)
end

function var8.GetCurrentState(arg0)
	return arg0._currentState
end

function var8.AddCDTimer(arg0, arg1)
	local function var0()
		arg0._currentState = arg0.STATE_READY

		arg0:RemoveCDTimer()
	end

	arg0:RemoveCDTimer()

	arg0._cdTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponTimer", -1, arg1, var0, true)
end

function var8.RemoveCDTimer(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._cdTimer)

	arg0._cdTimer = nil
end

function var8.Dispose(arg0)
	arg0:RemoveCDTimer()
	arg0:RemovePrecastTimer()

	arg0._crewUnitList = nil
	arg0._weightList = nil
	arg0._hitFXResIDList = nil
	arg0._dataProxy = nil
	arg0._SFXID = nil
end
