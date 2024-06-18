ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillRemoveAllWeapon", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillRemoveAllWeapon = var1_0
var1_0.__name = "BattleSkillRemoveAllWeapon"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)
end

function var1_0.DoDataEffect(arg0_2, arg1_2)
	arg0_2:doRemove(arg1_2)
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doRemove(arg1_3)
end

function var1_0.doRemove(arg0_4, arg1_4)
	arg1_4:RemoveAllAutoWeapon()
end
