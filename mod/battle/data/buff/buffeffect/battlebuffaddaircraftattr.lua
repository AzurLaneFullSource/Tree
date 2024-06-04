ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffAddAircraftAttr = class("BattleBuffAddAircraftAttr", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffAddAircraftAttr.__name = "BattleBuffAddAircraftAttr"

local var1 = var0.Battle.BattleBuffAddAircraftAttr

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._number = arg0._tempData.arg_list.number
	arg0._numberBase = arg0._number
end

function var1.onStack(arg0, arg1, arg2)
	arg0._number = arg0._numberBase * arg2._stack
end

function var1.onAircraftCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:calcAircraftAttr(arg3.aircraft)
end

function var1.calcAircraftAttr(arg0, arg1)
	var0.Battle.BattleAttr.Increase(arg1, arg0._attr, arg0._number)
end
