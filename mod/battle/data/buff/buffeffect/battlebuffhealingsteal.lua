ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffHealingSteal = class("BattleBuffHealingSteal", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffHealingSteal.__name = "BattleBuffHealingSteal"

local var1 = var0.Battle.BattleBuffHealingSteal

var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_LINK

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._stealRate = var0.stealingRate or 1
	arg0._absorbRate = var0.arsorbRate or 1
end

function var1.onTakeHealing(arg0, arg1, arg2, arg3)
	local var0 = arg3.damage
	local var1 = arg2:GetCaster()

	if var1 and var1:IsAlive() and var1 ~= arg1 then
		local var2 = math.ceil(var0 * arg0._stealRate)

		arg3.damage = var0 - var2

		local var3 = var1:GetAttrByName("healingRate")
		local var4 = var2 * arg0._absorbRate
		local var5 = math.ceil(var3 * var4)
		local var6 = {
			isMiss = false,
			isCri = false,
			isHeal = true,
			isShare = false
		}

		var1:UpdateHP(var5, var6)
	end
end
