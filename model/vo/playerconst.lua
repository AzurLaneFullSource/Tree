local var0_0 = class("PlayerConst")

var0_0.ResGold = 1
var0_0.ResOil = 2
var0_0.ResExploit = 3
var0_0.ResDiamond = 4
var0_0.ResOilField = 5
var0_0.ResDormMoney = 6
var0_0.ResGoldField = 7
var0_0.ResGuildCoin = 8
var0_0.ResBlueprintFragment = 9
var0_0.ResClassField = 10
var0_0.ResFreeDiamond = 14
var0_0.ResStoreGold = 16
var0_0.ResStoreOil = 17
var0_0.ResIslandGold = 18
var0_0.ResIslandGem = 19
var0_0.ResIslandSpeedUpTicket = 20
var0_0.ResBattery = 101
var0_0.ResPT = 102

local var1_0

local function var2_0(arg0_1)
	var1_0 = var1_0 or {
		[DROP_TYPE_RESOURCE] = function(arg0_2)
			local var0_2 = getProxy(PlayerProxy)

			if var0_2 then
				var0_2:UpdatePlayerRes({
					arg0_2
				})
			end
		end,
		[DROP_TYPE_ITEM] = function(arg0_3)
			local var0_3 = getProxy(BagProxy)

			if var0_3 then
				if arg0_3.count > 0 then
					var0_3:addItemById(arg0_3.id, arg0_3.count)
				elseif arg0_3.count < 0 then
					var0_3:removeItemById(arg0_3.id, -arg0_3.count)
				end
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_4)
			local var0_4 = nowWorld()

			assert(var0_4.type == World.TypeFull)

			local var1_4 = var0_4:GetInventoryProxy()

			if var1_4 then
				if arg0_4.count > 0 then
					var1_4:AddItem(arg0_4.id, arg0_4.count)
				elseif arg0_4.count < 0 then
					var1_4:RemoveItem(arg0_4.id, -arg0_4.count)
				end
			end
		end
	}

	switch(arg0_1.type, var1_0, function(arg0_5)
		if arg0_5.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_5 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_5.type].activity_id)

			if var0_5 and not var0_5:isEnd() then
				if arg0_5.count > 0 then
					var0_5:addVitemNumber(arg0_5.id, arg0_5.count)
				elseif arg0_5.count < 0 then
					var0_5:subVitemNumber(arg0_5.id, -arg0_5.count)
				end
			end

			getProxy(ActivityProxy):updateActivity(var0_5)
		else
			assert(false, string.format("without drop_type_%d owner logic from id_%d", type, arg0_5.id))
		end
	end, arg0_1)
end

function addPlayerOwn(arg0_6)
	arg0_6.count = math.max(arg0_6.count, 0)

	var2_0(arg0_6)
end

function reducePlayerOwn(arg0_7)
	arg0_7.count = -math.max(arg0_7.count, 0)

	print(arg0_7.count)
	var2_0(arg0_7)
end

function var0_0.addTranDrop(arg0_8, arg1_8)
	arg0_8 = underscore.map(arg0_8, function(arg0_9)
		return Drop.New({
			type = arg0_9.type,
			id = arg0_9.id,
			count = arg0_9.number
		})
	end)

	local var0_8 = getProxy(BayProxy):getNewShip(false)
	local var1_8 = {}

	for iter0_8, iter1_8 in pairs(var0_8) do
		if iter1_8:isMetaShip() then
			table.insert(var1_8, iter1_8.configId)
		end
	end

	for iter2_8, iter3_8 in ipairs(arg0_8) do
		if iter3_8.type == DROP_TYPE_SHIP and Ship.isMetaShipByConfigID(iter3_8.id) and not Player.isMetaShipNeedToTrans(iter3_8.id) then
			getProxy(MetaCharacterProxy):setMetaIDMark(iter3_8.id)
		end
	end

	local var2_8 = {}

	for iter4_8, iter5_8 in ipairs(arg0_8) do
		local var3_8, var4_8 = iter5_8:DropTrans(var1_8, arg1_8)

		if var3_8 and var3_8.type ~= DROP_TYPE_TIMESTAMP then
			table.insert(var2_8, var3_8)
			pg.m02:sendNotification(GAME.ADD_ITEM, var3_8)
		end

		if var4_8 then
			pg.m02:sendNotification(GAME.ADD_ITEM, var4_8)
		end
	end

	if arg1_8 and arg1_8.taskId and pg.task_data_template[arg1_8.taskId].auto_commit == 1 then
		return {}
	else
		return var2_8
	end
end

local var3_0
local var4_0

function var0_0.MergePassItemDrop(arg0_10)
	if not var3_0 then
		var4_0 = {
			[DROP_TYPE_SKIN] = 1,
			[DROP_TYPE_SHIP] = 9
		}
		var3_0 = {}

		for iter0_10, iter1_10 in pairs({
			[DROP_TYPE_RESOURCE] = {
				8,
				8,
				[14] = 2
			},
			[DROP_TYPE_ITEM] = {
				[20001] = 3,
				[21101] = 12,
				[16502] = 6,
				[50006] = 10,
				[16004] = 7,
				[16024] = 7,
				[17023] = 16,
				[17024] = 11,
				[30035] = 13,
				[15008] = 15,
				[42036] = 4,
				[30025] = 13,
				[21131] = 12,
				[21121] = 12,
				[17013] = 16,
				[42030] = 5,
				[20013] = 14,
				[17044] = 11,
				[17004] = 11,
				[17014] = 11,
				[30015] = 13,
				[16014] = 7,
				[17003] = 16,
				[21111] = 12,
				[17043] = 16,
				[17034] = 11,
				[54007] = 5,
				[30045] = 13,
				[15001] = 17,
				[17033] = 16
			}
		}) do
			for iter2_10, iter3_10 in pairs(iter1_10) do
				var3_0[string.format("%d_%d", iter0_10, iter2_10)] = iter3_10
			end
		end

		var0_0.PassItemOrder = setmetatable(var3_0, {
			__index = function(arg0_11, arg1_11)
				local var0_11, var1_11 = unpack(underscore.map(string.split(arg1_11, "_"), function(arg0_12)
					return tonumber(arg0_12)
				end))

				if var4_0[var0_11] then
					arg0_11[arg1_11] = var4_0[var0_11]
				elseif var0_11 == DROP_TYPE_ITEM and Item.getConfigData(var1_11).type == 13 then
					arg0_11[arg1_11] = 9
				else
					arg0_11[arg1_11] = 100
				end

				return arg0_11[arg1_11]
			end
		})
	end

	local var0_10 = var0_0.MergeSameDrops(arg0_10)

	table.sort(var0_10, CompareFuncs({
		function(arg0_13)
			return var0_0.PassItemOrder[arg0_13.type .. "_" .. arg0_13.id]
		end,
		function(arg0_14)
			return arg0_14.id
		end
	}))

	return var0_10
end

function var0_0.CheckResForShopping(arg0_15, arg1_15)
	local var0_15 = arg0_15.count * arg1_15
	local var1_15 = 0

	if arg0_15.type == DROP_TYPE_RESOURCE then
		var1_15 = getProxy(PlayerProxy):getRawData():getResource(arg0_15.id)
	elseif arg0_15.type == DROP_TYPE_ITEM then
		var1_15 = getProxy(BagProxy):getItemCountById(arg0_15.id)
	else
		assert(false)
	end

	return var0_15 <= var1_15
end

function var0_0.ConsumeResForShopping(arg0_16, arg1_16)
	local var0_16 = arg0_16.count * arg1_16

	if arg0_16.type == DROP_TYPE_RESOURCE then
		local var1_16 = getProxy(PlayerProxy):getData()

		var1_16:consume({
			[id2res(arg0_16.id)] = var0_16
		})
		getProxy(PlayerProxy):updatePlayer(var1_16)
	elseif arg0_16.type == DROP_TYPE_ITEM then
		getProxy(BagProxy):removeItemById(arg0_16.id, var0_16)
	else
		assert(false)
	end
end

function var0_0.GetTranAwards(arg0_17, arg1_17)
	local var0_17 = {}
	local var1_17 = PlayerConst.addTranDrop(arg1_17.award_list)

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if iter1_17.type == DROP_TYPE_SHIP then
			local var2_17 = pg.ship_data_template[iter1_17.id]

			if not getProxy(CollectionProxy):getShipGroup(var2_17.group_type) and Ship.inUnlockTip(iter1_17.id) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", var2_17.name))
			end
		end
	end

	if arg0_17.isAwardMerge then
		var1_17 = var0_0.MergeSameDrops(var1_17)
	end

	return var1_17
end

function var0_0.MergeTechnologyAward(arg0_18)
	local var0_18 = arg0_18.items

	for iter0_18, iter1_18 in ipairs(arg0_18.commons) do
		iter1_18.riraty = true

		table.insert(var0_18, iter1_18)
	end

	for iter2_18, iter3_18 in ipairs(arg0_18.catchupItems) do
		iter3_18.catchupTag = true

		table.insert(var0_18, iter3_18)
	end

	for iter4_18, iter5_18 in ipairs(arg0_18.catchupActItems) do
		iter5_18.catchupActTag = true

		table.insert(var0_18, iter5_18)
	end

	return var0_18
end

function var0_0.CanDropItem(arg0_19)
	local var0_19 = getProxy(ActivityProxy)
	local var1_19 = var0_19:getActivityById(ActivityConst.UTAWARERU_ACTIVITY_PT_ID)

	if var1_19 and not var1_19:isEnd() then
		local var2_19 = var1_19:getConfig("config_client").pt_id
		local var3_19 = _.detect(var0_19:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_20)
			return arg0_20:getConfig("config_id") == var2_19
		end):getData1()

		if var3_19 >= 1500 then
			local var4_19 = var3_19 - 1500
			local var5_19 = _.detect(arg0_19, function(arg0_21)
				return arg0_21.type == DROP_TYPE_RESOURCE and arg0_21.id == var2_19
			end)

			arg0_19 = _.filter(arg0_19, function(arg0_22)
				return arg0_22.type ~= DROP_TYPE_RESOURCE or arg0_22.id ~= var2_19
			end)

			if var5_19 and var4_19 < var5_19.count then
				var5_19.count = var5_19.count - var4_19

				table.insert(arg0_19, var5_19)
			end
		end
	end

	return table.getCount(arg0_19) > 0
end

local var5_0

local function var6_0(arg0_23)
	var5_0 = var5_0 or {
		[DROP_TYPE_SHIP] = true,
		[DROP_TYPE_OPERATION] = true,
		[DROP_TYPE_LOVE_LETTER] = true
	}

	if var5_0[arg0_23.type] then
		return true
	elseif arg0_23.type == DROP_TYPE_ITEM and tobool(arg0_23.extra) then
		return true
	else
		return false
	end
end

function var0_0.MergeSameDrops(arg0_24)
	local var0_24 = {}
	local var1_24 = {}

	for iter0_24, iter1_24 in ipairs(arg0_24) do
		local var2_24 = iter1_24.type .. "_" .. iter1_24.id

		if not var1_24[var2_24] then
			if var6_0(iter1_24) then
				-- block empty
			else
				var1_24[var2_24] = iter1_24
			end

			table.insert(var0_24, iter1_24)
		else
			var1_24[var2_24].count = var1_24[var2_24].count + iter1_24.count
		end
	end

	return var0_24
end

function var0_0.CheckMedalAllCollectionTrack()
	local var0_25, var1_25 = unpack(getGameset("live_streaming26_data2")[2])
	local var2_25 = 0
	local var3_25 = getProxy(PlayerProxy):getRawData()

	for iter0_25, iter1_25 in pairs(pg.activity_medal_template.get_id_list_by_group) do
		if iter0_25 == math.clamp(iter0_25, var0_25, var1_25) then
			if not var3_25.activityMedalGroupList[iter0_25] or not var3_25.activityMedalGroupList[iter0_25]:GetAll() then
				var2_25 = -1

				break
			else
				var2_25 = var2_25 + 1
			end
		end
	end

	local var4_25 = getProxy(PlayerProxy):getRawData().id

	if var2_25 > PlayerPrefs.GetInt("MEDAL_ALL_COLLECTION:" .. var4_25, 0) then
		PlayerPrefs.SetInt("MEDAL_ALL_COLLECTION:" .. var4_25, var2_25)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAllCollection(20001, var2_25))
	end
end

function var0_0.UpdateLinkActivity(arg0_26)
	local var0_26 = getProxy(ActivityProxy)
	local var1_26 = underscore.filter(var0_26:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_LINK_COLLECT), function(arg0_27)
		return not arg0_27:isEnd()
	end)

	for iter0_26, iter1_26 in ipairs(var1_26) do
		local var2_26 = pg.activity_limit_item_guide.get_id_list_by_activity[iter1_26.id]

		assert(var2_26, "activity_limit_item_guide not exist activity id: " .. iter1_26.id)

		for iter2_26, iter3_26 in ipairs(var2_26) do
			local var3_26 = pg.activity_limit_item_guide[iter3_26]

			for iter4_26, iter5_26 in ipairs(arg0_26) do
				if iter5_26.type == var3_26.type and iter5_26.id == var3_26.drop_id then
					local var4_26 = iter1_26:getKVPList(1, var3_26.id) + iter5_26.count

					iter1_26:updateKVPList(1, var3_26.id, var4_26)
				end
			end
		end

		var0_26:updateActivity(iter1_26)
	end
end

return var0_0
