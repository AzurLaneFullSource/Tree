ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleAllInStrikeVO = class("BattleAllInStrikeVO", var0.Battle.BattlePlayerWeaponVO)
var0.Battle.BattleAllInStrikeVO.__name = "BattleAllInStrikeVO"

local var2 = var0.Battle.BattleAllInStrikeVO

var2.GCD = var1.AirAssistCFG.GCD

function var2.Ctor(arg0)
	var2.super.Ctor(arg0, var2.GCD)
end

function var2.AppendWeapon(arg0, arg1)
	arg1:SetAllInWeaponVO(arg0)
	var2.super.AppendWeapon(arg0, arg1)
end

function var2.GetCurrentWeaponIconIndex(arg0)
	return 3
end
