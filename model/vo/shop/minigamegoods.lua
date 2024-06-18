local var0_0 = class("MiniGameGoods", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg1_1.id
	arg0_1.count = arg0_1:GetLimit()
end

function var0_0.getId(arg0_2)
	return arg0_2.id
end

function var0_0.UpdateCnt(arg0_3, arg1_3)
	arg0_3.count = arg0_3.count - arg1_3

	if arg0_3.count < 0 then
		arg0_3.count = 0
	end
end

function var0_0.bindConfigTable(arg0_4)
	return pg.gameroom_shop_template
end

function var0_0.CanPurchase(arg0_5)
	if arg0_5:getConfig("drop_type") == DROP_TYPE_SKIN and getProxy(ShipSkinProxy):getSkinById(arg0_5:getConfig("goods")[1]) then
		return false
	end

	return arg0_5.count > 0
end

function var0_0.GetPrice(arg0_6)
	return arg0_6:getConfig("price")
end

function var0_0.Selectable(arg0_7)
	return arg0_7:getConfig("goods_type") == 2
end

function var0_0.Single(arg0_8)
	return arg0_8:getConfig("goods_type") == 1
end

function var0_0.GetFirstDropId(arg0_9)
	return arg0_9:getConfig("goods")
end

function var0_0.GetMaxCnt(arg0_10)
	if arg0_10:CanPurchase() then
		return arg0_10.count
	else
		return 0
	end
end

function var0_0.CanPurchaseCnt(arg0_11, arg1_11)
	return arg1_11 <= arg0_11.count
end

function var0_0.GetLimit(arg0_12)
	return arg0_12:getConfig("goods_purchase_limit")
end

function var0_0.GetDropInfo(arg0_13)
	return Drop.New({
		type = arg0_13:getConfig("drop_type"),
		id = arg0_13:getConfig("goods")[1],
		count = arg0_13:getConfig("num")
	})
end

return var0_0
