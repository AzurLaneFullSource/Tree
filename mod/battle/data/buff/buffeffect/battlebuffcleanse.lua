ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffCleanse", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffCleanse = var1
var1.__name = "BattleBuffCleanse"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._buffIDList = arg0._tempData.arg_list.buff_id_list
	arg0._check_target = arg0._tempData.arg_list.check_target
	arg0._minTargetNumber = arg0._tempData.arg_list.minTargetNumber or 0
	arg0._maxTargetNumber = arg0._tempData.arg_list.maxTargetNumber or 10000
end

function var1.onTrigger(arg0, arg1, arg2, arg3)
	var1.super.onTrigger(arg0, arg1, arg2, arg3)

	if arg0._check_target then
		local var0 = #arg0:getTargetList(arg1, arg0._check_target, arg0._tempData.arg_list, arg3)

		if var0 >= arg0._minTargetNumber and var0 <= arg0._maxTargetNumber then
			for iter0, iter1 in ipairs(arg0._buffIDList) do
				arg1:RemoveBuff(iter1)
			end
		end
	else
		for iter2, iter3 in ipairs(arg0._buffIDList) do
			arg1:RemoveBuff(iter3)
		end
	end
end
