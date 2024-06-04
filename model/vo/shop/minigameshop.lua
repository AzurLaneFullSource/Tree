local var0 = class("MiniGameShop", import(".BaseShop"))

function var0.Ctor(arg0, arg1)
	arg0.goodsData = arg1.goods
	arg0.nextFlashTime = arg1.next_flash_time
	arg0.goods = {}

	for iter0, iter1 in ipairs(pg.gameroom_shop_template) do
		local var0 = Goods.Create(iter1, Goods.TYPE_MINI_GAME)
		local var1 = arg0:getGoodData(iter1.id) or 0

		var0:UpdateCnt(var1)

		arg0.goods[var0:getId()] = var0
	end

	arg0.type = ShopArgs.ShopMiniGame
end

function var0.setNextTime(arg0, arg1)
	arg0.nextFlashTime = arg1

	for iter0, iter1 in ipairs(arg0.goodsData) do
		local var0 = iter1.id
		local var1 = false

		if pg.gameroom_shop_template[var0] then
			var1 = pg.gameroom_shop_template[var0].month_re ~= 0
		else
			warning("gameroom_shop_template 不存在 id = " .. tostring(var0) .. "的物品")
		end

		if var1 then
			arg0.goodsData[iter0].count = 0
		end
	end
end

function var0.checkShopFlash(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0.nextFlashTime and arg0.nextFlashTime > 0 then
		return var0 > arg0.nextFlashTime
	end

	return false
end

function var0.getGoodData(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.goodsData) do
		if iter1 and iter1.id == arg1 then
			return iter1.count
		end
	end
end

function var0.consume(arg0, arg1, arg2)
	arg0.goods[arg1]:UpdateCnt(arg2)
end

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, MiniGameShop)
end

function var0.GetCommodityById(arg0, arg1)
	return arg0:getGoodsById(arg1)
end

function var0.GetCommodities(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		table.insert(var0, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0:CanPurchase() and 1 or 0
		local var1 = arg1:CanPurchase() and 1 or 0

		if var0 == var1 then
			return arg0:getConfig("order") < arg1:getConfig("order")
		else
			return var1 < var0
		end
	end)

	return var0
end

function var0.bindConfigTable(arg0)
	return nil
end

function var0.getRefreshCount(arg0)
	return arg0.refreshCount
end

function var0.resetRefreshCount(arg0)
	arg0.refreshCount = 1
end

function var0.increaseRefreshCount(arg0)
	arg0.refreshCount = arg0.refreshCount + 1
end

function var0.updateAllGoods(arg0, arg1)
	arg0.goods = arg1
end

function var0.getGoodsById(arg0, arg1)
	assert(arg0.goods[arg1], "should exist good" .. arg1)

	return Clone(arg0.goods[arg1])
end

function var0.updateGoods(arg0, arg1)
	assert(arg0.goods[arg1.id], "should exist good" .. arg1.id)

	arg0.goods[arg1.id] = arg1
end

return var0
