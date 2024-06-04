ys = ys or {}

local var0 = ys

var0.Battle.BattleDirectHitWeaponUnit = class("BattleDirectHitWeaponUnit", var0.Battle.BattleWeaponUnit)
var0.Battle.BattleDirectHitWeaponUnit.__name = "BattleDirectHitWeaponUnit"

local var1 = var0.Battle.BattleDirectHitWeaponUnit

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.Spawn(arg0, arg1, arg2)
	local var0 = var1.super.Spawn(arg0, arg1, arg2)

	var0:SetDirectHitUnit(arg2)

	return var0
end
