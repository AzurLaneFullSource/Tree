ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffFixRange = class("BattleBuffFixRange", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffFixRange.__name = "BattleBuffFixRange"

local var1_0 = var0_0.Battle.BattleBuffFixRange

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._weaponRange = arg0_2._tempData.arg_list.weaponRange
	arg0_2._bulletRange = arg0_2._tempData.arg_list.bulletRange
	arg0_2._minRange = arg0_2._tempData.arg_list.minRange
	arg0_2._bulletRangeOffset = arg0_2._tempData.arg_list.bulletRangeOffset
end

function var1_0.onAttach(arg0_3, arg1_3)
	if arg0_3._weaponRange or arg0_3._bulletRange or arg0_3._bulletRangeOffset then
		arg0_3:updateBulletRange(arg1_3, arg0_3._weaponRange, arg0_3._bulletRange, arg0_3._minRange, arg0_3._bulletRangeOffset)
	end
end

function var1_0.onRemove(arg0_4, arg1_4)
	arg0_4:updateBulletRange(arg1_4)
end

function var1_0.updateBulletRange(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	local var0_5 = arg1_5:GetAllWeapon()

	for iter0_5, iter1_5 in ipairs(var0_5) do
		local var1_5 = iter1_5:GetEquipmentIndex()

		if arg0_5._indexRequire == nil or table.contains(arg0_5._indexRequire, var1_5) then
			iter1_5:FixWeaponRange(arg2_5, arg3_5, arg4_5, arg5_5)
		end
	end
end
