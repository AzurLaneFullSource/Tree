ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffRegisterWaveFlags", var0.Battle.BattleBuffEffect)

var1.__name = "BattleBuffRegisterWaveFlags"
var0.Battle.BattleBuffRegisterWaveFlags = var1

function var1.SetArgs(arg0, arg1, arg2)
	arg0._flags = arg0._tempData.arg_list.flags
end

function var1.onTrigger(arg0, arg1, arg2, arg3)
	var1.super.onTrigger(arg0, arg1, arg2, arg3)

	local var0 = var0.Battle.BattleDataProxy.GetInstance()

	for iter0, iter1 in ipairs(arg0._flags) do
		var0:AddWaveFlag(iter1)
	end
end
