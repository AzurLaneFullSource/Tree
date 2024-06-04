ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig.TorpedoCFG
local var2 = class("BattleTorpedoWeaponVO", var0.Battle.BattlePlayerWeaponVO)

var0.Battle.BattleTorpedoWeaponVO = var2
var2.__name = "BattleTorpedoWeaponVO"

function var2.Ctor(arg0)
	var2.super.Ctor(arg0, var1.GCD)
end

function var2.AppendWeapon(arg0, arg1)
	var2.super.AppendWeapon(arg0, arg1)
	arg1:SetPlayerTorpedoWeaponVO(arg0)
end

function var2.GetCurrentWeaponIconIndex(arg0)
	return 2
end
