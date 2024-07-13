ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffLockHealth = class("BattleBuffLockHealth", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffLockHealth.__name = "BattleBuffLockHealth"

local var1_0 = var0_0.Battle.BattleBuffLockHealth

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._rate = arg0_2._tempData.arg_list.rate
	arg0_2._threshold = arg0_2._tempData.arg_list.value
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	if arg0_3._rate then
		arg0_3._threshold = math.floor(arg1_3:GetMaxHP() * arg0_3._rate)
	end
end

function var1_0.onTrigger(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg1_4:GetCurrentHP()

	if var0_4 <= arg0_4._threshold then
		arg3_4.damage = 0
	elseif var0_4 - arg3_4.damage < arg0_4._threshold then
		arg3_4.damage = var0_4 - arg0_4._threshold
	end
end
