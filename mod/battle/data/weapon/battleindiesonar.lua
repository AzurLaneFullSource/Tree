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
local var9_0 = class("BattleIndieSonar")

var0_0.Battle.BattleIndieSonar = var9_0
var9_0.__name = "BattleIndieSonar"

function var9_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._fleetVO = arg1_1
	arg0_1._range = 180
	arg0_1._duration = arg3_1
end

function var9_0.SwitchHost(arg0_2, arg1_2)
	arg0_2._host = arg1_2
end

function var9_0.Detect(arg0_3)
	arg0_3._snoarStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	local var0_3 = arg0_3:FilterTarget()

	for iter0_3, iter1_3 in ipairs(var0_3) do
		iter1_3:Detected(arg0_3._duration)
	end

	arg0_3._detectedList = var0_3

	arg0_3._fleetVO:DispatchSonarScan(true)
end

function var9_0.Update(arg0_4, arg1_4)
	if arg1_4 > arg0_4._snoarStartTime + arg0_4._duration then
		arg0_4._detectedList = nil

		arg0_4._fleetVO:RemoveIndieSonar(arg0_4)
	end
end

function var9_0.FilterTarget(arg0_5)
	local var0_5 = var8_0.LegalTarget(arg0_5._host)

	return (var8_0.TargetDiveState(arg0_5._host, {
		diveState = var3_0.OXY_STATE.DIVE
	}, var0_5))
end
