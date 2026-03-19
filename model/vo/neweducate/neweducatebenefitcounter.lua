local var0_0 = class("NewEducateBenefitCounter")

var0_0.TYPE = {
	GAIN = 1,
	COST = 2
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.group = arg1_1.group

	arg0_1:InitData(arg1_1.change)
end

function var0_0.InitData(arg0_2, arg1_2)
	arg0_2.data = {}

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		if not arg0_2.data[iter1_2.drop_type] then
			arg0_2.data[iter1_2.drop_type] = {}
		end

		arg0_2.data[iter1_2.drop_type][iter1_2.drop_id] = {
			[var0_0.TYPE.GAIN] = iter1_2.positive_counter,
			[var0_0.TYPE.COST] = iter1_2.negative_counter
		}
	end
end

function var0_0.UpdateData(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3) do
		if not arg0_3.data[iter1_3.drop_type] then
			arg0_3.data[iter1_3.drop_type] = {}
		end

		local var0_3 = arg0_3.data[iter1_3.drop_type][iter1_3.drop_id]

		arg0_3.data[iter1_3.drop_type][iter1_3.drop_id] = {
			[var0_0.TYPE.GAIN] = (var0_3 and var0_3[var0_0.TYPE.GAIN] or 0) + iter1_3.positive_counter,
			[var0_0.TYPE.COST] = (var0_3 and var0_3[var0_0.TYPE.COST] or 0) + iter1_3.negative_counter
		}
	end
end

function var0_0.GetValue(arg0_4, arg1_4, arg2_4, arg3_4)
	if not arg0_4.data[arg2_4] or not arg0_4.data[arg2_4][arg3_4] then
		return 0
	end

	return arg0_4.data[arg2_4][arg3_4][arg1_4]
end

return var0_0
