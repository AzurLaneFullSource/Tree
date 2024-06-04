ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffShiftWeaponSkin = class("BattleBuffShiftWeaponSkin", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffShiftWeaponSkin.__name = "BattleBuffShiftWeaponSkin"

local var1 = var0.Battle.BattleBuffShiftWeaponSkin

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._weaponIndex = arg0._tempData.arg_list.index
	arg0._skinID = arg0._tempData.arg_list.skin_id
end

function var1.onAttach(arg0, arg1, arg2)
	arg0:shiftWeaponSkin(arg1)
end

function var1.onRemove(arg0, arg1, arg2)
	return
end

function var1.shiftWeaponSkin(arg0, arg1)
	local var0 = arg1:GetAllWeapon()

	for iter0, iter1 in ipairs(arg0._indexRequire) do
		for iter2, iter3 in ipairs(var0) do
			if iter3:GetEquipmentIndex() == iter1 then
				iter3:SetSkinData(arg0._skinID)
			end
		end
	end
end
