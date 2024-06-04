ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffCancelBuff", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffCancelBuff = var1
var1.__name = "BattleBuffCancelBuff"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._buff_id = arg0._tempData.arg_list.buff_id
	arg0._count = arg0._tempData.arg_list.count or 99999
	arg0._delay = arg0._tempData.arg_list.delay
end

function var1.onTrigger(arg0, arg1, arg2, arg3)
	var1.super.onTrigger(arg0, arg1, arg2, attach)

	arg0._count = arg0._count - 1

	if arg0._count <= 0 then
		arg2:SetToCancel(arg0._delay)
	end
end
