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
local var9_0 = var4_0.VAN_SONAR_PROPERTY
local var10_0 = class("BattleFleetStaticSonar")

var0_0.Battle.BattleFleetStaticSonar = var10_0
var10_0.__name = "BattleFleetStaticSonar"
var10_0.STATE_DISABLE = "DISABLE"
var10_0.STATE_READY = "READY"

function var10_0.Ctor(arg0_1, arg1_1)
	arg0_1:init()

	arg0_1._fleetVO = arg1_1
end

function var10_0.GetCurrentState(arg0_2)
	return arg0_2._currentState
end

function var10_0.Dispose(arg0_3)
	arg0_3._detectedList = nil
	arg0_3._crewUnitList = nil
	arg0_3._host = nil
end

function var10_0.init(arg0_4)
	arg0_4._crewUnitList = {}
	arg0_4._detectedList = {}
	arg0_4._skillDiameter = 0
	arg0_4._radius = 0
	arg0_4._diameter = 0
end

function var10_0.AppendExtraSkillRange(arg0_5, arg1_5)
	arg0_5._skillDiameter = arg0_5._skillDiameter + arg1_5

	if arg0_5._radius ~= 0 then
		arg0_5._radius = arg0_5._radius + arg1_5 * 0.5
	end
end

function var10_0.AppendCrewUnit(arg0_6, arg1_6)
	arg0_6._crewUnitList[arg1_6:GetUniqueID()] = arg1_6

	arg0_6:flush()
end

function var10_0.RemoveCrewUnit(arg0_7, arg1_7)
	local var0_7 = arg1_7:GetUniqueID()

	if arg0_7._crewUnitList[var0_7] then
		arg0_7._crewUnitList[var0_7] = nil

		arg0_7:updateSonarState()

		if arg0_7._currentState == var10_0.STATE_DISABLE then
			arg0_7:Undetect()
		end
	end
end

function var10_0.SwitchHost(arg0_8, arg1_8)
	arg0_8._host = arg1_8
end

function var10_0.GetRange(arg0_9)
	return arg0_9._diameter
end

function var10_0.flush(arg0_10)
	arg0_10._diameter = 0

	local var0_10, var1_10, var2_10 = arg0_10:calcSonarRange()

	if var0_10 ~= 0 then
		arg0_10._diameter = var0_10 + var2_10 + var1_10
		arg0_10._radius = arg0_10._diameter * 0.5
	end

	arg0_10:updateSonarState()
end

function var10_0.calcSonarRange(arg0_11)
	local var0_11 = 0
	local var1_11 = 0
	local var2_11 = 0

	for iter0_11, iter1_11 in pairs(arg0_11._crewUnitList) do
		local var3_11, var4_11, var5_11 = arg0_11.getSonarProperty(iter1_11)

		if var3_11 > 0 then
			var0_11 = math.max(var3_11, var0_11)
		end

		var1_11 = var1_11 + var4_11
		var2_11 = var2_11 + var5_11
	end

	local var6_11 = var4_0.MAIN_SONAR_PROPERTY
	local var7_11 = var2_11 / var6_11.a
	local var8_11 = Mathf.Clamp(var7_11, var6_11.minRange, var6_11.maxRange)

	return var0_11, var8_11, var1_11
end

function var10_0.updateSonarState(arg0_12)
	local var0_12 = 0

	for iter0_12, iter1_12 in pairs(arg0_12._crewUnitList) do
		if arg0_12.getSonarProperty(iter1_12) > 0 then
			var0_12 = var0_12 + 1
		end
	end

	if var0_12 > 0 then
		arg0_12._currentState = var10_0.STATE_READY
	else
		arg0_12._currentState = var10_0.STATE_DISABLE
	end

	local var1_12 = var0_0.Event.New(var0_0.Battle.BattleEvent.SONAR_UPDATE)

	arg0_12._fleetVO:DispatchEvent(var1_12)
end

function var10_0.getSonarProperty(arg0_13)
	local var0_13 = arg0_13:GetTemplate().type
	local var1_13 = var9_0[var0_13]
	local var2_13 = 0

	if var1_13 then
		local var3_13 = arg0_13:GetAttrByName("baseAntiSubPower") / var1_13.a - var1_13.b

		var2_13 = Mathf.Clamp(var3_13, var1_13.minRange, var1_13.maxRange)
	end

	local var4_13 = arg0_13:GetAttrByName("sonarRange")
	local var5_13 = 0

	if table.contains(TeamType.MainShipType, var0_13) then
		var5_13 = arg0_13:GetAttrByName("baseAntiSubPower")
	end

	return var2_13, var4_13, var5_13
end

function var10_0.Update(arg0_14, arg1_14)
	if arg0_14._currentState ~= var10_0.STATE_DISABLE then
		arg0_14._fleetVO:DispatchSonarScan()
		arg0_14:updateDetectedList()
	end
end

function var10_0.Undetect(arg0_15)
	local var0_15 = arg0_15._detectedList

	for iter0_15, iter1_15 in ipairs(var0_15) do
		if iter1_15:IsAlive() then
			iter1_15:Undetected()
		end
	end

	arg0_15._detectedList = {}
end

function var10_0.updateDetectedList(arg0_16)
	local var0_16 = var8_0.LegalTarget(arg0_16._host)
	local var1_16 = var8_0.TargetDiveState(arg0_16._host, {
		diveState = var3_0.OXY_STATE.DIVE
	}, var0_16)
	local var2_16 = arg0_16:FilterRange(var1_16)

	for iter0_16, iter1_16 in ipairs(var1_16) do
		local var3_16 = table.contains(var2_16, iter1_16)
		local var4_16 = table.contains(arg0_16._detectedList, iter1_16)

		if var4_16 then
			if not var3_16 then
				iter1_16:Undetected()
			end
		elseif not var4_16 and var3_16 then
			iter1_16:Detected()
		end
	end

	arg0_16._detectedList = var2_16
end

function var10_0.FilterTarget(arg0_17)
	local var0_17 = var8_0.LegalTarget(arg0_17._host)
	local var1_17 = var8_0.TargetDiveState(arg0_17._host, {
		diveState = var3_0.OXY_STATE.DIVE
	}, var0_17)

	return (arg0_17:FilterRange(var1_17))
end

function var10_0.FilterRange(arg0_18, arg1_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(arg1_18) do
		if not arg0_18:isOutOfRange(iter1_18) then
			table.insert(var0_18, iter1_18)
		end
	end

	return var0_18
end

function var10_0.isOutOfRange(arg0_19, arg1_19)
	return arg0_19._host:GetDistance(arg1_19) > arg0_19._radius
end

function var10_0.GetTotalRangeDetail(arg0_20)
	local var0_20, var1_20, var2_20 = arg0_20:calcSonarRange()

	return var0_20, var1_20, var2_20, arg0_20._skillDiameter
end
