ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleAttr
local var4_0 = var0_0.Battle.BattleConst
local var5_0 = var4_0.EquipmentType
local var6_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleSubUnit = class("BattleSubUnit", var0_0.Battle.BattlePlayerUnit)
var0_0.Battle.BattleSubUnit.__name = "BattleSubUnit"

local var7_0 = var0_0.Battle.BattleSubUnit

function var7_0.Ctor(arg0_1, arg1_1, arg2_1)
	var7_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._type = var4_0.UnitType.PLAYER_UNIT
end

function var7_0.setWeapon(arg0_2, arg1_2)
	local var0_2 = arg0_2._tmpData.default_equip_list
	local var1_2 = arg0_2._tmpData.base_list
	local var2_2 = arg0_2._proficiencyList
	local var3_2 = arg0_2._tmpData.preload_count
	local var4_2 = 0

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		if iter0_2 > Ship.WEAPON_COUNT and iter1_2 then
			var4_2 = var4_2 + iter1_2.torpedoAmmo
		end
	end

	local var5_2 = {}

	for iter2_2, iter3_2 in ipairs(arg1_2) do
		if iter3_2 and iter3_2.skin and iter3_2.skin ~= 0 and Equipment.IsOrbitSkin(iter3_2.skin) then
			arg0_2._orbitSkinIDList = arg0_2._orbitSkinIDList or {}

			table.insert(arg0_2._orbitSkinIDList, iter3_2.skin)
		end

		if iter2_2 <= Ship.WEAPON_COUNT then
			local var6_2 = var2_2[iter2_2]

			local function var7_2(arg0_3, arg1_3, arg2_3)
				local var0_3 = var1_0.GetWeaponPropertyDataFromID(arg0_3)

				if var0_3.type == var4_0.EquipmentType.TORPEDO then
					return var0_3.torpedo_ammo
				else
					local var1_3 = var1_2[iter2_2]

					for iter0_3 = 1, var1_3 do
						arg0_2:AddWeapon(arg0_3, arg1_3, arg2_3, var6_2, iter2_2)
					end

					return false
				end
			end

			if iter3_2.equipment then
				local var8_2 = iter3_2.equipment.weapon_id

				for iter4_2, iter5_2 in ipairs(var8_2) do
					if iter5_2 and iter5_2 ~= -1 then
						local var9_2 = var7_2(iter5_2, iter3_2.equipment.label, iter3_2.skin)

						if var9_2 then
							table.insert(var5_2, {
								id = iter5_2,
								ammo = var9_2,
								index = iter2_2
							})
						end
					end
				end
			else
				local var10_2 = var0_2[iter2_2]
				local var11_2 = var7_2(var10_2)

				if var11_2 then
					table.insert(var5_2, {
						id = var10_2,
						ammo = var11_2,
						index = iter2_2
					})
				end
			end
		end
	end

	local function var12_2(arg0_4, arg1_4)
		local var0_4 = arg1_2[arg1_4]
		local var1_4
		local var2_4

		if var0_4.equipment then
			var1_4 = var0_4.equipment.label
			var2_4 = var0_4.skin
		end

		local var3_4 = var2_2[arg1_4]

		arg0_2:AddDisposableTorpedo(arg0_4, var1_4, var2_4, var3_4, arg1_4):SetModifyInitialCD()
	end

	repeat
		local var13_2 = 0

		for iter6_2, iter7_2 in ipairs(var5_2) do
			if iter7_2.ammo <= 0 and var4_2 > 0 then
				iter7_2.ammo = iter7_2.ammo + 1
				var4_2 = var4_2 - 1
			end

			if iter7_2.ammo > 0 then
				var12_2(iter7_2.id, iter7_2.index)

				iter7_2.ammo = iter7_2.ammo - 1
			end

			var13_2 = var13_2 + iter7_2.ammo
		end
	until var13_2 == 0 and var4_2 == 0
end

function var7_0.AddDisposableTorpedo(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	local var0_5 = var0_0.Battle.BattleDataFunction.CreateWeaponUnit(arg1_5, arg0_5, arg4_5, arg5_5, var4_0.EquipmentType.DISPOSABLE_TORPEDO)

	arg0_5._totalWeapon[#arg0_5._totalWeapon + 1] = var0_5

	if arg2_5 then
		var0_5:SetEquipmentLabel(arg2_5)
	end

	arg0_5._manualTorpedoList[#arg0_5._manualTorpedoList + 1] = var0_5

	arg0_5._weaponQueue:AppendManualTorpedo(var0_5)

	if arg3_5 and arg3_5 ~= 0 then
		var0_5:SetSkinData(arg3_5)
		arg0_5:SetPriorityWeaponSkin(arg3_5)
	end

	return var0_5
end
