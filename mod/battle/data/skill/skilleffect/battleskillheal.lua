ys = ys or {}

local var0 = ys

var0.Battle.BattleSkillHeal = class("BattleSkillHeal", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillHeal.__name = "BattleSkillHeal"

function var0.Battle.BattleSkillHeal.Ctor(arg0, arg1)
	var0.Battle.BattleSkillHeal.super.Ctor(arg0, arg1, lv)

	arg0._number = arg0._tempData.arg_list.number or 0
	arg0._maxHPRatio = arg0._tempData.arg_list.maxHPRatio or 0
	arg0._incorruptible = arg0._tempData.arg_list.incorrupt
end

function var0.Battle.BattleSkillHeal.DoDataEffect(arg0, arg1, arg2)
	local var0 = arg1:GetAttrByName("healingEnhancement") + 1
	local var1 = var0.Battle.BattleFormulas.HealFixer(var0.Battle.BattleDataProxy.GetInstance():GetInitData().battleType, arg2:GetAttr())
	local var2 = math.floor(arg0._number * var1)
	local var3 = arg1:GetAttrByName("healingRate")
	local var4 = math.max(0, math.floor((arg2:GetMaxHP() * arg0._maxHPRatio + var2) * var0 * var3))
	local var5 = {
		isMiss = false,
		isCri = false,
		isHeal = true,
		incorrupt = arg0._incorruptible
	}

	arg2:UpdateHP(var4, var5)
end
