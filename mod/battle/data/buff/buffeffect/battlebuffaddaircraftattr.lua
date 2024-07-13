ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffAddAircraftAttr = class("BattleBuffAddAircraftAttr", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffAddAircraftAttr.__name = "BattleBuffAddAircraftAttr"

local var1_0 = var0_0.Battle.BattleBuffAddAircraftAttr

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._attr = arg0_2._tempData.arg_list.attr
	arg0_2._number = arg0_2._tempData.arg_list.number
	arg0_2._numberBase = arg0_2._number
end

function var1_0.onStack(arg0_3, arg1_3, arg2_3)
	arg0_3._number = arg0_3._numberBase * arg2_3._stack
end

function var1_0.onAircraftCreate(arg0_4, arg1_4, arg2_4, arg3_4)
	if not arg0_4:equipIndexRequire(arg3_4.equipIndex) then
		return
	end

	arg0_4:calcAircraftAttr(arg3_4.aircraft)
end

function var1_0.calcAircraftAttr(arg0_5, arg1_5)
	var0_0.Battle.BattleAttr.Increase(arg1_5, arg0_5._attr, arg0_5._number)
end
