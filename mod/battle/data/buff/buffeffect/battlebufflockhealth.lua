ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffLockHealth = class("BattleBuffLockHealth", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffLockHealth.__name = "BattleBuffLockHealth"

local var1 = var0.Battle.BattleBuffLockHealth

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._rate = arg0._tempData.arg_list.rate
	arg0._threshold = arg0._tempData.arg_list.value
end

function var1.onAttach(arg0, arg1, arg2)
	if arg0._rate then
		arg0._threshold = math.floor(arg1:GetMaxHP() * arg0._rate)
	end
end

function var1.onTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetCurrentHP()

	if var0 <= arg0._threshold then
		arg3.damage = 0
	elseif var0 - arg3.damage < arg0._threshold then
		arg3.damage = var0 - arg0._threshold
	end
end
