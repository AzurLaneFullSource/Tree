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

function var0_0.IsAnyLoadUp(arg0_2)
	return _.any(arg0_2.consumeList, function(arg0_3)
		return arg0_3.state == 1
	end)
end

function var0_0.IsLoadUpAll(arg0_4)
	return _.all(arg0_4.consumeList, function(arg0_5)
		return arg0_5.state == 1
	end)
end

function var0_0.MarkLoadUp(arg0_6, arg1_6)
	arg0_6:GetComsume(arg1_6).state = 1
end

function var0_0.GetConsumeList(arg0_7)
	return arg0_7.consumeList
end

function var0_0.GetComsume(arg0_8, arg1_8)
	return arg0_8.consumeList[arg1_8] or {}
end

function var0_0.AnyCanLoadUp(arg0_9)
	if arg0_9:IsLoadUpAll() then
		return false
	end

	return _.any(arg0_9.consumeList, function(arg0_10)
		local var0_10 = Drop.New(arg0_10)

		return arg0_10.state ~= 1 and var0_10:getOwnedCount() >= arg0_10.count
	end)
end

function var0_0.ItemIsSubmited(arg0_11, arg1_11)
	local var0_11 = arg0_11.consumeList[arg1_11]

	return var0_11 and var0_11.state == 1
end

function var0_0.GetConsumeAwards(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetComsume(arg1_12)
	local var1_12 = pg.island_item_data_template[var0_12.id]
	local var2_12 = pg.island_set.order_ship_award_coefficient.key_value_varchar
	local var3_12 = var1_12.order_price * var0_12.count

	return {
		{
			type = DROP_TYPE_ISLAND_ITEM,
			id = var2_12[1],
			count = math.floor(var3_12 * (var2_12[2] / 100))
		},
		{
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = math.floor(var3_12 * (var2_12[3] / 100))
		}
	}
end

function var0_0.GetAwardList(arg0_13)
	return _.select(arg0_13.awardList, function(arg0_14)
		return arg0_14.count > 0
	end)
end

return var0_0
