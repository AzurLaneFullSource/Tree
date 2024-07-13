ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleFleetBuffFixSubRefLine = class("BattleFleetBuffFixSubRefLine", var0_0.Battle.BattleFleetBuffEffect)
var0_0.Battle.BattleFleetBuffFixSubRefLine.__name = "BattleFleetBuffFixSubRefLine"

local var1_0 = var0_0.Battle.BattleFleetBuffFixSubRefLine

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.onAttach(arg0_2, arg1_2, arg2_2)
	arg1_2:FixSubRefLine(arg0_2._tempData.arg_list.line)
end

function var1_0.onRemove(arg0_3, arg1_3, arg2_3)
	arg1_3:FixSubRefLine()
end
