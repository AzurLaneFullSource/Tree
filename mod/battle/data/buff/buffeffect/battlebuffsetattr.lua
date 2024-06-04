ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffSetAttr = class("BattleBuffSetAttr", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffSetAttr.__name = "BattleBuffSetAttr"

local var1 = var0.Battle.BattleBuffSetAttr
local var2 = var0.Battle.BattleAttr

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._value = arg0._tempData.arg_list.value
end

function var1.onAttach(arg0, arg1, arg2)
	if arg0._attr == "TargetChoise" then
		var2.AddTargetSelect(arg1, arg0._value)
	else
		var2.SetCurrent(arg1, arg0._attr, arg0._value)
	end
end

function var1.onRemove(arg0, arg1, arg2)
	if arg0._attr == "TargetChoise" then
		var2.RemoveTargetSelect(arg1, arg0._value)
	else
		var2.SetCurrent(arg1, arg0._attr, 0)
	end
end
