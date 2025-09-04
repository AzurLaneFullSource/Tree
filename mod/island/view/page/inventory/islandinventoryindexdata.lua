local var0_0 = class("IslandInventoryIndexData")

var0_0.MODE_SINGLE = 1
var0_0.MODE_MULTI = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.layoutData = arg0_1:GenLayoutData(arg1_1)
	arg0_1.data = _.map(arg0_1.layoutData, function(arg0_2)
		return arg0_2.list[1]
	end)
end

function var0_0.GenLayoutData(arg0_3, arg1_3)
	local var0_3 = pg.island_storage_filter_template.get_id_list_by_belong_filter_id[arg1_3]
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var2_3 = pg.island_storage_filter_template[iter1_3].name
		local var3_3 = {}
		local var4_3 = {}
		local var5_3 = pg.island_storage_filter_template.get_id_list_by_belong_filter_id[iter1_3]

		for iter2_3, iter3_3 in ipairs(var5_3) do
			local var6_3 = bit.lshift(1, iter2_3)
			local var7_3 = pg.island_storage_filter_template[iter3_3].name

			table.insert(var3_3, var6_3)
			table.insert(var4_3, var7_3)
		end

		table.insert(var3_3, 1, IndexConst.BitAll(var3_3))
		table.insert(var4_3, 1, i18n("index_all"))
		table.insert(var1_3, {
			mode = var0_0.MODE_MULTI,
			list = var3_3,
			names = var4_3,
			title = var2_3
		})
	end

	local var8_3 = pg.island_storage_filter_template[arg1_3].sort_id
	local var9_3 = pg.island_storage_filter_template[var8_3]
	local var10_3 = {}
	local var11_3 = {}
	local var12_3 = {}
	local var13_3 = pg.island_storage_filter_template.get_id_list_by_belong_filter_id[var8_3]

	for iter4_3, iter5_3 in ipairs(var13_3) do
		local var14_3 = pg.island_storage_filter_template[iter5_3]

		table.insert(var10_3, bit.lshift(1, iter4_3))
		table.insert(var11_3, var14_3.name)
		table.insert(var12_3, var14_3.args)
	end

	local var15_3 = {
		mode = var0_0.MODE_SINGLE,
		list = var10_3,
		names = var11_3,
		sortFuncName = var12_3,
		title = i18n("island_word_sort")
	}

	table.insert(var1_3, 1, var15_3)

	return var1_3
end

function var0_0.GetLayoutData(arg0_4)
	return arg0_4.layoutData
end

function var0_0.GetData(arg0_5, arg1_5)
	return arg0_5.data
end

function var0_0.SetData(arg0_6, arg1_6)
	arg0_6.data = arg1_6
end

function var0_0.Match(arg0_7, arg1_7)
	local var0_7 = arg1_7:getConfig("filter")
	local var1_7 = pg.island_storage_filter_template.get_id_list_by_belong_filter_id[arg0_7.id]
	local var2_7 = 0

	for iter0_7, iter1_7 in ipairs(var1_7) do
		local var3_7 = pg.island_storage_filter_template.get_id_list_by_belong_filter_id[iter1_7]
		local var4_7 = {}

		for iter2_7, iter3_7 in ipairs(var0_7) do
			local var5_7 = table.indexof(var3_7, iter3_7)

			if var5_7 then
				table.insert(var4_7, bit.lshift(1, var5_7))
			end
		end

		local var6_7 = IndexConst.BitAll(var4_7)
		local var7_7 = arg0_7.data[iter0_7 + 1]
		local var8_7 = arg0_7.layoutData[iter0_7 + 1].list

		if var0_0.CheckSelectedAll(var8_7, var7_7) or bit.band(var6_7, var7_7) > 0 then
			var2_7 = var2_7 + 1
		end
	end

	return var2_7 == #var1_7
end

function var0_0.GetSortData(arg0_8)
	return arg0_8.data[1]
end

function var0_0.GetSortText(arg0_9)
	local var0_9 = arg0_9:GetSortData()
	local var1_9 = arg0_9:GetLayoutData()[1]
	local var2_9 = 0

	for iter0_9, iter1_9 in ipairs(var1_9.list) do
		if bit.band(var0_9, iter1_9) > 0 then
			var2_9 = iter0_9

			break
		end
	end

	return var1_9.names[var2_9] or ""
end

function var0_0.Sort(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg0_10:GetSortData()
	local var1_10 = 0
	local var2_10 = 0
	local var3_10 = arg0_10:GetLayoutData()[1]
	local var4_10 = 0

	for iter0_10, iter1_10 in ipairs(var3_10.list) do
		if bit.band(var0_10, iter1_10) > 0 then
			var4_10 = iter0_10

			break
		end
	end

	if var4_10 > 0 then
		local var5_10 = var3_10.sortFuncName[var4_10]

		assert(arg1_10[var5_10], "func should be exist")

		var1_10, var2_10 = arg1_10[var5_10](arg1_10), arg2_10[var5_10](arg2_10)
	end

	local function var6_10(arg0_11, arg1_11, arg2_11)
		if arg0_11.id == arg1_11.id then
			return arg0_11:GetCount() > arg1_11:GetCount()
		else
			return (arg2_11 and {
				arg0_11.id < arg1_11.id
			} or {
				arg0_11.id > arg1_11.id
			})[1]
		end
	end

	if var1_10 == var2_10 then
		local var7_10 = arg1_10:GetType()
		local var8_10 = arg2_10:GetType()

		if var7_10 == var8_10 then
			return var6_10(arg1_10, arg2_10, arg3_10)
		else
			return (arg3_10 and {
				var7_10 < var8_10
			} or {
				var8_10 < var7_10
			})[1]
		end
	else
		return (arg3_10 and {
			var1_10 < var2_10
		} or {
			var2_10 < var1_10
		})[1]
	end
end

function var0_0.CheckSelectedAll(arg0_12, arg1_12)
	if #arg0_12 <= 1 then
		return true
	end

	return arg1_12 == arg0_12[1]
end

return var0_0
