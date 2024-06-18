local var0_0 = class("EducateShop", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.goods = {}

	for iter0_1, iter1_1 in ipairs(arg2_1) do
		arg0_1.goods[iter1_1.id] = EducateGood.New(iter1_1)
	end

	arg0_1:initRefreshTime()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_shop
end

function var0_0.initRefreshTime(arg0_3)
	arg0_3.refreshWeeks = {}

	local var0_3 = arg0_3:getConfig("goods_refresh_time")

	if var0_3 ~= -1 then
		local var1_3 = 9
		local var2_3 = 60

		table.insert(arg0_3.refreshWeeks, var1_3)

		while var1_3 < var2_3 do
			var1_3 = var1_3 + var0_3

			table.insert(arg0_3.refreshWeeks, var1_3)
		end
	end
end

function var0_0.GetShopTip(arg0_4)
	if #arg0_4.refreshWeeks == 0 then
		return i18n("child_shop_tip2")
	else
		return i18n("child_shop_tip1", arg0_4:getConfig("goods_refresh_time"))
	end
end

function var0_0.GetCommodities(arg0_5)
	return arg0_5:getSortGoods()
end

function var0_0.GetGoods(arg0_6, arg1_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.goods) do
		if iter1_6:InTime(arg1_6) then
			table.insert(var0_6, iter1_6)
		end
	end

	table.sort(var0_6, CompareFuncs({
		function(arg0_7)
			return arg0_7:CanBuy() and 0 or 1
		end,
		function(arg0_8)
			return arg0_8.id
		end
	}))

	return var0_6
end

function var0_0.GetGoodById(arg0_9, arg1_9)
	return arg0_9.goods[arg1_9]
end

function var0_0.UpdateGood(arg0_10, arg1_10)
	arg0_10.goods[arg1_10.id] = arg1_10
end

function var0_0.IsRefreshWeek(arg0_11, arg1_11)
	return table.contains(arg0_11.refreshWeeks, arg1_11)
end

function var0_0.IsRefreshShop(arg0_12, arg1_12)
	local var0_12 = EducateHelper.GetWeekIdxWithTime(arg1_12)

	return arg0_12:IsRefreshWeek(var0_12)
end

return var0_0
