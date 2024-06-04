ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleAttr
local var3 = class("BattleBuffAddReloadRequirement", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAddReloadRequirement = var3
var3.__name = "BattleBuffAddReloadRequirement"

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)
end

function var3.SetArgs(arg0, arg1, arg2)
	arg0._weaponIndex = arg0._tempData.arg_list.index
	arg0._weaponType = arg0._tempData.arg_list.type
	arg0._value = arg0._tempData.arg_list.number or 0
	arg0._convertAttr = arg0._tempData.arg_list.convert_attr
	arg0._convertValue = arg0._tempData.arg_list.convert_value
end

function var3.onAttach(arg0, arg1, arg2)
	local var0 = {}

	if arg0._weaponType then
		local var1

		if arg0._weaponType == var1.EquipmentType.POINT_HIT_AND_LOCK then
			var1 = arg1:GetChargeList()
		elseif arg0._weaponType == var1.EquipmentType.MANUAL_TORPEDO then
			var1 = arg1:GetTorpedoList()
		elseif arg0._weaponType == var1.EquipmentType.INTERCEPT_AIRCRAFT or arg0._weaponType == var1.EquipmentType.STRIKE_AIRCRAFT then
			var1 = arg1:GetHiveList()
		elseif arg0._weaponType == var1.EquipmentType.AIR_ASSIST then
			var1 = arg1:GetAirAssistList()
		else
			var1 = arg1:GetAutoWeapons()
		end

		if var1 then
			for iter0, iter1 in ipairs(var1) do
				var0[#var0 + 1] = iter1
			end
		end
	elseif arg0._weaponIndex then
		local var2 = arg1:GetTotalWeapon()

		for iter2, iter3 in ipairs(var2) do
			if iter3:GetEquipmentIndex() == arg0._weaponIndex then
				var0[#var0 + 1] = iter3
			end
		end
	else
		assert(false, "BattleBuffAddReloadRequirement：缺少指定类型或索引")
	end

	for iter4, iter5 in ipairs(var0) do
		iter5:AppendReloadFactor(arg2, arg0:calcFactor(arg2:GetCaster()))

		local var3 = iter5:GetReloadFactorList()
		local var4 = 1

		for iter6, iter7 in pairs(var3) do
			var4 = var4 + iter7
		end

		iter5:FlushReloadMax(var4)
	end

	arg0._targetWeaponList = var0
end

function var3.onRemove(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0._targetWeaponList) do
		iter1:RemoveReloadFactor(arg2)

		local var0 = iter1:GetReloadFactorList()
		local var1 = 1

		for iter2, iter3 in pairs(var0) do
			var1 = var1 + iter3
		end

		iter1:FlushReloadMax(var1)
	end
end

function var3.calcFactor(arg0, arg1)
	local var0 = arg0._value
	local var1 = 0

	if arg0._convertAttr == nil then
		-- block empty
	elseif arg0._convertAttr == "HPRate" or arg0._convertAttr == "DMGRate" then
		var1 = var2.GetCurrent(arg1, arg0._convertAttr) * arg0._convertValue
	else
		var1 = var2.GetBase(arg1, arg0._convertAttr) * arg0._convertValue
	end

	return var0 + var1
end
