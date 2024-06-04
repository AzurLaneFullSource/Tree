ys = ys or {}

local var0 = ys

var0.Battle.BattleSkillSetCloak = class("BattleSkillSetCloak", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillSetCloak.__name = "BattleSkillSetCloak"

local var1 = var0.Battle.BattleSkillSetCloak

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)

	arg0._rate = arg0._tempData.arg_list.cloak_rate or 0
end

function var1.DoDataEffect(arg0, arg1, arg2)
	arg0:doSetCloakValue(arg2)
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:doSetCloakValue(arg1)
end

function var1.doSetCloakValue(arg0, arg1)
	local var0 = arg1:GetCloak()

	if var0 then
		var0:ForceToRate(arg0._rate)
	end
end
