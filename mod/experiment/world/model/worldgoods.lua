local var0_0 = class("WorldGoods", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	item = "table",
	count = "number",
	id = "number",
	moneyItem = "table"
}
var0_0.EventUpdateCount = "WorldGoods.EventUpdateCount"

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1.goods_id
	arg0_1.config = pg.world_goods_data[arg0_1.id]

	assert(arg0_1.config, "world_goods_data not exist: " .. arg0_1.id)

	arg0_1.count = arg1_1.count
	arg0_1.item = Drop.New({
		type = arg0_1.config.item_type,
		id = arg0_1.config.item_id,
		count = arg0_1.config.item_num
	})
	arg0_1.moneyItem = Drop.New({
		type = arg0_1.config.price_type,
		id = arg0_1.config.price_id,
		count = arg0_1.config.price_num
	})
end

function var0_0.UpdateCount(arg0_2, arg1_2)
	if arg0_2.count ~= arg1_2 then
		arg0_2.count = arg1_2

		arg0_2:DispatchEvent(var0_0.EventUpdateCount)
	end
end

function var0_0.sortFunc(arg0_3, arg1_3)
	if arg0_3.config.priority == arg1_3.config.priority then
		return arg0_3.id < arg1_3.id
	else
		return arg0_3.config.priority > arg1_3.config.priority
	end
end

return var0_0
