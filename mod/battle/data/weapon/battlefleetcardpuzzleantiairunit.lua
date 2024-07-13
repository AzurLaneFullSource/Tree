ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleVariable
local var8_0 = class("BattleFleetCardPuzzleAntiAirUnit")

var0_0.Battle.BattleFleetCardPuzzleAntiAirUnit = var8_0
var8_0.__name = "BattleFleetCardPuzzleAntiAirUnit"
var8_0.STATE_DISABLE = "DISABLE"
var8_0.STATE_READY = "READY"
var8_0.STATE_PRECAST = "PRECAST"
var8_0.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var8_0.STATE_ATTACK = "ATTACK"
var8_0.STATE_OVER_HEAT = "OVER_HEAT"

function var8_0.Ctor(arg0_1, arg1_1)
	arg0_1._client = arg1_1

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
	arg0_3._crewUnitList[arg1_3] = true
	arg0_3._currentState = var8_0.STATE_READY

	arg0_3:flush()
end

function var8_0.RemoveCrewUnit(arg0_4, arg1_4)
	arg0_4._crewUnitList[arg1_4] = nil

	arg0_4:flush()
end

function var8_0.SwitchHost(arg0_5, arg1_5)
	arg0_5._host = arg1_5
end

function var8_0.GetCrewUnitList(arg0_6)
	return arg0_6._crewUnitList
end

function var8_0.GetRange(arg0_7)
	return arg0_7._range
end

function var8_0.flush(arg0_8)
	arg0_8._range = 0
	arg0_8._interval = 0

	local var0_8 = 0

	for iter0_8, iter1_8 in pairs(arg0_8._crewUnitList) do
		arg0_8._range = arg0_8._range + iter0_8:GetTemplate().AA_range
		arg0_8._interval = arg0_8._interval + iter0_8:GetTemplate().AA_CD
		var0_8 = var0_8 + 1
	end

	arg0_8._range = arg0_8._range / var0_8
	arg0_8._interval = arg0_8._interval / var0_8
end

function var8_0.Update(arg0_9)
	if arg0_9._client:IsAAActive() and arg0_9._currentState == var8_0.STATE_READY then
		local var0_9 = arg0_9:FilterTarget()
		local var1_9 = arg0_9:FilterRange(var0_9)
		local var2_9 = arg0_9:CompareDistance(var1_9)

		if var2_9 then
			arg0_9:Fire(var2_9)
		end
	end
end

function var8_0.FilterTarget(arg0_10)
	local var0_10 = arg0_10._dataProxy:GetAircraftList()
	local var1_10 = {}
	local var2_10 = arg0_10._host:GetIFF()
	local var3_10 = 1

	for iter0_10, iter1_10 in pairs(var0_10) do
		if iter1_10:GetIFF() ~= var2_10 and iter1_10:IsVisitable() then
			var1_10[var3_10] = iter1_10
			var3_10 = var3_10 + 1
		end
	end

	return var1_10
end

function var8_0.FilterRange(arg0_11, arg1_11)
	for iter0_11 = #arg1_11, 1, -1 do
		if arg0_11:IsOutOfRange(arg1_11[iter0_11]) then
			table.remove(arg1_11, iter0_11)
		end
	end

	return arg1_11
end

function var8_0.IsOutOfRange(arg0_12, arg1_12)
	return arg0_12:getTrackingHost():GetDistance(arg1_12) > arg0_12._range
end

function var8_0.CompareDistance(arg0_13, arg1_13)
	local var0_13 = 999999
	local var1_13

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		if var0_13 > iter1_13:GetPosition().x then
			var1_13 = iter1_13
			var0_13 = iter1_13:GetPosition().x
		end
	end

	return var1_13
end

function var8_0.getTrackingHost(arg0_14)
	return arg0_14._host
end

function var8_0.Fire(arg0_15, arg1_15)
	if arg0_15._currentState == arg0_15.DISABLE then
		return
	end

	local var0_15 = arg1_15:GetUniqueID()

	arg0_15._dataProxy:KillAircraft(var0_15)
	arg0_15:EnterCoolDown()
	arg0_15._client:ConsumeAACounter()
end

function var8_0.EnterCoolDown(arg0_16)
	arg0_16._currentState = arg0_16.STATE_OVER_HEAT

	arg0_16:AddCDTimer(arg0_16._interval)
end

function var8_0.GetCurrentState(arg0_17)
	return arg0_17._currentState
end

function var8_0.AddCDTimer(arg0_18, arg1_18)
	local function var0_18()
		arg0_18._currentState = arg0_18.STATE_READY

		arg0_18:RemoveCDTimer()
	end

	arg0_18:RemoveCDTimer()

	arg0_18._cdTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponTimer", -1, arg1_18, var0_18, true)
end

function var8_0.RemoveCDTimer(arg0_20)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_20._cdTimer)

	arg0_20._cdTimer = nil
end

function var8_0.Dispose(arg0_21)
	arg0_21:RemoveCDTimer()

	arg0_21._crewUnitList = nil
	arg0_21._hitFXResIDList = nil
	arg0_21._dataProxy = nil
	arg0_21._SFXID = nil
end
