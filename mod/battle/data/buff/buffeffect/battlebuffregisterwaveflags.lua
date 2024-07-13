ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffRegisterWaveFlags", var0_0.Battle.BattleBuffEffect)

var1_0.__name = "BattleBuffRegisterWaveFlags"
var0_0.Battle.BattleBuffRegisterWaveFlags = var1_0

function var1_0.SetArgs(arg0_1, arg1_1, arg2_1)
	arg0_1._flags = arg0_1._tempData.arg_list.flags
end

function var1_0.onTrigger(arg0_2, arg1_2, arg2_2, arg3_2)
	var1_0.super.onTrigger(arg0_2, arg1_2, arg2_2, arg3_2)

	local var0_2 = var0_0.Battle.BattleDataProxy.GetInstance()

	for iter0_2, iter1_2 in ipairs(arg0_2._flags) do
		var0_2:AddWaveFlag(iter1_2)
	end
end
