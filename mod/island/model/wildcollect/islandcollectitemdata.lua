local var0_0 = class("IslandCollectItemData", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.hadFragmentList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.had_fragment or {}) do
		table.insert(arg0_1.hadFragmentList, iter1_1)
	end
end

function var0_0.AddFragment(arg0_2, arg1_2)
	table.insert(arg0_2.hadFragmentList, arg1_2)
end

function var0_0.CheckFragment(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.hadFragmentList) do
		if iter1_3 == arg1_3 then
			return true
		end
	end

	return false
end

function var0_0.ResetFragment(arg0_4)
	arg0_4.hadFragmentList = {}
end

function var0_0.UpdateData(arg0_5, arg1_5)
	return
end

function var0_0.bindConfigTable(arg0_6)
	return pg.island_collection
end

return var0_0
