ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffHealingCorrupt = class("BattleBuffHealingCorrupt", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffHealingCorrupt.__name = "BattleBuffHealingCorrupt"

local var1 = var0.Battle.BattleBuffHealingCorrupt

var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_LINK

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._corruptRate = var0.corruptRate or 1
	arg0._damageRate = var0.damageRate or 1
end

function var1.onTakeHealing(arg0, arg1, arg2, arg3)
	if arg3.incorrupt then
		return
	end

	local var0 = arg3.damage
	local var1 = math.ceil(var0 * arg0._corruptRate)

	arg3.damage = var0 - var1

	local var2 = math.ceil(var1 * arg0._damageRate) * -1
	local var3 = {
		isMiss = false,
		isCri = false,
		isHeal = false,
		isShare = false
	}

	arg1:UpdateHP(var2, var3)
end
