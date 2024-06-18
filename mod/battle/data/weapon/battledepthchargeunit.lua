ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleDepthChargeUnit = class("BattleDepthChargeUnit", var0_0.Battle.BattleWeaponUnit)
var0_0.Battle.BattleDepthChargeUnit.__name = "BattleDepthChargeUnit"

local var2_0 = var0_0.Battle.BattleDepthChargeUnit
local var3_0 = var0_0.Battle.BattleTargetChoise

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.TriggerBuffOnFire(arg0_2)
	arg0_2._host:TriggerBuff(var1_0.BuffEffectType.ON_DEPTH_CHARGE_DROP, {
		equipIndex = arg0_2._equipmentIndex
	})
end
