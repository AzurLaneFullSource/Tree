ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffHealingSteal = class("BattleBuffHealingSteal", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffHealingSteal.__name = "BattleBuffHealingSteal"

local var1_0 = var0_0.Battle.BattleBuffHealingSteal

var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_LINK

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._stealRate = var0_2.stealingRate or 1
	arg0_2._absorbRate = var0_2.arsorbRate or 1
end

function var1_0.onTakeHealing(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3.damage
	local var1_3 = arg2_3:GetCaster()

	if var1_3 and var1_3:IsAlive() and var1_3 ~= arg1_3 then
		local var2_3 = math.ceil(var0_3 * arg0_3._stealRate)

		arg3_3.damage = var0_3 - var2_3

		local var3_3 = var1_3:GetAttrByName("healingRate")
		local var4_3 = var2_3 * arg0_3._absorbRate
		local var5_3 = math.ceil(var3_3 * var4_3)
		local var6_3 = {
			isMiss = false,
			isCri = false,
			isHeal = true,
			isShare = false
		}

		var1_3:UpdateHP(var5_3, var6_3)
	end
end
