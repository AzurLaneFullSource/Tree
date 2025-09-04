local var0_0 = class("IslandDressItem", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.hasSend = arg1_1.hasSend
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_dress_template
end

function var0_0.GetSortValue(arg0_3, arg1_3, arg2_3)
	local var0_3 = 0

	if arg1_3 == IslandShipDressUpPageNew.SORT_RARITY then
		var0_3 = arg0_3:GetRarity()
	elseif arg1_3 == IslandShipDressUpPageNew.SORT_CANSEND then
		var0_3 = arg0_3.hasSend and 1 or 0
	else
		var0_3 = arg0_3.id
	end

	return arg2_3 == 1 and var0_3 or -1 * var0_3
end

function var0_0.GetRarity(arg0_4)
	return arg0_4:getConfig("quality")
end

return var0_0
