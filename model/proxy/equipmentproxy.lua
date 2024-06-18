local var0_0 = class("EquipmentProxy", import(".NetProxy"))

var0_0.EQUIPMENT_UPDATED = "equipment updated"
var0_0.EQUIPMENT_SKIN_UPDATED = "equipment skin updated"
var0_0.SPWEAPONS_UPDATED = "spweapons updated"
var0_0.MAX_SPWEAPON_BAG = 2000

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.equipmentSkinIds = {}
	arg0_1.shipIdListInTimeLimit = {}
	arg0_1.spWeapons = {}
	arg0_1.spWeaponCapacity = 0

	arg0_1:on(14001, function(arg0_2)
		arg0_1.data.equipments = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.equip_list) do
			local var0_2 = Equipment.New(iter1_2)

			arg0_1.data.equipments[var0_2.id] = var0_2
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.ship_id_list) do
			table.insert(arg0_1.shipIdListInTimeLimit, iter3_2)
		end

		for iter4_2, iter5_2 in ipairs(arg0_2.spweapon_list) do
			arg0_1:AddSpWeapon(SpWeapon.CreateByNet(iter5_2))
		end

		arg0_1:AddSpWeaponCapacity(arg0_2.spweapon_bag_size)
	end)
	arg0_1:on(14101, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.equip_skin_list) do
			arg0_1.equipmentSkinIds[iter1_3.id] = {
				id = iter1_3.id,
				count = iter1_3.count
			}
		end
	end)
	arg0_1:on(14200, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.spweapon_list) do
			local var0_4 = SpWeapon.CreateByNet(iter1_4)

			arg0_1:AddSpWeapon(var0_4)
		end
	end)

	arg0_1.weakTable = setmetatable({}, {
		__mode = "v"
	})
end

function var0_0.getEquipmentSkins(arg0_5)
	return arg0_5.equipmentSkinIds or {}
end

function var0_0.getSkinsByType(arg0_6, arg1_6)
	local var0_6 = {}
	local var1_6 = pg.equip_skin_template
	local var2_6 = arg0_6:getEquipmentSkins()

	for iter0_6, iter1_6 in pairs(var2_6) do
		assert(var1_6[iter1_6.id], "miss config equip_skin_template >> " .. iter1_6.id)

		if table.contains(var1_6[iter1_6.id].equip_type, arg1_6) then
			table.insert(var0_6, iter1_6)
		end
	end

	return var0_6
end

function var0_0.getSkinsByTypes(arg0_7, arg1_7)
	if not arg1_7 or #arg1_7 <= 0 then
		return {}
	end

	local var0_7 = {}
	local var1_7 = pg.equip_skin_template
	local var2_7 = arg0_7:getEquipmentSkins()

	for iter0_7, iter1_7 in pairs(var2_7) do
		assert(var1_7[iter1_7.id], "miss config equip_skin_template >> " .. iter1_7.id)

		local var3_7 = false

		for iter2_7 = 1, #arg1_7 do
			if table.contains(var1_7[iter1_7.id].equip_type, arg1_7[iter2_7]) then
				var3_7 = true
			end
		end

		if var3_7 then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.getEquipmnentSkinById(arg0_8, arg1_8)
	return arg0_8.equipmentSkinIds[arg1_8]
end

function var0_0.addEquipmentSkin(arg0_9, arg1_9, arg2_9)
	if arg0_9.equipmentSkinIds[arg1_9] then
		arg0_9.equipmentSkinIds[arg1_9].count = arg0_9.equipmentSkinIds[arg1_9].count + arg2_9
	else
		arg0_9.equipmentSkinIds[arg1_9] = {
			id = arg1_9,
			count = arg2_9
		}
	end

	arg0_9:sendNotification(var0_0.EQUIPMENT_SKIN_UPDATED, {
		id = arg1_9,
		count = arg0_9.equipmentSkinIds[arg1_9].count
	})
end

function var0_0.useageEquipmnentSkin(arg0_10, arg1_10)
	assert(arg0_10.equipmentSkinIds[arg1_10], "equipmentSkin is nil--" .. arg1_10)
	assert(arg0_10.equipmentSkinIds[arg1_10].count > 0, "equipmentSkin count should greater than zero")

	arg0_10.equipmentSkinIds[arg1_10].count = arg0_10.equipmentSkinIds[arg1_10].count - 1

	arg0_10:sendNotification(var0_0.EQUIPMENT_SKIN_UPDATED, {
		id = arg1_10,
		count = arg0_10.equipmentSkinIds[arg1_10].count
	})
end

function var0_0.addEquipment(arg0_11, arg1_11)
	assert(isa(arg1_11, Equipment), "should be an instance of Equipment")

	arg1_11.count, arg1_11 = (arg0_11.data.equipments[arg1_11.id] and arg0_11.data.equipments[arg1_11.id].count or 0) + arg1_11.count, arg0_11.data.equipments[arg1_11.id] or arg1_11

	arg0_11:updateEquipment(arg1_11)
end

function var0_0.addEquipmentById(arg0_12, arg1_12, arg2_12, arg3_12)
	assert(arg1_12 ~= 0, "equipmentProxy装备的id==0")
	assert(arg1_12 ~= 1, "equipmentProxy装备的id==1")
	assert(arg2_12 > 0, "count should greater than zero")
	arg0_12:addEquipment(Equipment.New({
		id = arg1_12,
		count = arg2_12,
		new = arg3_12 and 0 or 1
	}))
end

function var0_0.updateEquipment(arg0_13, arg1_13)
	assert(isa(arg1_13, Equipment), "should be an instance of Equipment")

	arg0_13.data.equipments[arg1_13.id] = arg1_13.count ~= 0 and arg1_13:clone() or nil

	arg1_13:display("updated")
	arg0_13:OnEquipsUpdate(arg1_13)
	arg0_13.facade:sendNotification(var0_0.EQUIPMENT_UPDATED, arg1_13:clone())
end

function var0_0.removeEquipmentById(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.data.equipments[arg1_14]

	assert(var0_14 ~= nil, "equipment should exist")
	assert(arg2_14 > 0, "count should greater than zero")
	assert(arg2_14 <= var0_14.count, "number of equipment should enough")

	var0_14.count = math.max(var0_14.count - arg2_14, 0)

	arg0_14:updateEquipment(var0_14)
end

function var0_0.getEquipments(arg0_15, arg1_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in pairs(arg0_15.data.equipments) do
		if iter1_15.count > 0 then
			table.insert(var0_15, iter1_15:clone())

			if arg1_15 then
				iter1_15.new = 0
			end
		end
	end

	return var0_15
end

function var0_0.getEquipmentsByFillter(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in pairs(arg0_16.data.equipments) do
		if iter1_16.count > 0 and table.contains(arg2_16, iter1_16:getConfig("type")) and not table.contains(iter1_16:getConfig("ship_type_forbidden"), arg1_16) then
			table.insert(var0_16, iter1_16:clone())
		end
	end

	return var0_16
end

function var0_0.GetEquipmentsRaw(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in pairs(arg0_17.data.equipments) do
		if iter1_17.count > 0 then
			table.insert(var0_17, iter1_17)
		end
	end

	return var0_17
end

function var0_0.getEquipmentById(arg0_18, arg1_18)
	if arg0_18.data.equipments[arg1_18] ~= nil then
		return arg0_18.data.equipments[arg1_18]:clone()
	end

	return nil
end

function var0_0.getSameTypeEquipmentId(arg0_19, arg1_19)
	local var0_19 = Equipment.New({
		id = arg1_19:getConfig("id")
	})
	local var1_19

	while var0_19.config.next ~= 0 do
		local var2_19 = arg0_19:getEquipmentById(var0_19.config.next)

		if var2_19 and var2_19.count > 0 then
			var1_19 = var2_19
		end

		var0_19 = Equipment.New({
			id = var0_19.config.next
		})
	end

	if not var1_19 then
		local var3_19 = Equipment.New({
			id = arg1_19:getConfig("id")
		})

		while var3_19.config.prev ~= 0 do
			local var4_19 = arg0_19:getEquipmentById(var3_19.config.prev)

			if var4_19 and var4_19.count > 0 then
				var1_19 = var4_19

				break
			end

			var3_19 = Equipment.New({
				id = var3_19.config.prev
			})
		end
	end

	if var1_19 then
		return var1_19.id
	end
end

function var0_0.getEquipCount(arg0_20)
	local var0_20 = 0

	for iter0_20, iter1_20 in pairs(arg0_20.data.equipments) do
		var0_20 = var0_20 + iter1_20.count
	end

	return var0_20
end

function var0_0.getEquipmentSkinCount(arg0_21)
	local var0_21 = arg0_21:getEquipmentSkins()
	local var1_21 = 0

	for iter0_21, iter1_21 in pairs(var0_21) do
		var1_21 = var1_21 + iter1_21.count
	end

	return var1_21
end

function var0_0.getCapacity(arg0_22)
	return (arg0_22:getEquipCount())
end

function var0_0.getTimeLimitShipList(arg0_23)
	local var0_23 = getProxy(BayProxy)
	local var1_23 = {}
	local var2_23

	for iter0_23, iter1_23 in ipairs(arg0_23.shipIdListInTimeLimit) do
		local var3_23 = var0_23:getShipById(iter1_23)

		if var3_23 then
			table.insert(var1_23, {
				count = 1,
				type = 4,
				id = var3_23.configId
			})
		end
	end

	return var1_23
end

function var0_0.clearTimeLimitShipList(arg0_24)
	arg0_24.shipIdListInTimeLimit = {}
end

function var0_0.GetSpWeapons(arg0_25)
	return arg0_25.spWeapons
end

function var0_0.GetSpWeaponByUid(arg0_26, arg1_26)
	return arg0_26.spWeapons[arg1_26]
end

function var0_0.StaticGetSpWeapon(arg0_27, arg1_27)
	local var0_27
	local var1_27

	if arg0_27 and arg0_27 > 0 then
		var0_27 = getProxy(BayProxy):getShipById(arg0_27)
		var1_27 = var0_27 and var0_27:GetSpWeapon()
	else
		var1_27 = getProxy(EquipmentProxy):GetSpWeaponByUid(arg1_27)
	end

	return var1_27, var0_27
end

function var0_0.GetSameTypeSpWeapon(arg0_28, arg1_28)
	local var0_28
	local var1_28 = arg1_28:GetConfigID()
	local var2_28

	while var1_28 ~= 0 do
		local var3_28 = SpWeapon.New({
			id = var1_28
		})

		if var3_28:GetRarity() ~= arg1_28:GetRarity() then
			break
		end

		for iter0_28, iter1_28 in pairs(arg0_28:GetSpWeapons()) do
			if iter1_28:GetConfigID() == var1_28 then
				var0_28 = iter1_28

				break
			end
		end

		if var0_28 then
			break
		else
			var1_28 = var3_28:GetNextUpgradeID()
		end
	end

	if not var0_28 then
		local var4_28 = arg1_28:GetPrevUpgradeID()
		local var5_28

		while var4_28 ~= 0 do
			local var6_28 = SpWeapon.New({
				id = var4_28
			})

			if var6_28:GetRarity() ~= arg1_28:GetRarity() then
				break
			end

			for iter2_28, iter3_28 in pairs(arg0_28:GetSpWeapons()) do
				if iter3_28:GetConfigID() == var4_28 then
					var0_28 = iter3_28

					break
				end
			end

			if var0_28 then
				break
			else
				var4_28 = var6_28:GetPrevUpgradeID()
			end
		end
	end

	return var0_28
end

function var0_0.GetSpWeaponCapacity(arg0_29)
	return arg0_29.spWeaponCapacity
end

function var0_0.AddSpWeaponCapacity(arg0_30, arg1_30)
	arg0_30.spWeaponCapacity = arg0_30.spWeaponCapacity + arg1_30
end

function var0_0.GetSpWeaponCount(arg0_31)
	return table.getCount(arg0_31:GetSpWeapons())
end

function var0_0.AddSpWeapon(arg0_32, arg1_32)
	arg1_32:SetShipId(nil)

	arg0_32.spWeapons[arg1_32:GetUID()] = arg1_32

	arg0_32.facade:sendNotification(var0_0.SPWEAPONS_UPDATED)
end

function var0_0.RemoveSpWeapon(arg0_33, arg1_33)
	arg0_33.spWeapons[arg1_33:GetUID()] = nil

	arg0_33.facade:sendNotification(var0_0.SPWEAPONS_UPDATED)
end

var0_0.EquipTransformTargetDict = {}

for iter0_0, iter1_0 in ipairs(pg.equip_upgrade_data.all) do
	local var1_0 = pg.equip_upgrade_data[iter1_0]

	var0_0.EquipTransformTargetDict[var1_0.upgrade_from] = var0_0.EquipTransformTargetDict[var1_0.upgrade_from] or {}
	var0_0.EquipTransformTargetDict[var1_0.upgrade_from].targets = var0_0.EquipTransformTargetDict[var1_0.upgrade_from].targets or {}

	table.insert(var0_0.EquipTransformTargetDict[var1_0.upgrade_from].targets, iter1_0)

	var0_0.EquipTransformTargetDict[var1_0.target_id] = var0_0.EquipTransformTargetDict[var1_0.target_id] or {}
	var0_0.EquipTransformTargetDict[var1_0.target_id].sources = var0_0.EquipTransformTargetDict[var1_0.target_id].sources or {}

	table.insert(var0_0.EquipTransformTargetDict[var1_0.target_id].sources, iter1_0)
end

function var0_0.GetTransformTargets(arg0_34)
	return var0_0.EquipTransformTargetDict[arg0_34] and var0_0.EquipTransformTargetDict[arg0_34].targets or {}
end

function var0_0.GetTransformSources(arg0_35)
	return var0_0.EquipTransformTargetDict[arg0_35] and var0_0.EquipTransformTargetDict[arg0_35].sources or {}
end

var0_0.EquipmentTransformTreeTemplate = {}

for iter2_0 = 1, 4 do
	var0_0.EquipmentTransformTreeTemplate[iter2_0] = {}
end

for iter3_0, iter4_0 in ipairs(pg.equip_upgrade_template.all) do
	local var2_0 = pg.equip_upgrade_template[iter4_0]

	var0_0.EquipmentTransformTreeTemplate[var2_0.category1] = var0_0.EquipmentTransformTreeTemplate[var2_0.category1] or {}
	var0_0.EquipmentTransformTreeTemplate[var2_0.category1][var2_0.category2] = var2_0
end

function var0_0.SameEquip(arg0_36, arg1_36)
	assert(arg0_36 and arg1_36, "Compare NIL Equip")

	if not arg0_36 or not arg1_36 then
		return false
	end

	return arg0_36.id == arg1_36.id and arg0_36.shipId == arg1_36.shipId and arg0_36.shipPos == arg1_36.shipPos
end

function var0_0.GetWeakEquipsDict(arg0_37)
	if arg0_37.weakTable.equipsDict then
		return arg0_37.weakTable.equipsDict
	end

	local var0_37 = EquipmentsDict.New()

	arg0_37.weakTable.equipsDict = var0_37

	collectgarbage("collect")

	return var0_37
end

function var0_0.OnEquipsUpdate(arg0_38, arg1_38)
	if not arg0_38.weakTable.equipsDict then
		return
	end

	arg0_38.weakTable.equipsDict:UpdateEquipment(arg1_38)
end

function var0_0.OnShipEquipsAdd(arg0_39, arg1_39, arg2_39, arg3_39)
	if not arg0_39.weakTable.equipsDict then
		return
	end

	arg1_39 = CreateShell(arg1_39)
	arg1_39.shipId = arg2_39
	arg1_39.shipPos = arg3_39

	arg0_39.weakTable.equipsDict:AddEquipment(arg1_39)
end

function var0_0.OnShipEquipsRemove(arg0_40, arg1_40, arg2_40, arg3_40)
	if not arg0_40.weakTable.equipsDict then
		return
	end

	arg1_40 = CreateShell(arg1_40)
	arg1_40.shipId = arg2_40
	arg1_40.shipPos = arg3_40

	arg0_40.weakTable.equipsDict:RemoveEquipment(arg1_40)
end

return var0_0
