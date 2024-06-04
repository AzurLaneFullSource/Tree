ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleSubmarineAidVO = class("BattleSubmarineAidVO", var0.Battle.BattlePlayerWeaponVO)
var0.Battle.BattleSubmarineAidVO.__name = "BattleSubmarineAidVO"

local var2 = var0.Battle.BattleSubmarineAidVO

var2.GCD = var1.AirAssistCFG.GCD

function var2.Ctor(arg0)
	var2.super.Ctor(arg0, var2.GCD)
end

function var2.SetUseable(arg0, arg1)
	arg0._useable = arg1
	arg0._current = arg1 and 1 or 0
	arg0._max = 1

	arg0:DispatchOverLoadChange()
	arg0:DispatchCountChange()
end

function var2.GetUseable(arg0)
	return arg0._useable
end

function var2.IsOverLoad(arg0)
	return arg0._current < arg0._max or arg0._count < 1
end

function var2.Cast(arg0)
	arg0._count = arg0._count - 1

	arg0:resetCurrent()
	arg0:DispatchOverLoadChange()
	arg0:DispatchCountChange()
end
