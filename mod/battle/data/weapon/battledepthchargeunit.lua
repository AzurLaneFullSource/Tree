ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.BattleDepthChargeUnit = class("BattleDepthChargeUnit", var0.Battle.BattleWeaponUnit)
var0.Battle.BattleDepthChargeUnit.__name = "BattleDepthChargeUnit"

local var2 = var0.Battle.BattleDepthChargeUnit
local var3 = var0.Battle.BattleTargetChoise

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.TriggerBuffOnFire(arg0)
	arg0._host:TriggerBuff(var1.BuffEffectType.ON_DEPTH_CHARGE_DROP, {
		equipIndex = arg0._equipmentIndex
	})
end
