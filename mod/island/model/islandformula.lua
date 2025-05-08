local var0_0 = class("IslandFormula", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_formula
end

function var0_0.GetGroup(arg0_3)
	return arg0_3:getConfig("place_group")
end

function var0_0.GetName(arg0_4)
	return arg0_4:getConfig("name")
end

function var0_0.GetItemId(arg0_5)
	return arg0_5:getConfig("item_id")
end

function var0_0.GetDesc(arg0_6)
	return arg0_6:getConfig("desc")
end

function var0_0.GetPoint(arg0_7)
	return arg0_7:getConfig("production_points")
end

function var0_0.GetMakeCost(arg0_8)
	return arg0_8:getConfig("cost")
end

function var0_0.GetMakeDrop(arg0_9)
	return arg0_9:getConfig("drop_product")
end

function var0_0.GetCommissionCost(arg0_10)
	local var0_10 = arg0_10:getConfig("commission_cost")

	return var0_10 == "" and {} or var0_10
end

function var0_0.GetCommissionDrop(arg0_11)
	return arg0_11:getConfig("commission_product")
end

function var0_0.GetSecondDrop(arg0_12)
	return arg0_12:getConfig("second_product")
end

function var0_0.GetUnlock(arg0_13)
	return arg0_13:getConfig("unlock_place_level")
end

function var0_0.IsEnough(arg0_14)
	local var0_14 = arg0_14:GetMakeCost()

	if var0_14 == "" then
		return true
	end

	for iter0_14, iter1_14 in ipairs(var0_14) do
		local var1_14 = Drop.New({
			type = iter1_14[1],
			id = iter1_14[2],
			count = iter1_14[3]
		})

		if var1_14:getOwnedCount() < var1_14.count then
			return false
		end
	end

	return true
end

return var0_0
