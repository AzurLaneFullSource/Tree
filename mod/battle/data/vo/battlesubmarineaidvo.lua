ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleSubmarineAidVO = class("BattleSubmarineAidVO", var0_0.Battle.BattlePlayerWeaponVO)
var0_0.Battle.BattleSubmarineAidVO.__name = "BattleSubmarineAidVO"

local var2_0 = var0_0.Battle.BattleSubmarineAidVO

var2_0.GCD = var1_0.AirAssistCFG.GCD

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1, var2_0.GCD)
end

function var2_0.SetUseable(arg0_2, arg1_2)
	arg0_2._useable = arg1_2
	arg0_2._current = arg1_2 and 1 or 0
	arg0_2._max = 1

	arg0_2:DispatchOverLoadChange()
	arg0_2:DispatchCountChange()
end

function var2_0.GetUseable(arg0_3)
	return arg0_3._useable
end

function var2_0.IsOverLoad(arg0_4)
	return arg0_4._current < arg0_4._max or arg0_4._count < 1
end

function var2_0.Cast(arg0_5)
	arg0_5._count = arg0_5._count - 1

	arg0_5:resetCurrent()
	arg0_5:DispatchOverLoadChange()
	arg0_5:DispatchCountChange()
end
