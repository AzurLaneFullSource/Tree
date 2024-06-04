ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleAttr
local var4 = var0.Battle.BattleConst
local var5 = var4.EquipmentType
local var6 = var0.Battle.BattleConfig

var0.Battle.BattleSubUnit = class("BattleSubUnit", var0.Battle.BattlePlayerUnit)
var0.Battle.BattleSubUnit.__name = "BattleSubUnit"

local var7 = var0.Battle.BattleSubUnit

function var7.Ctor(arg0, arg1, arg2)
	var7.super.Ctor(arg0, arg1, arg2)

	arg0._type = var4.UnitType.PLAYER_UNIT
end

function var7.setWeapon(arg0, arg1)
	local var0 = arg0._tmpData.default_equip_list
	local var1 = arg0._tmpData.base_list
	local var2 = arg0._proficiencyList
	local var3 = arg0._tmpData.preload_count
	local var4 = 0

	for iter0, iter1 in ipairs(arg1) do
		if iter0 > Ship.WEAPON_COUNT and iter1 then
			var4 = var4 + iter1.torpedoAmmo
		end
	end

	local var5 = {}

	for iter2, iter3 in ipairs(arg1) do
		if iter3 and iter3.skin and iter3.skin ~= 0 and Equipment.IsOrbitSkin(iter3.skin) then
			arg0._orbitSkinIDList = arg0._orbitSkinIDList or {}

			table.insert(arg0._orbitSkinIDList, iter3.skin)
		end

		if iter2 <= Ship.WEAPON_COUNT then
			local var6 = var2[iter2]

			local function var7(arg0, arg1, arg2)
				local var0 = var1.GetWeaponPropertyDataFromID(arg0)

				if var0.type == var4.EquipmentType.TORPEDO then
					return var0.torpedo_ammo
				else
					local var1 = var1[iter2]

					for iter0 = 1, var1 do
						arg0:AddWeapon(arg0, arg1, arg2, var6, iter2)
					end

					return false
				end
			end

			if iter3.equipment then
				local var8 = iter3.equipment.weapon_id

				for iter4, iter5 in ipairs(var8) do
					if iter5 and iter5 ~= -1 then
						local var9 = var7(iter5, iter3.equipment.label, iter3.skin)

						if var9 then
							table.insert(var5, {
								id = iter5,
								ammo = var9,
								index = iter2
							})
						end
					end
				end
			else
				local var10 = var0[iter2]
				local var11 = var7(var10)

				if var11 then
					table.insert(var5, {
						id = var10,
						ammo = var11,
						index = iter2
					})
				end
			end
		end
	end

	local function var12(arg0, arg1)
		local var0 = arg1[arg1]
		local var1
		local var2

		if var0.equipment then
			var1 = var0.equipment.label
			var2 = var0.skin
		end

		local var3 = var2[arg1]

		arg0:AddDisposableTorpedo(arg0, var1, var2, var3, arg1):SetModifyInitialCD()
	end

	repeat
		local var13 = 0

		for iter6, iter7 in ipairs(var5) do
			if iter7.ammo <= 0 and var4 > 0 then
				iter7.ammo = iter7.ammo + 1
				var4 = var4 - 1
			end

			if iter7.ammo > 0 then
				var12(iter7.id, iter7.index)

				iter7.ammo = iter7.ammo - 1
			end

			var13 = var13 + iter7.ammo
		end
	until var13 == 0 and var4 == 0
end

function var7.AddDisposableTorpedo(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = var0.Battle.BattleDataFunction.CreateWeaponUnit(arg1, arg0, arg4, arg5, var4.EquipmentType.DISPOSABLE_TORPEDO)

	arg0._totalWeapon[#arg0._totalWeapon + 1] = var0

	if arg2 then
		var0:SetEquipmentLabel(arg2)
	end

	arg0._manualTorpedoList[#arg0._manualTorpedoList + 1] = var0

	arg0._weaponQueue:AppendManualTorpedo(var0)

	if arg3 and arg3 ~= 0 then
		var0:SetSkinData(arg3)
		arg0:SetPriorityWeaponSkin(arg3)
	end

	return var0
end
