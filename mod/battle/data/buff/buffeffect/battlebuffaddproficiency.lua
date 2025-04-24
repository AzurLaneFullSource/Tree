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
	arg0_2._numberBase = arg0_2._number
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg0_3:calcEnhancement(arg1_3)
end

function var1_0.onStack(arg0_4, arg1_4, arg2_4)
	arg0_4:resetEnhancement(arg1_4)

	arg0_4._number = arg0_4._numberBase * arg2_4._stack

	arg0_4:calcEnhancement(arg1_4)
end

function var1_0.onRemove(arg0_5, arg1_5, arg2_5)
	arg0_5:resetEnhancement(arg1_5)
end

function var1_0.calcEnhancement(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetAllWeapon()
	local var1_6 = arg0_6._number

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var2_6 = 1
		local var3_6 = iter1_6:GetEquipmentLabel()

		for iter2_6, iter3_6 in ipairs(arg0_6._weaponLabelList) do
			if not table.contains(var3_6, iter3_6) then
				var2_6 = 0

				break
			end
		end

		if arg0_6._weaponIndexList then
			local var4_6 = iter1_6:GetEquipmentIndex()

			if not table.contains(arg0_6._weaponIndexList, var4_6) then
				var2_6 = var2_6 * 0
			end
		end

		if var2_6 == 1 then
			local var5_6 = iter1_6:GetPotential() + var1_6

			iter1_6:SetPotentialFactor(var5_6)
		end
	end
end

function var1_0.resetEnhancement(arg0_7, arg1_7)
	local var0_7 = arg0_7._number * -1
	local var1_7 = arg1_7:GetAllWeapon()

	for iter0_7, iter1_7 in ipairs(var1_7) do
		local var2_7 = 1
		local var3_7 = iter1_7:GetEquipmentLabel()

		for iter2_7, iter3_7 in ipairs(arg0_7._weaponLabelList) do
			if not table.contains(var3_7, iter3_7) then
				var2_7 = 0

				break
			end
		end

		if arg0_7._weaponIndexList then
			local var4_7 = iter1_7:GetEquipmentIndex()

			if not table.contains(arg0_7._weaponIndexList, var4_7) then
				var2_7 = var2_7 * 0
			end
		end

		if var2_7 == 1 then
			local var5_7 = iter1_7:GetPotential() + var0_7

			iter1_7:SetPotentialFactor(var5_7)
		end
	end
end
