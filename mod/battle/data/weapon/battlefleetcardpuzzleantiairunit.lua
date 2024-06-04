ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleDataFunction
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleVariable
local var8 = class("BattleFleetCardPuzzleAntiAirUnit")

var0.Battle.BattleFleetCardPuzzleAntiAirUnit = var8
var8.__name = "BattleFleetCardPuzzleAntiAirUnit"
var8.STATE_DISABLE = "DISABLE"
var8.STATE_READY = "READY"
var8.STATE_PRECAST = "PRECAST"
var8.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var8.STATE_ATTACK = "ATTACK"
var8.STATE_OVER_HEAT = "OVER_HEAT"

function var8.Ctor(arg0, arg1)
	arg0._client = arg1

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
	arg0._crewUnitList[arg1] = true
	arg0._currentState = var8.STATE_READY

	arg0:flush()
end

function var8.RemoveCrewUnit(arg0, arg1)
	arg0._crewUnitList[arg1] = nil

	arg0:flush()
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

	local var0 = 0

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		arg0._range = arg0._range + iter0:GetTemplate().AA_range
		arg0._interval = arg0._interval + iter0:GetTemplate().AA_CD
		var0 = var0 + 1
	end

	arg0._range = arg0._range / var0
	arg0._interval = arg0._interval / var0
end

function var8.Update(arg0)
	if arg0._client:IsAAActive() and arg0._currentState == var8.STATE_READY then
		local var0 = arg0:FilterTarget()
		local var1 = arg0:FilterRange(var0)
		local var2 = arg0:CompareDistance(var1)

		if var2 then
			arg0:Fire(var2)
		end
	end
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

function var8.CompareDistance(arg0, arg1)
	local var0 = 999999
	local var1

	for iter0, iter1 in ipairs(arg1) do
		if var0 > iter1:GetPosition().x then
			var1 = iter1
			var0 = iter1:GetPosition().x
		end
	end

	return var1
end

function var8.getTrackingHost(arg0)
	return arg0._host
end

function var8.Fire(arg0, arg1)
	if arg0._currentState == arg0.DISABLE then
		return
	end

	local var0 = arg1:GetUniqueID()

	arg0._dataProxy:KillAircraft(var0)
	arg0:EnterCoolDown()
	arg0._client:ConsumeAACounter()
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

	arg0._crewUnitList = nil
	arg0._hitFXResIDList = nil
	arg0._dataProxy = nil
	arg0._SFXID = nil
end
