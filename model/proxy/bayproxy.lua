local var0 = class("BayProxy", import(".NetProxy"))

var0.SHIP_ADDED = "ship added"
var0.SHIP_REMOVED = "ship removed"
var0.SHIP_UPDATED = "ship updated"
var0.SHIP_EQUIPMENT_ADDED = "ship equipment added"
var0.SHIP_EQUIPMENT_REMOVED = "ship equipment removed"

function var0.register(arg0)
	arg0:on(12001, function(arg0)
		arg0.data = {}
		arg0.activityNpcShipIds = {}
		arg0.metaShipIDList = {}
		arg0.equipCountDic = {}
		arg0.equipSkinCountDic = {}

		for iter0, iter1 in ipairs(arg0.shiplist) do
			local var0 = Ship.New(iter1)

			var0:display("loaded")

			arg0.shipHighestLevel = math.max(arg0.shipHighestLevel, var0.level)

			if var0:getConfigTable() then
				arg0.data[var0.id] = var0

				if var0:isActivityNpc() then
					table.insert(arg0.activityNpcShipIds, var0.id)
				elseif var0:isMetaShip() and not table.contains(arg0.metaShipIDList, var0.id) then
					table.insert(arg0.metaShipIDList, var0.id)
				end

				var0.recordShipLevelVertify(var0)
				arg0:UpdateShipEquipAndSkinCount(var0, true)
			else
				warning("不存在的角色: " .. var0.id)
			end
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end)
	arg0:on(12031, function(arg0)
		arg0.energyRecoverTime = arg0.energy_auto_increase_time + Ship.ENERGY_RECOVER_TIME

		local var0 = arg0.energyRecoverTime - pg.TimeMgr.GetInstance():GetServerTime()

		arg0:addEnergyListener(var0)
	end)
	arg0:on(12010, function(arg0)
		for iter0, iter1 in ipairs(arg0.ship_list) do
			local var0 = Ship.New(iter1)

			var0:display("loaded")

			arg0.shipHighestLevel = math.max(arg0.shipHighestLevel, var0.level)

			if var0:getConfigTable() then
				arg0.data[var0.id] = var0

				if var0:isActivityNpc() then
					table.insert(arg0.activityNpcShipIds, var0.id)
				elseif var0:isMetaShip() and not table.contains(arg0.metaShipIDList, var0.id) then
					table.insert(arg0.metaShipIDList, var0.id)
				end

				var0.recordShipLevelVertify(var0)
				arg0:UpdateShipEquipAndSkinCount(var0, true)
			else
				warning("不存在的角色: " .. var0.id)
			end
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end)
	arg0:on(12042, function(arg0)
		local var0 = getProxy(PlayerProxy):getInited()
		local var1 = 0

		arg0.newShipList = {}

		for iter0, iter1 in ipairs(arg0.ship_list) do
			local var2 = Ship.New(iter1)

			if var2:getConfigTable() and var2.id > 0 then
				arg0:addShip(var2, false)

				if var0 then
					var1 = var1 + 1
				end

				arg0.newShipList[#arg0.newShipList + 1] = var2
			else
				warning("不存在的角色: " .. var2.id)
			end
		end

		if var1 > 0 then
			arg0:countShip(var1)
		end

		arg0.metaTransItemMap = {}
	end)

	local var0 = getProxy(PlayerProxy)

	arg0:on(12019, function(arg0)
		local var0 = var0:getData()
		local var1 = arg0:getShipById(var0.character)

		var1:setLikability(arg0.intimacy)
		arg0:updateShip(var1)
	end)

	arg0.shipHighestLevel = 0
end

function var0.recoverAllShipEnergy(arg0)
	local var0 = pg.energy_template[3].upper_bound - 1
	local var1 = pg.energy_template[4].upper_bound
	local var2 = {}
	local var3 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	table.insertto(var3, getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2))
	table.Foreach(var3, function(arg0, arg1)
		if arg1 and not arg1:isEnd() then
			local var0 = arg1:GetEnergyRecoverAddition()

			_.each(arg1:getData1List(), function(arg0)
				var2[arg0] = (var2[arg0] or 0) + var0
			end)
		end
	end)

	for iter0, iter1 in pairs(arg0.data) do
		local var4 = iter1:getRecoverEnergyPoint()
		local var5 = 0
		local var6 = var0

		if iter1.state == Ship.STATE_REST or iter1.state == Ship.STATE_TRAIN then
			if iter1.state == Ship.STATE_TRAIN then
				var5 = var5 + Ship.BACKYARD_1F_ENERGY_ADDITION
			elseif iter1.state == Ship.STATE_REST then
				var5 = var5 + Ship.BACKYARD_2F_ENERGY_ADDITION
			end

			for iter2, iter3 in ipairs(getProxy(ActivityProxy):getBackyardEnergyActivityBuffs()) do
				var5 = var5 + tonumber(iter3:getConfig("benefit_effect"))
			end

			var6 = var1
		end

		if var2[iter1.id] then
			var5 = var5 + var2[iter1.id]
			var6 = var1
		end

		local var7 = math.max(math.min(var4, var6 - iter1:getEnergy()), 0)
		local var8 = math.min(iter1:getEnergy() + var7 + var5, var1)

		iter1:setEnergy(var8)
		arg0:updateShip(iter1)
	end
end

function var0.addEnergyListener(arg0, arg1)
	if arg1 <= 0 then
		arg0:recoverAllShipEnergy()
		arg0:addEnergyListener(Ship.ENERGY_RECOVER_TIME)

		return
	end

	if arg0.energyTimer then
		arg0.energyTimer:Stop()

		arg0.energyTimer = nil
	end

	arg0.energyTimer = Timer.New(function()
		arg0:recoverAllShipEnergy()
		arg0:addEnergyListener(Ship.ENERGY_RECOVER_TIME)
	end, arg1, 1)

	arg0.energyTimer:Start()
end

function var0.remove(arg0)
	if arg0.energyTimer then
		arg0.energyTimer:Stop()

		arg0.energyTimer = nil
	end
end

function var0.recordShipLevelVertify(arg0)
	if arg0 then
		ys.BattleShipLevelVertify[arg0.id] = var0.generateLevelVertify(arg0.level)
	end
end

function var0.checkShiplevelVertify(arg0)
	if var0.generateLevelVertify(arg0.level) == ys.BattleShipLevelVertify[arg0.id] then
		return true
	else
		return false
	end
end

function var0.generateLevelVertify(arg0)
	return (arg0 + 1114) * 824
end

function var0.addShip(arg0, arg1, arg2)
	assert(isa(arg1, Ship), "should be an instance of Ship")
	assert(arg0.data[arg1.id] == nil, "ship already exist, use updateShip() instead")

	arg0.data[arg1.id] = arg1

	var0.recordShipLevelVertify(arg1)
	arg0:UpdateShipEquipAndSkinCount(arg1, true)

	arg2 = defaultValue(arg2, true)

	if arg2 then
		arg0:countShip()
	end

	arg0.shipHighestLevel = math.max(arg0.shipHighestLevel, arg1.level)

	if arg1:isActivityNpc() then
		table.insert(arg0.activityNpcShipIds, arg1.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	else
		if arg1:isMetaShip() and not table.contains(arg0.metaShipIDList, arg1.id) then
			table.insert(arg0.metaShipIDList, arg1.id)
			getProxy(MetaCharacterProxy):requestMetaTacticsInfo({
				arg1.id
			})
		end

		local var0 = getProxy(CollectionProxy)

		if var0 then
			var0:flushCollection(arg1)
		end
	end

	if getProxy(PlayerProxy):getInited() then
		arg0.facade:sendNotification(var0.SHIP_ADDED, arg1:clone())
	end
end

function var0.countShip(arg0, arg1)
	local var0 = getProxy(PlayerProxy)
	local var1 = var0:getData()

	var1:increaseShipCount(arg1)
	var0:updatePlayer(var1)
end

function var0.getNewShip(arg0, arg1)
	local var0 = arg0.newShipList or {}

	if arg1 then
		arg0.newShipList = nil
	end

	return var0
end

function var0.getMetaTransItemMap(arg0, arg1)
	local var0

	if arg0.metaTransItemMap and arg0.metaTransItemMap[arg1] and #arg0.metaTransItemMap[arg1] > 0 then
		var0 = arg0.metaTransItemMap[arg1][1]

		table.remove(arg0.metaTransItemMap[arg1], 1)
	end

	return var0
end

function var0.addMetaTransItemMap(arg0, arg1, arg2)
	if not arg0.metaTransItemMap then
		arg0.metaTransItemMap = {}
	end

	if not arg0.metaTransItemMap[arg1] then
		arg0.metaTransItemMap[arg1] = {}
	end

	table.insert(arg0.metaTransItemMap[arg1], arg2)
end

function var0.getShipsByFleet(arg0, arg1)
	assert(isa(arg1, Fleet), "should be an instance of Fleet")

	local var0 = {}

	for iter0, iter1 in ipairs(arg1:getShipIds()) do
		table.insert(var0, arg0.data[iter1])
	end

	return var0
end

function var0.getSortShipsByFleet(arg0, arg1)
	assert(isa(arg1, Fleet), "should be an instance of Fleet")

	local var0 = {}

	for iter0, iter1 in ipairs(arg1.mainShips) do
		table.insert(var0, arg0.data[iter1])
	end

	for iter2, iter3 in ipairs(arg1.vanguardShips) do
		table.insert(var0, arg0.data[iter3])
	end

	for iter4, iter5 in ipairs(arg1.subShips) do
		table.insert(var0, arg0.data[iter5])
	end

	return var0
end

function var0.getShipByTeam(arg0, arg1, arg2)
	assert(isa(arg1, Fleet), "should be an instance of Fleet")

	local var0 = {}

	if arg2 == TeamType.Vanguard then
		for iter0, iter1 in ipairs(arg1.vanguardShips) do
			table.insert(var0, arg0.data[iter1])
		end
	elseif arg2 == TeamType.Main then
		for iter2, iter3 in ipairs(arg1.mainShips) do
			table.insert(var0, arg0.data[iter3])
		end
	elseif arg2 == TeamType.Submarine then
		for iter4, iter5 in ipairs(arg1.subShips) do
			table.insert(var0, arg0.data[iter5])
		end
	end

	return Clone(var0)
end

function var0.getShipsByTypes(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if table.contains(arg1, iter1:getShipType()) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getShipsByStatus(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.status == arg1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getShipsByTeamType(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:getTeamType() == arg1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getConfigShipCount(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.configId == arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.getShips(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.getRawShipCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		var0 = var0 + 1
	end

	return var0
end

function var0.getShipCount(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(getGameset("unoccupied_ship_nationality")[2]) do
		var0[iter1] = true
	end

	local var1 = 0
	local var2 = 0

	for iter2, iter3 in pairs(arg0.data) do
		if var0[iter3:getNation()] then
			var2 = var2 + 1
		else
			var1 = var1 + 1
		end
	end

	return var1, var2
end

function var0.getShipById(arg0, arg1)
	if arg0.data[arg1] ~= nil then
		return arg0.data[arg1]:clone()
	end
end

function var0.RawGetShipById(arg0, arg1)
	return arg0.data[arg1]
end

function var0.getMetaShipByGroupId(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1:isMetaShip() and iter1.metaCharacter.id == arg1 then
			return iter1
		end
	end
end

function var0.getMetaShipIDList(arg0)
	return arg0.metaShipIDList
end

function var0.updateShip(arg0, arg1)
	if arg1.isNpc then
		return
	end

	assert(isa(arg1, Ship), "should be an instance of Ship")
	assert(arg0.data[arg1.id] ~= nil, "ship should exist")

	if arg1.level > arg0.shipHighestLevel then
		arg0.shipHighestLevel = arg1.level

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_HIGHEST_LEVEL, arg0.shipHighestLevel)
	end

	local var0 = arg0.data[arg1.id]

	arg0:UpdateShipEquipAndSkinCount(var0, false)

	arg0.data[arg1.id] = arg1

	var0.recordShipLevelVertify(arg1)
	arg0:UpdateShipEquipAndSkinCount(arg1, true)

	if var0:isActivityNpc() and not arg1:isActivityNpc() then
		table.removebyvalue(arg0.activityNpcShipIds, arg1.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	if var0.level < arg1.level then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_LEVEL_UP, arg1.level - var0.level)
	end

	if var0:getStar() < arg1:getStar() or var0.intimacy < arg1.intimacy or var0.level < arg1.level or not var0.propose and arg1.propose then
		local var1 = getProxy(CollectionProxy)

		if var1 and not arg1:isActivityNpc() then
			var1:flushCollection(arg1)
		end
	end

	arg0.facade:sendNotification(var0.SHIP_UPDATED, arg1:clone())
end

function var0.removeShip(arg0, arg1)
	assert(isa(arg1, Ship), "should be an instance of Ship")
	arg0:removeShipById(arg1.id)
end

function var0.getEquipment2ByflagShip(arg0)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = arg0:getShipById(var0.character)

	assert(var1, "ship is nil")

	return var1:getEquip(2)
end

function var0.removeShipById(arg0, arg1)
	local var0 = arg0.data[arg1]

	assert(var0 ~= nil, "ship should exist")

	if var0:isActivityNpc() then
		table.removebyvalue(arg0.activityNpcShipIds, var0.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	arg0.data[var0.id] = nil

	var0:display("removed")
	arg0:UpdateShipEquipAndSkinCount(var0, false)
	arg0.facade:sendNotification(var0.SHIP_REMOVED, var0)
end

function var0.findShipByGroup(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1.groupId == arg1 then
			return iter1
		end
	end

	return nil
end

function var0.findShipsByGroup(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.groupId == arg1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0._findShipsByGroup(arg0, arg1, arg2, arg3)
	local function var0(arg0)
		if arg2 then
			return arg0:isRemoulded()
		else
			return true
		end
	end

	local function var1(arg0)
		if arg3 then
			return arg0.propose
		else
			return true
		end
	end

	local var2 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.groupId == arg1 and var0(iter1) and var1(iter1) then
			table.insert(var2, iter1)
		end
	end

	return var2
end

function var0.ExistGroupShip(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1.groupId == arg1 then
			return true
		end
	end

	return false
end

function var0._ExistGroupShip(arg0, arg1, arg2, arg3)
	local function var0(arg0)
		if arg2 then
			return arg0:isRemoulded()
		else
			return true
		end
	end

	local function var1(arg0)
		if arg3 then
			return arg0.propose
		else
			return true
		end
	end

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.groupId == arg1 and var0(iter1) and var1(iter1) then
			return true
		end
	end

	return false
end

function var0.getSameGroupShipCount(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.groupId == arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.getUpgradeShips(arg0, arg1)
	local var0 = arg1:getConfig("rarity")
	local var1 = arg1.groupId
	local var2 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.groupId == var1 or iter1:isTestShip() and iter1:canUseTestShip(var0) then
			table.insert(var2, iter1)
		end
	end

	return var2
end

function var0.getBayPower(arg0)
	local var0 = {}
	local var1 = 0

	for iter0, iter1 in pairs(arg0.data) do
		local var2 = iter1.configId
		local var3 = iter1:getShipCombatPower()

		if ShipGroup.GetGroupConfig(iter1:getGroupId()).handbook_type ~= 1 and (not var0[var2] or var3 > var0[var2]) then
			var1 = var1 - defaultValue(var0[var2], 0)
			var0[var2] = var3
			var1 = var1 + var3
		end
	end

	return var1
end

function var0.GetBayPowerRootedAsyn(arg0, arg1)
	local var0

	var0 = coroutine.wrap(function()
		local var0 = {}
		local var1 = 0
		local var2 = 0

		for iter0, iter1 in pairs(arg0.data) do
			local var3 = iter1.configId
			local var4 = iter1:getShipCombatPower()

			if ShipGroup.GetGroupConfig(iter1:getGroupId()).handbook_type ~= 1 and (not var0[var3] or var4 > var0[var3]) then
				var1 = var1 - defaultValue(var0[var3], 0)
				var0[var3] = var4
				var1 = var1 + var4
			end

			var2 = var2 + 1

			if var2 == 1 or var2 % 50 == 0 then
				onNextTick(var0)
				coroutine.yield()
			end
		end

		arg1(var1^0.667)
	end)

	var0()
end

function var0.getBayPowerRooted(arg0)
	return arg0:getBayPower()^0.667
end

function var0.getEquipsInShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		for iter2, iter3 in pairs(iter1.equipments) do
			if iter3 and (not arg1 or arg1(iter3, iter1.id)) then
				table.insert(var0, setmetatable({
					shipId = iter1.id,
					shipPos = iter2
				}, {
					__index = iter3
				}))
			end
		end
	end

	return var0
end

function var0.UpdateShipEquipAndSkinCount(arg0, arg1, arg2)
	if not arg1 then
		return
	end

	local var0 = arg2 and 1 or -1

	for iter0, iter1 in pairs(arg1.equipments) do
		if iter1 then
			arg0.equipCountDic[iter1.id] = defaultValue(arg0.equipCountDic[iter1.id], 0) + var0

			assert(arg0.equipCountDic[iter1.id] >= 0)
		end
	end

	for iter2, iter3 in pairs(arg1.equipmentSkins) do
		if iter3 > 0 then
			arg0.equipSkinCountDic[iter3] = defaultValue(arg0.equipSkinCountDic[iter3], 0) + var0

			assert(arg0.equipSkinCountDic[iter3] >= 0)
		end
	end
end

function var0.GetEquipCountInShips(arg0, arg1)
	return arg0.equipCountDic[arg1] or 0
end

function var0.GetEquipSkinCountInShips(arg0, arg1)
	return arg0.equipSkinCountDic[arg1] or 0
end

function var0.GetEquipsInShipsRaw(arg0)
	local function var0(arg0, arg1, arg2)
		local var0 = CreateShell(arg0)

		var0.shipId = arg1
		var0.shipPos = arg2

		return var0
	end

	local var1 = {}

	for iter0, iter1 in pairs(arg0.data) do
		for iter2, iter3 in pairs(iter1.equipments) do
			if iter3 then
				table.insert(var1, var0(iter3, iter1.id, iter2))
			end
		end
	end

	return var1
end

function var0.getEquipmentSkinInShips(arg0, arg1, arg2)
	local function var0(arg0)
		local var0 = false

		if arg0 and arg0 > 0 then
			local var1 = pg.equip_skin_template[arg0]

			var0 = _.any(var1.equip_type, function(arg0)
				return not arg2 or table.contains(arg2, arg0)
			end)
		end

		return var0
	end

	local var1 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if not arg1 or arg1.id ~= iter1.id then
			for iter2, iter3 in pairs(iter1:getEquipSkins()) do
				local var2 = var0(iter3)

				if iter3 and var2 then
					table.insert(var1, {
						id = iter3,
						shipId = iter1.id,
						shipPos = iter2
					})
				end
			end
		end
	end

	return var1
end

function var0.GetSpWeaponsInShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if not arg1 or arg1.id ~= iter1.id then
			local var1 = iter1:GetSpWeapon()

			if var1 and (not arg1 or not arg1:IsSpWeaponForbidden(var1)) then
				table.insert(var0, var1)
			end
		end
	end

	return var0
end

function var0.getProposeGroupList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:ShowPropose() then
			var0[iter1.groupId] = true
		end
	end

	return var0
end

function var0.GetRecommendShip(arg0, arg1, arg2, arg3)
	assert(arg3)

	local var0 = arg0:getShipsByTypes(arg1)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[iter1] = iter1:getShipCombatPower()
	end

	table.sort(var0, function(arg0, arg1)
		return var1[arg0] < var1[arg1]
	end)

	local var2 = {}

	for iter2, iter3 in ipairs(arg2) do
		var2[#var2 + 1] = arg0.data[iter3]:getGroupId()
	end

	local var3 = #var0
	local var4

	while var3 > 0 do
		local var5 = var0[var3]
		local var6 = var5.id
		local var7 = var5:getGroupId()

		if not table.contains(arg2, var6) and not table.contains(var2, var7) and arg3(var5) then
			var4 = var5

			break
		else
			var3 = var3 - 1
		end
	end

	return var4
end

function var0.getActivityRecommendShips(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:getShipsByTypes(arg1)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[iter1] = iter1:getShipCombatPower()
	end

	table.sort(var0, function(arg0, arg1)
		return var1[arg0] < var1[arg1]
	end)

	local var2 = {}

	for iter2, iter3 in ipairs(arg2) do
		local var3 = arg0.data[iter3]

		var2[#var2 + 1] = var3:getGroupId()
	end

	local var4 = #var0
	local var5 = {}

	while var4 > 0 and arg3 > 0 do
		local var6 = var0[var4]
		local var7 = var6.id
		local var8 = var6:getGroupId()

		if not table.contains(arg2, var7) and not table.contains(var2, var8) and ShipStatus.ShipStatusCheck("inActivity", var6, nil, {
			inActivity = arg4
		}) then
			table.insert(var5, var6)
			table.insert(var2, var8)

			arg3 = arg3 - 1
		end

		var4 = var4 - 1
	end

	return var5
end

function var0.getDelegationRecommendShips(arg0, arg1)
	local var0 = 6 - #arg1.shipIds
	local var1 = arg1.template.ship_type
	local var2 = arg1.template.ship_lv
	local var3 = math.max(var2, 2)
	local var4 = Clone(arg1.shipIds)
	local var5 = arg0:getShipsByTypes(var1)

	table.sort(var5, function(arg0, arg1)
		return arg0.level > arg1.level
	end)

	local var6 = {}
	local var7 = false

	for iter0, iter1 in ipairs(var4) do
		local var8 = arg0.data[iter1]

		if var3 <= var8.level then
			var7 = true
		end

		var6[#var6 + 1] = var8:getGroupId()
	end

	if var7 then
		var3 = 2
	end

	local var9 = {}
	local var10 = #var5

	while var10 > 0 do
		if var0 <= 0 then
			break
		end

		local var11 = var5[var10]
		local var12 = var11.id
		local var13 = var11:getGroupId()

		if var3 <= var11.level and var11.lockState ~= Ship.LOCK_STATE_UNLOCK and not table.contains(var4, var12) and not table.contains(var6, var13) and not table.contains(var9, var12) and not var11:getFlag("inElite") and not var11:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var11) then
			table.insert(var6, var13)
			table.insert(var9, var12)

			var0 = var0 - 1

			if var7 == false then
				var7 = true
				var3 = 2
				var10 = #var5
			end
		else
			var10 = var10 - 1
		end
	end

	return var9
end

function var0.getDelegationRecommendShipsLV1(arg0, arg1)
	local var0 = 6 - #arg1.shipIds
	local var1 = arg1.template.ship_type
	local var2 = Clone(arg1.shipIds)
	local var3 = arg0:getShipsByTypes(var1)
	local var4 = _.select(var3, function(arg0)
		return arg0.level == 1
	end)

	table.sort(var4, CompareFuncs({
		function(arg0)
			return arg0.lockState == arg0.LOCK_STATE_UNLOCK and 0 or 1
		end
	}))

	local var5 = {}

	for iter0, iter1 in ipairs(var2) do
		local var6 = arg0.data[iter1]

		var5[#var5 + 1] = var6:getGroupId()
	end

	local var7 = {}
	local var8 = #var4

	while var8 > 0 do
		if var0 <= 0 then
			break
		end

		local var9 = var4[var8]
		local var10 = var9.id
		local var11 = var9:getGroupId()

		if not table.contains(var2, var10) and not table.contains(var5, var11) and not table.contains(var7, var10) and not var9:getFlag("inElite") and not var9:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var9) then
			table.insert(var5, var11)
			table.insert(var7, var10)

			var0 = var0 - 1
		else
			var8 = var8 - 1
		end
	end

	return var7
end

function var0.getWorldRecommendShip(arg0, arg1, arg2)
	local var0 = arg0:getShipsByTeamType(arg1)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[iter1] = iter1:getShipCombatPower()
	end

	table.sort(var0, function(arg0, arg1)
		return var1[arg0] < var1[arg1]
	end)

	local var2 = {}

	for iter2, iter3 in ipairs(arg2) do
		var2[#var2 + 1] = arg0.data[iter3]:getGroupId()
	end

	local var3 = #var0
	local var4

	while var3 > 0 do
		local var5 = var0[var3]
		local var6 = var5.id
		local var7 = var5:getGroupId()

		if not table.contains(arg2, var6) and not table.contains(var2, var7) and ShipStatus.ShipStatusCheck("inWorld", var5) then
			var4 = var5

			break
		else
			var3 = var3 - 1
		end
	end

	return var4
end

function var0.getModRecommendShip(arg0, arg1, arg2)
	local var0 = underscore.map(arg2, function(arg0)
		return arg0.data[arg0]
	end)
	local var1 = Clone(arg1)

	for iter0, iter1 in pairs(ShipModLayer.getModExpAdditions(var1, var0)) do
		var1:addModAttrExp(iter0, iter1)
	end

	local var2 = var1:getNeedModExp()
	local var3 = 0

	for iter2, iter3 in pairs(var2) do
		var3 = var3 + iter3
	end

	local var4 = {}

	for iter4, iter5 in pairs(arg0.data) do
		if iter5:isSameKind(arg1) then
			var4.sameKind = var4.sameKind or {}

			table.insert(var4.sameKind, iter5)
		else
			local var5 = iter5:getShipType()

			var4[var5] = var4[var5] or {}

			table.insert(var4[var5], iter5)
		end
	end

	local var6 = arg1:getConfig("type")

	for iter6, iter7 in ipairs(table.mergeArray({
		"sameKind"
	}, pg.ship_data_by_type[var6].strengthen_choose_type)) do
		if #var0 == 12 or var3 == 0 then
			break
		end

		local var7 = var4[iter7] or {}
		local var8 = {}

		for iter8, iter9 in ipairs(pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_2, underscore.map(var7, function(arg0)
			return arg0.id
		end))) do
			var8[iter9] = true
		end

		local var9 = underscore.filter(var7, function(arg0)
			return arg0.level == 1 and arg0:getRarity() <= ShipRarity.Gray and arg0:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2, arg0.id) and arg1.id ~= arg0.id and not var8[arg0.id]
		end)

		for iter10, iter11 in ipairs(var9) do
			if #var0 == 12 or var3 == 0 then
				break
			end

			local var10 = ShipModLayer.getModExpAdditions(var1, {
				iter11
			})
			local var11 = false

			for iter12, iter13 in pairs(var10) do
				if iter13 > 0 and var2[iter12] > 0 then
					var11 = true
					var3 = var3 - math.min(var2[iter12], iter13)
					var2[iter12] = math.max(var2[iter12] - iter13, 0)
				end
			end

			if var11 then
				table.insert(var0, iter11)
			end
		end
	end

	return underscore.map(var0, function(arg0)
		return arg0.id
	end)
end

function var0.getUpgradeRecommendShip(arg0, arg1, arg2, arg3)
	local var0 = arg0:getUpgradeShips(arg1)
	local var1 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_4, underscore.keys(arg0.data))

	local function var2(arg0)
		return arg0.level == 1 and arg0:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2, arg0.id) and arg1.id ~= arg0.id and not table.contains(var1, arg0.id)
	end

	local var3 = {}

	for iter0, iter1 in ipairs(var0) do
		if var2(iter1) then
			table.insert(var3, iter1)
		end
	end

	local var4 = {
		function(arg0)
			return arg0:isSameKind(arg1) and 0 or 1
		end
	}

	table.sort(var3, CompareFuncs(var4))

	local var5 = {}

	for iter2, iter3 in pairs(arg2) do
		table.insert(var5, arg0.data[iter3])
	end

	for iter4, iter5 in ipairs(var3) do
		if #var5 == arg3 then
			break
		end

		table.insert(var5, iter5)
	end

	return underscore.map(var5, function(arg0)
		return arg0.id
	end)
end

function var0.getGroupPropose(arg0, arg1)
	local var0 = false

	if arg0.data then
		for iter0, iter1 in ipairs(arg0.data) do
			if pg.ship_data_template[iter1.configId].group_type == arg1 and iter1.propose then
				return true
			end
		end
	end

	return var0
end

function var0.CanUseShareSkinShips(arg0, arg1)
	local var0 = pg.ship_skin_template[arg1].ship_group
	local var1 = pg.ship_data_group.get_id_list_by_group_type[var0][1]
	local var2 = pg.ship_data_group[var1].share_group_id
	local var3 = {}
	local var4 = arg0:getRawData()

	for iter0, iter1 in pairs(var4) do
		if table.contains(var2, iter1.groupId) and math.floor(iter1:getIntimacy() / 100) >= iter1:GetNoProposeIntimacyMax() then
			table.insert(var3, iter1)
		end
	end

	return var3
end

return var0
