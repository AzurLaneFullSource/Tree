ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffLink = class("BattleBuffLink", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffLink.__name = "BattleBuffLink"

function var0.Battle.BattleBuffLink.Ctor(arg0, arg1)
	var0.Battle.BattleBuffLink.super.Ctor(arg0, arg1)
end

function var0.Battle.BattleBuffLink.SetArgs(arg0, arg1, arg2)
	arg0._target = arg0._tempData.arg_list.target
	arg0._buff_id = arg0._tempData.arg_list.buff_id
end

function var0.Battle.BattleBuffLink.Trigger(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:getTargetList(arg2, arg0._target, arg0._tempData.arg_list)

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			local var1 = iter1:GetBuff(arg0._buff_id)

			if var1 then
				var1:onTrigger(arg1, iter1, arg4)
			end
		end
	end
end
