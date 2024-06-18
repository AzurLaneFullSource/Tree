ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffCleanse", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffCleanse = var1_0
var1_0.__name = "BattleBuffCleanse"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._buffIDList = arg0_2._tempData.arg_list.buff_id_list
	arg0_2._check_target = arg0_2._tempData.arg_list.check_target
	arg0_2._minTargetNumber = arg0_2._tempData.arg_list.minTargetNumber or 0
	arg0_2._maxTargetNumber = arg0_2._tempData.arg_list.maxTargetNumber or 10000
end

function var1_0.onTrigger(arg0_3, arg1_3, arg2_3, arg3_3)
	var1_0.super.onTrigger(arg0_3, arg1_3, arg2_3, arg3_3)

	if arg0_3._check_target then
		local var0_3 = #arg0_3:getTargetList(arg1_3, arg0_3._check_target, arg0_3._tempData.arg_list, arg3_3)

		if var0_3 >= arg0_3._minTargetNumber and var0_3 <= arg0_3._maxTargetNumber then
			for iter0_3, iter1_3 in ipairs(arg0_3._buffIDList) do
				arg1_3:RemoveBuff(iter1_3)
			end
		end
	else
		for iter2_3, iter3_3 in ipairs(arg0_3._buffIDList) do
			arg1_3:RemoveBuff(iter3_3)
		end
	end
end
