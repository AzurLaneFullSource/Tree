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

function var0_0.getShipList(arg0_29, arg1_29)
	return underscore.map(arg1_29, function(arg0_30)
		return arg0_29.data[arg0_30] or false
	end)
end

function var0_0.getRawShipCount(arg0_31)
	local var0_31 = 0

	for iter0_31, iter1_31 in pairs(arg0_31.data) do
		var0_31 = var0_31 + 1
	end

	return var0_31
end

function var0_0.getShipCount(arg0_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in ipairs(getGameset("unoccupied_ship_nationality")[2]) do
		var0_32[iter1_32] = true
	end

	local var1_32 = 0
	local var2_32 = 0

	for iter2_32, iter3_32 in pairs(arg0_32.data) do
		if var0_32[iter3_32:getNation()] then
			var2_32 = var2_32 + 1
		else
			var1_32 = var1_32 + 1
		end
	end

	return var1_32, var2_32
end

function var0_0.getShipById(arg0_33, arg1_33)
	if arg0_33.data[arg1_33] ~= nil then
		return arg0_33.data[arg1_33]:clone()
	end
end

function var0_0.RawGetShipById(arg0_34, arg1_34)
	return arg0_34.data[arg1_34]
end

function var0_0.getMetaShipByGroupId(arg0_35, arg1_35)
	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		if iter1_35:isMetaShip() and iter1_35.metaCharacter.id == arg1_35 then
			return iter1_35
		end
	end
end

function var0_0.getMetaShipIDList(arg0_36)
	return arg0_36.metaShipIDList
end

function var0_0.updateShip(arg0_37, arg1_37)
	if arg1_37.isNpc then
		return
	end

	assert(isa(arg1_37, Ship), "should be an instance of Ship")
	assert(arg0_37.data[arg1_37.id] ~= nil, "ship should exist")

	if arg1_37.level > arg0_37.shipHighestLevel then
		arg0_37.shipHighestLevel = arg1_37.level

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_HIGHEST_LEVEL, arg0_37.shipHighestLevel)
	end

	local var0_37 = arg0_37.data[arg1_37.id]

	arg0_37:UpdateShipEquipAndSkinCount(var0_37, false)

	arg0_37.data[arg1_37.id] = arg1_37

	var0_0.recordShipLevelVertify(arg1_37)
	arg0_37:UpdateShipEquipAndSkinCount(arg1_37, true)

	if var0_37:isActivityNpc() and not arg1_37:isActivityNpc() then
		table.removebyvalue(arg0_37.activityNpcShipIds, arg1_37.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	if var0_37.level < arg1_37.level then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_LEVEL_UP, arg1_37.level - var0_37.level)
	end

	if var0_37:getStar() < arg1_37:getStar() or var0_37.intimacy < arg1_37.intimacy or var0_37.level < arg1_37.level or not var0_37.propose and arg1_37.propose then
		local var1_37 = getProxy(CollectionProxy)

		if var1_37 and not arg1_37:isActivityNpc() then
			var1_37:flushCollection(arg1_37)
		end
	end

	arg0_37:sendNotification(var0_0.SHIP_UPDATED, arg1_37:clone())
end

function var0_0.removeShip(arg0_38, arg1_38)
	assert(isa(arg1_38, Ship), "should be an instance of Ship")
	arg0_38:removeShipById(arg1_38.id)
end

function var0_0.getEquipment2ByflagShip(arg0_39)
	local var0_39 = getProxy(PlayerProxy):getData()
	local var1_39 = arg0_39:getShipById(var0_39.character)

	assert(var1_39, "ship is nil")

	return var1_39:getEquip(2)
end

function var0_0.removeShipById(arg0_40, arg1_40)
	local var0_40 = arg0_40.data[arg1_40]

	assert(var0_40 ~= nil, "ship should exist")

	if var0_40:isActivityNpc() then
		table.removebyvalue(arg0_40.activityNpcShipIds, var0_40.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	arg0_40.data[var0_40.id] = nil

	var0_40:display("removed")
	arg0_40:UpdateShipEquipAndSkinCount(var0_40, false)
	arg0_40:sendNotification(var0_0.SHIP_REMOVED, var0_40)
end

function var0_0.findShipByGroup(arg0_41, arg1_41)
	for iter0_41, iter1_41 in pairs(arg0_41.data) do
		if iter1_41.groupId == arg1_41 then
			return iter1_41
		end
	end

	return nil
end

function var0_0.findShipsByGroup(arg0_42, arg1_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in pairs(arg0_42.data) do
		if iter1_42.groupId == arg1_42 then
			table.insert(var0_42, iter1_42)
		end
	end

	return var0_42
end

function var0_0.ExistGroupShip(arg0_43, arg1_43)
	for iter0_43, iter1_43 in pairs(arg0_43.data) do
		if iter1_43.groupId == arg1_43 then
			return true
		end
	end

	return false
end

function var0_0._ExistGroupShip(arg0_44, arg1_44, arg2_44, arg3_44)
	local function var0_44(arg0_45)
		if arg2_44 then
			return arg0_45:isRemoulded()
		else
			return true
		end
	end

	local function var1_44(arg0_46)
		if arg3_44 then
			return arg0_46.propose
		else
			return true
		end
	end

	for iter0_44, iter1_44 in pairs(arg0_44.data) do
		if iter1_44.groupId == arg1_44 and var0_44(iter1_44) and var1_44(iter1_44) then
			return true
		end
	end

	return false
end

function var0_0.getSameGroupShipCount(arg0_47, arg1_47)
	local var0_47 = 0

	for iter0_47, iter1_47 in pairs(arg0_47.data) do
		if iter1_47.groupId == arg1_47 then
			var0_47 = var0_47 + 1
		end
	end

	return var0_47
end

function var0_0.getUpgradeShips(arg0_48, arg1_48)
	local var0_48 = arg1_48:getConfig("rarity")
	local var1_48 = arg1_48.groupId
	local var2_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.data) do
		if iter1_48.groupId == var1_48 or iter1_48:isTestShip() and iter1_48:canUseTestShip(var0_48) then
			table.insert(var2_48, iter1_48)
		end
	end

	return var2_48
end

function var0_0.getBayPower(arg0_49)
	local var0_49 = {}
	local var1_49 = 0

	for iter0_49, iter1_49 in pairs(arg0_49.data) do
		local var2_49 = iter1_49.configId
		local var3_49 = iter1_49:getShipCombatPower()

		if ShipGroup.GetGroupConfig(iter1_49:getGroupId()).handbook_type ~= 1 and (not var0_49[var2_49] or var3_49 > var0_49[var2_49]) then
			var1_49 = var1_49 - defaultValue(var0_49[var2_49], 0)
			var0_49[var2_49] = var3_49
			var1_49 = var1_49 + var3_49
		end
	end

	return var1_49
end

function var0_0.GetBayPowerRootedAsyn(arg0_50, arg1_50)
	local var0_50

	var0_50 = coroutine.wrap(function()
		local var0_51 = {}
		local var1_51 = 0
		local var2_51 = 0

		for iter0_51, iter1_51 in pairs(arg0_50.data) do
			local var3_51 = iter1_51.configId
			local var4_51 = iter1_51:getShipCombatPower()

			if ShipGroup.GetGroupConfig(iter1_51:getGroupId()).handbook_type ~= 1 and (not var0_51[var3_51] or var4_51 > var0_51[var3_51]) then
				var1_51 = var1_51 - defaultValue(var0_51[var3_51], 0)
				var0_51[var3_51] = var4_51
				var1_51 = var1_51 + var4_51
			end

			var2_51 = var2_51 + 1

			if var2_51 == 1 or var2_51 % 50 == 0 then
				onNextTick(var0_50)
				coroutine.yield()
			end
		end

		arg1_50(var1_51^0.667)
	end)

	var0_50()
end

function var0_0.getBayPowerRooted(arg0_52)
	return arg0_52:getBayPower()^0.667
end

function var0_0.getEquipsInShips(arg0_53, arg1_53)
	local var0_53 = {}

	for iter0_53, iter1_53 in pairs(arg0_53.data) do
		for iter2_53, iter3_53 in pairs(iter1_53.equipments) do
			if iter3_53 and (not arg1_53 or arg1_53(iter3_53, iter1_53.id)) then
				table.insert(var0_53, setmetatable({
					shipId = iter1_53.id,
					shipPos = iter2_53
				}, {
					__index = iter3_53
				}))
			end
		end
	end

	return var0_53
end

function var0_0.UpdateShipEquipAndSkinCount(arg0_54, arg1_54, arg2_54)
	if not arg1_54 then
		return
	end

	local var0_54 = arg2_54 and 1 or -1

	for iter0_54, iter1_54 in pairs(arg1_54.equipments) do
		if iter1_54 then
			arg0_54.equipCountDic[iter1_54.id] = defaultValue(arg0_54.equipCountDic[iter1_54.id], 0) + var0_54

			assert(arg0_54.equipCountDic[iter1_54.id] >= 0)
		end
	end

	for iter2_54, iter3_54 in pairs(arg1_54.equipmentSkins) do
		if iter3_54 > 0 then
			arg0_54.equipSkinCountDic[iter3_54] = defaultValue(arg0_54.equipSkinCountDic[iter3_54], 0) + var0_54

			assert(arg0_54.equipSkinCountDic[iter3_54] >= 0)
		end
	end
end

function var0_0.GetEquipCountInShips(arg0_55, arg1_55)
	return arg0_55.equipCountDic[arg1_55] or 0
end

function var0_0.GetEquipSkinCountInShips(arg0_56, arg1_56)
	return arg0_56.equipSkinCountDic[arg1_56] or 0
end

function var0_0.GetEquipsInShipsRaw(arg0_57)
	local function var0_57(arg0_58, arg1_58, arg2_58)
		local var0_58 = CreateShell(arg0_58)

		var0_58.shipId = arg1_58
		var0_58.shipPos = arg2_58

		return var0_58
	end

	local var1_57 = {}

	for iter0_57, iter1_57 in pairs(arg0_57.data) do
		for iter2_57, iter3_57 in pairs(iter1_57.equipments) do
			if iter3_57 then
				table.insert(var1_57, var0_57(iter3_57, iter1_57.id, iter2_57))
			end
		end
	end

	return var1_57
end

function var0_0.getEquipmentSkinInShips(arg0_59, arg1_59, arg2_59)
	local function var0_59(arg0_60)
		local var0_60 = false

		if arg0_60 and arg0_60 > 0 then
			local var1_60 = pg.equip_skin_template[arg0_60]

			var0_60 = _.any(var1_60.equip_type, function(arg0_61)
				return not arg2_59 or table.contains(arg2_59, arg0_61)
			end)
		end

		return var0_60
	end

	local var1_59 = {}

	for iter0_59, iter1_59 in pairs(arg0_59.data) do
		if not arg1_59 or arg1_59.id ~= iter1_59.id then
			for iter2_59, iter3_59 in pairs(iter1_59:getEquipSkins()) do
				local var2_59 = var0_59(iter3_59)

				if iter3_59 and var2_59 then
					table.insert(var1_59, {
						id = iter3_59,
						shipId = iter1_59.id,
						shipPos = iter2_59
					})
				end
			end
		end
	end

	return var1_59
end

function var0_0.GetSpWeaponsInShips(arg0_62, arg1_62)
	local var0_62 = {}

	for iter0_62, iter1_62 in pairs(arg0_62.data) do
		if not arg1_62 or arg1_62.id ~= iter1_62.id then
			local var1_62 = iter1_62:GetSpWeapon()

			if var1_62 and (not arg1_62 or not arg1_62:IsSpWeaponForbidden(var1_62)) then
				table.insert(var0_62, var1_62)
			end
		end
	end

	return var0_62
end

function var0_0.getProposeGroupList(arg0_63)
	local var0_63 = {}

	for iter0_63, iter1_63 in pairs(arg0_63.data) do
		if iter1_63:ShowPropose() then
			var0_63[iter1_63.groupId] = true
		end
	end

	return var0_63
end

function var0_0.GetRecommendShip(arg0_64, arg1_64, arg2_64, arg3_64)
	assert(arg3_64)

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
		var2_64[#var2_64 + 1] = arg0_64.data[iter3_64]:getGroupId()
	end

	local var3_64 = #var0_64
	local var4_64

	while var3_64 > 0 do
		local var5_64 = var0_64[var3_64]
		local var6_64 = var5_64.id
		local var7_64 = var5_64:getGroupId()

		if not table.contains(arg2_64, var6_64) and not table.contains(var2_64, var7_64) and arg3_64(var5_64) then
			var4_64 = var5_64

			break
		else
			var3_64 = var3_64 - 1
		end
	end

	return var4_64
end

function var0_0.getActivityRecommendShips(arg0_66, arg1_66, arg2_66, arg3_66, arg4_66)
	local var0_66 = arg0_66:getShipsByTypes(arg1_66)
	local var1_66 = {}

	for iter0_66, iter1_66 in ipairs(var0_66) do
		var1_66[iter1_66] = iter1_66:getShipCombatPower()
	end

	table.sort(var0_66, function(arg0_67, arg1_67)
		return var1_66[arg0_67] < var1_66[arg1_67]
	end)

	local var2_66 = {}

	for iter2_66, iter3_66 in ipairs(arg2_66) do
		local var3_66 = arg0_66.data[iter3_66]

		var2_66[#var2_66 + 1] = var3_66:getGroupId()
	end

	local var4_66 = #var0_66
	local var5_66 = {}

	while var4_66 > 0 and arg3_66 > 0 do
		local var6_66 = var0_66[var4_66]
		local var7_66 = var6_66.id
		local var8_66 = var6_66:getGroupId()

		if not table.contains(arg2_66, var7_66) and not table.contains(var2_66, var8_66) and ShipStatus.ShipStatusCheck("inActivity", var6_66, nil, {
			inActivity = arg4_66
		}) then
			table.insert(var5_66, var6_66)
			table.insert(var2_66, var8_66)

			arg3_66 = arg3_66 - 1
		end

		var4_66 = var4_66 - 1
	end

	return var5_66
end

function var0_0.getDelegationRecommendShips(arg0_68, arg1_68)
	local var0_68 = 6 - #arg1_68.shipIds
	local var1_68 = arg1_68.template.ship_type
	local var2_68 = arg1_68.template.ship_lv
	local var3_68 = math.max(var2_68, 2)
	local var4_68 = Clone(arg1_68.shipIds)
	local var5_68 = arg0_68:getShipsByTypes(var1_68)

	table.sort(var5_68, function(arg0_69, arg1_69)
		return arg0_69.level > arg1_69.level
	end)

	local var6_68 = {}
	local var7_68 = false

	for iter0_68, iter1_68 in ipairs(var4_68) do
		local var8_68 = arg0_68.data[iter1_68]

		if var3_68 <= var8_68.level then
			var7_68 = true
		end

		var6_68[#var6_68 + 1] = var8_68:getGroupId()
	end

	if var7_68 then
		var3_68 = 2
	end

	local var9_68 = {}
	local var10_68 = #var5_68

	while var10_68 > 0 do
		if var0_68 <= 0 then
			break
		end

		local var11_68 = var5_68[var10_68]
		local var12_68 = var11_68.id
		local var13_68 = var11_68:getGroupId()

		if var3_68 <= var11_68.level and var11_68.lockState ~= Ship.LOCK_STATE_UNLOCK and not table.contains(var4_68, var12_68) and not table.contains(var6_68, var13_68) and not table.contains(var9_68, var12_68) and not var11_68:getFlag("inElite") and not var11_68:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var11_68) then
			table.insert(var6_68, var13_68)
			table.insert(var9_68, var12_68)

			var0_68 = var0_68 - 1

			if var7_68 == false then
				var7_68 = true
				var3_68 = 2
				var10_68 = #var5_68
			end
		else
			var10_68 = var10_68 - 1
		end
	end

	return var9_68
end

function var0_0.getDelegationRecommendShipsLV1(arg0_70, arg1_70)
	local var0_70 = 6 - #arg1_70.shipIds
	local var1_70 = arg1_70.template.ship_type
	local var2_70 = Clone(arg1_70.shipIds)
	local var3_70 = arg0_70:getShipsByTypes(var1_70)
	local var4_70 = _.select(var3_70, function(arg0_71)
		return arg0_71.level == 1
	end)

	table.sort(var4_70, CompareFuncs({
		function(arg0_72)
			return arg0_72.lockState == arg0_72.LOCK_STATE_UNLOCK and 0 or 1
		end
	}))

	local var5_70 = {}

	for iter0_70, iter1_70 in ipairs(var2_70) do
		local var6_70 = arg0_70.data[iter1_70]

		var5_70[#var5_70 + 1] = var6_70:getGroupId()
	end

	local var7_70 = {}
	local var8_70 = #var4_70

	while var8_70 > 0 do
		if var0_70 <= 0 then
			break
		end

		local var9_70 = var4_70[var8_70]
		local var10_70 = var9_70.id
		local var11_70 = var9_70:getGroupId()

		if not table.contains(var2_70, var10_70) and not table.contains(var5_70, var11_70) and not table.contains(var7_70, var10_70) and not var9_70:getFlag("inElite") and not var9_70:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var9_70) then
			table.insert(var5_70, var11_70)
			table.insert(var7_70, var10_70)

			var0_70 = var0_70 - 1
		else
			var8_70 = var8_70 - 1
		end
	end

	return var7_70
end

function var0_0.getWorldRecommendShip(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg0_73:getShipsByTeamType(arg1_73)
	local var1_73 = {}

	for iter0_73, iter1_73 in ipairs(var0_73) do
		var1_73[iter1_73] = iter1_73:getShipCombatPower()
	end

	table.sort(var0_73, function(arg0_74, arg1_74)
		return var1_73[arg0_74] < var1_73[arg1_74]
	end)

	local var2_73 = {}

	for iter2_73, iter3_73 in ipairs(arg2_73) do
		var2_73[#var2_73 + 1] = arg0_73.data[iter3_73]:getGroupId()
	end

	local var3_73 = #var0_73
	local var4_73

	while var3_73 > 0 do
		local var5_73 = var0_73[var3_73]
		local var6_73 = var5_73.id
		local var7_73 = var5_73:getGroupId()

		if not table.contains(arg2_73, var6_73) and not table.contains(var2_73, var7_73) and ShipStatus.ShipStatusCheck("inWorld", var5_73) then
			var4_73 = var5_73

			break
		else
			var3_73 = var3_73 - 1
		end
	end

	return var4_73
end

function var0_0.getModRecommendShip(arg0_75, arg1_75, arg2_75)
	local var0_75 = underscore.map(arg2_75, function(arg0_76)
		return arg0_75.data[arg0_76]
	end)
	local var1_75 = Clone(arg1_75)

	for iter0_75, iter1_75 in pairs(ShipModLayer.getModExpAdditions(var1_75, var0_75)) do
		var1_75:addModAttrExp(iter0_75, iter1_75)
	end

	local var2_75 = var1_75:getNeedModExp()
	local var3_75 = 0

	for iter2_75, iter3_75 in pairs(var2_75) do
		var3_75 = var3_75 + iter3_75
	end

	local var4_75 = {}

	for iter4_75, iter5_75 in pairs(arg0_75.data) do
		if iter5_75:isSameKind(arg1_75) then
			var4_75.sameKind = var4_75.sameKind or {}

			table.insert(var4_75.sameKind, iter5_75)
		else
			local var5_75 = iter5_75:getShipType()

			var4_75[var5_75] = var4_75[var5_75] or {}

			table.insert(var4_75[var5_75], iter5_75)
		end
	end

	local var6_75 = arg1_75:getConfig("type")

	for iter6_75, iter7_75 in ipairs(table.mergeArray({
		"sameKind"
	}, pg.ship_data_by_type[var6_75].strengthen_choose_type)) do
		if #var0_75 == 12 or var3_75 == 0 then
			break
		end

		local var7_75 = var4_75[iter7_75] or {}
		local var8_75 = {}

		for iter8_75, iter9_75 in ipairs(pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_2, underscore.map(var7_75, function(arg0_77)
			return arg0_77.id
		end))) do
			var8_75[iter9_75] = true
		end

		local var9_75 = underscore.filter(var7_75, function(arg0_78)
			return arg0_78.level == 1 and arg0_78:getRarity() <= ShipRarity.Gray and arg0_78:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_75, arg0_78.id) and arg1_75.id ~= arg0_78.id and not var8_75[arg0_78.id]
		end)

		for iter10_75, iter11_75 in ipairs(var9_75) do
			if #var0_75 == 12 or var3_75 == 0 then
				break
			end

			local var10_75 = ShipModLayer.getModExpAdditions(var1_75, {
				iter11_75
			})
			local var11_75 = false

			for iter12_75, iter13_75 in pairs(var10_75) do
				if iter13_75 > 0 and var2_75[iter12_75] > 0 then
					var11_75 = true
					var3_75 = var3_75 - math.min(var2_75[iter12_75], iter13_75)
					var2_75[iter12_75] = math.max(var2_75[iter12_75] - iter13_75, 0)
				end
			end

			if var11_75 then
				table.insert(var0_75, iter11_75)
			end
		end
	end

	return underscore.map(var0_75, function(arg0_79)
		return arg0_79.id
	end)
end

function var0_0.getUpgradeRecommendShip(arg0_80, arg1_80, arg2_80, arg3_80)
	local var0_80 = arg0_80:getUpgradeShips(arg1_80)
	local var1_80 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_4, underscore.keys(arg0_80.data))

	local function var2_80(arg0_81)
		return arg0_81.level == 1 and arg0_81:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_80, arg0_81.id) and arg1_80.id ~= arg0_81.id and not table.contains(var1_80, arg0_81.id)
	end

	local var3_80 = {}

	for iter0_80, iter1_80 in ipairs(var0_80) do
		if var2_80(iter1_80) then
			table.insert(var3_80, iter1_80)
		end
	end

	local var4_80 = {
		function(arg0_82)
			return arg0_82:isSameKind(arg1_80) and 0 or 1
		end
	}

	table.sort(var3_80, CompareFuncs(var4_80))

	local var5_80 = {}

	for iter2_80, iter3_80 in pairs(arg2_80) do
		table.insert(var5_80, arg0_80.data[iter3_80])
	end

	for iter4_80, iter5_80 in ipairs(var3_80) do
		if #var5_80 == arg3_80 then
			break
		end

		table.insert(var5_80, iter5_80)
	end

	return underscore.map(var5_80, function(arg0_83)
		return arg0_83.id
	end)
end

function var0_0.getGroupPropose(arg0_84, arg1_84)
	local var0_84 = false

	if arg0_84.data then
		for iter0_84, iter1_84 in ipairs(arg0_84.data) do
			if pg.ship_data_template[iter1_84.configId].group_type == arg1_84 and iter1_84.propose then
				return true
			end
		end
	end

	return var0_84
end

function var0_0.updateRandomFlagShips(arg0_85, arg1_85)
	for iter0_85, iter1_85 in ipairs(arg1_85) do
		arg0_85.data[iter1_85.ship_id]:updateRandomFlag(iter1_85.flag, iter1_85.shadow)
	end
end

function var0_0.getRandomFlagShipPhantomMarks(arg0_86)
	local var0_86 = {}

	for iter0_86, iter1_86 in pairs(arg0_86.data) do
		table.insertto(var0_86, iter1_86:getRandomFlagShipPhantomMarks())
	end

	return var0_86
end

function var0_0.getAllShipPhantomMarks(arg0_87)
	local var0_87 = {}

	for iter0_87, iter1_87 in pairs(arg0_87.data) do
		table.insertto(var0_87, iter1_87:getAllShipPhantomMarks())
	end

	return var0_87
end

function var0_0.GetShipPhantom(arg0_88, arg1_88)
	local var0_88, var1_88 = ShipPhantom.UnpackMark(arg1_88)

	return arg0_88.data[var0_88] and ShipPhantom.Create(arg0_88.data[var0_88], var1_88) or nil
end

function var0_0.getShipPhantomList(arg0_89, arg1_89)
	return underscore.map(arg1_89, function(arg0_90)
		return arg0_89:GetShipPhantom(arg0_90)
	end)
end

function var0_0.updateShipSkin(arg0_91, arg1_91, arg2_91, arg3_91)
	local var0_91 = arg0_91.data[arg1_91]

	assert(var0_91)
	var0_91:updateSkinId(arg3_91, arg2_91)
	arg0_91:sendNotification(var0_0.SHIP_UPDATED, var0_91:clone())
end

function var0_0.CanUseShareSkinPhantoms(arg0_92, arg1_92)
	local var0_92 = ShipSkin.New({
		id = arg1_92
	})
	local var1_92 = var0_92:IsTransSkin()
	local var2_92 = var0_92:IsProposeSkin()
	local var3_92, var4_92 = var0_92:GetShareGroupIds()
	local var5_92 = {}

	for iter0_92, iter1_92 in ipairs(var4_92) do
		var5_92[iter1_92] = true
	end

	local var6_92 = {}

	for iter2_92, iter3_92 in ipairs(underscore.filter(underscore.values(arg0_92:getRawData()), function(arg0_93)
		if not arg0_93 then
			return false
		end

		if var1_92 then
			return arg0_93.groupId == var3_92 and arg0_93:isRemoulded()
		elseif arg0_93.groupId == var3_92 or var5_92[arg0_93.groupId] and math.floor(arg0_93:getIntimacy() / 100) >= arg0_93:GetNoProposeIntimacyMax() then
			return not var2_92 or tobool(arg0_93.propose)
		else
			return false
		end
	end)) do
		table.insertto(var6_92, iter3_92:getAllShipPhantom())
	end

	return var6_92
end

return var0_0
