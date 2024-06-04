local var0 = class("EducateShop", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg1
	arg0.configId = arg0.id
	arg0.goods = {}

	for iter0, iter1 in ipairs(arg2) do
		arg0.goods[iter1.id] = EducateGood.New(iter1)
	end

	arg0:initRefreshTime()
end

function var0.bindConfigTable(arg0)
	return pg.child_shop
end

function var0.initRefreshTime(arg0)
	arg0.refreshWeeks = {}

	local var0 = arg0:getConfig("goods_refresh_time")

	if var0 ~= -1 then
		local var1 = 9
		local var2 = 60

		table.insert(arg0.refreshWeeks, var1)

		while var1 < var2 do
			var1 = var1 + var0

			table.insert(arg0.refreshWeeks, var1)
		end
	end
end

function var0.GetShopTip(arg0)
	if #arg0.refreshWeeks == 0 then
		return i18n("child_shop_tip2")
	else
		return i18n("child_shop_tip1", arg0:getConfig("goods_refresh_time"))
	end
end

function var0.GetCommodities(arg0)
	return arg0:getSortGoods()
end

function var0.GetGoods(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		if iter1:InTime(arg1) then
			table.insert(var0, iter1)
		end
	end

	table.sort(var0, CompareFuncs({
		function(arg0)
			return arg0:CanBuy() and 0 or 1
		end,
		function(arg0)
			return arg0.id
		end
	}))

	return var0
end

function var0.GetGoodById(arg0, arg1)
	return arg0.goods[arg1]
end

function var0.UpdateGood(arg0, arg1)
	arg0.goods[arg1.id] = arg1
end

function var0.IsRefreshWeek(arg0, arg1)
	return table.contains(arg0.refreshWeeks, arg1)
end

function var0.IsRefreshShop(arg0, arg1)
	local var0 = EducateHelper.GetWeekIdxWithTime(arg1)

	return arg0:IsRefreshWeek(var0)
end

return var0
