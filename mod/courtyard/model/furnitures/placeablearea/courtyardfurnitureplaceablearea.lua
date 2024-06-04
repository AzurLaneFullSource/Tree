local var0 = class("CourtYardFurniturePlaceableArea", import("...map.CourtYardPlaceableArea"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.furniture = arg2

	var0.super.Ctor(arg0, arg1, arg3)
end

function var0.LegalPosition(arg0, arg1, arg2)
	local var0 = arg0.furniture:GetCanputonPosition()

	return var0.super.IsEmptyPosition(arg0, arg1) and table.contains(var0, arg1)
end

function var0.AreaWithInfo(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:GetAreaByPosition(arg2)

	return _.map(var0, function(arg0)
		local var0 = arg4 or arg0:LegalPosition(arg0)

		return {
			flag = var0 and 3 or 2,
			position = arg0,
			offset = arg3
		}
	end)
end

return var0
