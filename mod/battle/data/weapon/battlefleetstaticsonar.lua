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
local var9 = var4.VAN_SONAR_PROPERTY
local var10 = class("BattleFleetStaticSonar")

var0.Battle.BattleFleetStaticSonar = var10
var10.__name = "BattleFleetStaticSonar"
var10.STATE_DISABLE = "DISABLE"
var10.STATE_READY = "READY"

function var10.Ctor(arg0, arg1)
	arg0:init()

	arg0._fleetVO = arg1
end

function var10.GetCurrentState(arg0)
	return arg0._currentState
end

function var10.Dispose(arg0)
	arg0._detectedList = nil
	arg0._crewUnitList = nil
	arg0._host = nil
end

function var10.init(arg0)
	arg0._crewUnitList = {}
	arg0._detectedList = {}
	arg0._skillDiameter = 0
	arg0._radius = 0
	arg0._diameter = 0
end

function var10.AppendExtraSkillRange(arg0, arg1)
	arg0._skillDiameter = arg0._skillDiameter + arg1

	if arg0._radius ~= 0 then
		arg0._radius = arg0._radius + arg1 * 0.5
	end
end

function var10.AppendCrewUnit(arg0, arg1)
	arg0._crewUnitList[arg1:GetUniqueID()] = arg1

	arg0:flush()
end

function var10.RemoveCrewUnit(arg0, arg1)
	local var0 = arg1:GetUniqueID()

	if arg0._crewUnitList[var0] then
		arg0._crewUnitList[var0] = nil

		arg0:updateSonarState()

		if arg0._currentState == var10.STATE_DISABLE then
			arg0:Undetect()
		end
	end
end

function var10.SwitchHost(arg0, arg1)
	arg0._host = arg1
end

function var10.GetRange(arg0)
	return arg0._diameter
end

function var10.flush(arg0)
	arg0._diameter = 0

	local var0, var1, var2 = arg0:calcSonarRange()

	if var0 ~= 0 then
		arg0._diameter = var0 + var2 + var1
		arg0._radius = arg0._diameter * 0.5
	end

	arg0:updateSonarState()
end

function var10.calcSonarRange(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = 0

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		local var3, var4, var5 = arg0.getSonarProperty(iter1)

		if var3 > 0 then
			var0 = math.max(var3, var0)
		end

		var1 = var1 + var4
		var2 = var2 + var5
	end

	local var6 = var4.MAIN_SONAR_PROPERTY
	local var7 = var2 / var6.a
	local var8 = Mathf.Clamp(var7, var6.minRange, var6.maxRange)

	return var0, var8, var1
end

function var10.updateSonarState(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0._crewUnitList) do
		if arg0.getSonarProperty(iter1) > 0 then
			var0 = var0 + 1
		end
	end

	if var0 > 0 then
		arg0._currentState = var10.STATE_READY
	else
		arg0._currentState = var10.STATE_DISABLE
	end

	local var1 = var0.Event.New(var0.Battle.BattleEvent.SONAR_UPDATE)

	arg0._fleetVO:DispatchEvent(var1)
end

function var10.getSonarProperty(arg0)
	local var0 = arg0:GetTemplate().type
	local var1 = var9[var0]
	local var2 = 0

	if var1 then
		local var3 = arg0:GetAttrByName("baseAntiSubPower") / var1.a - var1.b

		var2 = Mathf.Clamp(var3, var1.minRange, var1.maxRange)
	end

	local var4 = arg0:GetAttrByName("sonarRange")
	local var5 = 0

	if table.contains(TeamType.MainShipType, var0) then
		var5 = arg0:GetAttrByName("baseAntiSubPower")
	end

	return var2, var4, var5
end

function var10.Update(arg0, arg1)
	if arg0._currentState ~= var10.STATE_DISABLE then
		arg0._fleetVO:DispatchSonarScan()
		arg0:updateDetectedList()
	end
end

function var10.Undetect(arg0)
	local var0 = arg0._detectedList

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsAlive() then
			iter1:Undetected()
		end
	end

	arg0._detectedList = {}
end

function var10.updateDetectedList(arg0)
	local var0 = var8.LegalTarget(arg0._host)
	local var1 = var8.TargetDiveState(arg0._host, {
		diveState = var3.OXY_STATE.DIVE
	}, var0)
	local var2 = arg0:FilterRange(var1)

	for iter0, iter1 in ipairs(var1) do
		local var3 = table.contains(var2, iter1)
		local var4 = table.contains(arg0._detectedList, iter1)

		if var4 then
			if not var3 then
				iter1:Undetected()
			end
		elseif not var4 and var3 then
			iter1:Detected()
		end
	end

	arg0._detectedList = var2
end

function var10.FilterTarget(arg0)
	local var0 = var8.LegalTarget(arg0._host)
	local var1 = var8.TargetDiveState(arg0._host, {
		diveState = var3.OXY_STATE.DIVE
	}, var0)

	return (arg0:FilterRange(var1))
end

function var10.FilterRange(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		if not arg0:isOutOfRange(iter1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var10.isOutOfRange(arg0, arg1)
	return arg0._host:GetDistance(arg1) > arg0._radius
end

function var10.GetTotalRangeDetail(arg0)
	local var0, var1, var2 = arg0:calcSonarRange()

	return var0, var1, var2, arg0._skillDiameter
end
