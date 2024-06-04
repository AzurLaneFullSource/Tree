local var0 = class("EscortShop", import(".BaseVO"))

function var0.Ctor(arg0)
	arg0.goods = {}
	arg0.type = ShopArgs.ShopEscort
end

function var0.update(arg0, arg1, arg2)
	arg0.id = arg1
	arg0.configId = arg0.id

	local var0 = {}

	for iter0, iter1 in ipairs(arg2) do
		var0[iter1.shop_id] = iter1.count
	end

	arg0.goods = {}

	if arg0.id and arg0.id > 0 then
		for iter2, iter3 in ipairs(arg0:getConfig("goods")) do
			local var1 = var0[iter3] or 0

			arg0.goods[iter3] = Goods.Create({
				shop_id = iter3,
				buy_count = var1
			}, Goods.TYPE_SHAM_BATTLE)
		end
	end
end

function var0.isOpen(arg0)
	local var0 = false
	local var1 = arg0:bindConfigTable()[arg0.id]

	if var1 then
		local var2 = pg.TimeMgr.GetInstance()
		local var3 = var2:STimeDescS(var2:GetServerTime(), "*t")

		if var3.month == arg0.id then
			var0 = var3.day >= var1.time[1] and var3.day <= var1.time[2]
		end
	end

	return var0
end

function var0.getRestDays(arg0)
	local var0 = 0
	local var1 = arg0:bindConfigTable()[arg0.id]

	if var1 then
		local var2 = pg.TimeMgr.GetInstance()
		local var3 = pg.TimeMgr.GetInstance():STimeDescS(var2:GetServerTime(), "*t")

		var0 = var1.time[2] - var3.day + 1
	end

	return (math.max(var0, 1))
end

function var0.getSortGoods(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		table.insert(var0, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0:canPurchase() and 1 or 0
		local var1 = arg1:canPurchase() and 1 or 0

		if var0 == var1 then
			local var2 = arg0:getConfig("order")
			local var3 = arg1:getConfig("order")

			if var2 == var3 then
				return arg0.id < arg1.id
			else
				return var2 < var3
			end
		else
			return var1 < var0
		end
	end)

	return var0
end

function var0.bindConfigTable(arg0)
	return pg.escort_shop_template
end

function var0.getGoodsCfg(arg0, arg1)
	return pg.activity_shop_template[arg1]
end

function var0.getGoodsById(arg0, arg1)
	return arg0.goods[arg1]
end

return var0
