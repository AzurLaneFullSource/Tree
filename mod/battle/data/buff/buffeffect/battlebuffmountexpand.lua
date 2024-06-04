ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffMountExpand", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffMountExpand = var1
var1.__name = "BattleBuffMountExpand"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._weaponIndex = arg0._tempData.arg_list.index
end

function var1.onAttach(arg0, arg1, arg2)
	arg1:ExpandWeaponMount(arg0._weaponIndex)
end
