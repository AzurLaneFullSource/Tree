ys = ys or {}

local var0 = ys

var0.Battle.BattleFleetBuffJam = class("BattleFleetBuffJam", var0.Battle.BattleFleetBuffEffect)
var0.Battle.BattleFleetBuffJam.__name = "BattleFleetBuffJam"

local var1 = var0.Battle.BattleFleetBuffJam

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.onAttach(arg0, arg1, arg2)
	var0.Battle.BattleDataProxy.GetInstance():JamManualCast(true)
	arg1:Jamming(true)
	arg1:SetWeaponBlock(1)
end

function var1.onRemove(arg0, arg1, arg2)
	var0.Battle.BattleDataProxy.GetInstance():JamManualCast(false)
	arg1:Jamming(false)
	arg1:SetWeaponBlock(-1)
end
