local var0 = class("ShoppingStreet", import(".BaseShop"))

function var0.getRiseShopId(arg0, arg1)
	for iter0, iter1 in ipairs(pg.shop_template.all) do
		local var0 = pg.shop_template[iter1]

		if var0.genre == arg0 and arg1 >= var0.limit_args[2] and arg1 <= var0.limit_args[3] then
			return iter1
		end
	end
end

function var0.Ctor(arg0, arg1)
	arg0.level = arg1.lv
	arg0.configId = arg0.level
	arg0.nextFlashTime = arg1.next_flash_time
	arg0.levelUpTime = arg1.lv_up_time
	arg0.flashCount = arg1.flash_count
	arg0.goods = {}

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHOP_DISCOUNT)
	local var1 = var0 and not var0:isEnd()

	for iter0, iter1 in ipairs(arg1.goods_list) do
		local var2 = Goods.Create(iter1, Goods.TYPE_SHOPSTREET)

		var2.activityDiscount = var1

		table.insert(arg0.goods, var2)
	end

	arg0.type = ShopArgs.ShopStreet
end

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, ShoppingStreet)
end

function var0.GetCommodityById(arg0, arg1)
	return arg0:getGoodsById(arg1)
end

function var0.GetCommodities(arg0)
	return arg0.goods
end

function var0.bindConfigTable(arg0)
	return pg.navalacademy_shoppingstreet_template
end

function var0.resetflashCount(arg0)
	arg0.flashCount = 0
end

function var0.increaseFlashCount(arg0)
	arg0.flashCount = arg0.flashCount + 1
end

function var0.isUpdateGoods(arg0)
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0.nextFlashTime then
		return true
	end

	return false
end

function var0.getMaxLevel(arg0)
	local var0 = arg0:bindConfigTable()

	return var0.all[#var0.all]
end

function var0.isMaxLevel(arg0)
	return arg0:getMaxLevel() <= arg0.level
end

function var0.isUpgradeProcess(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0.levelUpTime
end

function var0.isFinishUpgrade(arg0)
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0.levelUpTime then
		return true
	end

	return false
end

function var0.getLevelUpTime(arg0)
	return arg0.levelUpTime
end

function var0.updateLeftTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.levelUpTime - var0
end

function var0.levelUp(arg0)
	arg0.levelUpTime = 0

	local var0 = arg0:bindConfigTable()
	local var1 = arg0.level

	arg0.level = math.min(arg0.level + 1, #var0.all)

	if var1 == arg0.level then
		warning("商品街配置最大等级")
	end

	arg0.configId = arg0.level
end

function var0.setLevelUpTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0.levelUpTime = getConfigFromLevel1(pg.navalacademy_shoppingstreet_template, arg0.level).levelUpTime + var0
end

function var0.getGoodsById(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.goods) do
		if arg1 == iter1.id then
			return iter1
		end
	end
end

return var0
