local var0 = class("ShipEvaluation", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.ship_group_id
	arg0.hearts = arg1.heart_count
	arg0.evaCount = arg1.discuss_count
	arg0.ievaCount = arg1.daily_discuss_count
	arg0.evas = {}

	for iter0, iter1 in ipairs(arg1.discuss_list) do
		table.insert(arg0.evas, {
			hot = false,
			izan = false,
			id = iter1.id,
			good_count = iter1.good_count,
			bad_count = iter1.bad_count,
			nick_name = iter1.nick_name,
			context = iter1.context
		})
	end

	arg0:sortEvas()
end

function var0.sortEvas(arg0)
	arg0.evas = _.sort(arg0.evas, function(arg0, arg1)
		local var0 = arg0.good_count - arg0.bad_count
		local var1 = arg1.good_count - arg1.bad_count

		if var0 == var1 then
			return arg0.id > arg1.id
		else
			return var1 < var0
		end
	end)

	local var0 = math.min(2, #arg0.evas)
	local var1 = _(arg0.evas):chain():slice(var0 + 1, #arg0.evas - var0):sort(function(arg0, arg1)
		local var0 = arg0.good_count - arg0.bad_count
		local var1 = arg1.good_count - arg1.bad_count

		if var0 <= -5 or var1 <= -5 then
			return var1 < var0
		else
			return arg0.id > arg1.id
		end
	end):value()

	for iter0 = 1, #arg0.evas do
		arg0.evas[iter0].hot = iter0 <= var0

		if var0 < iter0 then
			arg0.evas[iter0] = var1[iter0 - var0]
		end
	end
end

return var0
