ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffFixRange = class("BattleBuffFixRange", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffFixRange.__name = "BattleBuffFixRange"

local var1 = var0.Battle.BattleBuffFixRange

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._weaponRange = arg0._tempData.arg_list.weaponRange
	arg0._bulletRange = arg0._tempData.arg_list.bulletRange
	arg0._minRange = arg0._tempData.arg_list.minRange
	arg0._bulletRangeOffset = arg0._tempData.arg_list.bulletRangeOffset
end

function var1.onAttach(arg0, arg1)
	if arg0._weaponRange or arg0._bulletRange or arg0._bulletRangeOffset then
		arg0:updateBulletRange(arg1, arg0._weaponRange, arg0._bulletRange, arg0._minRange, arg0._bulletRangeOffset)
	end
end

function var1.onRemove(arg0, arg1)
	arg0:updateBulletRange(arg1)
end

function var1.updateBulletRange(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg1:GetAllWeapon()

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1:GetEquipmentIndex()

		if arg0._indexRequire == nil or table.contains(arg0._indexRequire, var1) then
			iter1:FixWeaponRange(arg2, arg3, arg4, arg5)
		end
	end
end
