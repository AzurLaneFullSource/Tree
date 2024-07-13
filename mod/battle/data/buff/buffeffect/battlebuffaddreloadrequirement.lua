ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleAttr
local var3_0 = class("BattleBuffAddReloadRequirement", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAddReloadRequirement = var3_0
var3_0.__name = "BattleBuffAddReloadRequirement"

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)
end

function var3_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._weaponIndex = arg0_2._tempData.arg_list.index
	arg0_2._weaponType = arg0_2._tempData.arg_list.type
	arg0_2._value = arg0_2._tempData.arg_list.number or 0
	arg0_2._convertAttr = arg0_2._tempData.arg_list.convert_attr
	arg0_2._convertValue = arg0_2._tempData.arg_list.convert_value
end

function var3_0.onAttach(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}

	if arg0_3._weaponType then
		local var1_3

		if arg0_3._weaponType == var1_0.EquipmentType.POINT_HIT_AND_LOCK then
			var1_3 = arg1_3:GetChargeList()
		elseif arg0_3._weaponType == var1_0.EquipmentType.MANUAL_TORPEDO then
			var1_3 = arg1_3:GetTorpedoList()
		elseif arg0_3._weaponType == var1_0.EquipmentType.INTERCEPT_AIRCRAFT or arg0_3._weaponType == var1_0.EquipmentType.STRIKE_AIRCRAFT then
			var1_3 = arg1_3:GetHiveList()
		elseif arg0_3._weaponType == var1_0.EquipmentType.AIR_ASSIST then
			var1_3 = arg1_3:GetAirAssistList()
		else
			var1_3 = arg1_3:GetAutoWeapons()
		end

		if var1_3 then
			for iter0_3, iter1_3 in ipairs(var1_3) do
				var0_3[#var0_3 + 1] = iter1_3
			end
		end
	elseif arg0_3._weaponIndex then
		local var2_3 = arg1_3:GetTotalWeapon()

		for iter2_3, iter3_3 in ipairs(var2_3) do
			if iter3_3:GetEquipmentIndex() == arg0_3._weaponIndex then
				var0_3[#var0_3 + 1] = iter3_3
			end
		end
	else
		assert(false, "BattleBuffAddReloadRequirement：缺少指定类型或索引")
	end

	for iter4_3, iter5_3 in ipairs(var0_3) do
		iter5_3:AppendReloadFactor(arg2_3, arg0_3:calcFactor(arg2_3:GetCaster()))

		local var3_3 = iter5_3:GetReloadFactorList()
		local var4_3 = 1

		for iter6_3, iter7_3 in pairs(var3_3) do
			var4_3 = var4_3 + iter7_3
		end

		iter5_3:FlushReloadMax(var4_3)
	end

	arg0_3._targetWeaponList = var0_3
end

function var3_0.onRemove(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg0_4._targetWeaponList) do
		iter1_4:RemoveReloadFactor(arg2_4)

		local var0_4 = iter1_4:GetReloadFactorList()
		local var1_4 = 1

		for iter2_4, iter3_4 in pairs(var0_4) do
			var1_4 = var1_4 + iter3_4
		end

		iter1_4:FlushReloadMax(var1_4)
	end
end

function var3_0.calcFactor(arg0_5, arg1_5)
	local var0_5 = arg0_5._value
	local var1_5 = 0

	if arg0_5._convertAttr == nil then
		-- block empty
	elseif arg0_5._convertAttr == "HPRate" or arg0_5._convertAttr == "DMGRate" then
		var1_5 = var2_0.GetCurrent(arg1_5, arg0_5._convertAttr) * arg0_5._convertValue
	else
		var1_5 = var2_0.GetBase(arg1_5, arg0_5._convertAttr) * arg0_5._convertValue
	end

	return var0_5 + var1_5
end
