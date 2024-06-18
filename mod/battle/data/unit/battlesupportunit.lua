ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleAttr
local var4_0 = var0_0.Battle.BattleConst
local var5_0 = var4_0.EquipmentType
local var6_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleSupportUnit = class("BattleSupportUnit", var0_0.Battle.BattlePlayerUnit)
var0_0.Battle.BattleSupportUnit.__name = "BattleSupportUnit"

local var7_0 = var0_0.Battle.BattleSupportUnit

function var7_0.Ctor(arg0_1, arg1_1, arg2_1)
	var7_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._type = var4_0.UnitType.SUPPORT_UNIT
end

function var7_0.setWeapon(arg0_2, arg1_2)
	local var0_2 = arg0_2._tmpData.default_equip_list
	local var1_2 = arg0_2._tmpData.base_list
	local var2_2 = arg0_2._proficiencyList
	local var3_2 = arg0_2._tmpData.preload_count

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		if iter1_2 and iter1_2.skin and iter1_2.skin ~= 0 and Equipment.IsOrbitSkin(iter1_2.skin) then
			arg0_2._orbitSkinIDList = arg0_2._orbitSkinIDList or {}

			table.insert(arg0_2._orbitSkinIDList, iter1_2.skin)
		end

		if iter0_2 <= Ship.WEAPON_COUNT then
			local var4_2 = var2_2[iter0_2]
			local var5_2 = var3_2[iter0_2]

			local function var6_2(arg0_3, arg1_3, arg2_3)
				if var1_0.GetWeaponPropertyDataFromID(arg0_3).type == var4_0.EquipmentType.INTERCEPT_AIRCRAFT then
					local var0_3 = var1_2[iter0_2]

					for iter0_3 = 1, var0_3 do
						local var1_3 = arg0_2:AddWeapon(arg0_3, arg1_3, arg2_3, var4_2, iter0_2)
						local var2_3 = var1_3:GetTemplateData().type

						if iter1_2.equipment then
							var1_3:SetSrcEquipmentID(iter1_2.equipment.id)
						end
					end
				end
			end

			if iter1_2.equipment and #iter1_2.equipment.weapon_id > 0 then
				if iter1_2.equipment.type == EquipType.FighterAircraft then
					local var7_2 = iter1_2.equipment.weapon_id

					for iter2_2, iter3_2 in ipairs(var7_2) do
						local var8_2 = var1_0.GetWeaponPropertyDataFromID(iter3_2).type
						local var9_2 = var6_0.EQUIPMENT_ACTIVE_LIMITED_BY_TYPE[var8_2]

						if (not var9_2 or table.contains(var9_2, arg0_2._tmpData.type)) and iter3_2 and iter3_2 ~= -1 then
							var6_2(iter3_2, iter1_2.equipment.label, iter1_2.skin)
						end
					end
				end
			else
				local var10_2 = var0_2[iter0_2]
				local var11_2 = var1_0.GetWeaponDataFromID(var10_2)

				if var11_2.type == EquipType.FighterAircraft then
					var6_2(var10_2, var11_2.label)
				end
			end
		end
	end

	local var12_2 = #var0_2
	local var13_2 = arg0_2._tmpData.fix_equip_list

	for iter4_2, iter5_2 in ipairs(var13_2) do
		if iter5_2 and iter5_2 ~= -1 then
			local var14_2 = var2_2[iter4_2 + var12_2] or 1

			arg0_2:AddWeapon(iter5_2, nil, nil, var14_2, iter4_2 + var12_2):SetFixedFlag()
		end
	end
end

function var7_0.AddWeapon(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4, arg6_4)
	local var0_4 = var1_0.CreateWeaponUnit(arg1_4, arg0_4, arg4_4, arg5_4)

	arg0_4._totalWeapon[#arg0_4._totalWeapon + 1] = var0_4

	if arg2_4 then
		var0_4:SetEquipmentLabel(arg2_4)
	end

	arg0_4:AddAutoWeapon(var0_4)

	if arg3_4 and arg3_4 ~= 0 then
		var0_4:SetSkinData(arg3_4)
		arg0_4:SetPriorityWeaponSkin(arg3_4)
	end

	return var0_4
end
