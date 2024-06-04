ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleDataFunction
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleVariable
local var8 = var0.Battle.BattleTargetChoise
local var9 = class("BattleFleetSonar")

var0.Battle.BattleFleetSonar = var9
var9.__name = "BattleFleetSonar"
var9.STATE_DISABLE = "DISABLE"
var9.STATE_OVER_HEAT = "OVER_HEAT"
var9.STATE_READY = "READY"
var9.STATE_DETECTING = "DETECTING"

function var9.Ctor(arg0, arg1)
	arg0:init()

	arg0._fleetVO = arg1
end

function var9.Dispose(arg0)
	arg0._detectedList = nil
	arg0._crewUnitList = nil
	arg0._host = nil
end

function var9.init(arg0)
	arg0._crewUnitList = {}
	arg0._detectedList = {}
end

function var9.AppendCrewUnit(arg0, arg1)
	arg0._crewUnitList[arg1:GetUniqueID()] = arg1

	arg0:flush()

	arg0._currentState = var9.STATE_READY
end

function var9.RemoveCrewUnit(arg0, arg1)
	local var0 = arg1:GetUniqueID()

	if arg0._crewUnitList[var0] then
		arg0._crewUnitList[var0] = nil

		arg0:flush()
	end
end

function var9.SwitchHost(arg0, arg1)
	arg0._host = arg1
end

function var9.GetRange(arg0)
	return arg0._range
end

function var9.flush(arg0)
	arg0._range, arg0._interval, arg0._duration = 0, 0, 0

	local var0 = 0
	local var1 = 0
	local var2 = 0
	local var3 = 0

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		local var4 = iter1:GetAttrByName("sonarRange")

		if var4 > 0 then
			var0 = var0 + 1

			local var5 = iter1:GetAttrByName("sonarInterval")
			local var6 = iter1:GetAttrByName("sonarDuration")

			var1 = math.max(var1, var4)
			var2 = var5 + var2
			var3 = math.max(var3, var6)
		end
	end

	if var0 > 0 then
		arg0._range = var1
		arg0._interval = var2 / var0 * (1 - (var0 - 1) * var4.SONAR_INTERVAL_K)
		arg0._duration = var3 * (1 + (var0 - 1) * var4.SONAR_DURATION_K)
	else
		arg0:Undetect()

		arg0._currentState = var9.STATE_DISABLE
	end
end

function var9.Update(arg0, arg1)
	if arg0._currentState == var9.STATE_DISABLE then
		-- block empty
	elseif arg0._currentState == var9.STATE_READY then
		arg0:Detect()
	elseif arg0._currentState == var9.STATE_OVER_HEAT then
		if arg1 > arg0._interval + arg0._overheatStartTime then
			arg0:Ready()
		end
	elseif arg0._currentState == var9.STATE_DETECTING then
		if arg1 > arg0._snoarStartTime + arg0._duration then
			arg0:Overheat()
		else
			arg0:updateDetectedList()
		end
	end
end

function var9.Detect(arg0)
	arg0._snoarStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0._currentState = var9.STATE_DETECTING

	local var0 = arg0:FilterTarget()

	for iter0, iter1 in ipairs(var0) do
		iter1:Detected(10)
	end

	arg0._detectedList = var0

	arg0._fleetVO:DispatchSonarScan()
end

function var9.Undetect(arg0)
	arg0._snoarStartTime = nil
	arg0._currentState = var9.STATE_OVER_HEAT

	local var0 = arg0._detectedList

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsAlive() then
			iter1:Undetected()
		end
	end

	arg0._detectedList = {}
end

function var9.updateDetectedList(arg0)
	local var0 = arg0:FilterTarget()
	local var1 = #arg0._detectedList

	while var1 > 0 do
		local var2 = arg0._detectedList[var1]

		if not var2:IsAlive() then
			table.remove(arg0._detectedList, var1)
		elseif not table.contains(var0, var2) then
			var2:Undetected()
			table.remove(arg0._detectedList, var1)
		end

		var1 = var1 - 1
	end
end

function var9.Overheat(arg0)
	arg0:Undetect()

	arg0._overheatStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var9.Ready(arg0)
	arg0._overheatStartTime = nil
	arg0._currentState = var9.STATE_READY
end

function var9.FilterTarget(arg0)
	local var0 = var8.LegalTarget(arg0._host)
	local var1 = var8.TargetDiveState(arg0._host, {
		diveState = var3.OXY_STATE.DIVE
	}, var0)

	return (arg0:FilterRange(var1))
end

function var9.FilterRange(arg0, arg1)
	for iter0 = #arg1, 1, -1 do
		if arg0:isOutOfRange(arg1[iter0]) then
			table.remove(arg1, iter0)
		end
	end

	return arg1
end

function var9.isOutOfRange(arg0, arg1)
	return arg0._host:GetDistance(arg1) > arg0._range
end
