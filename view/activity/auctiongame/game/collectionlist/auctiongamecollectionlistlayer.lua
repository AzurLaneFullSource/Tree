local var0_0 = class("AuctionGameCollectionListLayer", import("view.base.BaseUI"))

var0_0.ON_SWITCH_RARITY = "AuctionGameCollectionListLayer::ON_SWITCH_RARITY"
var0_0.ON_SWITCH_CONTOUR = "AuctionGameCollectionListLayer::ON_SWITCH_CONTOUR"

function var0_0.getUIName(arg0_1)
	return "AuctionGameCollectionListUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2.uiTitleText, i18n("auction_collection_title"))
	setText(arg0_2.uiCollectTitleText, i18n("auction_collect_unlock"))
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)

	arg0_2.uiScrollView = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiList, AuctionGameCollectionItem)

	arg0_2:GetFilterData()

	arg0_2.rarityItemList = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.rarityList) do
		arg0_2.rarityItemList[iter0_2] = AuctionGameCollectionRarityItem.New(arg0_2[string.format("uiRarityItem%s", iter0_2)], arg0_2)

		arg0_2.rarityItemList[iter0_2]:didEnter(iter1_2)
	end

	arg0_2.contourItemList = {}

	for iter2_2, iter3_2 in pairs(arg0_2.contourList) do
		local var0_2 = iter3_2[1]
		local var1_2 = iter3_2[2]

		table.insert(arg0_2.contourItemList, AuctionGameCollectionContourItem.New(arg0_2[string.format("uiContourItem%s", iter2_2)], arg0_2))
		arg0_2.contourItemList[#arg0_2.contourItemList]:didEnter(var1_2, var0_2)
	end
end

function var0_0.didEnter(arg0_5)
	arg0_5:OverlayPanel(arg0_5._tf, {
		pbList = {
			arg0_5.uiBg
		}
	})

	arg0_5.rarityIndex = arg0_5.contextData.rarityIndex or 0
	arg0_5.contourData = arg0_5.contextData.contour or {
		0,
		0
	}

	arg0_5:RefreshCollectionList()

	arg0_5.eventIDList = {
		arg0_5:bind(var0_0.ON_SWITCH_RARITY, handler(arg0_5, arg0_5.OnSwitchRarity)),
		arg0_5:bind(var0_0.ON_SWITCH_CONTOUR, handler(arg0_5, arg0_5.OnSwitchContour))
	}

	local var0_5 = getProxy(AuctionGameBaseProxy)

	setText(arg0_5.uiCollectText, string.format("%s/%s", var0_5.unlockCollectionCnt, #pg.auction_collection.all))
end

function var0_0.RefreshCollectionList(arg0_6)
	arg0_6:GetCollectionList(arg0_6.rarityIndex, arg0_6.contourData)
	arg0_6.uiScrollView:StartScroll(#arg0_6.idList)

	local var0_6, var1_6 = arg0_6:GetPriceArea(minValue, maxValue)

	setText(arg0_6.uiPriceAreaText, string.format("%s - %s", StringHelper.ForamtNumber(var0_6), StringHelper.ForamtNumber(var1_6)))

	for iter0_6, iter1_6 in ipairs(arg0_6.rarityItemList) do
		iter1_6:SetSelectedRarity(arg0_6.rarityIndex)
	end

	for iter2_6, iter3_6 in ipairs(arg0_6.contourItemList) do
		iter3_6:SetSelectedContour(arg0_6.contourData)
	end
end

function var0_0.IndexItem(arg0_7, arg1_7, arg2_7)
	arg2_7:didEnter(arg0_7.idList[arg1_7])
	arg2_7:ShowLockState()
end

function var0_0.GetCollectionList(arg0_8, arg1_8, arg2_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(pg.auction_collection.all) do
		local var1_8 = pg.auction_collection[iter1_8]

		if (arg1_8 == 0 or var1_8.rarity == arg1_8) and (arg2_8[1] == 0 or arg2_8[1] == var1_8.contour[1] and arg2_8[2] == var1_8.contour[2]) then
			table.insert(var0_8, iter1_8)
		end
	end

	table.sort(var0_8, function(arg0_9, arg1_9)
		local var0_9 = pg.auction_collection[arg0_9]
		local var1_9 = pg.auction_collection[arg1_9]

		if var0_9.rarity ~= var1_9.rarity then
			return var0_9.rarity > var1_9.rarity
		end

		if var0_9.contour[1] ~= var1_9.contour[1] then
			return var0_9.contour[1] > var1_9.contour[1]
		end

		if var0_9.contour[2] ~= var1_9.contour[2] then
			return var0_9.contour[2] > var1_9.contour[2]
		end

		return var0_9.value > var1_9.value
	end)

	arg0_8.idList = var0_8
end

function var0_0.GetPriceArea(arg0_10)
	local var0_10 = 0
	local var1_10 = 0

	for iter0_10, iter1_10 in ipairs(arg0_10.idList) do
		local var2_10 = pg.auction_collection[iter1_10]

		if iter0_10 == 1 then
			var0_10 = var2_10.value
			var1_10 = var2_10.value
		else
			var0_10 = var0_10 > var2_10.value and var2_10.value or var0_10
			var1_10 = var1_10 < var2_10.value and var2_10.value or var1_10
		end
	end

	return var0_10, var1_10
end

function var0_0.GetFilterData(arg0_11)
	local var0_11 = {
		0
	}
	local var1_11 = {}

	for iter0_11, iter1_11 in ipairs(pg.auction_collection.all) do
		local var2_11 = pg.auction_collection[iter1_11]

		if not table.keyof(var0_11, var2_11.rarity) then
			table.insert(var0_11, var2_11.rarity)
		end

		var1_11[var2_11.contour[1]] = var1_11[var2_11.contour[1]] or {}

		if not table.keyof(var1_11[var2_11.contour[1]], var2_11.contour[2]) then
			table.insert(var1_11[var2_11.contour[1]], var2_11.contour[2])
		end
	end

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg0_12 < arg1_12
	end)

	local var3_11 = {}

	for iter2_11, iter3_11 in pairs(var1_11) do
		table.sort(iter3_11, function(arg0_13, arg1_13)
			return arg0_13 < arg1_13
		end)
		table.insert(var3_11, iter2_11)
	end

	table.sort(var3_11, function(arg0_14, arg1_14)
		return arg0_14 < arg1_14
	end)

	arg0_11.rarityList = var0_11
	arg0_11.contourList = {
		{
			0,
			0
		}
	}

	for iter4_11, iter5_11 in ipairs(var3_11) do
		for iter6_11, iter7_11 in ipairs(var1_11[iter5_11]) do
			table.insert(arg0_11.contourList, {
				iter5_11,
				iter7_11
			})
		end
	end
end

function var0_0.OnSwitchRarity(arg0_15, arg1_15, arg2_15)
	arg0_15.rarityIndex = arg2_15

	arg0_15:RefreshCollectionList()
end

function var0_0.OnSwitchContour(arg0_16, arg1_16, arg2_16)
	arg0_16.contourData = arg2_16

	arg0_16:RefreshCollectionList()
end

function var0_0.willExit(arg0_17)
	arg0_17:UnOverlayPanel(arg0_17._tf)

	for iter0_17, iter1_17 in ipairs(arg0_17.eventIDList) do
		arg0_17:disconnect(iter1_17)
	end

	arg0_17.eventIDList = nil

	for iter2_17, iter3_17 in ipairs(arg0_17.rarityItemList) do
		iter3_17:willExit()
	end

	arg0_17.rarityItemList = nil

	for iter4_17, iter5_17 in ipairs(arg0_17.contourItemList) do
		iter5_17:willExit()
	end

	arg0_17.contourItemList = nil

	arg0_17.uiScrollView:Dispose()

	arg0_17.uiScrollView = nil
end

return var0_0
