ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffCease", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffCease = var1_0
var1_0.__name = "BattleBuffCease"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.onAttach(arg0_2, arg1_2, arg2_2)
	arg1_2:CeaseAllWeapon(true)
end

function var1_0.onRemove(arg0_3, arg1_3, arg2_3)
	arg1_3:CeaseAllWeapon(false)
end
