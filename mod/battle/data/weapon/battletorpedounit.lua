ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleTorpedoUnit = class("BattleTorpedoUnit", var0_0.Battle.BattleWeaponUnit)
var0_0.Battle.BattleTorpedoUnit.__name = "BattleTorpedoUnit"

local var1_0 = var0_0.Battle.BattleTorpedoUnit

function var1_0.Ctor(arg0_1)
	var0_0.Battle.BattleTorpedoUnit.super.Ctor(arg0_1)
end

function var1_0.TriggerBuffOnFire(arg0_2)
	arg0_2._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_FIRE, {
		equipIndex = arg0_2._equipmentIndex
	})
end

function var1_0.TriggerBuffWhenSpawn(arg0_3, arg1_3)
	local var0_3 = {
		_bullet = arg1_3,
		equipIndex = arg0_3._equipmentIndex,
		bulletTag = arg1_3:GetExtraTag()
	}

	arg0_3._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BULLET_CREATE, var0_3)
	arg0_3._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_BULLET_CREATE, var0_3)
end
