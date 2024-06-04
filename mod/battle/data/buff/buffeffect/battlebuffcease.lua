ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffCease", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffCease = var1
var1.__name = "BattleBuffCease"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.onAttach(arg0, arg1, arg2)
	arg1:CeaseAllWeapon(true)
end

function var1.onRemove(arg0, arg1, arg2)
	arg1:CeaseAllWeapon(false)
end
