ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffMountExpand", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffMountExpand = var1_0
var1_0.__name = "BattleBuffMountExpand"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._weaponIndex = arg0_2._tempData.arg_list.index
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg1_3:ExpandWeaponMount(arg0_3._weaponIndex)
end
