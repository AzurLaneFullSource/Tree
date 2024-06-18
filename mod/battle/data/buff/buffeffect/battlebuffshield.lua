ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffShield = class("BattleBuffShield", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffShield.__name = "BattleBuffShield"

local var1_0 = var0_0.Battle.BattleBuffShield

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectAttachData(arg0_2)
	return arg0_2._shield
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3._tempData.arg_list

	arg0_3._number = var0_3.number or 0
	arg0_3._maxHPRatio = var0_3.maxHPRatio or 0
	arg0_3._casterMaxHPRatio = var0_3.casterMaxHPRatio or 0
	arg0_3._shield = arg0_3:CalcNumber(arg1_3)
end

function var1_0.onStack(arg0_4, arg1_4, arg2_4)
	arg0_4._shield = arg0_4:CalcNumber(arg1_4)
end

function var1_0.onTakeDamage(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg0_5:damageCheck(arg3_5) then
		local var0_5 = arg3_5.damage

		arg0_5._shield = arg0_5._shield - var0_5

		if arg0_5._shield > 0 then
			arg3_5.damage = 0
		else
			arg3_5.damage = -arg0_5._shield

			arg2_5:SetToCancel()
		end
	end
end

function var1_0.CalcNumber(arg0_6, arg1_6)
	local var0_6, var1_6 = arg1_6:GetHP()
	local var2_6, var3_6 = arg0_6._caster:GetHP()
	local var4_6 = var1_6 * arg0_6._maxHPRatio + arg0_6._number + arg0_6._casterMaxHPRatio * var3_6

	return math.max(0, math.floor(var4_6))
end
