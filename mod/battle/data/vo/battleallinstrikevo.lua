ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleAllInStrikeVO = class("BattleAllInStrikeVO", var0_0.Battle.BattlePlayerWeaponVO)
var0_0.Battle.BattleAllInStrikeVO.__name = "BattleAllInStrikeVO"

local var2_0 = var0_0.Battle.BattleAllInStrikeVO

var2_0.GCD = var1_0.AirAssistCFG.GCD

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1, var2_0.GCD)
end

function var2_0.AppendWeapon(arg0_2, arg1_2)
	arg1_2:SetAllInWeaponVO(arg0_2)
	var2_0.super.AppendWeapon(arg0_2, arg1_2)
end

function var2_0.GetCurrentWeaponIconIndex(arg0_3)
	return 3
end
