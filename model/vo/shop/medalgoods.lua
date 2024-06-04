local var0 = class("MedalGoods", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id
	arg0.count = arg1.count
end

function var0.UpdateCnt(arg0, arg1)
	arg0.count = arg0.count - arg1
end

function var0.bindConfigTable(arg0)
	return pg.honormedal_goods_list
end

function var0.CanPurchase(arg0)
	return arg0.count > 0
end

function var0.GetPrice(arg0)
	return arg0:getConfig("price")
end

function var0.Selectable(arg0)
	return arg0:getConfig("goods_type") == 2
end

function var0.GetFirstDropId(arg0)
	return arg0:getConfig("goods")
end

function var0.GetMaxCnt(arg0)
	return arg0.count
end

function var0.CanPurchaseCnt(arg0, arg1)
	return arg1 <= arg0.count
end

function var0.GetLimit(arg0)
	return arg0:getConfig("goods_purchase_limit")
end

function var0.GetDropInfo(arg0)
	return Drop.New({
		type = arg0:getConfig("type"),
		id = arg0:getConfig("goods")[1],
		count = arg0:getConfig("num")
	})
end

return var0
