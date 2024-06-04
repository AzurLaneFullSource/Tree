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
local var9 = class("BattleIndieSonar")

var0.Battle.BattleIndieSonar = var9
var9.__name = "BattleIndieSonar"

function var9.Ctor(arg0, arg1, arg2, arg3)
	arg0._fleetVO = arg1
	arg0._range = 180
	arg0._duration = arg3
end

function var9.SwitchHost(arg0, arg1)
	arg0._host = arg1
end

function var9.Detect(arg0)
	arg0._snoarStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	local var0 = arg0:FilterTarget()

	for iter0, iter1 in ipairs(var0) do
		iter1:Detected(arg0._duration)
	end

	arg0._detectedList = var0

	arg0._fleetVO:DispatchSonarScan(true)
end

function var9.Update(arg0, arg1)
	if arg1 > arg0._snoarStartTime + arg0._duration then
		arg0._detectedList = nil

		arg0._fleetVO:RemoveIndieSonar(arg0)
	end
end

function var9.FilterTarget(arg0)
	local var0 = var8.LegalTarget(arg0._host)

	return (var8.TargetDiveState(arg0._host, {
		diveState = var3.OXY_STATE.DIVE
	}, var0))
end
