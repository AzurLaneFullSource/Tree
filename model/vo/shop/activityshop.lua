local var0 = class("ActivityShop", import(".BaseShop"))

function var0.Ctor(arg0, arg1)
	arg0.activityId = arg1.id

	local var0 = {}

	for iter0, iter1 in ipairs(arg1.data1_list) do
		var0[iter1] = arg1.data2_list[iter0]
	end

	arg0.goods = {}

	local var1 = arg0:bindConfigTable()

	for iter2, iter3 in ipairs(var1.all) do
		if arg1.id == var1[iter3].activity then
			local var2 = var0[iter3] or 0

			arg0.goods[iter3] = Goods.Create({
				shop_id = iter3,
				buy_count = var2
			}, Goods.TYPE_ACTIVITY)
		end
	end

	arg0.type = ShopArgs.ShopActivity
	arg0.config = pg.activity_template[arg0.activityId]
end

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, ActivityShop) and arg1.activityId and arg1.activityId == arg0.activityId
end

function var0.GetCommodityById(arg0, arg1)
	return arg0:getGoodsById(arg1)
end

function var0.GetCommodities(arg0)
	return arg0:getSortGoods()
end

function var0.getSortGoods(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		table.insert(var0, iter1)
	end

	table.sort(var0, CompareFuncs({
		function(arg0)
			local var0, var1 = arg0:CheckArgLimit()

			return (arg0:canPurchase() or var1) and 0 or 1
		end,
		function(arg0)
			local var0, var1, var2 = arg0:CheckTimeLimit()

			return var0 and var1 and 0 or 1
		end,
		function(arg0)
			return arg0:getConfig("order")
		end,
		function(arg0)
			return arg0.id
		end
	}))

	return var0
end

function var0.bindConfigTable(arg0)
	return pg.activity_shop_template
end

function var0.getGoodsById(arg0, arg1)
	return arg0.goods[arg1]
end

function var0.isEnd(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.activityId)

	return not var0 or var0:isEnd()
end

function var0.getOpenTime(arg0)
	local var0 = pg.activity_template[arg0.activityId].time
	local var1 = var0[2][1]
	local var2 = var0[3][1]
	local var3 = var0[3][2]

	return string.format("%d.%d.%d~%d.%d.%d %d:%d:%d", var1[1], var1[2], var1[3], var2[1], var2[2], var2[3], var3[1], var3[2], var3[3])
end

function var0.getStartTime(arg0)
	if arg0:isEnd() then
		return 0
	end

	return getProxy(ActivityProxy):getActivityById(arg0.activityId):getStartTime()
end

function var0.getBgPath(arg0)
	local var0 = pg.activity_template[arg0.activityId]
	local var1 = var0.config_client[2] or {
		255,
		255,
		255,
		255
	}
	local var2 = var0.config_client.outline or {
		0,
		0,
		0,
		1
	}

	return var0.config_client[1], Color.New(var1[1], var1[2], var1[3], var1[4]), Color.New(var2[1], var2[2], var2[3], var2[4])
end

function var0.getToggleImage(arg0)
	return pg.activity_template[arg0.activityId].config_client.toggle or "huodongdduihuan_butten"
end

function var0.getResId(arg0)
	local var0

	for iter0, iter1 in pairs(arg0.goods) do
		var0 = iter1

		break
	end

	return (var0:getConfig("resource_type"))
end

function var0.GetResList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		var0[iter1:getConfig("resource_type")] = true
	end

	local var1 = {}

	for iter2, iter3 in pairs(var0) do
		table.insert(var1, iter2)
	end

	return var1
end

function var0.GetEnterVoice(arg0)
	local var0 = arg0.config.config_client.enter

	if var0 then
		return var0[1], var0[2], var0[3]
	end
end

function var0.GetPurchaseVoice(arg0)
	local var0 = arg0.config.config_client.purchase

	if var0 then
		return var0[1], var0[2], var0[3]
	end
end

function var0.GetPurchaseAllVoice(arg0)
	local var0 = arg0.config.config_client.purchase_all

	if var0 then
		return var0[1], var0[2], var0[3]
	end
end

function var0.GetTouchVoice(arg0)
	local var0 = arg0.config.config_client.touch

	if var0 then
		return var0[1], var0[2], var0[3]
	end
end

function var0.IsEventShop(arg0)
	return pg.activity_template[arg0.activityId].config_client.event_shop
end

function var0.GetBGM(arg0)
	return pg.activity_template[arg0.activityId].config_client.bgm or ""
end

return var0
