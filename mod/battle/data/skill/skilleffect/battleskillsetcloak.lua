ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillSetCloak = class("BattleSkillSetCloak", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillSetCloak.__name = "BattleSkillSetCloak"

local var1_0 = var0_0.Battle.BattleSkillSetCloak

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._rate = arg0_1._tempData.arg_list.cloak_rate or 0
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	arg0_2:doSetCloakValue(arg2_2)
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doSetCloakValue(arg1_3)
end

function var1_0.doSetCloakValue(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetCloak()

	if var0_4 then
		var0_4:ForceToRate(arg0_4._rate)
	end
end
