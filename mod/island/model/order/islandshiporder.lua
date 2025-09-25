local var0_0 = class("IslandShipOrder")

var0_0.OP_TYPE_UNLOCK = 1
var0_0.OP_TYPE_GET_AWARD = 2
var0_0.OP_TYPE_LOADUP = 3
var0_0.OPOP_TYPE_LOADUP_ALL = 4

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

	table.insert(arg0_1.awardList, {
		id = 0,
		type = VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT,
		count = arg1_1.add_pt or 0
	})
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

function var0_0.AnyCanLoadUp(arg0_7)
	if arg0_7:IsLoadUpAll() then
		return false
	end

	return _.any(arg0_7.consumeList, function(arg0_8)
		local var0_8 = Drop.New(arg0_8)

		return arg0_8.state ~= 1 and var0_8:getOwnedCount() >= arg0_8.count
	end)
end

function var0_0.ItemIsSubmited(arg0_9, arg1_9)
	local var0_9 = arg0_9.consumeList[arg1_9]

	return var0_9 and var0_9.state == 1
end

function var0_0.GetConsumeAwards(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetComsume(arg1_10)
	local var1_10 = pg.island_item_data_template[var0_10.id]
	local var2_10 = pg.island_set.order_ship_award_coefficient.key_value_varchar
	local var3_10 = var1_10.order_price * var0_10.count

	return {
		{
			type = DROP_TYPE_ISLAND_ITEM,
			id = var2_10[1],
			count = math.floor(var3_10 * (var2_10[2] / 100))
		},
		{
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = math.floor(var3_10 * (var2_10[3] / 100))
		}
	}
end

function var0_0.GetAwardList(arg0_11)
	return arg0_11.awardList
end

return var0_0
