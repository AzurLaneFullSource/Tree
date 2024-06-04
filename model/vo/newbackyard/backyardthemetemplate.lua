local var0 = class("BackYardThemeTemplate", import(".BackYardBaseThemeTemplate"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.isFetched = arg1.is_fetch
end

function var0.GetType(arg0)
	return BackYardConst.THEME_TEMPLATE_USAGE_TYPE_OTHER
end

function var0.ShouldFetch(arg0)
	return not arg0.isFetched
end

function var0.GetAllFurniture(arg0)
	if not arg0.furnitruesByIds then
		local var0 = arg0:GetRawPutList()

		arg0.furnitruesByIds = arg0:InitFurnitures({
			skipCheck = true,
			floor = 1,
			mapSize = arg0:GetMapSize(),
			furniture_put_list = var0
		})
	end

	return arg0.furnitruesByIds
end

function var0.GetMapSize(arg0)
	return (Dorm.StaticGetMapSize(4))
end

function var0.GetFurnitureCnt(arg0)
	if not arg0.furnitureCnts then
		arg0.furnitureCnts = {}

		for iter0, iter1 in ipairs(arg0:GetWarpFurnitures()) do
			if not arg0.furnitureCnts[iter1.configId] then
				arg0.furnitureCnts[iter1.configId] = 0
			end

			arg0.furnitureCnts[iter1.configId] = arg0.furnitureCnts[iter1.configId] + 1
		end
	end

	return arg0.furnitureCnts
end

return var0
