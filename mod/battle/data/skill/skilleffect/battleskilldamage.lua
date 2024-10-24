ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillDamage = class("BattleSkillDamage", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillDamage.__name = "BattleSkillDamage"

function var0_0.Battle.BattleSkillDamage.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleSkillDamage.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._number = arg0_1._tempData.arg_list.number or 0
	arg0_1._currentHPRate = arg0_1._tempData.arg_list.current_hp_rate or 0
	arg0_1._maxHPRate = arg0_1._tempData.arg_list.rate or 0
	arg0_1._proxy = var0_0.Battle.BattleDataProxy.GetInstance()
end

function var0_0.Battle.BattleSkillDamage.DoDataEffect(arg0_2, arg1_2, arg2_2)
	local var0_2, var1_2 = arg2_2:GetHP()
	local var2_2 = math.floor(var1_2 * arg0_2._maxHPRate) + math.floor(var0_2 * arg0_2._currentHPRate) + arg0_2._number

	arg0_2._proxy:HandleDirectDamage(arg2_2, var2_2, arg1_2)

	if not arg2_2:IsAlive() then
		var0_0.Battle.BattleAttr.Spirit(arg2_2)
		var0_0.Battle.BattleAttr.AppendInvincible(arg2_2)
	end
end
