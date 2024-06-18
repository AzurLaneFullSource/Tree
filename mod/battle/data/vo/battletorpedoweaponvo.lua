ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig.TorpedoCFG
local var2_0 = class("BattleTorpedoWeaponVO", var0_0.Battle.BattlePlayerWeaponVO)

var0_0.Battle.BattleTorpedoWeaponVO = var2_0
var2_0.__name = "BattleTorpedoWeaponVO"

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1, var1_0.GCD)
end

function var2_0.AppendWeapon(arg0_2, arg1_2)
	var2_0.super.AppendWeapon(arg0_2, arg1_2)
	arg1_2:SetPlayerTorpedoWeaponVO(arg0_2)
end

function var2_0.GetCurrentWeaponIconIndex(arg0_3)
	return 2
end
