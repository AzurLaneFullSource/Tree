ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddProficiency", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAddProficiency = var1
var1.__name = "BattleBuffAddProficiency"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg0._tempData.arg_list.group or arg2:GetID()
	arg0._weaponLabelList = arg0._tempData.arg_list.label or {}
	arg0._weaponIndexList = arg0._tempData.arg_list.index
	arg0._number = arg0._tempData.arg_list.number
end

function var1.onAttach(arg0, arg1, arg2)
	local var0 = arg1:GetAllWeapon()

	arg0:calcEnhancement(var0, true)
end

function var1.onRemove(arg0, arg1, arg2)
	local var0 = arg1:GetAllWeapon()

	arg0:calcEnhancement(var0, false)
end

function var1.calcEnhancement(arg0, arg1, arg2)
	local var0 = arg0._number

	if not arg2 then
		var0 = var0 * -1
	end

	for iter0, iter1 in ipairs(arg1) do
		local var1 = 1
		local var2 = iter1:GetEquipmentLabel()

		for iter2, iter3 in ipairs(arg0._weaponLabelList) do
			if not table.contains(var2, iter3) then
				var1 = 0

				break
			end
		end

		if arg0._weaponIndexList then
			local var3 = iter1:GetEquipmentIndex()

			if not table.contains(arg0._weaponIndexList, var3) then
				var1 = var1 * 0
			end
		end

		if var1 == 1 then
			local var4 = iter1:GetPotential() + var0

			iter1:SetPotentialFactor(var4)
		end
	end
end
