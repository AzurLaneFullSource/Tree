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

	table.sort(var0_5, CompareFuncs({
		function(arg0_6)
			local var0_6 = arg0_6:CheckArgLimit()

			return (arg0_6:canPurchase() or var0_6) and 0 or 1
		end,
		function(arg0_7)
			local var0_7, var1_7, var2_7 = arg0_7:CheckTimeLimit()

			return var0_7 and var1_7 and 0 or 1
		end,
		function(arg0_8)
			return arg0_8:getConfig("order")
		end,
		function(arg0_9)
			return arg0_9.id
		end
	}))

	return var0_5
end

function var0_0.bindConfigTable(arg0_10)
	return pg.activity_shop_template
end

function var0_0.getGoodsById(arg0_11, arg1_11)
	return arg0_11.goods[arg1_11]
end

function var0_0.isEnd(arg0_12)
	local var0_12 = getProxy(ActivityProxy):getActivityById(arg0_12.activityId)

	return not var0_12 or var0_12:isEnd()
end

function var0_0.getOpenTime(arg0_13)
	local var0_13 = pg.activity_template[arg0_13.activityId].time
	local var1_13 = var0_13[2][1]
	local var2_13 = var0_13[3][1]
	local var3_13 = var0_13[3][2]

	return string.format("%d.%d.%d~%d.%d.%d %d:%d:%d", var1_13[1], var1_13[2], var1_13[3], var2_13[1], var2_13[2], var2_13[3], var3_13[1], var3_13[2], var3_13[3])
end

function var0_0.getStartTime(arg0_14)
	if arg0_14:isEnd() then
		return 0
	end

	return getProxy(ActivityProxy):getActivityById(arg0_14.activityId):getStartTime()
end

function var0_0.getBgPath(arg0_15)
	local var0_15 = pg.activity_template[arg0_15.activityId]
	local var1_15 = var0_15.config_client[2] or {
		255,
		255,
		255,
		255
	}
	local var2_15 = var0_15.config_client.outline or {
		0,
		0,
		0,
		1
	}

	return var0_15.config_client[1], Color.New(var1_15[1], var1_15[2], var1_15[3], var1_15[4]), Color.New(var2_15[1], var2_15[2], var2_15[3], var2_15[4])
end

function var0_0.getToggleImage(arg0_16)
	return pg.activity_template[arg0_16.activityId].config_client.toggle or "huodongdduihuan_butten"
end

function var0_0.getResId(arg0_17)
	local var0_17

	for iter0_17, iter1_17 in pairs(arg0_17.goods) do
		var0_17 = iter1_17

		break
	end

	return (var0_17:getConfig("resource_type"))
end

function var0_0.GetResList(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.goods) do
		var0_18[iter1_18:getConfig("resource_type")] = true
	end

	local var1_18 = {}

	for iter2_18, iter3_18 in pairs(var0_18) do
		table.insert(var1_18, iter2_18)
	end

	return var1_18
end

function var0_0.GetEnterVoice(arg0_19)
	local var0_19 = arg0_19.config.config_client.enter

	if var0_19 then
		return var0_19[1], var0_19[2], var0_19[3]
	end
end

function var0_0.GetPurchaseVoice(arg0_20)
	local var0_20 = arg0_20.config.config_client.purchase

	if var0_20 then
		return var0_20[1], var0_20[2], var0_20[3]
	end
end

function var0_0.GetPurchaseAllVoice(arg0_21)
	local var0_21 = arg0_21.config.config_client.purchase_all

	if var0_21 then
		return var0_21[1], var0_21[2], var0_21[3]
	end
end

function var0_0.GetTouchVoice(arg0_22)
	local var0_22 = arg0_22.config.config_client.touch

	if var0_22 then
		return var0_22[1], var0_22[2], var0_22[3]
	end
end

function var0_0.IsEventShop(arg0_23)
	return pg.activity_template[arg0_23.activityId].config_client.event_shop
end

function var0_0.GetBGM(arg0_24)
	return pg.activity_template[arg0_24.activityId].config_client.bgm or ""
end

return var0_0
