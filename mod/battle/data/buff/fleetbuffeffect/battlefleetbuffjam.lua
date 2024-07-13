ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleFleetBuffJam = class("BattleFleetBuffJam", var0_0.Battle.BattleFleetBuffEffect)
var0_0.Battle.BattleFleetBuffJam.__name = "BattleFleetBuffJam"

local var1_0 = var0_0.Battle.BattleFleetBuffJam

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.onAttach(arg0_2, arg1_2, arg2_2)
	var0_0.Battle.BattleDataProxy.GetInstance():JamManualCast(true)
	arg1_2:Jamming(true)
	arg1_2:SetWeaponBlock(1)
end

function var1_0.onRemove(arg0_3, arg1_3, arg2_3)
	var0_0.Battle.BattleDataProxy.GetInstance():JamManualCast(false)
	arg1_3:Jamming(false)
	arg1_3:SetWeaponBlock(-1)
end
