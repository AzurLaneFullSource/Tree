local var0 = class("WorldGoods", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	item = "table",
	count = "number",
	id = "number",
	moneyItem = "table"
}
var0.EventUpdateCount = "WorldGoods.EventUpdateCount"

function var0.Setup(arg0, arg1)
	arg0.id = arg1.goods_id
	arg0.config = pg.world_goods_data[arg0.id]

	assert(arg0.config, "world_goods_data not exist: " .. arg0.id)

	arg0.count = arg1.count
	arg0.item = Drop.New({
		type = arg0.config.item_type,
		id = arg0.config.item_id,
		count = arg0.config.item_num
	})
	arg0.moneyItem = Drop.New({
		type = arg0.config.price_type,
		id = arg0.config.price_id,
		count = arg0.config.price_num
	})
end

function var0.UpdateCount(arg0, arg1)
	if arg0.count ~= arg1 then
		arg0.count = arg1

		arg0:DispatchEvent(var0.EventUpdateCount)
	end
end

function var0.sortFunc(arg0, arg1)
	if arg0.config.priority == arg1.config.priority then
		return arg0.id < arg1.id
	else
		return arg0.config.priority > arg1.config.priority
	end
end

return var0
