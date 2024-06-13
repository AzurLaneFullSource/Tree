ys = ys or {}

local var0 = ys

var0.Battle.BattleSkillDamage = class("BattleSkillDamage", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillDamage.__name = "BattleSkillDamage"

function var0.Battle.BattleSkillDamage.Ctor(arg0, arg1)
	var0.Battle.BattleSkillDamage.super.Ctor(arg0, arg1, lv)

	arg0._number = arg0._tempData.arg_list.number or 0
	arg0._currentHPRate = arg0._tempData.arg_list.current_hp_rate or 0
	arg0._maxHPRate = arg0._tempData.arg_list.rate or 0
end

function var0.Battle.BattleSkillDamage.DoDataEffect(arg0, arg1, arg2)
	local var0 = {
		isMiss = false,
		isCri = false,
		isHeal = false
	}
	local var1, var2 = arg2:GetHP()
	local var3 = math.floor(var2 * arg0._maxHPRate) + math.floor(var1 * arg0._currentHPRate) + arg0._number
	local var4 = arg2:UpdateHP(-var3, var0)

	var0.Battle.BattleDataProxy.GetInstance():DamageStatistics(arg1:GetAttrByName("id"), arg2:GetAttrByName("id"), -var4)

	if not arg2:IsAlive() then
		var0.Battle.BattleAttr.Spirit(arg2)
		var0.Battle.BattleAttr.AppendInvincible(arg2)
	end
end
