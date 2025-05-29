local var0_0 = class("BayProxy", import(".NetProxy"))

var0_0.SHIP_ADDED = "ship added"
var0_0.SHIP_REMOVED = "ship removed"
var0_0.SHIP_UPDATED = "ship updated"
var0_0.SHIP_EQUIPMENT_ADDED = "ship equipment added"
var0_0.SHIP_EQUIPMENT_REMOVED = "ship equipment removed"

function var0_0.register(arg0_1)
	arg0_1:on(12001, function(arg0_2)
		arg0_1.data = {}
		arg0_1.activityNpcShipIds = {}
		arg0_1.metaShipIDList = {}
		arg0_1.equipCountDic = {}
		arg0_1.equipSkinCountDic = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.shiplist) do
			local var0_2 = Ship.New(iter1_2)

			var0_2:display("loaded")

			arg0_1.shipHighestLevel = math.max(arg0_1.shipHighestLevel, var0_2.level)

			if var0_2:getConfigTable() then
				arg0_1.data[var0_2.id] = var0_2

				if var0_2:isActivityNpc() then
					table.insert(arg0_1.activityNpcShipIds, var0_2.id)
				elseif var0_2:isMetaShip() and not table.contains(arg0_1.metaShipIDList, var0_2.id) then
					table.insert(arg0_1.metaShipIDList, var0_2.id)
				end

				var0_0.recordShipLevelVertify(var0_2)
				arg0_1:UpdateShipEquipAndSkinCount(var0_2, true)
			else
				warning("不存在的角色: " .. var0_2.id)
			end
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end)
	arg0_1:on(12031, function(arg0_3)
		arg0_1.energyRecoverTime = arg0_3.energy_auto_increase_time + Ship.ENERGY_RECOVER_TIME

		local var0_3 = arg0_1.energyRecoverTime - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_1:addEnergyListener(var0_3)
	end)
	arg0_1:on(12010, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.ship_list) do
			local var0_4 = Ship.New(iter1_4)

			var0_4:display("loaded")

			arg0_1.shipHighestLevel = math.max(arg0_1.shipHighestLevel, var0_4.level)

			if var0_4:getConfigTable() then
				arg0_1.data[var0_4.id] = var0_4

				if var0_4:isActivityNpc() then
					table.insert(arg0_1.activityNpcShipIds, var0_4.id)
				elseif var0_4:isMetaShip() and not table.contains(arg0_1.metaShipIDList, var0_4.id) then
					table.insert(arg0_1.metaShipIDList, var0_4.id)
				end

				var0_0.recordShipLevelVertify(var0_4)
				arg0_1:UpdateShipEquipAndSkinCount(var0_4, true)
			else
				warning("不存在的角色: " .. var0_4.id)
			end
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end)
	arg0_1:on(12042, function(arg0_5)
		local var0_5 = getProxy(PlayerProxy):getInited()
		local var1_5 = 0

		arg0_1.newShipList = {}

		for iter0_5, iter1_5 in ipairs(arg0_5.ship_list) do
			local var2_5 = Ship.New(iter1_5)

			if var2_5:getConfigTable() and var2_5.id > 0 then
				arg0_1:addShip(var2_5, false)

				if var0_5 then
					var1_5 = var1_5 + 1
				end

				arg0_1.newShipList[#arg0_1.newShipList + 1] = var2_5
			else
				warning("不存在的角色: " .. var2_5.id)
			end
		end

		if var1_5 > 0 then
			arg0_1:countShip(var1_5)
		end

		arg0_1.metaTransItemMap = {}
	end)

	local var0_1 = getProxy(PlayerProxy)

	arg0_1:on(12019, function(arg0_6)
		local var0_6 = var0_1:getData()
		local var1_6 = arg0_1:getShipById(var0_6.character)

		var1_6:setLikability(arg0_6.intimacy)
		arg0_1:updateShip(var1_6)
	end)

	arg0_1.shipHighestLevel = 0
end

function var0_0.recoverAllShipEnergy(arg0_7)
	local var0_7 = pg.energy_template[3].upper_bound - 1
	local var1_7 = pg.energy_template[4].upper_bound
	local var2_7 = {}
	local var3_7 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	table.insertto(var3_7, getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2))
	table.Foreach(var3_7, function(arg0_8, arg1_8)
		if arg1_8 and not arg1_8:isEnd() then
			local var0_8 = arg1_8:GetEnergyRecoverAddition()

			_.each(arg1_8:getData1List(), function(arg0_9)
				var2_7[arg0_9] = (var2_7[arg0_9] or 0) + var0_8
			end)
		end
	end)

	for iter0_7, iter1_7 in pairs(arg0_7.data) do
		local var4_7 = iter1_7:getRecoverEnergyPoint()
		local var5_7 = 0
		local var6_7 = var0_7

		if iter1_7.state == Ship.STATE_REST or iter1_7.state == Ship.STATE_TRAIN then
			if iter1_7.state == Ship.STATE_TRAIN then
				var5_7 = var5_7 + Ship.BACKYARD_1F_ENERGY_ADDITION
			elseif iter1_7.state == Ship.STATE_REST then
				var5_7 = var5_7 + Ship.BACKYARD_2F_ENERGY_ADDITION
			end

			for iter2_7, iter3_7 in ipairs(getProxy(ActivityProxy):getBackyardEnergyActivityBuffs()) do
				var5_7 = var5_7 + tonumber(iter3_7:getConfig("benefit_effect"))
			end

			var6_7 = var1_7
		end

		if var2_7[iter1_7.id] then
			var5_7 = var5_7 + var2_7[iter1_7.id]
			var6_7 = var1_7
		end

		local var7_7 = math.max(math.min(var4_7, var6_7 - iter1_7:getEnergy()), 0)
		local var8_7 = math.min(iter1_7:getEnergy() + var7_7 + var5_7, var1_7)

		iter1_7:setEnergy(var8_7)
		arg0_7:updateShip(iter1_7)
	end
end

function var0_0.addEnergyListener(arg0_10, arg1_10)
	if arg1_10 <= 0 then
		arg0_10:recoverAllShipEnergy()
		arg0_10:addEnergyListener(Ship.ENERGY_RECOVER_TIME)

		return
	end

	if arg0_10.energyTimer then
		arg0_10.energyTimer:Stop()

		arg0_10.energyTimer = nil
	end

	arg0_10.energyTimer = Timer.New(function()
		arg0_10:recoverAllShipEnergy()
		arg0_10:addEnergyListener(Ship.ENERGY_RECOVER_TIME)
	end, arg1_10, 1)

	arg0_10.energyTimer:Start()
end

function var0_0.remove(arg0_12)
	if arg0_12.energyTimer then
		arg0_12.energyTimer:Stop()

		arg0_12.energyTimer = nil
	end
end

function var0_0.recordShipLevelVertify(arg0_13)
	if arg0_13 then
		ys.BattleShipLevelVertify[arg0_13.id] = var0_0.generateLevelVertify(arg0_13.level)
	end
end

function var0_0.checkShiplevelVertify(arg0_14)
	if var0_0.generateLevelVertify(arg0_14.level) == ys.BattleShipLevelVertify[arg0_14.id] then
		return true
	else
		return false
	end
end

function var0_0.generateLevelVertify(arg0_15)
	return (arg0_15 + 1114) * 824
end

function var0_0.addShip(arg0_16, arg1_16, arg2_16)
	assert(isa(arg1_16, Ship), "should be an instance of Ship")
	assert(arg0_16.data[arg1_16.id] == nil, "ship already exist, use updateShip() instead")

	arg0_16.data[arg1_16.id] = arg1_16

	var0_0.recordShipLevelVertify(arg1_16)
	arg0_16:UpdateShipEquipAndSkinCount(arg1_16, true)

	arg2_16 = defaultValue(arg2_16, true)

	if arg2_16 then
		arg0_16:countShip()
	end

	arg0_16.shipHighestLevel = math.max(arg0_16.shipHighestLevel, arg1_16.level)

	if arg1_16:isActivityNpc() then
		table.insert(arg0_16.activityNpcShipIds, arg1_16.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	else
		if arg1_16:isMetaShip() and not table.contains(arg0_16.metaShipIDList, arg1_16.id) then
			table.insert(arg0_16.metaShipIDList, arg1_16.id)
			getProxy(MetaCharacterProxy):requestMetaTacticsInfo({
				arg1_16.id
			})
		end

		local var0_16 = getProxy(CollectionProxy)

		if var0_16 then
			var0_16:flushCollection(arg1_16)
		end
	end

	if getProxy(PlayerProxy):getInited() then
		arg0_16:sendNotification(var0_0.SHIP_ADDED, arg1_16:clone())
	end
end

function var0_0.countShip(arg0_17, arg1_17)
	local var0_17 = getProxy(PlayerProxy)
	local var1_17 = var0_17:getData()

	var1_17:increaseShipCount(arg1_17)
	var0_17:updatePlayer(var1_17)
end

function var0_0.getNewShip(arg0_18, arg1_18)
	local var0_18 = arg0_18.newShipList or {}

	if arg1_18 then
		arg0_18.newShipList = nil
	end

	return var0_18
end

function var0_0.getMetaTransItemMap(arg0_19, arg1_19)
	local var0_19

	if arg0_19.metaTransItemMap and arg0_19.metaTransItemMap[arg1_19] and #arg0_19.metaTransItemMap[arg1_19] > 0 then
		var0_19 = arg0_19.metaTransItemMap[arg1_19][1]

		table.remove(arg0_19.metaTransItemMap[arg1_19], 1)
	end

	return var0_19
end

function var0_0.addMetaTransItemMap(arg0_20, arg1_20, arg2_20)
	if not arg0_20.metaTransItemMap then
		arg0_20.metaTransItemMap = {}
	end

	if not arg0_20.metaTransItemMap[arg1_20] then
		arg0_20.metaTransItemMap[arg1_20] = {}
	end

	table.insert(arg0_20.metaTransItemMap[arg1_20], arg2_20)
end

function var0_0.getShipsByFleet(arg0_21, arg1_21)
	assert(isa(arg1_21, Fleet), "should be an instance of Fleet")

	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg1_21:getShipIds()) do
		table.insert(var0_21, arg0_21.data[iter1_21])
	end

	return var0_21
end

function var0_0.getSortShipsByFleet(arg0_22, arg1_22)
	assert(isa(arg1_22, Fleet), "should be an instance of Fleet")

	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(arg1_22.mainShips) do
		table.insert(var0_22, arg0_22.data[iter1_22])
	end

	for iter2_22, iter3_22 in ipairs(arg1_22.vanguardShips) do
		table.insert(var0_22, arg0_22.data[iter3_22])
	end

	for iter4_22, iter5_22 in ipairs(arg1_22.subShips) do
		table.insert(var0_22, arg0_22.data[iter5_22])
	end

	return var0_22
end

function var0_0.getShipByTeam(arg0_23, arg1_23, arg2_23)
	assert(isa(arg1_23, Fleet), "should be an instance of Fleet")

	local var0_23 = {}

	if arg2_23 == TeamType.Vanguard then
		for iter0_23, iter1_23 in ipairs(arg1_23.vanguardShips) do
			table.insert(var0_23, arg0_23.data[iter1_23])
		end
	elseif arg2_23 == TeamType.Main then
		for iter2_23, iter3_23 in ipairs(arg1_23.mainShips) do
			table.insert(var0_23, arg0_23.data[iter3_23])
		end
	elseif arg2_23 == TeamType.Submarine then
		for iter4_23, iter5_23 in ipairs(arg1_23.subShips) do
			table.insert(var0_23, arg0_23.data[iter5_23])
		end
	end

	return Clone(var0_23)
end

function var0_0.getShipsByTypes(arg0_24, arg1_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.data) do
		if table.contains(arg1_24, iter1_24:getShipType()) then
			table.insert(var0_24, iter1_24)
		end
	end

	return var0_24
end

function var0_0.getShipsByStatus(arg0_25, arg1_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25.data) do
		if iter1_25.status == arg1_25 then
			table.insert(var0_25, iter1_25)
		end
	end

	return var0_25
end

function var0_0.getShipsByTeamType(arg0_26, arg1_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.data) do
		if iter1_26:getTeamType() == arg1_26 then
			table.insert(var0_26, iter1_26)
		end
	end

	return var0_26
end

function var0_0.getConfigShipCount(arg0_27, arg1_27)
	local var0_27 = 0

	for iter0_27, iter1_27 in pairs(arg0_27.data) do
		if iter1_27.configId == arg1_27 then
			var0_27 = var0_27 + 1
		end
	end

	return var0_27
end

function var0_0.getShips(arg0_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in pairs(arg0_28.data) do
		table.insert(var0_28, iter1_28)
	end

	return var0_28
end

function var0_0.getRawShipCount(arg0_29)
	local var0_29 = 0

	for iter0_29, iter1_29 in pairs(arg0_29.data) do
		var0_29 = var0_29 + 1
	end

	return var0_29
end

function var0_0.getShipCount(arg0_30)
	local var0_30 = {}

	for iter0_30, iter1_30 in ipairs(getGameset("unoccupied_ship_nationality")[2]) do
		var0_30[iter1_30] = true
	end

	local var1_30 = 0
	local var2_30 = 0

	for iter2_30, iter3_30 in pairs(arg0_30.data) do
		if var0_30[iter3_30:getNation()] then
			var2_30 = var2_30 + 1
		else
			var1_30 = var1_30 + 1
		end
	end

	return var1_30, var2_30
end

function var0_0.getShipById(arg0_31, arg1_31)
	if arg0_31.data[arg1_31] ~= nil then
		return arg0_31.data[arg1_31]:clone()
	end
end

function var0_0.RawGetShipById(arg0_32, arg1_32)
	return arg0_32.data[arg1_32]
end

function var0_0.getMetaShipByGroupId(arg0_33, arg1_33)
	for iter0_33, iter1_33 in pairs(arg0_33.data) do
		if iter1_33:isMetaShip() and iter1_33.metaCharacter.id == arg1_33 then
			return iter1_33
		end
	end
end

function var0_0.getMetaShipIDList(arg0_34)
	return arg0_34.metaShipIDList
end

function var0_0.updateShip(arg0_35, arg1_35)
	if arg1_35.isNpc then
		return
	end

	assert(isa(arg1_35, Ship), "should be an instance of Ship")
	assert(arg0_35.data[arg1_35.id] ~= nil, "ship should exist")

	if arg1_35.level > arg0_35.shipHighestLevel then
		arg0_35.shipHighestLevel = arg1_35.level

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_HIGHEST_LEVEL, arg0_35.shipHighestLevel)
	end

	local var0_35 = arg0_35.data[arg1_35.id]

	arg0_35:UpdateShipEquipAndSkinCount(var0_35, false)

	arg0_35.data[arg1_35.id] = arg1_35

	var0_0.recordShipLevelVertify(arg1_35)
	arg0_35:UpdateShipEquipAndSkinCount(arg1_35, true)

	if var0_35:isActivityNpc() and not arg1_35:isActivityNpc() then
		table.removebyvalue(arg0_35.activityNpcShipIds, arg1_35.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	if var0_35.level < arg1_35.level then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_LEVEL_UP, arg1_35.level - var0_35.level)
	end

	if var0_35:getStar() < arg1_35:getStar() or var0_35.intimacy < arg1_35.intimacy or var0_35.level < arg1_35.level or not var0_35.propose and arg1_35.propose then
		local var1_35 = getProxy(CollectionProxy)

		if var1_35 and not arg1_35:isActivityNpc() then
			var1_35:flushCollection(arg1_35)
		end
	end

	arg0_35:sendNotification(var0_0.SHIP_UPDATED, arg1_35:clone())
end

function var0_0.removeShip(arg0_36, arg1_36)
	assert(isa(arg1_36, Ship), "should be an instance of Ship")
	arg0_36:removeShipById(arg1_36.id)
end

function var0_0.getEquipment2ByflagShip(arg0_37)
	local var0_37 = getProxy(PlayerProxy):getData()
	local var1_37 = arg0_37:getShipById(var0_37.character)

	assert(var1_37, "ship is nil")

	return var1_37:getEquip(2)
end

function var0_0.removeShipById(arg0_38, arg1_38)
	local var0_38 = arg0_38.data[arg1_38]

	assert(var0_38 ~= nil, "ship should exist")

	if var0_38:isActivityNpc() then
		table.removebyvalue(arg0_38.activityNpcShipIds, var0_38.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	arg0_38.data[var0_38.id] = nil

	var0_38:display("removed")
	arg0_38:UpdateShipEquipAndSkinCount(var0_38, false)
	arg0_38:sendNotification(var0_0.SHIP_REMOVED, var0_38)
end

function var0_0.findShipByGroup(arg0_39, arg1_39)
	for iter0_39, iter1_39 in pairs(arg0_39.data) do
		if iter1_39.groupId == arg1_39 then
			return iter1_39
		end
	end

	return nil
end

function var0_0.findShipsByGroup(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(arg0_40.data) do
		if iter1_40.groupId == arg1_40 then
			table.insert(var0_40, iter1_40)
		end
	end

	return var0_40
end

function var0_0.ExistGroupShip(arg0_41, arg1_41)
	for iter0_41, iter1_41 in pairs(arg0_41.data) do
		if iter1_41.groupId == arg1_41 then
			return true
		end
	end

	return false
end

function var0_0._ExistGroupShip(arg0_42, arg1_42, arg2_42, arg3_42)
	local function var0_42(arg0_43)
		if arg2_42 then
			return arg0_43:isRemoulded()
		else
			return true
		end
	end

	local function var1_42(arg0_44)
		if arg3_42 then
			return arg0_44.propose
		else
			return true
		end
	end

	for iter0_42, iter1_42 in pairs(arg0_42.data) do
		if iter1_42.groupId == arg1_42 and var0_42(iter1_42) and var1_42(iter1_42) then
			return true
		end
	end

	return false
end

function var0_0.getSameGroupShipCount(arg0_45, arg1_45)
	local var0_45 = 0

	for iter0_45, iter1_45 in pairs(arg0_45.data) do
		if iter1_45.groupId == arg1_45 then
			var0_45 = var0_45 + 1
		end
	end

	return var0_45
end

function var0_0.getUpgradeShips(arg0_46, arg1_46)
	local var0_46 = arg1_46:getConfig("rarity")
	local var1_46 = arg1_46.groupId
	local var2_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.data) do
		if iter1_46.groupId == var1_46 or iter1_46:isTestShip() and iter1_46:canUseTestShip(var0_46) then
			table.insert(var2_46, iter1_46)
		end
	end

	return var2_46
end

function var0_0.getBayPower(arg0_47)
	local var0_47 = {}
	local var1_47 = 0

	for iter0_47, iter1_47 in pairs(arg0_47.data) do
		local var2_47 = iter1_47.configId
		local var3_47 = iter1_47:getShipCombatPower()

		if ShipGroup.GetGroupConfig(iter1_47:getGroupId()).handbook_type ~= 1 and (not var0_47[var2_47] or var3_47 > var0_47[var2_47]) then
			var1_47 = var1_47 - defaultValue(var0_47[var2_47], 0)
			var0_47[var2_47] = var3_47
			var1_47 = var1_47 + var3_47
		end
	end

	return var1_47
end

function var0_0.GetBayPowerRootedAsyn(arg0_48, arg1_48)
	local var0_48

	var0_48 = coroutine.wrap(function()
		local var0_49 = {}
		local var1_49 = 0
		local var2_49 = 0

		for iter0_49, iter1_49 in pairs(arg0_48.data) do
			local var3_49 = iter1_49.configId
			local var4_49 = iter1_49:getShipCombatPower()

			if ShipGroup.GetGroupConfig(iter1_49:getGroupId()).handbook_type ~= 1 and (not var0_49[var3_49] or var4_49 > var0_49[var3_49]) then
				var1_49 = var1_49 - defaultValue(var0_49[var3_49], 0)
				var0_49[var3_49] = var4_49
				var1_49 = var1_49 + var4_49
			end

			var2_49 = var2_49 + 1

			if var2_49 == 1 or var2_49 % 50 == 0 then
				onNextTick(var0_48)
				coroutine.yield()
			end
		end

		arg1_48(var1_49^0.667)
	end)

	var0_48()
end

function var0_0.getBayPowerRooted(arg0_50)
	return arg0_50:getBayPower()^0.667
end

function var0_0.getEquipsInShips(arg0_51, arg1_51)
	local var0_51 = {}

	for iter0_51, iter1_51 in pairs(arg0_51.data) do
		for iter2_51, iter3_51 in pairs(iter1_51.equipments) do
			if iter3_51 and (not arg1_51 or arg1_51(iter3_51, iter1_51.id)) then
				table.insert(var0_51, setmetatable({
					shipId = iter1_51.id,
					shipPos = iter2_51
				}, {
					__index = iter3_51
				}))
			end
		end
	end

	return var0_51
end

function var0_0.UpdateShipEquipAndSkinCount(arg0_52, arg1_52, arg2_52)
	if not arg1_52 then
		return
	end

	local var0_52 = arg2_52 and 1 or -1

	for iter0_52, iter1_52 in pairs(arg1_52.equipments) do
		if iter1_52 then
			arg0_52.equipCountDic[iter1_52.id] = defaultValue(arg0_52.equipCountDic[iter1_52.id], 0) + var0_52

			assert(arg0_52.equipCountDic[iter1_52.id] >= 0)
		end
	end

	for iter2_52, iter3_52 in pairs(arg1_52.equipmentSkins) do
		if iter3_52 > 0 then
			arg0_52.equipSkinCountDic[iter3_52] = defaultValue(arg0_52.equipSkinCountDic[iter3_52], 0) + var0_52

			assert(arg0_52.equipSkinCountDic[iter3_52] >= 0)
		end
	end
end

function var0_0.GetEquipCountInShips(arg0_53, arg1_53)
	return arg0_53.equipCountDic[arg1_53] or 0
end

function var0_0.GetEquipSkinCountInShips(arg0_54, arg1_54)
	return arg0_54.equipSkinCountDic[arg1_54] or 0
end

function var0_0.GetEquipsInShipsRaw(arg0_55)
	local function var0_55(arg0_56, arg1_56, arg2_56)
		local var0_56 = CreateShell(arg0_56)

		var0_56.shipId = arg1_56
		var0_56.shipPos = arg2_56

		return var0_56
	end

	local var1_55 = {}

	for iter0_55, iter1_55 in pairs(arg0_55.data) do
		for iter2_55, iter3_55 in pairs(iter1_55.equipments) do
			if iter3_55 then
				table.insert(var1_55, var0_55(iter3_55, iter1_55.id, iter2_55))
			end
		end
	end

	return var1_55
end

function var0_0.getEquipmentSkinInShips(arg0_57, arg1_57, arg2_57)
	local function var0_57(arg0_58)
		local var0_58 = false

		if arg0_58 and arg0_58 > 0 then
			local var1_58 = pg.equip_skin_template[arg0_58]

			var0_58 = _.any(var1_58.equip_type, function(arg0_59)
				return not arg2_57 or table.contains(arg2_57, arg0_59)
			end)
		end

		return var0_58
	end

	local var1_57 = {}

	for iter0_57, iter1_57 in pairs(arg0_57.data) do
		if not arg1_57 or arg1_57.id ~= iter1_57.id then
			for iter2_57, iter3_57 in pairs(iter1_57:getEquipSkins()) do
				local var2_57 = var0_57(iter3_57)

				if iter3_57 and var2_57 then
					table.insert(var1_57, {
						id = iter3_57,
						shipId = iter1_57.id,
						shipPos = iter2_57
					})
				end
			end
		end
	end

	return var1_57
end

function var0_0.GetSpWeaponsInShips(arg0_60, arg1_60)
	local var0_60 = {}

	for iter0_60, iter1_60 in pairs(arg0_60.data) do
		if not arg1_60 or arg1_60.id ~= iter1_60.id then
			local var1_60 = iter1_60:GetSpWeapon()

			if var1_60 and (not arg1_60 or not arg1_60:IsSpWeaponForbidden(var1_60)) then
				table.insert(var0_60, var1_60)
			end
		end
	end

	return var0_60
end

function var0_0.getProposeGroupList(arg0_61)
	local var0_61 = {}

	for iter0_61, iter1_61 in pairs(arg0_61.data) do
		if iter1_61:ShowPropose() then
			var0_61[iter1_61.groupId] = true
		end
	end

	return var0_61
end

function var0_0.GetRecommendShip(arg0_62, arg1_62, arg2_62, arg3_62)
	assert(arg3_62)

	local var0_62 = arg0_62:getShipsByTypes(arg1_62)
	local var1_62 = {}

	for iter0_62, iter1_62 in ipairs(var0_62) do
		var1_62[iter1_62] = iter1_62:getShipCombatPower()
	end

	table.sort(var0_62, function(arg0_63, arg1_63)
		return var1_62[arg0_63] < var1_62[arg1_63]
	end)

	local var2_62 = {}

	for iter2_62, iter3_62 in ipairs(arg2_62) do
		var2_62[#var2_62 + 1] = arg0_62.data[iter3_62]:getGroupId()
	end

	local var3_62 = #var0_62
	local var4_62

	while var3_62 > 0 do
		local var5_62 = var0_62[var3_62]
		local var6_62 = var5_62.id
		local var7_62 = var5_62:getGroupId()

		if not table.contains(arg2_62, var6_62) and not table.contains(var2_62, var7_62) and arg3_62(var5_62) then
			var4_62 = var5_62

			break
		else
			var3_62 = var3_62 - 1
		end
	end

	return var4_62
end

function var0_0.getActivityRecommendShips(arg0_64, arg1_64, arg2_64, arg3_64, arg4_64)
	local var0_64 = arg0_64:getShipsByTypes(arg1_64)
	local var1_64 = {}

	for iter0_64, iter1_64 in ipairs(var0_64) do
		var1_64[iter1_64] = iter1_64:getShipCombatPower()
	end

	table.sort(var0_64, function(arg0_65, arg1_65)
		return var1_64[arg0_65] < var1_64[arg1_65]
	end)

	local var2_64 = {}

	for iter2_64, iter3_64 in ipairs(arg2_64) do
		local var3_64 = arg0_64.data[iter3_64]

		var2_64[#var2_64 + 1] = var3_64:getGroupId()
	end

	local var4_64 = #var0_64
	local var5_64 = {}

	while var4_64 > 0 and arg3_64 > 0 do
		local var6_64 = var0_64[var4_64]
		local var7_64 = var6_64.id
		local var8_64 = var6_64:getGroupId()

		if not table.contains(arg2_64, var7_64) and not table.contains(var2_64, var8_64) and ShipStatus.ShipStatusCheck("inActivity", var6_64, nil, {
			inActivity = arg4_64
		}) then
			table.insert(var5_64, var6_64)
			table.insert(var2_64, var8_64)

			arg3_64 = arg3_64 - 1
		end

		var4_64 = var4_64 - 1
	end

	return var5_64
end

function var0_0.getDelegationRecommendShips(arg0_66, arg1_66)
	local var0_66 = 6 - #arg1_66.shipIds
	local var1_66 = arg1_66.template.ship_type
	local var2_66 = arg1_66.template.ship_lv
	local var3_66 = math.max(var2_66, 2)
	local var4_66 = Clone(arg1_66.shipIds)
	local var5_66 = arg0_66:getShipsByTypes(var1_66)

	table.sort(var5_66, function(arg0_67, arg1_67)
		return arg0_67.level > arg1_67.level
	end)

	local var6_66 = {}
	local var7_66 = false

	for iter0_66, iter1_66 in ipairs(var4_66) do
		local var8_66 = arg0_66.data[iter1_66]

		if var3_66 <= var8_66.level then
			var7_66 = true
		end

		var6_66[#var6_66 + 1] = var8_66:getGroupId()
	end

	if var7_66 then
		var3_66 = 2
	end

	local var9_66 = {}
	local var10_66 = #var5_66

	while var10_66 > 0 do
		if var0_66 <= 0 then
			break
		end

		local var11_66 = var5_66[var10_66]
		local var12_66 = var11_66.id
		local var13_66 = var11_66:getGroupId()

		if var3_66 <= var11_66.level and var11_66.lockState ~= Ship.LOCK_STATE_UNLOCK and not table.contains(var4_66, var12_66) and not table.contains(var6_66, var13_66) and not table.contains(var9_66, var12_66) and not var11_66:getFlag("inElite") and not var11_66:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var11_66) then
			table.insert(var6_66, var13_66)
			table.insert(var9_66, var12_66)

			var0_66 = var0_66 - 1

			if var7_66 == false then
				var7_66 = true
				var3_66 = 2
				var10_66 = #var5_66
			end
		else
			var10_66 = var10_66 - 1
		end
	end

	return var9_66
end

function var0_0.getDelegationRecommendShipsLV1(arg0_68, arg1_68)
	local var0_68 = 6 - #arg1_68.shipIds
	local var1_68 = arg1_68.template.ship_type
	local var2_68 = Clone(arg1_68.shipIds)
	local var3_68 = arg0_68:getShipsByTypes(var1_68)
	local var4_68 = _.select(var3_68, function(arg0_69)
		return arg0_69.level == 1
	end)

	table.sort(var4_68, CompareFuncs({
		function(arg0_70)
			return arg0_70.lockState == arg0_70.LOCK_STATE_UNLOCK and 0 or 1
		end
	}))

	local var5_68 = {}

	for iter0_68, iter1_68 in ipairs(var2_68) do
		local var6_68 = arg0_68.data[iter1_68]

		var5_68[#var5_68 + 1] = var6_68:getGroupId()
	end

	local var7_68 = {}
	local var8_68 = #var4_68

	while var8_68 > 0 do
		if var0_68 <= 0 then
			break
		end

		local var9_68 = var4_68[var8_68]
		local var10_68 = var9_68.id
		local var11_68 = var9_68:getGroupId()

		if not table.contains(var2_68, var10_68) and not table.contains(var5_68, var11_68) and not table.contains(var7_68, var10_68) and not var9_68:getFlag("inElite") and not var9_68:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var9_68) then
			table.insert(var5_68, var11_68)
			table.insert(var7_68, var10_68)

			var0_68 = var0_68 - 1
		else
			var8_68 = var8_68 - 1
		end
	end

	return var7_68
end

function var0_0.getWorldRecommendShip(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71:getShipsByTeamType(arg1_71)
	local var1_71 = {}

	for iter0_71, iter1_71 in ipairs(var0_71) do
		var1_71[iter1_71] = iter1_71:getShipCombatPower()
	end

	table.sort(var0_71, function(arg0_72, arg1_72)
		return var1_71[arg0_72] < var1_71[arg1_72]
	end)

	local var2_71 = {}

	for iter2_71, iter3_71 in ipairs(arg2_71) do
		var2_71[#var2_71 + 1] = arg0_71.data[iter3_71]:getGroupId()
	end

	local var3_71 = #var0_71
	local var4_71

	while var3_71 > 0 do
		local var5_71 = var0_71[var3_71]
		local var6_71 = var5_71.id
		local var7_71 = var5_71:getGroupId()

		if not table.contains(arg2_71, var6_71) and not table.contains(var2_71, var7_71) and ShipStatus.ShipStatusCheck("inWorld", var5_71) then
			var4_71 = var5_71

			break
		else
			var3_71 = var3_71 - 1
		end
	end

	return var4_71
end

function var0_0.getModRecommendShip(arg0_73, arg1_73, arg2_73)
	local var0_73 = underscore.map(arg2_73, function(arg0_74)
		return arg0_73.data[arg0_74]
	end)
	local var1_73 = Clone(arg1_73)

	for iter0_73, iter1_73 in pairs(ShipModLayer.getModExpAdditions(var1_73, var0_73)) do
		var1_73:addModAttrExp(iter0_73, iter1_73)
	end

	local var2_73 = var1_73:getNeedModExp()
	local var3_73 = 0

	for iter2_73, iter3_73 in pairs(var2_73) do
		var3_73 = var3_73 + iter3_73
	end

	local var4_73 = {}

	for iter4_73, iter5_73 in pairs(arg0_73.data) do
		if iter5_73:isSameKind(arg1_73) then
			var4_73.sameKind = var4_73.sameKind or {}

			table.insert(var4_73.sameKind, iter5_73)
		else
			local var5_73 = iter5_73:getShipType()

			var4_73[var5_73] = var4_73[var5_73] or {}

			table.insert(var4_73[var5_73], iter5_73)
		end
	end

	local var6_73 = arg1_73:getConfig("type")

	for iter6_73, iter7_73 in ipairs(table.mergeArray({
		"sameKind"
	}, pg.ship_data_by_type[var6_73].strengthen_choose_type)) do
		if #var0_73 == 12 or var3_73 == 0 then
			break
		end

		local var7_73 = var4_73[iter7_73] or {}
		local var8_73 = {}

		for iter8_73, iter9_73 in ipairs(pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_2, underscore.map(var7_73, function(arg0_75)
			return arg0_75.id
		end))) do
			var8_73[iter9_73] = true
		end

		local var9_73 = underscore.filter(var7_73, function(arg0_76)
			return arg0_76.level == 1 and arg0_76:getRarity() <= ShipRarity.Gray and arg0_76:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_73, arg0_76.id) and arg1_73.id ~= arg0_76.id and not var8_73[arg0_76.id]
		end)

		for iter10_73, iter11_73 in ipairs(var9_73) do
			if #var0_73 == 12 or var3_73 == 0 then
				break
			end

			local var10_73 = ShipModLayer.getModExpAdditions(var1_73, {
				iter11_73
			})
			local var11_73 = false

			for iter12_73, iter13_73 in pairs(var10_73) do
				if iter13_73 > 0 and var2_73[iter12_73] > 0 then
					var11_73 = true
					var3_73 = var3_73 - math.min(var2_73[iter12_73], iter13_73)
					var2_73[iter12_73] = math.max(var2_73[iter12_73] - iter13_73, 0)
				end
			end

			if var11_73 then
				table.insert(var0_73, iter11_73)
			end
		end
	end

	return underscore.map(var0_73, function(arg0_77)
		return arg0_77.id
	end)
end

function var0_0.getUpgradeRecommendShip(arg0_78, arg1_78, arg2_78, arg3_78)
	local var0_78 = arg0_78:getUpgradeShips(arg1_78)
	local var1_78 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_4, underscore.keys(arg0_78.data))

	local function var2_78(arg0_79)
		return arg0_79.level == 1 and arg0_79:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_78, arg0_79.id) and arg1_78.id ~= arg0_79.id and not table.contains(var1_78, arg0_79.id)
	end

	local var3_78 = {}

	for iter0_78, iter1_78 in ipairs(var0_78) do
		if var2_78(iter1_78) then
			table.insert(var3_78, iter1_78)
		end
	end

	local var4_78 = {
		function(arg0_80)
			return arg0_80:isSameKind(arg1_78) and 0 or 1
		end
	}

	table.sort(var3_78, CompareFuncs(var4_78))

	local var5_78 = {}

	for iter2_78, iter3_78 in pairs(arg2_78) do
		table.insert(var5_78, arg0_78.data[iter3_78])
	end

	for iter4_78, iter5_78 in ipairs(var3_78) do
		if #var5_78 == arg3_78 then
			break
		end

		table.insert(var5_78, iter5_78)
	end

	return underscore.map(var5_78, function(arg0_81)
		return arg0_81.id
	end)
end

function var0_0.getGroupPropose(arg0_82, arg1_82)
	local var0_82 = false

	if arg0_82.data then
		for iter0_82, iter1_82 in ipairs(arg0_82.data) do
			if pg.ship_data_template[iter1_82.configId].group_type == arg1_82 and iter1_82.propose then
				return true
			end
		end
	end

	return var0_82
end

function var0_0.updateRandomFlagShips(arg0_83, arg1_83)
	for iter0_83, iter1_83 in ipairs(arg1_83) do
		arg0_83.data[iter1_83.ship_id]:updateRandomFlag(iter1_83.flag, iter1_83.shadow)
	end
end

function var0_0.getRandomFlagShipPhantomMarks(arg0_84)
	local var0_84 = {}

	for iter0_84, iter1_84 in pairs(arg0_84.data) do
		table.insertto(var0_84, iter1_84:getRandomFlagShipPhantomMarks())
	end

	return var0_84
end

function var0_0.getAllShipPhantomMarks(arg0_85)
	local var0_85 = {}

	for iter0_85, iter1_85 in pairs(arg0_85.data) do
		table.insertto(var0_85, iter1_85:getAllShipPhantomMarks())
	end

	return var0_85
end

function var0_0.GetShipPhantom(arg0_86, arg1_86)
	local var0_86, var1_86 = ShipPhantom.UnpackMark(arg1_86)

	return arg0_86.data[var0_86] and ShipPhantom.Create(arg0_86.data[var0_86], var1_86) or nil
end

function var0_0.getShipPhantomList(arg0_87, arg1_87)
	return underscore.map(arg1_87, function(arg0_88)
		return arg0_87:GetShipPhantom(arg0_88)
	end)
end

function var0_0.updateShipSkin(arg0_89, arg1_89, arg2_89, arg3_89)
	local var0_89 = arg0_89.data[arg1_89]

	assert(var0_89)
	var0_89:updateSkinId(arg3_89, arg2_89)
	arg0_89:sendNotification(var0_0.SHIP_UPDATED, var0_89:clone())
end

function var0_0.CanUseShareSkinPhantoms(arg0_90, arg1_90)
	local var0_90 = ShipSkin.New({
		id = arg1_90
	})
	local var1_90 = var0_90:IsTransSkin()
	local var2_90 = var0_90:IsProposeSkin()
	local var3_90, var4_90 = var0_90:GetShareGroupIds()
	local var5_90 = {}

	for iter0_90, iter1_90 in ipairs(var4_90) do
		var5_90[iter1_90] = true
	end

	local var6_90 = {}

	for iter2_90, iter3_90 in ipairs(underscore.filter(underscore.values(arg0_90:getRawData()), function(arg0_91)
		if not arg0_91 then
			return false
		end

		if var1_90 then
			return arg0_91.groupId == var3_90 and arg0_91:isRemoulded()
		elseif arg0_91.groupId == var3_90 or var5_90[arg0_91.groupId] and math.floor(arg0_91:getIntimacy() / 100) >= arg0_91:GetNoProposeIntimacyMax() then
			return not var2_90 or tobool(arg0_91.propose)
		else
			return false
		end
	end)) do
		table.insertto(var6_90, iter3_90:getAllShipPhantom())
	end

	return var6_90
end

return var0_0
