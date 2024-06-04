ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffWorldVariable = class("BattleBuffWorldVariable", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffWorldVariable.__name = "BattleBuffWorldVariable"

local var1 = var0.Battle.BattleBuffWorldVariable

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._variable = arg0._tempData.arg_list.variable
	arg0._key = arg0._tempData.arg_list.key
	arg0._number = arg0._tempData.arg_list.number
	arg0._resetNumber = arg0._tempData.arg_list.resetNumber
	arg0._speedFactorName = "buff_" .. arg0._tempData.id
end

function var1.onAttach(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleVariable

	if arg0._key then
		var0.AppendIFFFactor(arg0._key, arg0._speedFactorName, arg0._number)
	else
		var0.AppendMapFactor(arg0._speedFactorName, arg0._number)
	end
end

function var1.onRemove(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleVariable

	if arg0._key then
		var0.RemoveIFFFactor(arg0._key, arg0._speedFactorName)
	else
		var0.RemoveMapFactor(arg0._speedFactorName)
	end
end
