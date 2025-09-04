local var0_0 = class("IslandShipSkin", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.color_id = arg1_1.color_id
	arg0_1.color_list = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.color_list or {}) do
		table.insert(arg0_1.color_list, iter1_1)
	end
end

function var0_0.CheckColorOwned(arg0_2, arg1_2)
	if arg1_2 == 0 then
		return true
	end

	for iter0_2, iter1_2 in ipairs(arg0_2.color_list or {}) do
		if iter1_2 == arg1_2 then
			return true
		end
	end

	return false
end

function var0_0.SetCurrentColor(arg0_3, arg1_3)
	arg0_3.color_id = arg1_3
end

function var0_0.AddSkinColor(arg0_4, arg1_4)
	table.insert(arg0_4.color_list, arg1_4)
end

function var0_0.IsOwnAllColor(arg0_5)
	return #arg0_5.color_list == #pg.island_skin_colordiff_template.get_id_list_by_skin_group[arg0_5.id]
end

return var0_0
