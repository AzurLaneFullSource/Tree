ys = ys or {}

local var0 = ys

var0.Battle.BattleFleetBuffInk = class("BattleFleetBuffInk", var0.Battle.BattleFleetBuffEffect)
var0.Battle.BattleFleetBuffInk.__name = "BattleFleetBuffInk"

local var1 = var0.Battle.BattleFleetBuffInk

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.onAttach(arg0, arg1, arg2)
	arg1:Blinding(true)
	arg1:SetWeaponBlock(1)
end

function var1.onRemove(arg0, arg1, arg2)
	arg1:Blinding(false)
	arg1:SetWeaponBlock(-1)
end
