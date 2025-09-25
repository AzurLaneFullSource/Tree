local var0_0 = {}

function var0_0.GetGiftList(arg0_1)
	local var0_1 = {}
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(pg.item_data_statistics.get_id_list_by_type[Item.SHIP_GIFT]) do
		local var2_1 = getProxy(BagProxy):getItemById(iter1_1)

		if var2_1 and var2_1.count > 0 then
			table.insert(var1_1, Item.New({
				id = iter1_1,
				count = var2_1.count
			}))
		else
			table.insert(var0_1, Item.New({
				count = 0,
				id = iter1_1
			}))
		end
	end

	local var3_1 = var0_0.SortGiftList(var1_1, arg0_1)
	local var4_1 = var0_0.SortGiftList(var0_1, arg0_1)

	table.insertto(var3_1, var4_1)

	return var3_1
end

function var0_0.SortGiftList(arg0_2, arg1_2)
	table.sort(arg0_2, function(arg0_3, arg1_3)
		local var0_3 = var0_0.GetItemFavoriteState(arg1_2, arg0_3)
		local var1_3 = var0_0.GetItemFavoriteState(arg1_2, arg1_3)

		if var0_3 ~= var1_3 then
			return var0_3 < var1_3
		end

		if arg0_3:getConfig("rarity") ~= arg1_3:getConfig("rarity") then
			return arg0_3:getConfig("rarity") > arg1_3:getConfig("rarity")
		end

		return arg0_3.id < arg1_3.id
	end)

	return arg0_2
end

function var0_0.GetItemFavoriteState(arg0_4, arg1_4)
	local var0_4 = arg0_4:getConfig("gift_dislike")

	var0_4 = arg0_4:getConfig("gift_prefer") ~= "" and var0_4 or {}

	if table.contains(var0_4, arg1_4.id) then
		return ShipGiftConst.GIFT_FAVORITE_STATE.HATE
	end

	return ShipGiftConst.GIFT_FAVORITE_STATE.LIKE
end

function var0_0.GetItemIntimacyValue(arg0_5, arg1_5)
	return var0_0.GetItemFavoriteState(arg0_5, arg1_5) == ShipGiftConst.GIFT_FAVORITE_STATE.LIKE and arg1_5:getConfig("usage_arg")[2] or 0
end

function var0_0.GetItemIntimacySpriteName(arg0_6, arg1_6)
	local var0_6 = var0_0.GetItemFavoriteState(arg0_6, arg1_6)

	if var0_6 == ShipGiftConst.GIFT_FAVORITE_STATE.LIKE then
		return "express_3"
	elseif var0_6 == ShipGiftConst.GIFT_FAVORITE_STATE.HATE then
		return "express_1"
	end

	return nil
end

function var0_0.GetShipNeedIntimacyValue(arg0_7)
	local var0_7 = arg0_7:getIntimacy()

	return arg0_7:getIntimacyMax() * 100 - var0_7
end

function var0_0.GetNeedMaxCnt(arg0_8, arg1_8)
	local var0_8 = var0_0.GetItemIntimacyValue(arg0_8, arg1_8)
	local var1_8 = var0_0.GetShipNeedIntimacyValue(arg0_8)

	if var1_8 <= 0 then
		return 0
	end

	local var2_8 = math.ceil(var1_8 / var0_8)

	return var2_8 < arg1_8.count and var2_8 or arg1_8.count
end

function var0_0.GetNeedMinCnt(arg0_9, arg1_9)
	local var0_9 = var0_0.GetItemIntimacyValue(arg0_9, arg1_9)

	if var0_0.GetShipNeedIntimacyValue(arg0_9) <= 0 then
		return 0
	end

	return arg1_9.count > 0 and 1 or 0
end

return var0_0
