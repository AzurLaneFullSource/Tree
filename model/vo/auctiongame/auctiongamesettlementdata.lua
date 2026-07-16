local var0_0 = class("AuctionGameSettlementData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.bidUserID = arg1_1.bid_user_id
	arg0_1.bidValue = arg1_1.bid_price
	arg0_1.proceeds = arg1_1.change_gold
	arg0_1.bidItemList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.item_list) do
		arg0_1.bidItemList[iter0_1] = AuctionGameStoreItemData.New(iter1_1)
	end
end

function var0_0.GetItemList(arg0_2)
	return arg0_2.bidItemList
end

function var0_0.GetSortItemList(arg0_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.bidItemList) do
		table.insert(var0_3, iter1_3)
	end

	table.sort(var0_3, function(arg0_4, arg1_4)
		if arg0_4.position.y == arg1_4.position.y then
			return arg0_4.position.x < arg1_4.position.x
		end

		return arg0_4.position.y < arg1_4.position.y
	end)

	return var0_3
end

return var0_0
