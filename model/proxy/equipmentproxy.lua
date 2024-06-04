local var0 = class("EquipmentProxy", import(".NetProxy"))

var0.EQUIPMENT_UPDATED = "equipment updated"
var0.EQUIPMENT_SKIN_UPDATED = "equipment skin updated"
var0.SPWEAPONS_UPDATED = "spweapons updated"
var0.MAX_SPWEAPON_BAG = 2000

function var0.register(arg0)
	arg0.data = {}
	arg0.equipmentSkinIds = {}
	arg0.shipIdListInTimeLimit = {}
	arg0.spWeapons = {}
	arg0.spWeaponCapacity = 0

	arg0:on(14001, function(arg0)
		arg0.data.equipments = {}

		for iter0, iter1 in ipairs(arg0.equip_list) do
			local var0 = Equipment.New(iter1)

			arg0.data.equipments[var0.id] = var0
		end

		for iter2, iter3 in ipairs(arg0.ship_id_list) do
			table.insert(arg0.shipIdListInTimeLimit, iter3)
		end

		for iter4, iter5 in ipairs(arg0.spweapon_list) do
			arg0:AddSpWeapon(SpWeapon.CreateByNet(iter5))
		end

		arg0:AddSpWeaponCapacity(arg0.spweapon_bag_size)
	end)
	arg0:on(14101, function(arg0)
		for iter0, iter1 in ipairs(arg0.equip_skin_list) do
			arg0.equipmentSkinIds[iter1.id] = {
				id = iter1.id,
				count = iter1.count
			}
		end
	end)
	arg0:on(14200, function(arg0)
		for iter0, iter1 in ipairs(arg0.spweapon_list) do
			local var0 = SpWeapon.CreateByNet(iter1)

			arg0:AddSpWeapon(var0)
		end
	end)

	arg0.weakTable = setmetatable({}, {
		__mode = "v"
	})
end

function var0.getEquipmentSkins(arg0)
	return arg0.equipmentSkinIds or {}
end

function var0.getSkinsByType(arg0, arg1)
	local var0 = {}
	local var1 = pg.equip_skin_template
	local var2 = arg0:getEquipmentSkins()

	for iter0, iter1 in pairs(var2) do
		assert(var1[iter1.id], "miss config equip_skin_template >> " .. iter1.id)

		if table.contains(var1[iter1.id].equip_type, arg1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getSkinsByTypes(arg0, arg1)
	if not arg1 or #arg1 <= 0 then
		return {}
	end

	local var0 = {}
	local var1 = pg.equip_skin_template
	local var2 = arg0:getEquipmentSkins()

	for iter0, iter1 in pairs(var2) do
		assert(var1[iter1.id], "miss config equip_skin_template >> " .. iter1.id)

		local var3 = false

		for iter2 = 1, #arg1 do
			if table.contains(var1[iter1.id].equip_type, arg1[iter2]) then
				var3 = true
			end
		end

		if var3 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getEquipmnentSkinById(arg0, arg1)
	return arg0.equipmentSkinIds[arg1]
end

function var0.addEquipmentSkin(arg0, arg1, arg2)
	if arg0.equipmentSkinIds[arg1] then
		arg0.equipmentSkinIds[arg1].count = arg0.equipmentSkinIds[arg1].count + arg2
	else
		arg0.equipmentSkinIds[arg1] = {
			id = arg1,
			count = arg2
		}
	end

	arg0:sendNotification(var0.EQUIPMENT_SKIN_UPDATED, {
		id = arg1,
		count = arg0.equipmentSkinIds[arg1].count
	})
end

function var0.useageEquipmnentSkin(arg0, arg1)
	assert(arg0.equipmentSkinIds[arg1], "equipmentSkin is nil--" .. arg1)
	assert(arg0.equipmentSkinIds[arg1].count > 0, "equipmentSkin count should greater than zero")

	arg0.equipmentSkinIds[arg1].count = arg0.equipmentSkinIds[arg1].count - 1

	arg0:sendNotification(var0.EQUIPMENT_SKIN_UPDATED, {
		id = arg1,
		count = arg0.equipmentSkinIds[arg1].count
	})
end

function var0.addEquipment(arg0, arg1)
	assert(isa(arg1, Equipment), "should be an instance of Equipment")

	arg1.count, arg1 = (arg0.data.equipments[arg1.id] and arg0.data.equipments[arg1.id].count or 0) + arg1.count, arg0.data.equipments[arg1.id] or arg1

	arg0:updateEquipment(arg1)
end

function var0.addEquipmentById(arg0, arg1, arg2, arg3)
	assert(arg1 ~= 0, "equipmentProxy装备的id==0")
	assert(arg1 ~= 1, "equipmentProxy装备的id==1")
	assert(arg2 > 0, "count should greater than zero")
	arg0:addEquipment(Equipment.New({
		id = arg1,
		count = arg2,
		new = arg3 and 0 or 1
	}))
end

function var0.updateEquipment(arg0, arg1)
	assert(isa(arg1, Equipment), "should be an instance of Equipment")

	arg0.data.equipments[arg1.id] = arg1.count ~= 0 and arg1:clone() or nil

	arg1:display("updated")
	arg0:OnEquipsUpdate(arg1)
	arg0.facade:sendNotification(var0.EQUIPMENT_UPDATED, arg1:clone())
end

function var0.removeEquipmentById(arg0, arg1, arg2)
	local var0 = arg0.data.equipments[arg1]

	assert(var0 ~= nil, "equipment should exist")
	assert(arg2 > 0, "count should greater than zero")
	assert(arg2 <= var0.count, "number of equipment should enough")

	var0.count = math.max(var0.count - arg2, 0)

	arg0:updateEquipment(var0)
end

function var0.getEquipments(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data.equipments) do
		if iter1.count > 0 then
			table.insert(var0, iter1:clone())

			if arg1 then
				iter1.new = 0
			end
		end
	end

	return var0
end

function var0.getEquipmentsByFillter(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data.equipments) do
		if iter1.count > 0 and table.contains(arg2, iter1:getConfig("type")) and not table.contains(iter1:getConfig("ship_type_forbidden"), arg1) then
			table.insert(var0, iter1:clone())
		end
	end

	return var0
end

function var0.GetEquipmentsRaw(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data.equipments) do
		if iter1.count > 0 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getEquipmentById(arg0, arg1)
	if arg0.data.equipments[arg1] ~= nil then
		return arg0.data.equipments[arg1]:clone()
	end

	return nil
end

function var0.getSameTypeEquipmentId(arg0, arg1)
	local var0 = Equipment.New({
		id = arg1:getConfig("id")
	})
	local var1

	while var0.config.next ~= 0 do
		local var2 = arg0:getEquipmentById(var0.config.next)

		if var2 and var2.count > 0 then
			var1 = var2
		end

		var0 = Equipment.New({
			id = var0.config.next
		})
	end

	if not var1 then
		local var3 = Equipment.New({
			id = arg1:getConfig("id")
		})

		while var3.config.prev ~= 0 do
			local var4 = arg0:getEquipmentById(var3.config.prev)

			if var4 and var4.count > 0 then
				var1 = var4

				break
			end

			var3 = Equipment.New({
				id = var3.config.prev
			})
		end
	end

	if var1 then
		return var1.id
	end
end

function var0.getEquipCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data.equipments) do
		var0 = var0 + iter1.count
	end

	return var0
end

function var0.getEquipmentSkinCount(arg0)
	local var0 = arg0:getEquipmentSkins()
	local var1 = 0

	for iter0, iter1 in pairs(var0) do
		var1 = var1 + iter1.count
	end

	return var1
end

function var0.getCapacity(arg0)
	return (arg0:getEquipCount())
end

function var0.getTimeLimitShipList(arg0)
	local var0 = getProxy(BayProxy)
	local var1 = {}
	local var2

	for iter0, iter1 in ipairs(arg0.shipIdListInTimeLimit) do
		local var3 = var0:getShipById(iter1)

		if var3 then
			table.insert(var1, {
				count = 1,
				type = 4,
				id = var3.configId
			})
		end
	end

	return var1
end

function var0.clearTimeLimitShipList(arg0)
	arg0.shipIdListInTimeLimit = {}
end

function var0.GetSpWeapons(arg0)
	return arg0.spWeapons
end

function var0.GetSpWeaponByUid(arg0, arg1)
	return arg0.spWeapons[arg1]
end

function var0.StaticGetSpWeapon(arg0, arg1)
	local var0
	local var1

	if arg0 and arg0 > 0 then
		var0 = getProxy(BayProxy):getShipById(arg0)
		var1 = var0 and var0:GetSpWeapon()
	else
		var1 = getProxy(EquipmentProxy):GetSpWeaponByUid(arg1)
	end

	return var1, var0
end

function var0.GetSameTypeSpWeapon(arg0, arg1)
	local var0
	local var1 = arg1:GetConfigID()
	local var2

	while var1 ~= 0 do
		local var3 = SpWeapon.New({
			id = var1
		})

		if var3:GetRarity() ~= arg1:GetRarity() then
			break
		end

		for iter0, iter1 in pairs(arg0:GetSpWeapons()) do
			if iter1:GetConfigID() == var1 then
				var0 = iter1

				break
			end
		end

		if var0 then
			break
		else
			var1 = var3:GetNextUpgradeID()
		end
	end

	if not var0 then
		local var4 = arg1:GetPrevUpgradeID()
		local var5

		while var4 ~= 0 do
			local var6 = SpWeapon.New({
				id = var4
			})

			if var6:GetRarity() ~= arg1:GetRarity() then
				break
			end

			for iter2, iter3 in pairs(arg0:GetSpWeapons()) do
				if iter3:GetConfigID() == var4 then
					var0 = iter3

					break
				end
			end

			if var0 then
				break
			else
				var4 = var6:GetPrevUpgradeID()
			end
		end
	end

	return var0
end

function var0.GetSpWeaponCapacity(arg0)
	return arg0.spWeaponCapacity
end

function var0.AddSpWeaponCapacity(arg0, arg1)
	arg0.spWeaponCapacity = arg0.spWeaponCapacity + arg1
end

function var0.GetSpWeaponCount(arg0)
	return table.getCount(arg0:GetSpWeapons())
end

function var0.AddSpWeapon(arg0, arg1)
	arg1:SetShipId(nil)

	arg0.spWeapons[arg1:GetUID()] = arg1

	arg0.facade:sendNotification(var0.SPWEAPONS_UPDATED)
end

function var0.RemoveSpWeapon(arg0, arg1)
	arg0.spWeapons[arg1:GetUID()] = nil

	arg0.facade:sendNotification(var0.SPWEAPONS_UPDATED)
end

var0.EquipTransformTargetDict = {}

for iter0, iter1 in ipairs(pg.equip_upgrade_data.all) do
	local var1 = pg.equip_upgrade_data[iter1]

	var0.EquipTransformTargetDict[var1.upgrade_from] = var0.EquipTransformTargetDict[var1.upgrade_from] or {}
	var0.EquipTransformTargetDict[var1.upgrade_from].targets = var0.EquipTransformTargetDict[var1.upgrade_from].targets or {}

	table.insert(var0.EquipTransformTargetDict[var1.upgrade_from].targets, iter1)

	var0.EquipTransformTargetDict[var1.target_id] = var0.EquipTransformTargetDict[var1.target_id] or {}
	var0.EquipTransformTargetDict[var1.target_id].sources = var0.EquipTransformTargetDict[var1.target_id].sources or {}

	table.insert(var0.EquipTransformTargetDict[var1.target_id].sources, iter1)
end

function var0.GetTransformTargets(arg0)
	return var0.EquipTransformTargetDict[arg0] and var0.EquipTransformTargetDict[arg0].targets or {}
end

function var0.GetTransformSources(arg0)
	return var0.EquipTransformTargetDict[arg0] and var0.EquipTransformTargetDict[arg0].sources or {}
end

var0.EquipmentTransformTreeTemplate = {}

for iter2 = 1, 4 do
	var0.EquipmentTransformTreeTemplate[iter2] = {}
end

for iter3, iter4 in ipairs(pg.equip_upgrade_template.all) do
	local var2 = pg.equip_upgrade_template[iter4]

	var0.EquipmentTransformTreeTemplate[var2.category1] = var0.EquipmentTransformTreeTemplate[var2.category1] or {}
	var0.EquipmentTransformTreeTemplate[var2.category1][var2.category2] = var2
end

function var0.SameEquip(arg0, arg1)
	assert(arg0 and arg1, "Compare NIL Equip")

	if not arg0 or not arg1 then
		return false
	end

	return arg0.id == arg1.id and arg0.shipId == arg1.shipId and arg0.shipPos == arg1.shipPos
end

function var0.GetWeakEquipsDict(arg0)
	if arg0.weakTable.equipsDict then
		return arg0.weakTable.equipsDict
	end

	local var0 = EquipmentsDict.New()

	arg0.weakTable.equipsDict = var0

	collectgarbage("collect")

	return var0
end

function var0.OnEquipsUpdate(arg0, arg1)
	if not arg0.weakTable.equipsDict then
		return
	end

	arg0.weakTable.equipsDict:UpdateEquipment(arg1)
end

function var0.OnShipEquipsAdd(arg0, arg1, arg2, arg3)
	if not arg0.weakTable.equipsDict then
		return
	end

	arg1 = CreateShell(arg1)
	arg1.shipId = arg2
	arg1.shipPos = arg3

	arg0.weakTable.equipsDict:AddEquipment(arg1)
end

function var0.OnShipEquipsRemove(arg0, arg1, arg2, arg3)
	if not arg0.weakTable.equipsDict then
		return
	end

	arg1 = CreateShell(arg1)
	arg1.shipId = arg2
	arg1.shipPos = arg3

	arg0.weakTable.equipsDict:RemoveEquipment(arg1)
end

return var0
