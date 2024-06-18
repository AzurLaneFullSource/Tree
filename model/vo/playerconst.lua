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
var0_0.ResStoreGold = 16
var0_0.ResStoreOil = 17
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

	switch(arg0_1.type, var1_0, function()
		assert(false)
	end, arg0_1)
end

function addPlayerOwn(arg0_6)
	arg0_6.count = math.max(arg0_6.count, 0)

	var2_0(arg0_6)
end

function reducePlayerOwn(arg0_7)
	arg0_7.count = -math.max(arg0_7.count, 0)

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

	local var2_8 = {}

	for iter2_8, iter3_8 in ipairs(arg0_8) do
		local var3_8, var4_8 = iter3_8:DropTrans(var1_8, arg1_8)

		if var3_8 then
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

function var0_0.BonusItemMarker(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10) do
		if iter1_10.type == DROP_TYPE_VITEM and iter1_10:getConfig("virtual_type") == 20 then
			iter1_10.catchupActTag = var0_10[iter1_10.id]
			var0_10[iter1_10.id] = true
		end
	end

	return arg0_10
end

local var3_0
local var4_0

function var0_0.MergePassItemDrop(arg0_11)
	if not var3_0 then
		var4_0 = {
			[DROP_TYPE_SKIN] = 1,
			[DROP_TYPE_SHIP] = 9
		}
		var3_0 = {}

		for iter0_11, iter1_11 in pairs({
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
			for iter2_11, iter3_11 in pairs(iter1_11) do
				var3_0[string.format("%d_%d", iter0_11, iter2_11)] = iter3_11
			end
		end

		var0_0.PassItemOrder = setmetatable(var3_0, {
			__index = function(arg0_12, arg1_12)
				local var0_12, var1_12 = unpack(underscore.map(string.split(arg1_12, "_"), function(arg0_13)
					return tonumber(arg0_13)
				end))

				if var4_0[var0_12] then
					arg0_12[arg1_12] = var4_0[var0_12]
				elseif var0_12 == DROP_TYPE_ITEM and Item.getConfigData(var1_12).type == 13 then
					arg0_12[arg1_12] = 9
				else
					arg0_12[arg1_12] = 100
				end

				return arg0_12[arg1_12]
			end
		})
	end

	local var0_11 = var0_0.MergeSameDrops(arg0_11)

	table.sort(var0_11, CompareFuncs({
		function(arg0_14)
			return var0_0.PassItemOrder[arg0_14.type .. "_" .. arg0_14.id]
		end,
		function(arg0_15)
			return arg0_15.id
		end
	}))

	return var0_11
end

function var0_0.CheckResForShopping(arg0_16, arg1_16)
	local var0_16 = arg0_16.count * arg1_16
	local var1_16 = 0

	if arg0_16.type == DROP_TYPE_RESOURCE then
		var1_16 = getProxy(PlayerProxy):getRawData():getResource(arg0_16.id)
	elseif arg0_16.type == DROP_TYPE_ITEM then
		var1_16 = getProxy(BagProxy):getItemCountById(arg0_16.id)
	else
		assert(false)
	end

	return var0_16 <= var1_16
end

function var0_0.ConsumeResForShopping(arg0_17, arg1_17)
	local var0_17 = arg0_17.count * arg1_17

	if arg0_17.type == DROP_TYPE_RESOURCE then
		local var1_17 = getProxy(PlayerProxy):getData()

		var1_17:consume({
			[id2res(arg0_17.id)] = var0_17
		})
		getProxy(PlayerProxy):updatePlayer(var1_17)
	elseif arg0_17.type == DROP_TYPE_ITEM then
		getProxy(BagProxy):removeItemById(arg0_17.id, var0_17)
	else
		assert(false)
	end
end

function var0_0.GetTranAwards(arg0_18, arg1_18)
	local var0_18 = {}
	local var1_18 = PlayerConst.addTranDrop(arg1_18.award_list)

	for iter0_18, iter1_18 in ipairs(var0_18) do
		if iter1_18.type == DROP_TYPE_SHIP then
			local var2_18 = pg.ship_data_template[iter1_18.id]

			if not getProxy(CollectionProxy):getShipGroup(var2_18.group_type) and Ship.inUnlockTip(iter1_18.id) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", var2_18.name))
			end
		end
	end

	if arg0_18.isAwardMerge then
		var1_18 = var0_0.MergeSameDrops(var1_18)
	end

	return var1_18
end

function var0_0.MergeTechnologyAward(arg0_19)
	local var0_19 = arg0_19.items

	for iter0_19, iter1_19 in ipairs(arg0_19.commons) do
		iter1_19.riraty = true

		table.insert(var0_19, iter1_19)
	end

	for iter2_19, iter3_19 in ipairs(arg0_19.catchupItems) do
		iter3_19.catchupTag = true

		table.insert(var0_19, iter3_19)
	end

	for iter4_19, iter5_19 in ipairs(arg0_19.catchupActItems) do
		iter5_19.catchupActTag = true

		table.insert(var0_19, iter5_19)
	end

	return var0_19
end

function var0_0.CanDropItem(arg0_20)
	local var0_20 = getProxy(ActivityProxy)
	local var1_20 = var0_20:getActivityById(ActivityConst.UTAWARERU_ACTIVITY_PT_ID)

	if var1_20 and not var1_20:isEnd() then
		local var2_20 = var1_20:getConfig("config_client").pt_id
		local var3_20 = _.detect(var0_20:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_21)
			return arg0_21:getConfig("config_id") == var2_20
		end):getData1()

		if var3_20 >= 1500 then
			local var4_20 = var3_20 - 1500
			local var5_20 = _.detect(arg0_20, function(arg0_22)
				return arg0_22.type == DROP_TYPE_RESOURCE and arg0_22.id == var2_20
			end)

			arg0_20 = _.filter(arg0_20, function(arg0_23)
				return arg0_23.type ~= DROP_TYPE_RESOURCE or arg0_23.id ~= var2_20
			end)

			if var5_20 and var4_20 < var5_20.count then
				var5_20.count = var5_20.count - var4_20

				table.insert(arg0_20, var5_20)
			end
		end
	end

	arg0_20 = PlayerConst.BonusItemMarker(arg0_20)

	return table.getCount(arg0_20) > 0
end

local var5_0

local function var6_0(arg0_24)
	var5_0 = var5_0 or {
		[DROP_TYPE_SHIP] = true,
		[DROP_TYPE_OPERATION] = true,
		[DROP_TYPE_LOVE_LETTER] = true
	}

	if var5_0[arg0_24.type] then
		return true
	elseif arg0_24.type == DROP_TYPE_ITEM and tobool(arg0_24.extra) then
		return true
	else
		return false
	end
end

function var0_0.MergeSameDrops(arg0_25)
	local var0_25 = {}
	local var1_25 = {}

	for iter0_25, iter1_25 in ipairs(arg0_25) do
		local var2_25 = iter1_25.type .. "_" .. iter1_25.id

		if not var1_25[var2_25] then
			if var6_0(iter1_25) then
				-- block empty
			else
				var1_25[var2_25] = iter1_25
			end

			table.insert(var0_25, iter1_25)
		else
			var1_25[var2_25].count = var1_25[var2_25].count + iter1_25.count
		end
	end

	return var0_25
end

return var0_0
