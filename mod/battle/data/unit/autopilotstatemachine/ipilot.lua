ys = ys or {}

local var0 = ys
local var1 = class("IPilot")

var0.Battle.IPilot = var1
var1.__name = "IPilot"

function var1.Ctor(arg0, arg1, arg2)
	arg0._index = arg1
	arg0._pilot = arg2
end

function var1.SetParameter(arg0, arg1, arg2)
	arg0._paramList = arg1
	arg0._valve = arg1.valve or var0.Battle.AutoPilot.PILOT_VALVE
	arg0._toIndex = arg2
	arg0._duration = arg1.duration or -1
end

function var1.GetIndex(arg0)
	return arg0._index
end

function var1.GetToIndex(arg0)
	return arg0._toIndex
end

function var1.Active(arg0, arg1)
	arg0._startTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var1.IsExpired(arg0)
	if arg0._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0._startTime > arg0._duration then
		return true
	else
		return false
	end
end

function var1.GetDirection(arg0, arg1)
	return
end

function var1.Finish(arg0)
	arg0._pilot:NextStep()
end
