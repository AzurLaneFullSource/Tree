ys = ys or {}

local var0 = ys

var0.Battle.BattleFleetBuffFixSubRefLine = class("BattleFleetBuffFixSubRefLine", var0.Battle.BattleFleetBuffEffect)
var0.Battle.BattleFleetBuffFixSubRefLine.__name = "BattleFleetBuffFixSubRefLine"

local var1 = var0.Battle.BattleFleetBuffFixSubRefLine

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.onAttach(arg0, arg1, arg2)
	arg1:FixSubRefLine(arg0._tempData.arg_list.line)
end

function var1.onRemove(arg0, arg1, arg2)
	arg1:FixSubRefLine()
end
