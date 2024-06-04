ys = ys or {}

local var0 = ys

var0.Battle.BattleSkillGridmanFloat = class("BattleSkillGridmanFloat", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillGridmanFloat.__name = "BattleSkillGridmanFloat"

local var1 = var0.Battle.BattleSkillGridmanFloat

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._iconType = arg0._tempData.arg_list.icon_type
end

function var1.DoDataEffect(arg0, arg1)
	arg0:doGridmanSkillFloat(arg1)
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:doGridmanSkillFloat(arg1)
end

function var1.doGridmanSkillFloat(arg0, arg1)
	var0.Battle.BattleDataProxy.GetInstance():DispatchGridmanSkill(arg0._iconType, arg1:GetIFF())
end
