local var0_0 = class("BlackFridayShop", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.startTime = arg1_1.start_time
	arg0_1.stopTime = arg1_1.stop_time
	arg0_1.goods = {}
	arg0_1.activityId = arg1_1.id

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.goods) do
		arg0_1.goods[iter1_1.id] = BlackFridayCommodity.New(iter1_1, Goods.TYPE_SHOPSTREET)
	end

	arg0_1.tabList = {}
	arg0_1.tabCount = 0

	local var1_1 = getProxy(ActivityProxy):getActivityById(arg0_1.activityId):getConfig("config_client").tabLabel

	for iter2_1, iter3_1 in pairs(var1_1) do
		arg0_1.tabCount = arg0_1.tabCount + 1

		local var2_1 = arg0_1.tabList[iter2_1] or {}

		for iter4_1, iter5_1 in ipairs(iter3_1) do
			table.insert(var2_1, arg0_1.goods[iter5_1])
		end

		arg0_1.tabList[iter2_1] = var2_1
	end
end

function var0_0.GetResID(arg0_2, arg1_2)
	return arg0_2.tabList[arg1_2][1]:GetResType()
end

function var0_0.GetStartTime(arg0_3)
	return arg0_3.startTime
end

function var0_0.GetEndTime(arg0_4)
	return arg0_4.stopTime
end

function var0_0.GetTabCount(arg0_5)
	return arg0_5.tabCount
end

function var0_0.GetCommodityById(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.goods) do
		if arg1_6 == iter1_6.id then
			return iter1_6
		end
	end
end

function var0_0.GetGoodsByTabs(arg0_7, arg1_7)
	local var0_7 = arg1_7 + arg1_7

	return arg0_7.tabList[arg1_7]
end

return var0_0
