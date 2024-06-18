ys = ys or {}

local var0_0 = ys
local var1_0 = class("IPilot")

var0_0.Battle.IPilot = var1_0
var1_0.__name = "IPilot"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._index = arg1_1
	arg0_1._pilot = arg2_1
end

function var1_0.SetParameter(arg0_2, arg1_2, arg2_2)
	arg0_2._paramList = arg1_2
	arg0_2._valve = arg1_2.valve or var0_0.Battle.AutoPilot.PILOT_VALVE
	arg0_2._toIndex = arg2_2
	arg0_2._duration = arg1_2.duration or -1
end

function var1_0.GetIndex(arg0_3)
	return arg0_3._index
end

function var1_0.GetToIndex(arg0_4)
	return arg0_4._toIndex
end

function var1_0.Active(arg0_5, arg1_5)
	arg0_5._startTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var1_0.IsExpired(arg0_6)
	if arg0_6._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0_6._startTime > arg0_6._duration then
		return true
	else
		return false
	end
end

function var1_0.GetDirection(arg0_7, arg1_7)
	return
end

function var1_0.Finish(arg0_8)
	arg0_8._pilot:NextStep()
end
