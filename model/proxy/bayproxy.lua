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
		arg0_16.facade:sendNotification(var0_0.SHIP_ADDED, arg1_16:clone())
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

	arg0_35.facade:sendNotification(var0_0.SHIP_UPDATED, arg1_35:clone())
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
	arg0_38.facade:sendNotification(var0_0.SHIP_REMOVED, var0_38)
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

function var0_0._findShipsByGroup(arg0_41, arg1_41, arg2_41, arg3_41)
	local function var0_41(arg0_42)
		if arg2_41 then
			return arg0_42:isRemoulded()
		else
			return true
		end
	end

	local function var1_41(arg0_43)
		if arg3_41 then
			return arg0_43.propose
		else
			return true
		end
	end

	local var2_41 = {}

	for iter0_41, iter1_41 in pairs(arg0_41.data) do
		if iter1_41.groupId == arg1_41 and var0_41(iter1_41) and var1_41(iter1_41) then
			table.insert(var2_41, iter1_41)
		end
	end

	return var2_41
end

function var0_0.ExistGroupShip(arg0_44, arg1_44)
	for iter0_44, iter1_44 in pairs(arg0_44.data) do
		if iter1_44.groupId == arg1_44 then
			return true
		end
	end

	return false
end

function var0_0._ExistGroupShip(arg0_45, arg1_45, arg2_45, arg3_45)
	local function var0_45(arg0_46)
		if arg2_45 then
			return arg0_46:isRemoulded()
		else
			return true
		end
	end

	local function var1_45(arg0_47)
		if arg3_45 then
			return arg0_47.propose
		else
			return true
		end
	end

	for iter0_45, iter1_45 in pairs(arg0_45.data) do
		if iter1_45.groupId == arg1_45 and var0_45(iter1_45) and var1_45(iter1_45) then
			return true
		end
	end

	return false
end

function var0_0.getSameGroupShipCount(arg0_48, arg1_48)
	local var0_48 = 0

	for iter0_48, iter1_48 in pairs(arg0_48.data) do
		if iter1_48.groupId == arg1_48 then
			var0_48 = var0_48 + 1
		end
	end

	return var0_48
end

function var0_0.getUpgradeShips(arg0_49, arg1_49)
	local var0_49 = arg1_49:getConfig("rarity")
	local var1_49 = arg1_49.groupId
	local var2_49 = {}

	for iter0_49, iter1_49 in pairs(arg0_49.data) do
		if iter1_49.groupId == var1_49 or iter1_49:isTestShip() and iter1_49:canUseTestShip(var0_49) then
			table.insert(var2_49, iter1_49)
		end
	end

	return var2_49
end

function var0_0.getBayPower(arg0_50)
	local var0_50 = {}
	local var1_50 = 0

	for iter0_50, iter1_50 in pairs(arg0_50.data) do
		local var2_50 = iter1_50.configId
		local var3_50 = iter1_50:getShipCombatPower()

		if ShipGroup.GetGroupConfig(iter1_50:getGroupId()).handbook_type ~= 1 and (not var0_50[var2_50] or var3_50 > var0_50[var2_50]) then
			var1_50 = var1_50 - defaultValue(var0_50[var2_50], 0)
			var0_50[var2_50] = var3_50
			var1_50 = var1_50 + var3_50
		end
	end

	return var1_50
end

function var0_0.GetBayPowerRootedAsyn(arg0_51, arg1_51)
	local var0_51

	var0_51 = coroutine.wrap(function()
		local var0_52 = {}
		local var1_52 = 0
		local var2_52 = 0

		for iter0_52, iter1_52 in pairs(arg0_51.data) do
			local var3_52 = iter1_52.configId
			local var4_52 = iter1_52:getShipCombatPower()

			if ShipGroup.GetGroupConfig(iter1_52:getGroupId()).handbook_type ~= 1 and (not var0_52[var3_52] or var4_52 > var0_52[var3_52]) then
				var1_52 = var1_52 - defaultValue(var0_52[var3_52], 0)
				var0_52[var3_52] = var4_52
				var1_52 = var1_52 + var4_52
			end

			var2_52 = var2_52 + 1

			if var2_52 == 1 or var2_52 % 50 == 0 then
				onNextTick(var0_51)
				coroutine.yield()
			end
		end

		arg1_51(var1_52^0.667)
	end)

	var0_51()
end

function var0_0.getBayPowerRooted(arg0_53)
	return arg0_53:getBayPower()^0.667
end

function var0_0.getEquipsInShips(arg0_54, arg1_54)
	local var0_54 = {}

	for iter0_54, iter1_54 in pairs(arg0_54.data) do
		for iter2_54, iter3_54 in pairs(iter1_54.equipments) do
			if iter3_54 and (not arg1_54 or arg1_54(iter3_54, iter1_54.id)) then
				table.insert(var0_54, setmetatable({
					shipId = iter1_54.id,
					shipPos = iter2_54
				}, {
					__index = iter3_54
				}))
			end
		end
	end

	return var0_54
end

function var0_0.UpdateShipEquipAndSkinCount(arg0_55, arg1_55, arg2_55)
	if not arg1_55 then
		return
	end

	local var0_55 = arg2_55 and 1 or -1

	for iter0_55, iter1_55 in pairs(arg1_55.equipments) do
		if iter1_55 then
			arg0_55.equipCountDic[iter1_55.id] = defaultValue(arg0_55.equipCountDic[iter1_55.id], 0) + var0_55

			assert(arg0_55.equipCountDic[iter1_55.id] >= 0)
		end
	end

	for iter2_55, iter3_55 in pairs(arg1_55.equipmentSkins) do
		if iter3_55 > 0 then
			arg0_55.equipSkinCountDic[iter3_55] = defaultValue(arg0_55.equipSkinCountDic[iter3_55], 0) + var0_55

			assert(arg0_55.equipSkinCountDic[iter3_55] >= 0)
		end
	end
end

function var0_0.GetEquipCountInShips(arg0_56, arg1_56)
	return arg0_56.equipCountDic[arg1_56] or 0
end

function var0_0.GetEquipSkinCountInShips(arg0_57, arg1_57)
	return arg0_57.equipSkinCountDic[arg1_57] or 0
end

function var0_0.GetEquipsInShipsRaw(arg0_58)
	local function var0_58(arg0_59, arg1_59, arg2_59)
		local var0_59 = CreateShell(arg0_59)

		var0_59.shipId = arg1_59
		var0_59.shipPos = arg2_59

		return var0_59
	end

	local var1_58 = {}

	for iter0_58, iter1_58 in pairs(arg0_58.data) do
		for iter2_58, iter3_58 in pairs(iter1_58.equipments) do
			if iter3_58 then
				table.insert(var1_58, var0_58(iter3_58, iter1_58.id, iter2_58))
			end
		end
	end

	return var1_58
end

function var0_0.getEquipmentSkinInShips(arg0_60, arg1_60, arg2_60)
	local function var0_60(arg0_61)
		local var0_61 = false

		if arg0_61 and arg0_61 > 0 then
			local var1_61 = pg.equip_skin_template[arg0_61]

			var0_61 = _.any(var1_61.equip_type, function(arg0_62)
				return not arg2_60 or table.contains(arg2_60, arg0_62)
			end)
		end

		return var0_61
	end

	local var1_60 = {}

	for iter0_60, iter1_60 in pairs(arg0_60.data) do
		if not arg1_60 or arg1_60.id ~= iter1_60.id then
			for iter2_60, iter3_60 in pairs(iter1_60:getEquipSkins()) do
				local var2_60 = var0_60(iter3_60)

				if iter3_60 and var2_60 then
					table.insert(var1_60, {
						id = iter3_60,
						shipId = iter1_60.id,
						shipPos = iter2_60
					})
				end
			end
		end
	end

	return var1_60
end

function var0_0.GetSpWeaponsInShips(arg0_63, arg1_63)
	local var0_63 = {}

	for iter0_63, iter1_63 in pairs(arg0_63.data) do
		if not arg1_63 or arg1_63.id ~= iter1_63.id then
			local var1_63 = iter1_63:GetSpWeapon()

			if var1_63 and (not arg1_63 or not arg1_63:IsSpWeaponForbidden(var1_63)) then
				table.insert(var0_63, var1_63)
			end
		end
	end

	return var0_63
end

function var0_0.getProposeGroupList(arg0_64)
	local var0_64 = {}

	for iter0_64, iter1_64 in pairs(arg0_64.data) do
		if iter1_64:ShowPropose() then
			var0_64[iter1_64.groupId] = true
		end
	end

	return var0_64
end

function var0_0.GetRecommendShip(arg0_65, arg1_65, arg2_65, arg3_65)
	assert(arg3_65)

	local var0_65 = arg0_65:getShipsByTypes(arg1_65)
	local var1_65 = {}

	for iter0_65, iter1_65 in ipairs(var0_65) do
		var1_65[iter1_65] = iter1_65:getShipCombatPower()
	end

	table.sort(var0_65, function(arg0_66, arg1_66)
		return var1_65[arg0_66] < var1_65[arg1_66]
	end)

	local var2_65 = {}

	for iter2_65, iter3_65 in ipairs(arg2_65) do
		var2_65[#var2_65 + 1] = arg0_65.data[iter3_65]:getGroupId()
	end

	local var3_65 = #var0_65
	local var4_65

	while var3_65 > 0 do
		local var5_65 = var0_65[var3_65]
		local var6_65 = var5_65.id
		local var7_65 = var5_65:getGroupId()

		if not table.contains(arg2_65, var6_65) and not table.contains(var2_65, var7_65) and arg3_65(var5_65) then
			var4_65 = var5_65

			break
		else
			var3_65 = var3_65 - 1
		end
	end

	return var4_65
end

function var0_0.getActivityRecommendShips(arg0_67, arg1_67, arg2_67, arg3_67, arg4_67)
	local var0_67 = arg0_67:getShipsByTypes(arg1_67)
	local var1_67 = {}

	for iter0_67, iter1_67 in ipairs(var0_67) do
		var1_67[iter1_67] = iter1_67:getShipCombatPower()
	end

	table.sort(var0_67, function(arg0_68, arg1_68)
		return var1_67[arg0_68] < var1_67[arg1_68]
	end)

	local var2_67 = {}

	for iter2_67, iter3_67 in ipairs(arg2_67) do
		local var3_67 = arg0_67.data[iter3_67]

		var2_67[#var2_67 + 1] = var3_67:getGroupId()
	end

	local var4_67 = #var0_67
	local var5_67 = {}

	while var4_67 > 0 and arg3_67 > 0 do
		local var6_67 = var0_67[var4_67]
		local var7_67 = var6_67.id
		local var8_67 = var6_67:getGroupId()

		if not table.contains(arg2_67, var7_67) and not table.contains(var2_67, var8_67) and ShipStatus.ShipStatusCheck("inActivity", var6_67, nil, {
			inActivity = arg4_67
		}) then
			table.insert(var5_67, var6_67)
			table.insert(var2_67, var8_67)

			arg3_67 = arg3_67 - 1
		end

		var4_67 = var4_67 - 1
	end

	return var5_67
end

function var0_0.getDelegationRecommendShips(arg0_69, arg1_69)
	local var0_69 = 6 - #arg1_69.shipIds
	local var1_69 = arg1_69.template.ship_type
	local var2_69 = arg1_69.template.ship_lv
	local var3_69 = math.max(var2_69, 2)
	local var4_69 = Clone(arg1_69.shipIds)
	local var5_69 = arg0_69:getShipsByTypes(var1_69)

	table.sort(var5_69, function(arg0_70, arg1_70)
		return arg0_70.level > arg1_70.level
	end)

	local var6_69 = {}
	local var7_69 = false

	for iter0_69, iter1_69 in ipairs(var4_69) do
		local var8_69 = arg0_69.data[iter1_69]

		if var3_69 <= var8_69.level then
			var7_69 = true
		end

		var6_69[#var6_69 + 1] = var8_69:getGroupId()
	end

	if var7_69 then
		var3_69 = 2
	end

	local var9_69 = {}
	local var10_69 = #var5_69

	while var10_69 > 0 do
		if var0_69 <= 0 then
			break
		end

		local var11_69 = var5_69[var10_69]
		local var12_69 = var11_69.id
		local var13_69 = var11_69:getGroupId()

		if var3_69 <= var11_69.level and var11_69.lockState ~= Ship.LOCK_STATE_UNLOCK and not table.contains(var4_69, var12_69) and not table.contains(var6_69, var13_69) and not table.contains(var9_69, var12_69) and not var11_69:getFlag("inElite") and not var11_69:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var11_69) then
			table.insert(var6_69, var13_69)
			table.insert(var9_69, var12_69)

			var0_69 = var0_69 - 1

			if var7_69 == false then
				var7_69 = true
				var3_69 = 2
				var10_69 = #var5_69
			end
		else
			var10_69 = var10_69 - 1
		end
	end

	return var9_69
end

function var0_0.getDelegationRecommendShipsLV1(arg0_71, arg1_71)
	local var0_71 = 6 - #arg1_71.shipIds
	local var1_71 = arg1_71.template.ship_type
	local var2_71 = Clone(arg1_71.shipIds)
	local var3_71 = arg0_71:getShipsByTypes(var1_71)
	local var4_71 = _.select(var3_71, function(arg0_72)
		return arg0_72.level == 1
	end)

	table.sort(var4_71, CompareFuncs({
		function(arg0_73)
			return arg0_73.lockState == arg0_73.LOCK_STATE_UNLOCK and 0 or 1
		end
	}))

	local var5_71 = {}

	for iter0_71, iter1_71 in ipairs(var2_71) do
		local var6_71 = arg0_71.data[iter1_71]

		var5_71[#var5_71 + 1] = var6_71:getGroupId()
	end

	local var7_71 = {}
	local var8_71 = #var4_71

	while var8_71 > 0 do
		if var0_71 <= 0 then
			break
		end

		local var9_71 = var4_71[var8_71]
		local var10_71 = var9_71.id
		local var11_71 = var9_71:getGroupId()

		if not table.contains(var2_71, var10_71) and not table.contains(var5_71, var11_71) and not table.contains(var7_71, var10_71) and not var9_71:getFlag("inElite") and not var9_71:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var9_71) then
			table.insert(var5_71, var11_71)
			table.insert(var7_71, var10_71)

			var0_71 = var0_71 - 1
		else
			var8_71 = var8_71 - 1
		end
	end

	return var7_71
end

function var0_0.getWorldRecommendShip(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg0_74:getShipsByTeamType(arg1_74)
	local var1_74 = {}

	for iter0_74, iter1_74 in ipairs(var0_74) do
		var1_74[iter1_74] = iter1_74:getShipCombatPower()
	end

	table.sort(var0_74, function(arg0_75, arg1_75)
		return var1_74[arg0_75] < var1_74[arg1_75]
	end)

	local var2_74 = {}

	for iter2_74, iter3_74 in ipairs(arg2_74) do
		var2_74[#var2_74 + 1] = arg0_74.data[iter3_74]:getGroupId()
	end

	local var3_74 = #var0_74
	local var4_74

	while var3_74 > 0 do
		local var5_74 = var0_74[var3_74]
		local var6_74 = var5_74.id
		local var7_74 = var5_74:getGroupId()

		if not table.contains(arg2_74, var6_74) and not table.contains(var2_74, var7_74) and ShipStatus.ShipStatusCheck("inWorld", var5_74) then
			var4_74 = var5_74

			break
		else
			var3_74 = var3_74 - 1
		end
	end

	return var4_74
end

function var0_0.getModRecommendShip(arg0_76, arg1_76, arg2_76)
	local var0_76 = underscore.map(arg2_76, function(arg0_77)
		return arg0_76.data[arg0_77]
	end)
	local var1_76 = Clone(arg1_76)

	for iter0_76, iter1_76 in pairs(ShipModLayer.getModExpAdditions(var1_76, var0_76)) do
		var1_76:addModAttrExp(iter0_76, iter1_76)
	end

	local var2_76 = var1_76:getNeedModExp()
	local var3_76 = 0

	for iter2_76, iter3_76 in pairs(var2_76) do
		var3_76 = var3_76 + iter3_76
	end

	local var4_76 = {}

	for iter4_76, iter5_76 in pairs(arg0_76.data) do
		if iter5_76:isSameKind(arg1_76) then
			var4_76.sameKind = var4_76.sameKind or {}

			table.insert(var4_76.sameKind, iter5_76)
		else
			local var5_76 = iter5_76:getShipType()

			var4_76[var5_76] = var4_76[var5_76] or {}

			table.insert(var4_76[var5_76], iter5_76)
		end
	end

	local var6_76 = arg1_76:getConfig("type")

	for iter6_76, iter7_76 in ipairs(table.mergeArray({
		"sameKind"
	}, pg.ship_data_by_type[var6_76].strengthen_choose_type)) do
		if #var0_76 == 12 or var3_76 == 0 then
			break
		end

		local var7_76 = var4_76[iter7_76] or {}
		local var8_76 = {}

		for iter8_76, iter9_76 in ipairs(pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_2, underscore.map(var7_76, function(arg0_78)
			return arg0_78.id
		end))) do
			var8_76[iter9_76] = true
		end

		local var9_76 = underscore.filter(var7_76, function(arg0_79)
			return arg0_79.level == 1 and arg0_79:getRarity() <= ShipRarity.Gray and arg0_79:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_76, arg0_79.id) and arg1_76.id ~= arg0_79.id and not var8_76[arg0_79.id]
		end)

		for iter10_76, iter11_76 in ipairs(var9_76) do
			if #var0_76 == 12 or var3_76 == 0 then
				break
			end

			local var10_76 = ShipModLayer.getModExpAdditions(var1_76, {
				iter11_76
			})
			local var11_76 = false

			for iter12_76, iter13_76 in pairs(var10_76) do
				if iter13_76 > 0 and var2_76[iter12_76] > 0 then
					var11_76 = true
					var3_76 = var3_76 - math.min(var2_76[iter12_76], iter13_76)
					var2_76[iter12_76] = math.max(var2_76[iter12_76] - iter13_76, 0)
				end
			end

			if var11_76 then
				table.insert(var0_76, iter11_76)
			end
		end
	end

	return underscore.map(var0_76, function(arg0_80)
		return arg0_80.id
	end)
end

function var0_0.getUpgradeRecommendShip(arg0_81, arg1_81, arg2_81, arg3_81)
	local var0_81 = arg0_81:getUpgradeShips(arg1_81)
	local var1_81 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_4, underscore.keys(arg0_81.data))

	local function var2_81(arg0_82)
		return arg0_82.level == 1 and arg0_82:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_81, arg0_82.id) and arg1_81.id ~= arg0_82.id and not table.contains(var1_81, arg0_82.id)
	end

	local var3_81 = {}

	for iter0_81, iter1_81 in ipairs(var0_81) do
		if var2_81(iter1_81) then
			table.insert(var3_81, iter1_81)
		end
	end

	local var4_81 = {
		function(arg0_83)
			return arg0_83:isSameKind(arg1_81) and 0 or 1
		end
	}

	table.sort(var3_81, CompareFuncs(var4_81))

	local var5_81 = {}

	for iter2_81, iter3_81 in pairs(arg2_81) do
		table.insert(var5_81, arg0_81.data[iter3_81])
	end

	for iter4_81, iter5_81 in ipairs(var3_81) do
		if #var5_81 == arg3_81 then
			break
		end

		table.insert(var5_81, iter5_81)
	end

	return underscore.map(var5_81, function(arg0_84)
		return arg0_84.id
	end)
end

function var0_0.getGroupPropose(arg0_85, arg1_85)
	local var0_85 = false

	if arg0_85.data then
		for iter0_85, iter1_85 in ipairs(arg0_85.data) do
			if pg.ship_data_template[iter1_85.configId].group_type == arg1_85 and iter1_85.propose then
				return true
			end
		end
	end

	return var0_85
end

function var0_0.CanUseShareSkinShips(arg0_86, arg1_86)
	local var0_86 = pg.ship_skin_template[arg1_86].ship_group
	local var1_86 = pg.ship_data_group.get_id_list_by_group_type[var0_86][1]
	local var2_86 = pg.ship_data_group[var1_86].share_group_id
	local var3_86 = {}
	local var4_86 = arg0_86:getRawData()

	for iter0_86, iter1_86 in pairs(var4_86) do
		if table.contains(var2_86, iter1_86.groupId) and math.floor(iter1_86:getIntimacy() / 100) >= iter1_86:GetNoProposeIntimacyMax() then
			table.insert(var3_86, iter1_86)
		end
	end

	return var3_86
end

return var0_0
