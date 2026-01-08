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

function var1_0.EnterCoolDown(arg0_3)
	if arg0_3._isSupportWeapon then
		arg0_3._currentState = arg0_3.STATE_DISABLE
	else
		var1_0.super.EnterCoolDown(arg0_3)
	end
end

function var1_0.TriggerBuffWhenSpawn(arg0_4, arg1_4)
	local var0_4 = {
		_bullet = arg1_4,
		equipIndex = arg0_4._equipmentIndex,
		bulletTag = arg1_4:GetExtraTag()
	}

	arg0_4._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BULLET_CREATE, var0_4)
	arg0_4._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_BULLET_CREATE, var0_4)
end
