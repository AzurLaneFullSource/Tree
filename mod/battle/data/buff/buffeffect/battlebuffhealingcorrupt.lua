ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffHealingCorrupt = class("BattleBuffHealingCorrupt", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffHealingCorrupt.__name = "BattleBuffHealingCorrupt"

local var1_0 = var0_0.Battle.BattleBuffHealingCorrupt

var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_LINK

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._corruptRate = var0_2.corruptRate or 1
	arg0_2._damageRate = var0_2.damageRate or 1
	arg0_2._proxy = var0_0.Battle.BattleDataProxy.GetInstance()
end

function var1_0.onTakeHealing(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg3_3.incorrupt then
		return
	end

	local var0_3 = arg3_3.damage
	local var1_3 = math.ceil(var0_3 * arg0_3._corruptRate)

	arg3_3.damage = var0_3 - var1_3

	local var2_3 = math.ceil(var1_3 * arg0_3._damageRate)

	arg0_3._proxy:HandleDirectDamage(arg1_3, var2_3)
end
