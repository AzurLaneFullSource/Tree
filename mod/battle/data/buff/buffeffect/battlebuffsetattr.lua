ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffSetAttr = class("BattleBuffSetAttr", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffSetAttr.__name = "BattleBuffSetAttr"

local var1_0 = var0_0.Battle.BattleBuffSetAttr
local var2_0 = var0_0.Battle.BattleAttr

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._attr = arg0_2._tempData.arg_list.attr
	arg0_2._value = arg0_2._tempData.arg_list.value
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	if arg0_3._attr == "TargetChoise" then
		var2_0.AddTargetSelect(arg1_3, arg0_3._value)
	else
		var2_0.SetCurrent(arg1_3, arg0_3._attr, arg0_3._value)
	end
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	if arg0_4._attr == "TargetChoise" then
		var2_0.RemoveTargetSelect(arg1_4, arg0_4._value)
	else
		var2_0.SetCurrent(arg1_4, arg0_4._attr, 0)
	end
end
