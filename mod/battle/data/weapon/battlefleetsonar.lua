ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleVariable
local var8_0 = var0_0.Battle.BattleTargetChoise
local var9_0 = class("BattleFleetSonar")

var0_0.Battle.BattleFleetSonar = var9_0
var9_0.__name = "BattleFleetSonar"
var9_0.STATE_DISABLE = "DISABLE"
var9_0.STATE_OVER_HEAT = "OVER_HEAT"
var9_0.STATE_READY = "READY"
var9_0.STATE_DETECTING = "DETECTING"

function var9_0.Ctor(arg0_1, arg1_1)
	arg0_1:init()

	arg0_1._fleetVO = arg1_1
end

function var9_0.Dispose(arg0_2)
	arg0_2._detectedList = nil
	arg0_2._crewUnitList = nil
	arg0_2._host = nil
end

function var9_0.init(arg0_3)
	arg0_3._crewUnitList = {}
	arg0_3._detectedList = {}
end

function var9_0.AppendCrewUnit(arg0_4, arg1_4)
	arg0_4._crewUnitList[arg1_4:GetUniqueID()] = arg1_4

	arg0_4:flush()

	arg0_4._currentState = var9_0.STATE_READY
end

function var9_0.RemoveCrewUnit(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetUniqueID()

	if arg0_5._crewUnitList[var0_5] then
		arg0_5._crewUnitList[var0_5] = nil

		arg0_5:flush()
	end
end

function var9_0.SwitchHost(arg0_6, arg1_6)
	arg0_6._host = arg1_6
end

function var9_0.GetRange(arg0_7)
	return arg0_7._range
end

function var9_0.flush(arg0_8)
	arg0_8._range, arg0_8._interval, arg0_8._duration = 0, 0, 0

	local var0_8 = 0
	local var1_8 = 0
	local var2_8 = 0
	local var3_8 = 0

	for iter0_8, iter1_8 in pairs(arg0_8._crewUnitList) do
		local var4_8 = iter1_8:GetAttrByName("sonarRange")

		if var4_8 > 0 then
			var0_8 = var0_8 + 1

			local var5_8 = iter1_8:GetAttrByName("sonarInterval")
			local var6_8 = iter1_8:GetAttrByName("sonarDuration")

			var1_8 = math.max(var1_8, var4_8)
			var2_8 = var5_8 + var2_8
			var3_8 = math.max(var3_8, var6_8)
		end
	end

	if var0_8 > 0 then
		arg0_8._range = var1_8
		arg0_8._interval = var2_8 / var0_8 * (1 - (var0_8 - 1) * var4_0.SONAR_INTERVAL_K)
		arg0_8._duration = var3_8 * (1 + (var0_8 - 1) * var4_0.SONAR_DURATION_K)
	else
		arg0_8:Undetect()

		arg0_8._currentState = var9_0.STATE_DISABLE
	end
end

function var9_0.Update(arg0_9, arg1_9)
	if arg0_9._currentState == var9_0.STATE_DISABLE then
		-- block empty
	elseif arg0_9._currentState == var9_0.STATE_READY then
		arg0_9:Detect()
	elseif arg0_9._currentState == var9_0.STATE_OVER_HEAT then
		if arg1_9 > arg0_9._interval + arg0_9._overheatStartTime then
			arg0_9:Ready()
		end
	elseif arg0_9._currentState == var9_0.STATE_DETECTING then
		if arg1_9 > arg0_9._snoarStartTime + arg0_9._duration then
			arg0_9:Overheat()
		else
			arg0_9:updateDetectedList()
		end
	end
end

function var9_0.Detect(arg0_10)
	arg0_10._snoarStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_10._currentState = var9_0.STATE_DETECTING

	local var0_10 = arg0_10:FilterTarget()

	for iter0_10, iter1_10 in ipairs(var0_10) do
		iter1_10:Detected(10)
	end

	arg0_10._detectedList = var0_10

	arg0_10._fleetVO:DispatchSonarScan()
end

function var9_0.Undetect(arg0_11)
	arg0_11._snoarStartTime = nil
	arg0_11._currentState = var9_0.STATE_OVER_HEAT

	local var0_11 = arg0_11._detectedList

	for iter0_11, iter1_11 in ipairs(var0_11) do
		if iter1_11:IsAlive() then
			iter1_11:Undetected()
		end
	end

	arg0_11._detectedList = {}
end

function var9_0.updateDetectedList(arg0_12)
	local var0_12 = arg0_12:FilterTarget()
	local var1_12 = #arg0_12._detectedList

	while var1_12 > 0 do
		local var2_12 = arg0_12._detectedList[var1_12]

		if not var2_12:IsAlive() then
			table.remove(arg0_12._detectedList, var1_12)
		elseif not table.contains(var0_12, var2_12) then
			var2_12:Undetected()
			table.remove(arg0_12._detectedList, var1_12)
		end

		var1_12 = var1_12 - 1
	end
end

function var9_0.Overheat(arg0_13)
	arg0_13:Undetect()

	arg0_13._overheatStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var9_0.Ready(arg0_14)
	arg0_14._overheatStartTime = nil
	arg0_14._currentState = var9_0.STATE_READY
end

function var9_0.FilterTarget(arg0_15)
	local var0_15 = var8_0.LegalTarget(arg0_15._host)
	local var1_15 = var8_0.TargetDiveState(arg0_15._host, {
		diveState = var3_0.OXY_STATE.DIVE
	}, var0_15)

	return (arg0_15:FilterRange(var1_15))
end

function var9_0.FilterRange(arg0_16, arg1_16)
	for iter0_16 = #arg1_16, 1, -1 do
		if arg0_16:isOutOfRange(arg1_16[iter0_16]) then
			table.remove(arg1_16, iter0_16)
		end
	end

	return arg1_16
end

function var9_0.isOutOfRange(arg0_17, arg1_17)
	return arg0_17._host:GetDistance(arg1_17) > arg0_17._range
end
