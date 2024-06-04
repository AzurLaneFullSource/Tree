ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffShield = class("BattleBuffShield", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffShield.__name = "BattleBuffShield"

local var1 = var0.Battle.BattleBuffShield

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectAttachData(arg0)
	return arg0._shield
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._number = var0.number or 0
	arg0._maxHPRatio = var0.maxHPRatio or 0
	arg0._casterMaxHPRatio = var0.casterMaxHPRatio or 0
	arg0._shield = arg0:CalcNumber(arg1)
end

function var1.onStack(arg0, arg1, arg2)
	arg0._shield = arg0:CalcNumber(arg1)
end

function var1.onTakeDamage(arg0, arg1, arg2, arg3)
	if arg0:damageCheck(arg3) then
		local var0 = arg3.damage

		arg0._shield = arg0._shield - var0

		if arg0._shield > 0 then
			arg3.damage = 0
		else
			arg3.damage = -arg0._shield

			arg2:SetToCancel()
		end
	end
end

function var1.CalcNumber(arg0, arg1)
	local var0, var1 = arg1:GetHP()
	local var2, var3 = arg0._caster:GetHP()
	local var4 = var1 * arg0._maxHPRatio + arg0._number + arg0._casterMaxHPRatio * var3

	return math.max(0, math.floor(var4))
end
