local var0 = class("NewServerCommodity", import("...BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.count = arg1.count or arg0:getConfig("goods_purchase_limit")
	arg0.boughtRecord = {}

	for iter0, iter1 in ipairs(arg1.bought_record or {}) do
		arg0.boughtRecord[iter1] = true
	end
end

function var0.bindConfigTable(arg0)
	return pg.newserver_shop_template
end

function var0.CanPurchase(arg0)
	return arg0.count > 0
end

function var0.ReduceCnt(arg0, arg1)
	arg0.count = arg0.count - arg1
end

function var0.CanPurchaseMulTimes(arg0, arg1)
	return arg1 <= arg0.count
end

function var0.CanPurchaseSubGoods(arg0, arg1)
	if arg0:LimitPurchaseSubGoods() then
		return not (arg0.boughtRecord[arg1] == true)
	else
		return true
	end
end

function var0.UpdateBoughtRecord(arg0, arg1)
	arg0.boughtRecord[arg1] = true
end

function var0.LimitPurchaseSubGoods(arg0)
	return arg0:getConfig("goods_type") == 4
end

function var0.Selectable(arg0)
	local var0 = arg0:getConfig("goods_type")

	return var0 == 2 or var0 == 4
end

function var0.GetConsume(arg0)
	return Drop.New({
		type = arg0:getConfig("resource_category"),
		id = arg0:getConfig("resource_type"),
		count = arg0:getConfig("resource_num")
	})
end

function var0.GetDesc(arg0)
	return {
		name = arg0:getConfig("goods_name"),
		icon = arg0:getConfig("goods_icon"),
		rarity = arg0:getConfig("goods_rarity")
	}
end

function var0.IsOpening(arg0, arg1)
	local var0 = {}
	local var1 = arg1 + arg0:getConfig("unlock_time")
	local var2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3 = var1 <= var2

	if not var3 then
		local var4, var5, var6, var7 = pg.TimeMgr.GetInstance():parseTimeFrom(var1 - var2)

		var0.day = var4
		var0.hour = var5
	end

	return var3, var0
end

function var0.GetDropCnt(arg0)
	return arg0:getConfig("num")
end

function var0.GetCanPurchaseCnt(arg0)
	return arg0.count
end

function var0.GetCanPurchaseMaxCnt(arg0)
	return arg0:getConfig("goods_purchase_limit")
end

function var0.GetDropType(arg0)
	return arg0:getConfig("type")
end

function var0.GetSelectableGoods(arg0)
	return arg0:getConfig("goods")
end

function var0.CheckTimeLimit(arg0)
	local var0 = false
	local var1 = false
	local var2
	local var3 = arg0:getConfig("type")
	local var4 = arg0:getConfig("goods")[1]
	local var5 = Item.getConfigData(var4)

	if var3 == DROP_TYPE_VITEM and var5.virtual_type == 22 then
		var0 = true
		var2 = true

		local var6 = getProxy(ActivityProxy):getActivityById(var5.link_id)

		if var6 and not var6:isEnd() then
			var1 = true
		end
	end

	return var0, var1, var2
end

function var0.GetPurchasableCnt(arg0)
	return arg0.count
end

return var0
