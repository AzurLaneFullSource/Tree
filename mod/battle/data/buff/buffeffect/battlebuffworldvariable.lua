ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffWorldVariable = class("BattleBuffWorldVariable", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffWorldVariable.__name = "BattleBuffWorldVariable"

local var1_0 = var0_0.Battle.BattleBuffWorldVariable

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._variable = arg0_2._tempData.arg_list.variable
	arg0_2._key = arg0_2._tempData.arg_list.key
	arg0_2._number = arg0_2._tempData.arg_list.number
	arg0_2._resetNumber = arg0_2._tempData.arg_list.resetNumber
	arg0_2._speedFactorName = "buff_" .. arg0_2._tempData.id
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	local var0_3 = var0_0.Battle.BattleVariable

	if arg0_3._key then
		var0_3.AppendIFFFactor(arg0_3._key, arg0_3._speedFactorName, arg0_3._number)
	else
		var0_3.AppendMapFactor(arg0_3._speedFactorName, arg0_3._number)
	end
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	local var0_4 = var0_0.Battle.BattleVariable

	if arg0_4._key then
		var0_4.RemoveIFFFactor(arg0_4._key, arg0_4._speedFactorName)
	else
		var0_4.RemoveMapFactor(arg0_4._speedFactorName)
	end
end
