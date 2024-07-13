ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAddProficiency", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAddProficiency = var1_0
var1_0.__name = "BattleBuffAddProficiency"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._group = arg0_2._tempData.arg_list.group or arg2_2:GetID()
	arg0_2._weaponLabelList = arg0_2._tempData.arg_list.label or {}
	arg0_2._weaponIndexList = arg0_2._tempData.arg_list.index
	arg0_2._number = arg0_2._tempData.arg_list.number
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3:GetAllWeapon()

	arg0_3:calcEnhancement(var0_3, true)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:GetAllWeapon()

	arg0_4:calcEnhancement(var0_4, false)
end

function var1_0.calcEnhancement(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5._number

	if not arg2_5 then
		var0_5 = var0_5 * -1
	end

	for iter0_5, iter1_5 in ipairs(arg1_5) do
		local var1_5 = 1
		local var2_5 = iter1_5:GetEquipmentLabel()

		for iter2_5, iter3_5 in ipairs(arg0_5._weaponLabelList) do
			if not table.contains(var2_5, iter3_5) then
				var1_5 = 0

				break
			end
		end

		if arg0_5._weaponIndexList then
			local var3_5 = iter1_5:GetEquipmentIndex()

			if not table.contains(arg0_5._weaponIndexList, var3_5) then
				var1_5 = var1_5 * 0
			end
		end

		if var1_5 == 1 then
			local var4_5 = iter1_5:GetPotential() + var0_5

			iter1_5:SetPotentialFactor(var4_5)
		end
	end
end
