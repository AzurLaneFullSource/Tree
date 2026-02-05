local var0_0 = class("IslandTradegency", import(".IslandBaseAgency"))

var0_0.WEEK_NUM_UPDATE = "IslandTradegency:WEEK_NUM_UPDATE"
var0_0.RESET_PRICE = "IslandTradegency:RESET_PRICE"
var0_0.INVITE_LIST_UPDATE = "IslandTradegency:INVITE_LIST_UPDATE"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.treasure or {}

	arg0_1.weekNum = var0_1.week_buy_num or 0
	arg0_1.weekNumMax = pg.island_set.treasure_week_limit.key_value_varchar[1]
	arg0_1.sellNumMax = pg.island_set.treasure_week_limit.key_value_varchar[2]
	arg0_1.coefficient = pg.island_set.treasure_price_buy.key_value_int * 0.01
	arg0_1.sellList = {}

	for iter0_1, iter1_1 in ipairs(var0_1.sell_list or {}) do
		arg0_1.sellList[iter1_1.island_id] = iter1_1.num
	end

	arg0_1.priceList = {}

	for iter2_1, iter3_1 in ipairs(var0_1.price_list or {}) do
		arg0_1.priceList[iter3_1.timestamp] = iter3_1.price
	end

	arg0_1.ranks = {}
	arg0_1.inviteList = {}

	for iter4_1, iter5_1 in ipairs(var0_1.invite_list or {}) do
		table.insert(arg0_1.inviteList, iter5_1)
	end

	arg0_1.cacheRankTime = 0
end

function var0_0.IsInvited(arg0_2, arg1_2)
	return table.contains(arg0_2.inviteList, arg1_2)
end

function var0_0.UpdateInviteList(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3) do
		table.insert(arg0_3.inviteList, iter1_3)
	end

	arg0_3:DispatchEvent(var0_0.INVITE_LIST_UPDATE)
end

function var0_0.ClearInviteList(arg0_4)
	arg0_4.inviteList = {}

	arg0_4:DispatchEvent(var0_0.INVITE_LIST_UPDATE)
end

function var0_0.GetSellLimit(arg0_5, arg1_5)
	return arg0_5.sellList[arg1_5] or 0
end

function var0_0.UpdateSellLimit(arg0_6, arg1_6, arg2_6)
	if not arg0_6.sellList[arg1_6] then
		arg0_6.sellList[arg1_6] = 0
	end

	arg0_6.sellList[arg1_6] = arg0_6.sellList[arg1_6] + arg2_6
end

function var0_0.GetSellLimitMax(arg0_7)
	return arg0_7.sellNumMax
end

function var0_0.GetCanSellCnt(arg0_8, arg1_8)
	local var0_8 = getProxy(IslandProxy):GetIsland()
	local var1_8 = var0_8:GetInventoryAgency():GetOwnCount(IslandItem.PEARL_ID)

	if var0_8.id == arg1_8 then
		return var1_8
	end

	return math.min(var1_8, arg0_8.sellNumMax - arg0_8:GetSellLimit(arg1_8))
end

function var0_0.GetCanPurchaseCnt(arg0_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(IslandItem.GOLD_ID)
	local var1_9 = arg0_9:GetTodayPrice()
	local var2_9 = math.floor(var0_9 / var1_9)

	return math.min(var2_9, arg0_9.weekNumMax - arg0_9.weekNum)
end

function var0_0.GetWeekNum(arg0_10)
	return arg0_10.weekNum
end

function var0_0.GetWeekNumMax(arg0_11)
	return arg0_11.weekNumMax
end

function var0_0.UpdateWeekNum(arg0_12, arg1_12)
	arg0_12.weekNum = arg0_12.weekNum + arg1_12

	arg0_12:DispatchEvent(var0_0.WEEK_NUM_UPDATE)
end

function var0_0.ResetWeekNum(arg0_13)
	arg0_13.weekNum = 0

	arg0_13:DispatchEvent(var0_0.WEEK_NUM_UPDATE)
end

function var0_0.ShouldRefreshRank(arg0_14)
	if #arg0_14.ranks <= 0 then
		return true
	end

	return arg0_14.cacheRankTime < pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.SetRanks(arg0_15, arg1_15, arg2_15)
	arg0_15.ranks = arg1_15
	arg0_15.cacheRankTime = arg2_15
end

function var0_0.GetRanks(arg0_16)
	local var0_16 = arg0_16:GetSelfRank()

	var0_16:SetValue(math.floor(var0_16.value * arg0_16.coefficient))

	return _.map(arg0_16.ranks, function(arg0_17)
		local var0_17 = Clone(arg0_17)

		var0_17:SetValue(math.floor(arg0_17.value * arg0_16.coefficient))

		return var0_17
	end), var0_16
end

function var0_0.GetSelfRank(arg0_18)
	local var0_18 = getProxy(PlayerProxy):getRawData()
	local var1_18 = getProxy(IslandProxy):GetIsland()
	local var2_18 = var1_18:GetLevel()
	local var3_18 = var1_18:GetTradeAgency():GetTodaySellPrice()

	return (IslandTradeRank.New({
		id = var0_18.id,
		value = var3_18,
		skinId = var0_18.skinId,
		islandLevel = var2_18,
		name = var0_18.name or ""
	}))
end

function var0_0.GetSellRanks(arg0_19)
	local var0_19 = arg0_19:GetSelfRank()

	return arg0_19.ranks, var0_19
end

function var0_0.GetLatestTime(arg0_20)
	local var0_20 = {}

	for iter0_20, iter1_20 in pairs(arg0_20.priceList) do
		table.insert(var0_20, iter0_20)
	end

	table.sort(var0_20, function(arg0_21, arg1_21)
		return arg1_21 < arg0_21
	end)

	return var0_20[1] or -1
end

function var0_0.CanPurchase(arg0_22)
	return pg.TimeMgr.GetInstance():GetServerTime() <= arg0_22:GetLatestTime()
end

function var0_0.GetTodayPrice(arg0_23)
	local var0_23 = arg0_23:GetTodaySellPrice()

	return math.floor(var0_23 * arg0_23.coefficient)
end

function var0_0.GetTodaySellPrice(arg0_24)
	local var0_24 = arg0_24:GetLatestTime()

	return arg0_24.priceList[var0_24] or 0
end

function var0_0.UpdateTodayPrice(arg0_25, arg1_25, arg2_25)
	arg0_25.priceList[arg1_25] = arg2_25

	arg0_25:ClearInviteList()

	arg0_25.sellList = {}

	arg0_25:DispatchEvent(var0_0.RESET_PRICE)
end

function var0_0.GetPriceTrend(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.priceList) do
		var0_26[iter0_26 - 86400] = math.floor(iter1_26 * arg0_26.coefficient)
	end

	return var0_26
end

function var0_0.GetSellPriceTrend(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(arg0_27.priceList) do
		var0_27[iter0_27 - 86400] = iter1_27
	end

	return var0_27
end

function var0_0.ExistTrade(arg0_28, arg1_28)
	return arg0_28:GetPriceTrend()[arg1_28] ~= nil
end

function var0_0.UpdatePerHour(arg0_29, arg1_29)
	if pg.TimeMgr.GetInstance():GetServerWeek() == 1 and arg1_29 == 3 then
		arg0_29:ResetWeekNum()
	end

	if arg1_29 == 3 then
		-- block empty
	end
end

return var0_0
