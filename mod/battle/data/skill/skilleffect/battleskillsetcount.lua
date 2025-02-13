ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillSetCount = class("BattleSkillSetCount", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillSetCount.__name = "BattleSkillSetCount"

local var1_0 = var0_0.Battle.BattleSkillSetCount

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._countType = arg0_1._tempData.arg_list.countType
	arg0_1._countTarget = arg0_1._tempData.arg_list.countTarget or 0
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	arg0_2:doSetCounter(arg2_2)
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doSetCounter(arg1_3)
end

function var1_0.doSetCounter(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetBuffList()

	for iter0_4, iter1_4 in pairs(var0_4) do
		local var1_4 = iter1_4:GetEffectList()

		for iter2_4, iter3_4 in ipairs(var1_4) do
			if iter3_4:GetEffectType() == var0_0.Battle.BattleBuffEffect.FX_TYPE_COUNTER and iter3_4:GetCountType() == arg0_4._countType then
				iter3_4:SetCount(arg0_4._countTarget)
			end
		end
	end
end
