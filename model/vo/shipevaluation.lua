local var0_0 = class("ShipEvaluation", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.ship_group_id
	arg0_1.hearts = arg1_1.heart_count
	arg0_1.evaCount = arg1_1.discuss_count
	arg0_1.ievaCount = arg1_1.daily_discuss_count
	arg0_1.evas = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.discuss_list) do
		table.insert(arg0_1.evas, {
			hot = false,
			izan = false,
			id = iter1_1.id,
			good_count = iter1_1.good_count,
			bad_count = iter1_1.bad_count,
			nick_name = iter1_1.nick_name,
			context = iter1_1.context
		})
	end

	arg0_1:sortEvas()
end

function var0_0.sortEvas(arg0_2)
	arg0_2.evas = _.sort(arg0_2.evas, function(arg0_3, arg1_3)
		local var0_3 = arg0_3.good_count - arg0_3.bad_count
		local var1_3 = arg1_3.good_count - arg1_3.bad_count

		if var0_3 == var1_3 then
			return arg0_3.id > arg1_3.id
		else
			return var1_3 < var0_3
		end
	end)

	local var0_2 = math.min(2, #arg0_2.evas)
	local var1_2 = _(arg0_2.evas):chain():slice(var0_2 + 1, #arg0_2.evas - var0_2):sort(function(arg0_4, arg1_4)
		local var0_4 = arg0_4.good_count - arg0_4.bad_count
		local var1_4 = arg1_4.good_count - arg1_4.bad_count

		if var0_4 <= -5 or var1_4 <= -5 then
			return var1_4 < var0_4
		else
			return arg0_4.id > arg1_4.id
		end
	end):value()

	for iter0_2 = 1, #arg0_2.evas do
		arg0_2.evas[iter0_2].hot = iter0_2 <= var0_2

		if var0_2 < iter0_2 then
			arg0_2.evas[iter0_2] = var1_2[iter0_2 - var0_2]
		end
	end
end

return var0_0
