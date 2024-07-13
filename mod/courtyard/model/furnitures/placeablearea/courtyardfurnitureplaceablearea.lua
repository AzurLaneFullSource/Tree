local var0_0 = class("CourtYardFurniturePlaceableArea", import("...map.CourtYardPlaceableArea"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.furniture = arg2_1

	var0_0.super.Ctor(arg0_1, arg1_1, arg3_1)
end

function var0_0.LegalPosition(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.furniture:GetCanputonPosition()

	return var0_0.super.IsEmptyPosition(arg0_2, arg1_2) and table.contains(var0_2, arg1_2)
end

function var0_0.AreaWithInfo(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg1_3:GetAreaByPosition(arg2_3)

	return _.map(var0_3, function(arg0_4)
		local var0_4 = arg4_3 or arg0_3:LegalPosition(arg0_4)

		return {
			flag = var0_4 and 3 or 2,
			position = arg0_4,
			offset = arg3_3
		}
	end)
end

return var0_0
