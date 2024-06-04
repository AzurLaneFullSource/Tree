local var0 = class("PlayerConst")

var0.ResGold = 1
var0.ResOil = 2
var0.ResExploit = 3
var0.ResDiamond = 4
var0.ResOilField = 5
var0.ResDormMoney = 6
var0.ResGoldField = 7
var0.ResGuildCoin = 8
var0.ResBlueprintFragment = 9
var0.ResClassField = 10
var0.ResStoreGold = 16
var0.ResStoreOil = 17
var0.ResBattery = 101
var0.ResPT = 102

local var1

local function var2(arg0)
	var1 = var1 or {
		[DROP_TYPE_RESOURCE] = function(arg0)
			local var0 = getProxy(PlayerProxy)

			if var0 then
				var0:UpdatePlayerRes({
					arg0
				})
			end
		end,
		[DROP_TYPE_ITEM] = function(arg0)
			local var0 = getProxy(BagProxy)

			if var0 then
				if arg0.count > 0 then
					var0:addItemById(arg0.id, arg0.count)
				elseif arg0.count < 0 then
					var0:removeItemById(arg0.id, -arg0.count)
				end
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0)
			local var0 = nowWorld()

			assert(var0.type == World.TypeFull)

			local var1 = var0:GetInventoryProxy()

			if var1 then
				if arg0.count > 0 then
					var1:AddItem(arg0.id, arg0.count)
				elseif arg0.count < 0 then
					var1:RemoveItem(arg0.id, -arg0.count)
				end
			end
		end
	}

	switch(arg0.type, var1, function()
		assert(false)
	end, arg0)
end

function addPlayerOwn(arg0)
	arg0.count = math.max(arg0.count, 0)

	var2(arg0)
end

function reducePlayerOwn(arg0)
	arg0.count = -math.max(arg0.count, 0)

	var2(arg0)
end

function var0.addTranDrop(arg0, arg1)
	arg0 = underscore.map(arg0, function(arg0)
		return Drop.New({
			type = arg0.type,
			id = arg0.id,
			count = arg0.number
		})
	end)

	local var0 = getProxy(BayProxy):getNewShip(false)
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		if iter1:isMetaShip() then
			table.insert(var1, iter1.configId)
		end
	end

	local var2 = {}

	for iter2, iter3 in ipairs(arg0) do
		local var3, var4 = iter3:DropTrans(var1, arg1)

		if var3 then
			table.insert(var2, var3)
			pg.m02:sendNotification(GAME.ADD_ITEM, var3)
		end

		if var4 then
			pg.m02:sendNotification(GAME.ADD_ITEM, var4)
		end
	end

	if arg1 and arg1.taskId and pg.task_data_template[arg1.taskId].auto_commit == 1 then
		return {}
	else
		return var2
	end
end

function var0.BonusItemMarker(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		if iter1.type == DROP_TYPE_VITEM and iter1:getConfig("virtual_type") == 20 then
			iter1.catchupActTag = var0[iter1.id]
			var0[iter1.id] = true
		end
	end

	return arg0
end

local var3
local var4

function var0.MergePassItemDrop(arg0)
	if not var3 then
		var4 = {
			[DROP_TYPE_SKIN] = 1,
			[DROP_TYPE_SHIP] = 9
		}
		var3 = {}

		for iter0, iter1 in pairs({
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
			for iter2, iter3 in pairs(iter1) do
				var3[string.format("%d_%d", iter0, iter2)] = iter3
			end
		end

		var0.PassItemOrder = setmetatable(var3, {
			__index = function(arg0, arg1)
				local var0, var1 = unpack(underscore.map(string.split(arg1, "_"), function(arg0)
					return tonumber(arg0)
				end))

				if var4[var0] then
					arg0[arg1] = var4[var0]
				elseif var0 == DROP_TYPE_ITEM and Item.getConfigData(var1).type == 13 then
					arg0[arg1] = 9
				else
					arg0[arg1] = 100
				end

				return arg0[arg1]
			end
		})
	end

	local var0 = var0.MergeSameDrops(arg0)

	table.sort(var0, CompareFuncs({
		function(arg0)
			return var0.PassItemOrder[arg0.type .. "_" .. arg0.id]
		end,
		function(arg0)
			return arg0.id
		end
	}))

	return var0
end

function var0.CheckResForShopping(arg0, arg1)
	local var0 = arg0.count * arg1
	local var1 = 0

	if arg0.type == DROP_TYPE_RESOURCE then
		var1 = getProxy(PlayerProxy):getRawData():getResource(arg0.id)
	elseif arg0.type == DROP_TYPE_ITEM then
		var1 = getProxy(BagProxy):getItemCountById(arg0.id)
	else
		assert(false)
	end

	return var0 <= var1
end

function var0.ConsumeResForShopping(arg0, arg1)
	local var0 = arg0.count * arg1

	if arg0.type == DROP_TYPE_RESOURCE then
		local var1 = getProxy(PlayerProxy):getData()

		var1:consume({
			[id2res(arg0.id)] = var0
		})
		getProxy(PlayerProxy):updatePlayer(var1)
	elseif arg0.type == DROP_TYPE_ITEM then
		getProxy(BagProxy):removeItemById(arg0.id, var0)
	else
		assert(false)
	end
end

function var0.GetTranAwards(arg0, arg1)
	local var0 = {}
	local var1 = PlayerConst.addTranDrop(arg1.award_list)

	for iter0, iter1 in ipairs(var0) do
		if iter1.type == DROP_TYPE_SHIP then
			local var2 = pg.ship_data_template[iter1.id]

			if not getProxy(CollectionProxy):getShipGroup(var2.group_type) and Ship.inUnlockTip(iter1.id) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", var2.name))
			end
		end
	end

	if arg0.isAwardMerge then
		var1 = var0.MergeSameDrops(var1)
	end

	return var1
end

function var0.MergeTechnologyAward(arg0)
	local var0 = arg0.items

	for iter0, iter1 in ipairs(arg0.commons) do
		iter1.riraty = true

		table.insert(var0, iter1)
	end

	for iter2, iter3 in ipairs(arg0.catchupItems) do
		iter3.catchupTag = true

		table.insert(var0, iter3)
	end

	for iter4, iter5 in ipairs(arg0.catchupActItems) do
		iter5.catchupActTag = true

		table.insert(var0, iter5)
	end

	return var0
end

function var0.CanDropItem(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityById(ActivityConst.UTAWARERU_ACTIVITY_PT_ID)

	if var1 and not var1:isEnd() then
		local var2 = var1:getConfig("config_client").pt_id
		local var3 = _.detect(var0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0)
			return arg0:getConfig("config_id") == var2
		end):getData1()

		if var3 >= 1500 then
			local var4 = var3 - 1500
			local var5 = _.detect(arg0, function(arg0)
				return arg0.type == DROP_TYPE_RESOURCE and arg0.id == var2
			end)

			arg0 = _.filter(arg0, function(arg0)
				return arg0.type ~= DROP_TYPE_RESOURCE or arg0.id ~= var2
			end)

			if var5 and var4 < var5.count then
				var5.count = var5.count - var4

				table.insert(arg0, var5)
			end
		end
	end

	arg0 = PlayerConst.BonusItemMarker(arg0)

	return table.getCount(arg0) > 0
end

local var5

local function var6(arg0)
	var5 = var5 or {
		[DROP_TYPE_SHIP] = true,
		[DROP_TYPE_OPERATION] = true,
		[DROP_TYPE_LOVE_LETTER] = true
	}

	if var5[arg0.type] then
		return true
	elseif arg0.type == DROP_TYPE_ITEM and tobool(arg0.extra) then
		return true
	else
		return false
	end
end

function var0.MergeSameDrops(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var2 = iter1.type .. "_" .. iter1.id

		if not var1[var2] then
			if var6(iter1) then
				-- block empty
			else
				var1[var2] = iter1
			end

			table.insert(var0, iter1)
		else
			var1[var2].count = var1[var2].count + iter1.count
		end
	end

	return var0
end

return var0
