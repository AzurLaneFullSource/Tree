ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffLink = class("BattleBuffLink", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffLink.__name = "BattleBuffLink"

function var0_0.Battle.BattleBuffLink.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffLink.super.Ctor(arg0_1, arg1_1)
end

function var0_0.Battle.BattleBuffLink.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._target = arg0_2._tempData.arg_list.target
	arg0_2._buff_id = arg0_2._tempData.arg_list.buff_id
end

function var0_0.Battle.BattleBuffLink.Trigger(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg0_3:getTargetList(arg2_3, arg0_3._target, arg0_3._tempData.arg_list)

	if var0_3 then
		for iter0_3, iter1_3 in ipairs(var0_3) do
			local var1_3 = iter1_3:GetBuff(arg0_3._buff_id)

			if var1_3 then
				var1_3:onTrigger(arg1_3, iter1_3, arg4_3)
			end
		end
	end
end
