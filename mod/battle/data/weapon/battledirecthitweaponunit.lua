ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleDirectHitWeaponUnit = class("BattleDirectHitWeaponUnit", var0_0.Battle.BattleWeaponUnit)
var0_0.Battle.BattleDirectHitWeaponUnit.__name = "BattleDirectHitWeaponUnit"

local var1_0 = var0_0.Battle.BattleDirectHitWeaponUnit

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.Spawn(arg0_2, arg1_2, arg2_2)
	local var0_2 = var1_0.super.Spawn(arg0_2, arg1_2, arg2_2)

	var0_2:SetDirectHitUnit(arg2_2)

	return var0_2
end
