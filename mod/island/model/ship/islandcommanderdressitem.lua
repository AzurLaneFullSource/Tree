local var0_0 = class("IslandCommanderDressItem", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.state = arg1_1.state
	arg0_1.color = arg1_1.color
	arg0_1.color_list = arg1_1.color_list or {}
end

function var0_0.SetReadState(arg0_2, arg1_2)
	arg0_2.state = arg1_2
end

function var0_0.ChangeColor(arg0_3, arg1_3)
	arg0_3.color = arg1_3
end

function var0_0.CheckColorIsOwned(arg0_4, arg1_4)
	if arg1_4 == 0 then
		return true
	end

	for iter0_4, iter1_4 in ipairs(arg0_4.color_list) do
		if iter1_4 == arg1_4 then
			return true
		end
	end

	return false
end

function var0_0.AddDressColor(arg0_5, arg1_5)
	table.insert(arg0_5.color_list, arg1_5)
end

function var0_0.bindConfigTable(arg0_6)
	return pg.island_dress_template
end

function var0_0.GetSortValue(arg0_7, arg1_7, arg2_7)
	local var0_7 = 0

	if arg1_7 == IslandShipDressUpPageNew.SORT_RARITY then
		var0_7 = arg0_7:GetRarity()
	else
		var0_7 = arg0_7.id
	end

	return arg2_7 == 1 and var0_7 or -1 * var0_7
end

function var0_0.GetRarity(arg0_8)
	return arg0_8:getConfig("quality")
end

return var0_0
