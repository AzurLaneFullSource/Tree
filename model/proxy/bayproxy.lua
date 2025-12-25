local var0_0 = class("BayProxy", import(".NetProxy"))

var0_0.SHIP_ADDED = "ship added"
var0_0.SHIP_REMOVED = "ship removed"
var0_0.SHIP_UPDATED = "ship updated"
var0_0.SHIP_EQUIPMENT_ADDED = "ship equipment added"
var0_0.SHIP_EQUIPMENT_REMOVED = "ship equipment removed"

function var0_0.register(arg0_1)
	arg0_1:on(12001, function(arg0_2)
		arg0_1.data = {}
		arg0_1.activityNPCShipIds = {}
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
					table.insert(arg0_1.activityNPCShipIds, var0_2.id)
				elseif var0_2:isMetaShip() and not table.contains(arg0_1.metaShipIDList, var0_2.id) then
					table.insert(arg0_1.metaShipIDList, var0_2.id)
				end

				var0_0.recordShipLevelVertify(var0_2)
				arg0_1:UpdateShipEquipAndSkinCount(var0_2, true)
			else
				warning("不存在的角色: " .. var0_2.id)
			end
		end

		arg0_1:ClearChangeSkinAsmr()
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
					table.insert(arg0_1.activityNPCShipIds, var0_4.id)
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

			for iter2_7, iter3_7 in ipairs(BuffHelper.GetBackYardEnergyBuffs()) do
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
		table.insert(arg0_16.activityNPCShipIds, arg1_16.id)
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

function var0_0.getActivityNPCShipByActId(arg0_35, arg1_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.activityNPCShipIds) do
		if arg0_35.data[iter1_35].activityNpc == arg1_35 then
			return iter1_35
		end
	end
end

function var0_0.getMetaShipByGroupId(arg0_36, arg1_36)
	for iter0_36, iter1_36 in pairs(arg0_36.data) do
		if iter1_36:isMetaShip() and iter1_36.metaCharacter.id == arg1_36 then
			return iter1_36
		end
	end
end

function var0_0.getMetaShipIDList(arg0_37)
	return arg0_37.metaShipIDList
end

function var0_0.updateShip(arg0_38, arg1_38)
	if arg1_38.isNpc then
		return
	end

	assert(isa(arg1_38, Ship), "should be an instance of Ship")
	assert(arg0_38.data[arg1_38.id] ~= nil, "ship should exist")

	if arg1_38.level > arg0_38.shipHighestLevel then
		arg0_38.shipHighestLevel = arg1_38.level

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_HIGHEST_LEVEL, arg0_38.shipHighestLevel)
	end

	local var0_38 = arg0_38.data[arg1_38.id]

	arg0_38:UpdateShipEquipAndSkinCount(var0_38, false)

	arg0_38.data[arg1_38.id] = arg1_38

	var0_0.recordShipLevelVertify(arg1_38)
	arg0_38:UpdateShipEquipAndSkinCount(arg1_38, true)

	if var0_38:isActivityNpc() and not arg1_38:isActivityNpc() then
		table.removebyvalue(arg0_38.activityNPCShipIds, arg1_38.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	if var0_38.level < arg1_38.level then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_LEVEL_UP, arg1_38.level - var0_38.level)
	end

	if var0_38:getStar() < arg1_38:getStar() or var0_38.intimacy < arg1_38.intimacy or var0_38.level < arg1_38.level or not var0_38.propose and arg1_38.propose then
		local var1_38 = getProxy(CollectionProxy)

		if var1_38 and not arg1_38:isActivityNpc() then
			var1_38:flushCollection(arg1_38)
		end
	end

	arg0_38:sendNotification(var0_0.SHIP_UPDATED, arg1_38:clone())
end

function var0_0.removeShip(arg0_39, arg1_39)
	assert(isa(arg1_39, Ship), "should be an instance of Ship")
	arg0_39:removeShipById(arg1_39.id)
end

function var0_0.getEquipment2ByflagShip(arg0_40)
	local var0_40 = getProxy(PlayerProxy):getData()
	local var1_40 = arg0_40:getShipById(var0_40.character)

	assert(var1_40, "ship is nil")

	return var1_40:getEquip(2)
end

function var0_0.removeShipById(arg0_41, arg1_41)
	local var0_41 = arg0_41.data[arg1_41]

	assert(var0_41 ~= nil, "ship should exist")

	if var0_41:isActivityNpc() then
		table.removebyvalue(arg0_41.activityNPCShipIds, var0_41.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	arg0_41.data[var0_41.id] = nil

	var0_41:display("removed")
	arg0_41:UpdateShipEquipAndSkinCount(var0_41, false)
	arg0_41:sendNotification(var0_0.SHIP_REMOVED, var0_41)
end

function var0_0.findShipByGroup(arg0_42, arg1_42)
	for iter0_42, iter1_42 in pairs(arg0_42.data) do
		if iter1_42.groupId == arg1_42 then
			return iter1_42
		end
	end

	return nil
end

function var0_0.findShipsByGroup(arg0_43, arg1_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in pairs(arg0_43.data) do
		if iter1_43.groupId == arg1_43 then
			table.insert(var0_43, iter1_43)
		end
	end

	return var0_43
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

	if getProxy(SettingsProxy):GetRecommendLowEnerySkipEnable() then
		var0_65 = underscore.filter(var0_65, function(arg0_67)
			return not arg0_67:isLowEnergy()
		end)
	end

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

function var0_0.getActivityRecommendShips(arg0_68, arg1_68, arg2_68, arg3_68, arg4_68)
	local var0_68 = arg0_68:getShipsByTypes(arg1_68)
	local var1_68 = {}

	for iter0_68, iter1_68 in ipairs(var0_68) do
		var1_68[iter1_68] = iter1_68:getShipCombatPower()
	end

	table.sort(var0_68, function(arg0_69, arg1_69)
		return var1_68[arg0_69] < var1_68[arg1_69]
	end)

	local var2_68 = {}

	for iter2_68, iter3_68 in ipairs(arg2_68) do
		local var3_68 = arg0_68.data[iter3_68]

		var2_68[#var2_68 + 1] = var3_68:getGroupId()
	end

	local var4_68 = #var0_68
	local var5_68 = {}

	while var4_68 > 0 and arg3_68 > 0 do
		local var6_68 = var0_68[var4_68]
		local var7_68 = var6_68.id
		local var8_68 = var6_68:getGroupId()

		if not table.contains(arg2_68, var7_68) and not table.contains(var2_68, var8_68) and ShipStatus.ShipStatusCheck("inActivity", var6_68, nil, {
			inActivity = arg4_68
		}) then
			table.insert(var5_68, var6_68)
			table.insert(var2_68, var8_68)

			arg3_68 = arg3_68 - 1
		end

		var4_68 = var4_68 - 1
	end

	return var5_68
end

function var0_0.getDelegationRecommendShips(arg0_70, arg1_70)
	local var0_70 = 6 - #arg1_70.shipIds
	local var1_70 = arg1_70.template.ship_type
	local var2_70 = arg1_70.template.ship_lv
	local var3_70 = math.max(var2_70, 2)
	local var4_70 = Clone(arg1_70.shipIds)
	local var5_70 = arg0_70:getShipsByTypes(var1_70)

	table.sort(var5_70, function(arg0_71, arg1_71)
		return arg0_71.level > arg1_71.level
	end)

	local var6_70 = {}
	local var7_70 = false

	for iter0_70, iter1_70 in ipairs(var4_70) do
		local var8_70 = arg0_70.data[iter1_70]

		if var3_70 <= var8_70.level then
			var7_70 = true
		end

		var6_70[#var6_70 + 1] = var8_70:getGroupId()
	end

	if var7_70 then
		var3_70 = 2
	end

	local var9_70 = {}
	local var10_70 = #var5_70

	while var10_70 > 0 do
		if var0_70 <= 0 then
			break
		end

		local var11_70 = var5_70[var10_70]
		local var12_70 = var11_70.id
		local var13_70 = var11_70:getGroupId()

		if var3_70 <= var11_70.level and var11_70.lockState ~= Ship.LOCK_STATE_UNLOCK and not table.contains(var4_70, var12_70) and not table.contains(var6_70, var13_70) and not table.contains(var9_70, var12_70) and not var11_70:getFlag("inElite") and not var11_70:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var11_70) then
			table.insert(var6_70, var13_70)
			table.insert(var9_70, var12_70)

			var0_70 = var0_70 - 1

			if var7_70 == false then
				var7_70 = true
				var3_70 = 2
				var10_70 = #var5_70
			end
		else
			var10_70 = var10_70 - 1
		end
	end

	return var9_70
end

function var0_0.getDelegationRecommendShipsLV1(arg0_72, arg1_72)
	local var0_72 = 6 - #arg1_72.shipIds
	local var1_72 = arg1_72.template.ship_type
	local var2_72 = Clone(arg1_72.shipIds)
	local var3_72 = arg0_72:getShipsByTypes(var1_72)
	local var4_72 = _.select(var3_72, function(arg0_73)
		return arg0_73.level == 1
	end)

	table.sort(var4_72, CompareFuncs({
		function(arg0_74)
			return arg0_74.lockState == arg0_74.LOCK_STATE_UNLOCK and 0 or 1
		end
	}))

	local var5_72 = {}

	for iter0_72, iter1_72 in ipairs(var2_72) do
		local var6_72 = arg0_72.data[iter1_72]

		var5_72[#var5_72 + 1] = var6_72:getGroupId()
	end

	local var7_72 = {}
	local var8_72 = #var4_72

	while var8_72 > 0 do
		if var0_72 <= 0 then
			break
		end

		local var9_72 = var4_72[var8_72]
		local var10_72 = var9_72.id
		local var11_72 = var9_72:getGroupId()

		if not table.contains(var2_72, var10_72) and not table.contains(var5_72, var11_72) and not table.contains(var7_72, var10_72) and not var9_72:getFlag("inElite") and not var9_72:getFlag("inActivity") and ShipStatus.ShipStatusCheck("inEvent", var9_72) then
			table.insert(var5_72, var11_72)
			table.insert(var7_72, var10_72)

			var0_72 = var0_72 - 1
		else
			var8_72 = var8_72 - 1
		end
	end

	return var7_72
end

function var0_0.getWorldRecommendShip(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75:getShipsByTeamType(arg1_75)
	local var1_75 = {}

	for iter0_75, iter1_75 in ipairs(var0_75) do
		var1_75[iter1_75] = iter1_75:getShipCombatPower()
	end

	table.sort(var0_75, function(arg0_76, arg1_76)
		return var1_75[arg0_76] < var1_75[arg1_76]
	end)

	local var2_75 = {}

	for iter2_75, iter3_75 in ipairs(arg2_75) do
		var2_75[#var2_75 + 1] = arg0_75.data[iter3_75]:getGroupId()
	end

	local var3_75 = #var0_75
	local var4_75

	while var3_75 > 0 do
		local var5_75 = var0_75[var3_75]
		local var6_75 = var5_75.id
		local var7_75 = var5_75:getGroupId()

		if not table.contains(arg2_75, var6_75) and not table.contains(var2_75, var7_75) and ShipStatus.ShipStatusCheck("inWorld", var5_75) then
			var4_75 = var5_75

			break
		else
			var3_75 = var3_75 - 1
		end
	end

	return var4_75
end

function var0_0.getModRecommendShip(arg0_77, arg1_77, arg2_77)
	local var0_77 = underscore.map(arg2_77, function(arg0_78)
		return arg0_77.data[arg0_78]
	end)
	local var1_77 = Clone(arg1_77)

	for iter0_77, iter1_77 in pairs(ShipModLayer.getModExpAdditions(var1_77, var0_77)) do
		var1_77:addModAttrExp(iter0_77, iter1_77)
	end

	local var2_77 = var1_77:getNeedModExp()
	local var3_77 = 0

	for iter2_77, iter3_77 in pairs(var2_77) do
		var3_77 = var3_77 + iter3_77
	end

	local var4_77 = {}

	for iter4_77, iter5_77 in pairs(arg0_77.data) do
		if iter5_77:isSameKind(arg1_77) then
			var4_77.sameKind = var4_77.sameKind or {}

			table.insert(var4_77.sameKind, iter5_77)
		else
			local var5_77 = iter5_77:getShipType()

			var4_77[var5_77] = var4_77[var5_77] or {}

			table.insert(var4_77[var5_77], iter5_77)
		end
	end

	local var6_77 = arg1_77:getConfig("type")

	for iter6_77, iter7_77 in ipairs(table.mergeArray({
		"sameKind"
	}, pg.ship_data_by_type[var6_77].strengthen_choose_type)) do
		if #var0_77 == 12 or var3_77 == 0 then
			break
		end

		local var7_77 = var4_77[iter7_77] or {}
		local var8_77 = {}

		for iter8_77, iter9_77 in ipairs(pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_2, underscore.map(var7_77, function(arg0_79)
			return arg0_79.id
		end))) do
			var8_77[iter9_77] = true
		end

		local var9_77 = underscore.filter(var7_77, function(arg0_80)
			return arg0_80.level == 1 and arg0_80:getRarity() <= ShipRarity.Gray and arg0_80:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_77, arg0_80.id) and arg1_77.id ~= arg0_80.id and not var8_77[arg0_80.id]
		end)

		for iter10_77, iter11_77 in ipairs(var9_77) do
			if #var0_77 == 12 or var3_77 == 0 then
				break
			end

			local var10_77 = ShipModLayer.getModExpAdditions(var1_77, {
				iter11_77
			})
			local var11_77 = false

			for iter12_77, iter13_77 in pairs(var10_77) do
				if iter13_77 > 0 and var2_77[iter12_77] > 0 then
					var11_77 = true
					var3_77 = var3_77 - math.min(var2_77[iter12_77], iter13_77)
					var2_77[iter12_77] = math.max(var2_77[iter12_77] - iter13_77, 0)
				end
			end

			if var11_77 then
				table.insert(var0_77, iter11_77)
			end
		end
	end

	return underscore.map(var0_77, function(arg0_81)
		return arg0_81.id
	end)
end

function var0_0.getUpgradeRecommendShip(arg0_82, arg1_82, arg2_82, arg3_82)
	local var0_82 = arg0_82:getUpgradeShips(arg1_82)
	local var1_82 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_4, underscore.keys(arg0_82.data))

	local function var2_82(arg0_83)
		return arg0_83.level == 1 and arg0_83:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(arg2_82, arg0_83.id) and arg1_82.id ~= arg0_83.id and not table.contains(var1_82, arg0_83.id)
	end

	local var3_82 = {}

	for iter0_82, iter1_82 in ipairs(var0_82) do
		if var2_82(iter1_82) then
			table.insert(var3_82, iter1_82)
		end
	end

	local var4_82 = {
		function(arg0_84)
			return arg0_84:isSameKind(arg1_82) and 0 or 1
		end
	}

	table.sort(var3_82, CompareFuncs(var4_82))

	local var5_82 = {}

	for iter2_82, iter3_82 in pairs(arg2_82) do
		table.insert(var5_82, arg0_82.data[iter3_82])
	end

	for iter4_82, iter5_82 in ipairs(var3_82) do
		if #var5_82 == arg3_82 then
			break
		end

		table.insert(var5_82, iter5_82)
	end

	return underscore.map(var5_82, function(arg0_85)
		return arg0_85.id
	end)
end

function var0_0.getGroupPropose(arg0_86, arg1_86)
	local var0_86 = false

	if arg0_86.data then
		for iter0_86, iter1_86 in ipairs(arg0_86.data) do
			if pg.ship_data_template[iter1_86.configId].group_type == arg1_86 and iter1_86.propose then
				return true
			end
		end
	end

	return var0_86
end

function var0_0.updateRandomFlagShips(arg0_87, arg1_87)
	for iter0_87, iter1_87 in ipairs(arg1_87) do
		arg0_87.data[iter1_87.ship_id]:updateRandomFlag(iter1_87.flag, iter1_87.shadow)
	end
end

function var0_0.getRandomFlagShipPhantomMarks(arg0_88)
	local var0_88 = {}

	for iter0_88, iter1_88 in pairs(arg0_88.data) do
		table.insertto(var0_88, iter1_88:getRandomFlagShipPhantomMarks())
	end

	return var0_88
end

function var0_0.getAllShipPhantomMarks(arg0_89)
	local var0_89 = {}

	for iter0_89, iter1_89 in pairs(arg0_89.data) do
		table.insertto(var0_89, iter1_89:getAllShipPhantomMarks())
	end

	return var0_89
end

function var0_0.GetShipPhantom(arg0_90, arg1_90)
	local var0_90, var1_90 = ShipPhantom.UnpackMark(arg1_90)

	return arg0_90.data[var0_90] and ShipPhantom.Create(arg0_90.data[var0_90], var1_90) or nil
end

function var0_0.getShipPhantomList(arg0_91, arg1_91)
	return underscore.map(arg1_91, function(arg0_92)
		return arg0_91:GetShipPhantom(arg0_92)
	end)
end

function var0_0.ClearChangeSkinAsmr(arg0_93)
	for iter0_93, iter1_93 in pairs(arg0_93.data) do
		iter1_93:RevertAsmrSkin()
	end
end

function var0_0.updateShipSkin(arg0_94, arg1_94, arg2_94, arg3_94)
	local var0_94 = arg0_94.data[arg1_94]

	assert(var0_94)
	var0_94:updateSkinId(arg3_94, arg2_94)
	arg0_94:sendNotification(var0_0.SHIP_UPDATED, var0_94:clone())
end

function var0_0.CanUseShareSkinPhantoms(arg0_95, arg1_95)
	local var0_95 = ShipSkin.New({
		id = arg1_95
	})
	local var1_95 = var0_95:IsTransSkin()
	local var2_95 = var0_95:IsProposeSkin()
	local var3_95, var4_95 = var0_95:GetShareGroupIds()
	local var5_95 = {}

	for iter0_95, iter1_95 in ipairs(var4_95) do
		var5_95[iter1_95] = true
	end

	local var6_95 = {}

	for iter2_95, iter3_95 in ipairs(underscore.filter(underscore.values(arg0_95:getRawData()), function(arg0_96)
		if not arg0_96 then
			return false
		end

		if var1_95 then
			return arg0_96.groupId == var3_95 and arg0_96:isRemoulded()
		elseif arg0_96.groupId == var3_95 or var5_95[arg0_96.groupId] and math.floor(arg0_96:getIntimacy() / 100) >= arg0_96:GetNoProposeIntimacyMax() then
			return not var2_95 or tobool(arg0_96.propose)
		else
			return false
		end
	end)) do
		table.insertto(var6_95, iter3_95:getAllShipPhantom())
	end

	return var6_95
end

return var0_0
