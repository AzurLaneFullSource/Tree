ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillHeal = class("BattleSkillHeal", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillHeal.__name = "BattleSkillHeal"

function var0_0.Battle.BattleSkillHeal.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleSkillHeal.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._number = arg0_1._tempData.arg_list.number or 0
	arg0_1._maxHPRatio = arg0_1._tempData.arg_list.maxHPRatio or 0
	arg0_1._incorruptible = arg0_1._tempData.arg_list.incorrupt
end

function var0_0.Battle.BattleSkillHeal.DoDataEffect(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2:GetAttrByName("healingEnhancement") + 1
	local var1_2 = var0_0.Battle.BattleFormulas.HealFixer(var0_0.Battle.BattleDataProxy.GetInstance():GetInitData().battleType, arg2_2:GetAttr())
	local var2_2 = math.floor(arg0_2._number * var1_2)
	local var3_2 = arg1_2:GetAttrByName("healingRate")
	local var4_2 = math.max(0, math.floor((arg2_2:GetMaxHP() * arg0_2._maxHPRatio + var2_2) * var0_2 * var3_2))
	local var5_2 = {
		isMiss = false,
		isCri = false,
		isHeal = true,
		incorrupt = arg0_2._incorruptible
	}

	arg2_2:UpdateHP(var4_2, var5_2)
end
