ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleAttr
local var4 = var0.Battle.BattleConst
local var5 = var4.EquipmentType
local var6 = var0.Battle.BattleConfig

var0.Battle.BattleSupportUnit = class("BattleSupportUnit", var0.Battle.BattlePlayerUnit)
var0.Battle.BattleSupportUnit.__name = "BattleSupportUnit"

local var7 = var0.Battle.BattleSupportUnit

function var7.Ctor(arg0, arg1, arg2)
	var7.super.Ctor(arg0, arg1, arg2)

	arg0._type = var4.UnitType.SUPPORT_UNIT
end

function var7.setWeapon(arg0, arg1)
	local var0 = arg0._tmpData.default_equip_list
	local var1 = arg0._tmpData.base_list
	local var2 = arg0._proficiencyList
	local var3 = arg0._tmpData.preload_count

	for iter0, iter1 in ipairs(arg1) do
		if iter1 and iter1.skin and iter1.skin ~= 0 and Equipment.IsOrbitSkin(iter1.skin) then
			arg0._orbitSkinIDList = arg0._orbitSkinIDList or {}

			table.insert(arg0._orbitSkinIDList, iter1.skin)
		end

		if iter0 <= Ship.WEAPON_COUNT then
			local var4 = var2[iter0]
			local var5 = var3[iter0]

			local function var6(arg0, arg1, arg2)
				if var1.GetWeaponPropertyDataFromID(arg0).type == var4.EquipmentType.INTERCEPT_AIRCRAFT then
					local var0 = var1[iter0]

					for iter0 = 1, var0 do
						local var1 = arg0:AddWeapon(arg0, arg1, arg2, var4, iter0)
						local var2 = var1:GetTemplateData().type

						if iter1.equipment then
							var1:SetSrcEquipmentID(iter1.equipment.id)
						end
					end
				end
			end

			if iter1.equipment and #iter1.equipment.weapon_id > 0 then
				if iter1.equipment.type == EquipType.FighterAircraft then
					local var7 = iter1.equipment.weapon_id

					for iter2, iter3 in ipairs(var7) do
						local var8 = var1.GetWeaponPropertyDataFromID(iter3).type
						local var9 = var6.EQUIPMENT_ACTIVE_LIMITED_BY_TYPE[var8]

						if (not var9 or table.contains(var9, arg0._tmpData.type)) and iter3 and iter3 ~= -1 then
							var6(iter3, iter1.equipment.label, iter1.skin)
						end
					end
				end
			else
				local var10 = var0[iter0]
				local var11 = var1.GetWeaponDataFromID(var10)

				if var11.type == EquipType.FighterAircraft then
					var6(var10, var11.label)
				end
			end
		end
	end

	local var12 = #var0
	local var13 = arg0._tmpData.fix_equip_list

	for iter4, iter5 in ipairs(var13) do
		if iter5 and iter5 ~= -1 then
			local var14 = var2[iter4 + var12] or 1

			arg0:AddWeapon(iter5, nil, nil, var14, iter4 + var12):SetFixedFlag()
		end
	end
end

function var7.AddWeapon(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = var1.CreateWeaponUnit(arg1, arg0, arg4, arg5)

	arg0._totalWeapon[#arg0._totalWeapon + 1] = var0

	if arg2 then
		var0:SetEquipmentLabel(arg2)
	end

	arg0:AddAutoWeapon(var0)

	if arg3 and arg3 ~= 0 then
		var0:SetSkinData(arg3)
		arg0:SetPriorityWeaponSkin(arg3)
	end

	return var0
end
