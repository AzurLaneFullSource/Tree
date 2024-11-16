local var0_0 = class("BlackFridayCommodity", import(".NewServerCommodity"))

function var0_0.bindConfigTable(arg0_1)
	return pg.blackfriday_shop_template
end

function var0_0.GetResType(arg0_2)
	return arg0_2:getConfig("resource_type")
end

function var0_0.GetDiscount(arg0_3)
	return arg0_3:getConfig("discount")
end

function var0_0.GetSalesPrice(arg0_4)
	return arg0_4:getConfig("resource_num") - arg0_4:getConfig("discount")
end

function var0_0.GetOffPercent(arg0_5)
	return math.modf(arg0_5:getConfig("discount") / arg0_5:getConfig("resource_num") * 100)
end

function var0_0.GetConsume(arg0_6)
	return Drop.New({
		type = arg0_6:getConfig("resource_category"),
		id = arg0_6:getConfig("resource_type"),
		count = arg0_6:GetSalesPrice()
	})
end

return var0_0
