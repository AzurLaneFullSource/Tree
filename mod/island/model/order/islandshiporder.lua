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
end

function var0_0.FillConsumeList(arg0_2, arg1_2)
	arg0_2.consumeList = arg1_2
end

function var0_0.FillAwardList(arg0_3, arg1_3)
	arg0_3.awardList = arg1_3
end

function var0_0.IsAnyLoadUp(arg0_4)
	return _.any(arg0_4.consumeList, function(arg0_5)
		return arg0_5.state == 1
	end)
end

function var0_0.IsLoadUpAll(arg0_6)
	return _.all(arg0_6.consumeList, function(arg0_7)
		return arg0_7.state == 1
	end)
end

function var0_0.MarkLoadUp(arg0_8, arg1_8)
	arg0_8:GetComsume(arg1_8).state = 1
end

function var0_0.GetConsumeList(arg0_9)
	return arg0_9.consumeList
end

function var0_0.GetComsume(arg0_10, arg1_10)
	return arg0_10.consumeList[arg1_10] or {}
end

function var0_0.AnyCanLoadUp(arg0_11)
	if arg0_11:IsLoadUpAll() then
		return false
	end

	return _.any(arg0_11.consumeList, function(arg0_12)
		local var0_12 = Drop.New(arg0_12)

		return arg0_12.state ~= 1 and var0_12:getOwnedCount() >= arg0_12.count
	end)
end

function var0_0.ItemIsSubmited(arg0_13, arg1_13)
	local var0_13 = arg0_13.consumeList[arg1_13]

	return var0_13 and var0_13.state == 1
end

function var0_0.GetConsumeAwards(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetComsume(arg1_14)
	local var1_14 = pg.island_item_data_template[var0_14.id]
	local var2_14 = pg.island_set.order_ship_award_coefficient.key_value_varchar
	local var3_14 = var1_14.order_price * var0_14.count

	return {
		{
			type = DROP_TYPE_ISLAND_ITEM,
			id = var2_14[1],
			count = math.floor(var3_14 * (var2_14[2] / 100))
		},
		{
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = math.floor(var3_14 * (var2_14[3] / 100))
		}
	}
end

function var0_0.GetAwardList(arg0_15)
	return _.select(arg0_15.awardList, function(arg0_16)
		return arg0_16.count > 0
	end)
end

return var0_0
