local var0_0 = class("NewServerCommodity", import("...BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.count = arg1_1.count or arg0_1:getConfig("goods_purchase_limit")
	arg0_1.boughtRecord = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.bought_record or {}) do
		arg0_1.boughtRecord[iter1_1] = true
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.newserver_shop_template
end

function var0_0.CanPurchase(arg0_3)
	return arg0_3.count > 0
end

function var0_0.ReduceCnt(arg0_4, arg1_4)
	arg0_4.count = arg0_4.count - arg1_4
end

function var0_0.CanPurchaseMulTimes(arg0_5, arg1_5)
	return arg1_5 <= arg0_5.count
end

function var0_0.CanPurchaseSubGoods(arg0_6, arg1_6)
	if arg0_6:LimitPurchaseSubGoods() then
		return not (arg0_6.boughtRecord[arg1_6] == true)
	else
		return true
	end
end

function var0_0.UpdateBoughtRecord(arg0_7, arg1_7)
	arg0_7.boughtRecord[arg1_7] = true
end

function var0_0.LimitPurchaseSubGoods(arg0_8)
	return arg0_8:getConfig("goods_type") == 4
end

function var0_0.Selectable(arg0_9)
	local var0_9 = arg0_9:getConfig("goods_type")

	return var0_9 == 2 or var0_9 == 4
end

function var0_0.GetConsume(arg0_10)
	return Drop.New({
		type = arg0_10:getConfig("resource_category"),
		id = arg0_10:getConfig("resource_type"),
		count = arg0_10:getConfig("resource_num")
	})
end

function var0_0.GetDesc(arg0_11)
	return {
		name = arg0_11:getConfig("goods_name"),
		icon = arg0_11:getConfig("goods_icon"),
		rarity = arg0_11:getConfig("goods_rarity")
	}
end

function var0_0.IsOpening(arg0_12, arg1_12)
	local var0_12 = {}
	local var1_12 = arg1_12 + arg0_12:getConfig("unlock_time")
	local var2_12 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3_12 = var1_12 <= var2_12

	if not var3_12 then
		local var4_12, var5_12, var6_12, var7_12 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_12 - var2_12)

		var0_12.day = var4_12
		var0_12.hour = var5_12
	end

	return var3_12, var0_12
end

function var0_0.GetDropCnt(arg0_13)
	return arg0_13:getConfig("num")
end

function var0_0.GetCanPurchaseCnt(arg0_14)
	return arg0_14.count
end

function var0_0.GetCanPurchaseMaxCnt(arg0_15)
	return arg0_15:getConfig("goods_purchase_limit")
end

function var0_0.GetDropType(arg0_16)
	return arg0_16:getConfig("type")
end

function var0_0.GetSelectableGoods(arg0_17)
	return arg0_17:getConfig("goods")
end

function var0_0.CheckTimeLimit(arg0_18)
	local var0_18 = false
	local var1_18 = false
	local var2_18
	local var3_18 = arg0_18:getConfig("type")
	local var4_18 = arg0_18:getConfig("goods")[1]
	local var5_18 = Item.getConfigData(var4_18)

	if var3_18 == DROP_TYPE_VITEM and var5_18.virtual_type == 22 then
		var0_18 = true
		var2_18 = true

		local var6_18 = getProxy(ActivityProxy):getActivityById(var5_18.link_id)

		if var6_18 and not var6_18:isEnd() then
			var1_18 = true
		end
	end

	return var0_18, var1_18, var2_18
end

function var0_0.GetPurchasableCnt(arg0_19)
	return arg0_19.count
end

return var0_0
