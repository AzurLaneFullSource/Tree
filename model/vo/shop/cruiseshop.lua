local var0_0 = class("CruiseShop", import(".BaseShop"))

var0_0.TYPE_SKIN = "skin"
var0_0.TYPE_EQUIP_SKIN = "equip_skin"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.type = var0_0.ShopCruise
	arg0_1.genres = {
		[var0_0.TYPE_SKIN] = ShopArgs.CruiseSkin,
		[var0_0.TYPE_EQUIP_SKIN] = ShopArgs.CruiseGearSkin
	}

	local var0_1 = {}

	for iter0_1, iter1_1 in pairs(arg0_1.genres) do
		local var1_1 = pg.shop_template.get_id_list_by_genre[iter1_1]

		if var1_1 then
			local var2_1 = pg.TimeMgr.GetInstance()

			for iter2_1, iter3_1 in ipairs(var1_1) do
				if var2_1:inTime(pg.shop_template[iter3_1].time) then
					table.insert(var0_1, iter3_1)
				end
			end
		end
	end

	local var3_1 = {}

	for iter4_1, iter5_1 in ipairs(arg1_1) do
		var3_1[iter5_1.shop_id] = iter5_1.pay_count
	end

	local var4_1 = {}

	for iter6_1, iter7_1 in ipairs(arg2_1) do
		var4_1[iter7_1.shop_id] = iter7_1.pay_count
	end

	arg0_1.goods = {}

	for iter8_1, iter9_1 in ipairs(var0_1) do
		local var5_1 = var3_1[iter9_1] or 0
		local var6_1 = var4_1[pg.shop_template[iter9_1].group] or 0

		arg0_1.goods[iter9_1] = Goods.Create({
			shop_id = iter9_1,
			buy_count = var5_1,
			groupCount = var6_1
		}, Goods.TYPE_CRUISE)
	end
end

function var0_0.GetRemainEquipSkinCnt(arg0_2)
	for iter0_2, iter1_2 in pairs(arg0_2.goods) do
		if iter1_2:getConfig("genre") == ShopArgs.CruiseGearSkin then
			return iter1_2:getConfig("group_limit") - iter1_2.groupCount
		end
	end

	return 0
end

function var0_0.IsSameKind(arg0_3, arg1_3)
	return isa(arg1_3, CruiseShop)
end

function var0_0.GetCommodityById(arg0_4, arg1_4)
	return arg0_4:getGoodsById(arg1_4)
end

function var0_0.GetCommodities(arg0_5)
	return arg0_5:getSortGoods()
end

function var0_0.GetCommoditiesByType(arg0_6, arg1_6)
	return arg0_6:getSortGoodsByType(arg1_6)
end

function var0_0.getGoodsById(arg0_7, arg1_7)
	return arg0_7.goods[arg1_7]
end

function var0_0.getSortGoods(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.goods) do
		table.insert(var0_8, iter1_8)
	end

	return arg0_8:sort(var0_8)
end

function var0_0.getSortGoodsByType(arg0_9, arg1_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.goods) do
		if iter1_9:getConfig("genre") == arg0_9.genres[arg1_9] then
			table.insert(var0_9, iter1_9)
		end
	end

	return arg0_9:sort(var0_9)
end

function var0_0.sort(arg0_10, arg1_10)
	table.sort(arg1_10, CompareFuncs({
		function(arg0_11)
			return arg0_11:canPurchase() and 0 or 1
		end,
		function(arg0_12)
			return arg0_12:getConfig("order")
		end,
		function(arg0_13)
			return arg0_13.id
		end
	}))

	return arg1_10
end

return var0_0
