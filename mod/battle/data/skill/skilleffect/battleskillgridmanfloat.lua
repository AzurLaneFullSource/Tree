ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillGridmanFloat = class("BattleSkillGridmanFloat", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillGridmanFloat.__name = "BattleSkillGridmanFloat"

local var1_0 = var0_0.Battle.BattleSkillGridmanFloat

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._iconType = arg0_1._tempData.arg_list.icon_type
end

function var1_0.DoDataEffect(arg0_2, arg1_2)
	arg0_2:doGridmanSkillFloat(arg1_2)
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doGridmanSkillFloat(arg1_3)
end

function var1_0.doGridmanSkillFloat(arg0_4, arg1_4)
	var0_0.Battle.BattleDataProxy.GetInstance():DispatchGridmanSkill(arg0_4._iconType, arg1_4:GetIFF())
end
