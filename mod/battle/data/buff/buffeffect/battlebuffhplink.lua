ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffHPLink = class("BattleBuffHPLink", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffHPLink.__name = "BattleBuffHPLink"

local var1 = var0.Battle.BattleBuffHPLink

var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_LINK

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._number = var0.number or 0
	arg0._absorbRate = var0.absorb or 0
	arg0._restoreRate = 0
	arg0._sumDMG = 0

	if var0.restoreRatio then
		arg0._restoreRate = var0.restoreRatio * 0.0001
	end
end

function var1.onTakeDamage(arg0, arg1, arg2, arg3)
	if arg3.isShare then
		return
	end

	local var0 = arg3.damage
	local var1 = arg2:GetCaster()

	if var1 and var1:IsAlive() and var1 ~= arg1 then
		arg3.damage = math.ceil(var0 * arg0._number)

		local var2 = math.ceil((var0 - arg3.damage) * (1 - arg0._absorbRate))

		if var2 > 0 then
			arg0._sumDMG = arg0._sumDMG + var2

			local var3 = {
				isMiss = false,
				isCri = false,
				isHeal = false,
				isShare = true
			}

			var1:UpdateHP(-var2, var3)

			if arg3.damageSrc then
				local var4 = arg3.damageSrc

				var0.Battle.BattleDataProxy.GetInstance():DamageStatistics(var4, arg1:GetAttrByName("id"), -var2)
				var0.Battle.BattleDataProxy.GetInstance():DamageStatistics(var4, var1:GetAttrByName("id"), var2)
			end
		end
	end
end

function var1.onRemove(arg0, arg1, arg2)
	local var0 = arg2:GetCaster()

	if var0 and var0:IsAlive() and arg0._restoreRate > 0 and var0 ~= arg1 then
		local var1 = var0:GetAttrByName("healingRate")
		local var2 = math.floor(arg0._sumDMG * arg0._restoreRate * var1)

		if var2 ~= 0 then
			local var3 = {
				isMiss = false,
				isCri = false,
				isHeal = true
			}

			var0:UpdateHP(var2, var3)
		end
	end
end
