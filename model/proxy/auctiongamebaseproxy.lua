local var0_0 = class("AuctionGameBaseProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:UpdateData({})

	arg0_1.needInitFlag = true
end

function var0_0.UpdateData(arg0_2, arg1_2)
	arg0_2.gold = arg1_2.gold or 0
	arg0_2.matchNum = arg1_2.game_num or 0
	arg0_2.bidSuccessCnt = arg1_2.buy_num or 0
	arg0_2.highestProfit = arg1_2.max_profit or 0
	arg0_2.totalProfit = arg1_2.acc_profit or 0
	arg0_2.unlockCollectionCnt = arg1_2.item_list and #arg1_2.item_list or 0
	arg0_2.unlockCollectionList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.item_list or {}) do
		table.insert(arg0_2.unlockCollectionList, iter1_2)
	end

	arg0_2.totalBidPrice = arg1_2.acc_buy_price or 0
	arg0_2.totalCollectionPrice = arg1_2.acc_item_price or 0
	arg0_2.preorderState = arg1_2.pre_buy_state or 0
	arg0_2.preorderTimestamp = arg1_2.pre_timestamp or 0
	arg0_2.forbiddenTime = arg1_2.match_time or 0
	arg0_2.isForbidden = arg1_2.is_forbidden or 0
	arg0_2.inactiveNum = arg1_2.inactive_num or 0
	arg0_2.isMatchWarning = arg1_2.inactive_state or 0
	arg0_2.serverForbidden = arg1_2.back_forbidden or 0
	arg0_2.reliefCnt = arg1_2.get_relief_num or 0
end

function var0_0.AddGold(arg0_3, arg1_3)
	arg0_3.gold = arg0_3.gold + arg1_3

	local var0_3 = pg.gameset.auction_currency_ceiling.key_value

	if var0_3 < arg0_3.gold then
		arg0_3.gold = var0_3
	end
end

function var0_0.GetPreorderState(arg0_4)
	return arg0_4.preorderState
end

function var0_0.GetPreorderTimestamp(arg0_5)
	return arg0_5.preorderTimestamp
end

function var0_0.SetOrderTimestamp(arg0_6, arg1_6)
	arg0_6.preorderTimestamp = arg1_6
	arg0_6.preorderState = 1
end

function var0_0.SetMatchWarning(arg0_7)
	arg0_7.isMatchWarning = 1
end

function var0_0.GetNeedInitFlag(arg0_8)
	return arg0_8.needInitFlag
end

function var0_0.SetNeedInitFlag(arg0_9, arg1_9)
	arg0_9.needInitFlag = arg1_9
end

function var0_0.GetUnlockCollectionList(arg0_10)
	return arg0_10.unlockCollectionList
end

function var0_0.AddReliefCnt(arg0_11)
	arg0_11.reliefCnt = arg0_11.reliefCnt + 1
end

function var0_0.UpdateSettlementData(arg0_12, arg1_12)
	arg0_12.storeLine = arg1_12.line or 10
	arg0_12.bidItemList = {}

	for iter0_12, iter1_12 in ipairs(arg1_12.item_list) do
		arg0_12.bidItemList[iter0_12] = AuctionGameStoreItemData.New(iter1_12)
	end
end

function var0_0.GetItemList(arg0_13)
	return arg0_13.bidItemList
end

function var0_0.GetMaxLineCnt(arg0_14)
	return arg0_14.storeLine > 10 and arg0_14.storeLine or 10
end

return var0_0
