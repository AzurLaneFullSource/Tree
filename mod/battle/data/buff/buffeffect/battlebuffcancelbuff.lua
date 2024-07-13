ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffCancelBuff", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffCancelBuff = var1_0
var1_0.__name = "BattleBuffCancelBuff"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._buff_id = arg0_2._tempData.arg_list.buff_id
	arg0_2._count = arg0_2._tempData.arg_list.count or 99999
	arg0_2._delay = arg0_2._tempData.arg_list.delay
end

function var1_0.onTrigger(arg0_3, arg1_3, arg2_3, arg3_3)
	var1_0.super.onTrigger(arg0_3, arg1_3, arg2_3, attach)

	arg0_3._count = arg0_3._count - 1

	if arg0_3._count <= 0 then
		arg2_3:SetToCancel(arg0_3._delay)
	end
end
