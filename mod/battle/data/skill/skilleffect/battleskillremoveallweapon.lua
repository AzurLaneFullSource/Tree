ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillRemoveAllWeapon", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillRemoveAllWeapon = var1
var1.__name = "BattleSkillRemoveAllWeapon"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)
end

function var1.DoDataEffect(arg0, arg1)
	arg0:doRemove(arg1)
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:doRemove(arg1)
end

function var1.doRemove(arg0, arg1)
	arg1:RemoveAllAutoWeapon()
end
