local var0_0 = class("MiniGameShop", import(".BaseShop"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.goodsData = arg1_1.goods
	arg0_1.nextFlashTime = arg1_1.next_flash_time
	arg0_1.goods = {}

	for iter0_1, iter1_1 in ipairs(pg.gameroom_shop_template) do
		local var0_1 = Goods.Create(iter1_1, Goods.TYPE_MINI_GAME)
		local var1_1 = arg0_1:getGoodData(iter1_1.id) or 0

		var0_1:UpdateCnt(var1_1)

		arg0_1.goods[var0_1:getId()] = var0_1
	end

	arg0_1.type = ShopArgs.ShopMiniGame
end

function var0_0.setNextTime(arg0_2, arg1_2)
	arg0_2.nextFlashTime = arg1_2

	for iter0_2, iter1_2 in ipairs(arg0_2.goodsData) do
		local var0_2 = iter1_2.id
		local var1_2 = false

		if pg.gameroom_shop_template[var0_2] then
			var1_2 = pg.gameroom_shop_template[var0_2].month_re ~= 0
		else
			warning("gameroom_shop_template 不存在 id = " .. tostring(var0_2) .. "的物品")
		end

		if var1_2 then
			arg0_2.goodsData[iter0_2].count = 0
		end
	end
end

function var0_0.checkShopFlash(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_3.nextFlashTime and arg0_3.nextFlashTime > 0 then
		return var0_3 > arg0_3.nextFlashTime
	end

	return false
end

function var0_0.getGoodData(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.goodsData) do
		if iter1_4 and iter1_4.id == arg1_4 then
			return iter1_4.count
		end
	end
end

function var0_0.consume(arg0_5, arg1_5, arg2_5)
	arg0_5.goods[arg1_5]:UpdateCnt(arg2_5)
end

function var0_0.IsSameKind(arg0_6, arg1_6)
	return isa(arg1_6, MiniGameShop)
end

function var0_0.GetCommodityById(arg0_7, arg1_7)
	return arg0_7:getGoodsById(arg1_7)
end

function var0_0.GetCommodities(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.goods) do
		table.insert(var0_8, iter1_8)
	end

	table.sort(var0_8, function(arg0_9, arg1_9)
		local var0_9 = arg0_9:CanPurchase() and 1 or 0
		local var1_9 = arg1_9:CanPurchase() and 1 or 0

		if var0_9 == var1_9 then
			return arg0_9:getConfig("order") < arg1_9:getConfig("order")
		else
			return var1_9 < var0_9
		end
	end)

	return var0_8
end

function var0_0.bindConfigTable(arg0_10)
	return nil
end

function var0_0.getRefreshCount(arg0_11)
	return arg0_11.refreshCount
end

function var0_0.resetRefreshCount(arg0_12)
	arg0_12.refreshCount = 1
end

function var0_0.increaseRefreshCount(arg0_13)
	arg0_13.refreshCount = arg0_13.refreshCount + 1
end

function var0_0.updateAllGoods(arg0_14, arg1_14)
	arg0_14.goods = arg1_14
end

function var0_0.getGoodsById(arg0_15, arg1_15)
	assert(arg0_15.goods[arg1_15], "should exist good" .. arg1_15)

	return Clone(arg0_15.goods[arg1_15])
end

function var0_0.updateGoods(arg0_16, arg1_16)
	assert(arg0_16.goods[arg1_16.id], "should exist good" .. arg1_16.id)

	arg0_16.goods[arg1_16.id] = arg1_16
end

return var0_0
