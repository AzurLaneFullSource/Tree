local var0_0 = class("BackYardThemeTemplate", import(".BackYardBaseThemeTemplate"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.isFetched = arg1_1.is_fetch
end

function var0_0.GetType(arg0_2)
	return BackYardConst.THEME_TEMPLATE_USAGE_TYPE_OTHER
end

function var0_0.ShouldFetch(arg0_3)
	return not arg0_3.isFetched
end

function var0_0.GetAllFurniture(arg0_4)
	if not arg0_4.furnitruesByIds then
		local var0_4 = arg0_4:GetRawPutList()

		arg0_4.furnitruesByIds = arg0_4:InitFurnitures({
			skipCheck = true,
			floor = 1,
			mapSize = arg0_4:GetMapSize(),
			furniture_put_list = var0_4
		})
	end

	return arg0_4.furnitruesByIds
end

function var0_0.GetMapSize(arg0_5)
	return (Dorm.StaticGetMapSize(4))
end

function var0_0.GetFurnitureCnt(arg0_6)
	if not arg0_6.furnitureCnts then
		arg0_6.furnitureCnts = {}

		for iter0_6, iter1_6 in ipairs(arg0_6:GetWarpFurnitures()) do
			if not arg0_6.furnitureCnts[iter1_6.configId] then
				arg0_6.furnitureCnts[iter1_6.configId] = 0
			end

			arg0_6.furnitureCnts[iter1_6.configId] = arg0_6.furnitureCnts[iter1_6.configId] + 1
		end
	end

	return arg0_6.furnitureCnts
end

return var0_0
