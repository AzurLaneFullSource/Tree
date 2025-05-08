local var0_0 = class("IslandShipOrder")

var0_0.OP_TYPE_UNLOCK = 1
var0_0.OP_TYPE_GET_AWARD = 2
var0_0.OP_TYPE_LOADUP = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.consumeList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.cost or {}) do
		table.insert(arg0_1.consumeList, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_1.id,
			count = iter1_1.num,
			state = iter1_1.state
		})
	end

	arg0_1.awardList = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.reward or {}) do
		table.insert(arg0_1.awardList, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter3_1.id,
			count = iter3_1.num
		})
	end
end

function var0_0.IsLoadUpAll(arg0_2)
	return _.all(arg0_2.consumeList, function(arg0_3)
		return arg0_3.state == 1
	end)
end

function var0_0.MarkLoadUp(arg0_4, arg1_4)
	arg0_4:GetComsume(arg1_4).state = 1
end

function var0_0.GetConsumeList(arg0_5)
	return arg0_5.consumeList
end

function var0_0.GetComsume(arg0_6, arg1_6)
	return arg0_6.consumeList[arg1_6] or {}
end

function var0_0.ItemIsSubmited(arg0_7, arg1_7)
	local var0_7 = arg0_7.consumeList[arg1_7]

	return var0_7 and var0_7.state == 1
end

function var0_0.GetConsumeAwards(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetComsume(arg1_8)
	local var1_8 = pg.island_item_data_template[var0_8.id]
	local var2_8 = pg.island_set.order_ship_award_coefficient.key_value_varchar
	local var3_8 = var1_8.order_price * var0_8.count

	return {
		{
			type = DROP_TYPE_ISLAND_ITEM,
			id = var2_8[1],
			count = math.floor(var3_8 * (var2_8[2] / 100))
		},
		{
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = math.floor(var3_8 * (var2_8[3] / 100))
		}
	}
end

function var0_0.GetAwardList(arg0_9)
	return arg0_9.awardList
end

return var0_0
