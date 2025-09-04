local var0_0 = class("IslandShipDressItem", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.state = arg1_1.state
	arg0_1.color = arg1_1.color
	arg0_1.color_list = arg1_1.color_list or {}
end

function var0_0.ChangeColor(arg0_2, arg1_2)
	arg0_2.color = arg1_2
end

function var0_0.CheckColorIsOwned(arg0_3, arg1_3)
	if arg1_3 == 0 then
		return true
	end

	for iter0_3, iter1_3 in ipairs(arg0_3.color_list) do
		if iter1_3 == arg1_3 then
			return true
		end
	end

	return false
end

function var0_0.AddDressColor(arg0_4, arg1_4)
	table.insert(arg0_4.color_list, arg1_4)
end

function var0_0.bindConfigTable(arg0_5)
	return pg.island_dress_template
end

function var0_0.GetSortValue(arg0_6, arg1_6, arg2_6)
	local var0_6 = 0

	if arg1_6 == IslandShipDressUpPageNew.SORT_RARITY then
		var0_6 = arg0_6:GetRarity()
	else
		var0_6 = arg0_6.id
	end

	return arg2_6 == 1 and var0_6 or -1 * var0_6
end

function var0_0.GetRarity(arg0_7)
	return arg0_7:getConfig("quality")
end

return var0_0
