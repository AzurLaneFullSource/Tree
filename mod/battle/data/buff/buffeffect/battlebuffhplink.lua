ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffHPLink = class("BattleBuffHPLink", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffHPLink.__name = "BattleBuffHPLink"

local var1_0 = var0_0.Battle.BattleBuffHPLink

var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_LINK

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._number = var0_2.number or 0
	arg0_2._absorbRate = var0_2.absorb or 0
	arg0_2._restoreRate = 0
	arg0_2._sumDMG = 0

	if var0_2.restoreRatio then
		arg0_2._restoreRate = var0_2.restoreRatio * 0.0001
	end
end

function var1_0.onTakeDamage(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg3_3.isShare then
		return
	end

	local var0_3 = arg3_3.damage
	local var1_3 = arg2_3:GetCaster()

	if var1_3 and var1_3:IsAlive() and var1_3 ~= arg1_3 then
		arg3_3.damage = math.ceil(var0_3 * arg0_3._number)

		local var2_3 = math.ceil((var0_3 - arg3_3.damage) * (1 - arg0_3._absorbRate))

		if var2_3 > 0 then
			arg0_3._sumDMG = arg0_3._sumDMG + var2_3

			local var3_3 = {
				isMiss = false,
				isCri = false,
				isHeal = false,
				isShare = true
			}

			var1_3:UpdateHP(-var2_3, var3_3)

			if arg3_3.damageSrc then
				local var4_3 = arg3_3.damageSrc

				var0_0.Battle.BattleDataProxy.GetInstance():DamageStatistics(var4_3, arg1_3:GetAttrByName("id"), -var2_3)
				var0_0.Battle.BattleDataProxy.GetInstance():DamageStatistics(var4_3, var1_3:GetAttrByName("id"), var2_3)
			end
		end
	end
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg2_4:GetCaster()

	if var0_4 and var0_4:IsAlive() and arg0_4._restoreRate > 0 and var0_4 ~= arg1_4 then
		local var1_4 = var0_4:GetAttrByName("healingRate")
		local var2_4 = math.floor(arg0_4._sumDMG * arg0_4._restoreRate * var1_4)

		if var2_4 ~= 0 then
			local var3_4 = {
				isMiss = false,
				isCri = false,
				isHeal = true
			}

			var0_4:UpdateHP(var2_4, var3_4)
		end
	end
end
