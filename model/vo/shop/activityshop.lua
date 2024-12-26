local var0_0 = class("ActivityShop", import(".BaseShop"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.activityId = arg1_1.id

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.data1_list) do
		var0_1[iter1_1] = arg1_1.data2_list[iter0_1]
	end

	arg0_1.goods = {}

	local var1_1 = arg0_1:bindConfigTable()

	for iter2_1, iter3_1 in ipairs(var1_1.all) do
		if arg1_1.id == var1_1[iter3_1].activity then
			local var2_1 = var0_1[iter3_1] or 0

			arg0_1.goods[iter3_1] = Goods.Create({
				shop_id = iter3_1,
				buy_count = var2_1
			}, Goods.TYPE_ACTIVITY)
		end
	end

	arg0_1.type = ShopArgs.ShopActivity
	arg0_1.config = pg.activity_template[arg0_1.activityId]
end

function var0_0.IsSameKind(arg0_2, arg1_2)
	return isa(arg1_2, ActivityShop) and arg1_2.activityId and arg1_2.activityId == arg0_2.activityId
end

function var0_0.GetCommodityById(arg0_3, arg1_3)
	return arg0_3:getGoodsById(arg1_3)
end

function var0_0.GetCommodities(arg0_4)
	return arg0_4:getSortGoods()
end

function var0_0.getSortGoods(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.goods) do
		table.insert(var0_5, iter1_5)
	end

	arg0_5:SortGoods(var0_5)

	return var0_5
end

function var0_0.SortGoods(arg0_6, arg1_6)
	table.sort(arg1_6, CompareFuncs({
		function(arg0_7)
			local var0_7 = arg0_7:CheckArgLimit()

			return (arg0_7:canPurchase() or var0_7) and arg0_7:CheckCntLimit() and 0 or 1
		end,
		function(arg0_8)
			local var0_8, var1_8, var2_8 = arg0_8:CheckTimeLimit()

			return var0_8 and var1_8 and 0 or 1
		end,
		function(arg0_9)
			return arg0_9:getConfig("order")
		end,
		function(arg0_10)
			return arg0_10.id
		end
	}))
end

function var0_0.GetSplitNameCodes(arg0_11)
	local var0_11 = {}

	if arg0_11.config and arg0_11.config.config_client and arg0_11.config.config_client.category then
		for iter0_11, iter1_11 in ipairs(arg0_11.config.config_client.category) do
			table.insert(var0_11, iter1_11[1])
		end
	end

	return var0_11
end

function var0_0.GetSplitCommodities(arg0_12)
	local var0_12 = {}

	if arg0_12.config and arg0_12.config.config_client and arg0_12.config.config_client.category then
		for iter0_12, iter1_12 in ipairs(arg0_12.config.config_client.category) do
			local var1_12 = {}

			for iter2_12, iter3_12 in ipairs(iter1_12[2]) do
				table.insert(var1_12, arg0_12.goods[iter3_12])
			end

			arg0_12:SortGoods(var1_12)
			table.insert(var0_12, var1_12)
		end
	end

	return var0_12
end

function var0_0.bindConfigTable(arg0_13)
	return pg.activity_shop_template
end

function var0_0.getGoodsById(arg0_14, arg1_14)
	return arg0_14.goods[arg1_14]
end

function var0_0.isEnd(arg0_15)
	local var0_15 = getProxy(ActivityProxy):getActivityById(arg0_15.activityId)

	return not var0_15 or var0_15:isEnd()
end

function var0_0.getOpenTime(arg0_16)
	local var0_16 = pg.activity_template[arg0_16.activityId].time
	local var1_16 = var0_16[2][1]
	local var2_16 = var0_16[3][1]
	local var3_16 = var0_16[3][2]

	return string.format("%d.%d.%d~%d.%d.%d %d:%d:%d", var1_16[1], var1_16[2], var1_16[3], var2_16[1], var2_16[2], var2_16[3], var3_16[1], var3_16[2], var3_16[3])
end

function var0_0.getStartTime(arg0_17)
	if arg0_17:isEnd() then
		return 0
	end

	return getProxy(ActivityProxy):getActivityById(arg0_17.activityId):getStartTime()
end

function var0_0.getBgPath(arg0_18)
	local var0_18 = pg.activity_template[arg0_18.activityId]
	local var1_18 = var0_18.config_client[2] or {
		255,
		255,
		255,
		255
	}
	local var2_18 = var0_18.config_client.outline or {
		0,
		0,
		0,
		1
	}

	return var0_18.config_client[1], Color.New(var1_18[1], var1_18[2], var1_18[3], var1_18[4]), Color.New(var2_18[1], var2_18[2], var2_18[3], var2_18[4])
end

function var0_0.getToggleImage(arg0_19)
	return pg.activity_template[arg0_19.activityId].config_client.toggle or "huodongdduihuan_butten"
end

function var0_0.getResId(arg0_20)
	local var0_20

	for iter0_20, iter1_20 in pairs(arg0_20.goods) do
		var0_20 = iter1_20

		break
	end

	return (var0_20:getConfig("resource_type"))
end

function var0_0.GetResList(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in pairs(arg0_21.goods) do
		var0_21[iter1_21:getConfig("resource_type")] = true
	end

	local var1_21 = {}

	for iter2_21, iter3_21 in pairs(var0_21) do
		table.insert(var1_21, iter2_21)
	end

	return var1_21
end

function var0_0.GetEnterVoice(arg0_22)
	local var0_22 = arg0_22.config.config_client.enter

	if var0_22 then
		return var0_22[1], var0_22[2], var0_22[3]
	end
end

function var0_0.GetPurchaseVoice(arg0_23)
	local var0_23 = arg0_23.config.config_client.purchase

	if var0_23 then
		return var0_23[1], var0_23[2], var0_23[3]
	end
end

function var0_0.GetPurchaseAllVoice(arg0_24)
	local var0_24 = arg0_24.config.config_client.purchase_all

	if var0_24 then
		return var0_24[1], var0_24[2], var0_24[3]
	end
end

function var0_0.GetTouchVoice(arg0_25)
	local var0_25 = arg0_25.config.config_client.touch

	if var0_25 then
		return var0_25[1], var0_25[2], var0_25[3]
	end
end

function var0_0.IsEventShop(arg0_26)
	return pg.activity_template[arg0_26.activityId].config_client.event_shop
end

function var0_0.GetBGM(arg0_27)
	return pg.activity_template[arg0_27.activityId].config_client.bgm or ""
end

return var0_0
