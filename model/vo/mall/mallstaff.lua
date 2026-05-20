local var0_0 = class("MallStaff", import("model.vo.BaseVO"))

var0_0.STATUS = {
	FLOOR = 2,
	NORMAL = 1,
	ORDER = 3
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.tid = arg1_1.tid
	arg0_1.configId = arg0_1.tid
	arg0_1.attrs = {}

	if arg1_1.attr_list then
		table.sort(arg1_1.attr_list, function(arg0_2, arg1_2)
			return arg0_2.key < arg1_2.key
		end)

		for iter0_1, iter1_1 in ipairs(arg1_1.attr_list) do
			table.insert(arg0_1.attrs, iter1_1.value)
		end
	end

	arg0_1:SetStatus(var0_0.STATUS.NORMAL, {})
end

function var0_0.bindConfigTable(arg0_3)
	return pg.activity_mall_staff_template
end

function var0_0.NeedReqData(arg0_4)
	return #arg0_4.attrs == 0
end

function var0_0.GetAttrList(arg0_5)
	return arg0_5.attrs
end

function var0_0.SetStatus(arg0_6, arg1_6, arg2_6)
	arg0_6.status = arg1_6
	arg0_6.statusData = arg2_6
end

function var0_0.GetStatusInfos(arg0_7)
	return arg0_7.status, arg0_7.statusData
end

function var0_0.SetExtraData(arg0_8, arg1_8)
	local var0_8 = {}

	for iter0_8 = 1, #arg1_8, 2 do
		table.insert(var0_8, {
			key = arg1_8[iter0_8],
			value = arg1_8[iter0_8 + 1]
		})
	end

	table.sort(var0_8, function(arg0_9, arg1_9)
		return arg0_9.key < arg1_9.key
	end)

	arg0_8.attrs = {}

	for iter1_8, iter2_8 in ipairs(var0_8) do
		table.insert(arg0_8.attrs, iter2_8.value)
	end
end

function var0_0.GetTotalVal(arg0_10)
	local var0_10 = 0

	for iter0_10, iter1_10 in ipairs(arg0_10.attrs) do
		var0_10 = var0_10 + iter1_10
	end

	return var0_10
end

return var0_0
