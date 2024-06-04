ys = ys or {}

local var0 = ys

var0.Battle.BattleTorpedoUnit = class("BattleTorpedoUnit", var0.Battle.BattleWeaponUnit)
var0.Battle.BattleTorpedoUnit.__name = "BattleTorpedoUnit"

local var1 = var0.Battle.BattleTorpedoUnit

function var1.Ctor(arg0)
	var0.Battle.BattleTorpedoUnit.super.Ctor(arg0)
end

function var1.TriggerBuffOnFire(arg0)
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_FIRE, {
		equipIndex = arg0._equipmentIndex
	})
end

function var1.TriggerBuffWhenSpawn(arg0, arg1)
	local var0 = {
		_bullet = arg1,
		equipIndex = arg0._equipmentIndex,
		bulletTag = arg1:GetExtraTag()
	}

	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_BULLET_CREATE, var0)
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_BULLET_CREATE, var0)
end
