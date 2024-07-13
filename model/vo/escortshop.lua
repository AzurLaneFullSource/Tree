local var0_0 = class("EscortShop", import(".BaseVO"))

function var0_0.Ctor(arg0_1)
	arg0_1.goods = {}
	arg0_1.type = ShopArgs.ShopEscort
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	arg0_2.id = arg1_2
	arg0_2.configId = arg0_2.id

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg2_2) do
		var0_2[iter1_2.shop_id] = iter1_2.count
	end

	arg0_2.goods = {}

	if arg0_2.id and arg0_2.id > 0 then
		for iter2_2, iter3_2 in ipairs(arg0_2:getConfig("goods")) do
			local var1_2 = var0_2[iter3_2] or 0

			arg0_2.goods[iter3_2] = Goods.Create({
				shop_id = iter3_2,
				buy_count = var1_2
			}, Goods.TYPE_SHAM_BATTLE)
		end
	end
end

function var0_0.isOpen(arg0_3)
	local var0_3 = false
	local var1_3 = arg0_3:bindConfigTable()[arg0_3.id]

	if var1_3 then
		local var2_3 = pg.TimeMgr.GetInstance()
		local var3_3 = var2_3:STimeDescS(var2_3:GetServerTime(), "*t")

		if var3_3.month == arg0_3.id then
			var0_3 = var3_3.day >= var1_3.time[1] and var3_3.day <= var1_3.time[2]
		end
	end

	return var0_3
end

function var0_0.getRestDays(arg0_4)
	local var0_4 = 0
	local var1_4 = arg0_4:bindConfigTable()[arg0_4.id]

	if var1_4 then
		local var2_4 = pg.TimeMgr.GetInstance()
		local var3_4 = pg.TimeMgr.GetInstance():STimeDescS(var2_4:GetServerTime(), "*t")

		var0_4 = var1_4.time[2] - var3_4.day + 1
	end

	return (math.max(var0_4, 1))
end

function var0_0.getSortGoods(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.goods) do
		table.insert(var0_5, iter1_5)
	end

	table.sort(var0_5, function(arg0_6, arg1_6)
		local var0_6 = arg0_6:canPurchase() and 1 or 0
		local var1_6 = arg1_6:canPurchase() and 1 or 0

		if var0_6 == var1_6 then
			local var2_6 = arg0_6:getConfig("order")
			local var3_6 = arg1_6:getConfig("order")

			if var2_6 == var3_6 then
				return arg0_6.id < arg1_6.id
			else
				return var2_6 < var3_6
			end
		else
			return var1_6 < var0_6
		end
	end)

	return var0_5
end

function var0_0.bindConfigTable(arg0_7)
	return pg.escort_shop_template
end

function var0_0.getGoodsCfg(arg0_8, arg1_8)
	return pg.activity_shop_template[arg1_8]
end

function var0_0.getGoodsById(arg0_9, arg1_9)
	return arg0_9.goods[arg1_9]
end

return var0_0
