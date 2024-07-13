local var0_0 = class("ShoppingStreet", import(".BaseShop"))

function var0_0.getRiseShopId(arg0_1, arg1_1)
	for iter0_1, iter1_1 in ipairs(pg.shop_template.all) do
		local var0_1 = pg.shop_template[iter1_1]

		if var0_1.genre == arg0_1 and arg1_1 >= var0_1.limit_args[2] and arg1_1 <= var0_1.limit_args[3] then
			return iter1_1
		end
	end
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.level = arg1_2.lv
	arg0_2.configId = arg0_2.level
	arg0_2.nextFlashTime = arg1_2.next_flash_time
	arg0_2.levelUpTime = arg1_2.lv_up_time
	arg0_2.flashCount = arg1_2.flash_count
	arg0_2.goods = {}

	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHOP_DISCOUNT)
	local var1_2 = var0_2 and not var0_2:isEnd()

	for iter0_2, iter1_2 in ipairs(arg1_2.goods_list) do
		local var2_2 = Goods.Create(iter1_2, Goods.TYPE_SHOPSTREET)

		var2_2.activityDiscount = var1_2

		table.insert(arg0_2.goods, var2_2)
	end

	arg0_2.type = ShopArgs.ShopStreet
end

function var0_0.IsSameKind(arg0_3, arg1_3)
	return isa(arg1_3, ShoppingStreet)
end

function var0_0.GetCommodityById(arg0_4, arg1_4)
	return arg0_4:getGoodsById(arg1_4)
end

function var0_0.GetCommodities(arg0_5)
	return arg0_5.goods
end

function var0_0.bindConfigTable(arg0_6)
	return pg.navalacademy_shoppingstreet_template
end

function var0_0.resetflashCount(arg0_7)
	arg0_7.flashCount = 0
end

function var0_0.increaseFlashCount(arg0_8)
	arg0_8.flashCount = arg0_8.flashCount + 1
end

function var0_0.isUpdateGoods(arg0_9)
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0_9.nextFlashTime then
		return true
	end

	return false
end

function var0_0.getMaxLevel(arg0_10)
	local var0_10 = arg0_10:bindConfigTable()

	return var0_10.all[#var0_10.all]
end

function var0_0.isMaxLevel(arg0_11)
	return arg0_11:getMaxLevel() <= arg0_11.level
end

function var0_0.isUpgradeProcess(arg0_12)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_12.levelUpTime
end

function var0_0.isFinishUpgrade(arg0_13)
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0_13.levelUpTime then
		return true
	end

	return false
end

function var0_0.getLevelUpTime(arg0_14)
	return arg0_14.levelUpTime
end

function var0_0.updateLeftTime(arg0_15)
	local var0_15 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_15.levelUpTime - var0_15
end

function var0_0.levelUp(arg0_16)
	arg0_16.levelUpTime = 0

	local var0_16 = arg0_16:bindConfigTable()
	local var1_16 = arg0_16.level

	arg0_16.level = math.min(arg0_16.level + 1, #var0_16.all)

	if var1_16 == arg0_16.level then
		warning("商品街配置最大等级")
	end

	arg0_16.configId = arg0_16.level
end

function var0_0.setLevelUpTime(arg0_17)
	local var0_17 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0_17.levelUpTime = getConfigFromLevel1(pg.navalacademy_shoppingstreet_template, arg0_17.level).levelUpTime + var0_17
end

function var0_0.getGoodsById(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.goods) do
		if arg1_18 == iter1_18.id then
			return iter1_18
		end
	end
end

return var0_0
