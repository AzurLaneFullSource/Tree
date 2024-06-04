local var0 = class("Furniture", import("..BaseVO"))

var0.TYPE_WALLPAPER = 1
var0.TYPE_FURNITURE = 2
var0.TYPE_DECORATE = 3
var0.TYPE_FLOORPAPER = 4
var0.TYPE_MAT = 5
var0.TYPE_WALL = 6
var0.TYPE_COLLECTION = 7
var0.TYPE_STAGE = 8
var0.TYPE_ARCH = 9
var0.TYPE_WALL_MAT = 10
var0.TYPE_MOVEABLE = 11
var0.TYPE_TRANSPORT = 12
var0.TYPE_RANDOM_CONTROLLER = 13
var0.TYPE_FOLLOWER = 14
var0.TYPE_LUTE = 15
var0.TYPE_RANDOM_SLOT = 16
var0.INDEX_TO_COMFORTABLE_TYPE = {
	var0.TYPE_WALLPAPER,
	var0.TYPE_FURNITURE,
	var0.TYPE_DECORATE,
	var0.TYPE_FLOORPAPER,
	var0.TYPE_MAT,
	var0.TYPE_WALL,
	var0.TYPE_COLLECTION,
	var0.TYPE_FURNITURE,
	var0.TYPE_FURNITURE,
	var0.TYPE_WALL,
	var0.TYPE_FURNITURE,
	var0.TYPE_FURNITURE,
	var0.TYPE_FURNITURE,
	var0.TYPE_FURNITURE,
	var0.TYPE_FURNITURE,
	var0.TYPE_FURNITURE
}
var0.INDEX_TO_SHOP_TYPE = {
	{
		var0.TYPE_WALLPAPER
	},
	{
		var0.TYPE_FLOORPAPER
	},
	{
		var0.TYPE_FURNITURE,
		var0.TYPE_MAT,
		var0.TYPE_COLLECTION,
		var0.TYPE_STAGE,
		var0.TYPE_ARCH,
		var0.TYPE_MOVEABLE,
		var0.TYPE_TRANSPORT,
		var0.TYPE_RANDOM_CONTROLLER,
		var0.TYPE_FOLLOWER,
		var0.TYPE_LUTE,
		var0.TYPE_RANDOM_SLOT
	},
	{},
	{
		var0.TYPE_DECORATE
	},
	{
		var0.TYPE_WALL,
		var0.TYPE_WALL_MAT
	}
}

function var0.Ctor(arg0, arg1)
	arg0.id = tonumber(arg1.id)
	arg0.configId = arg1.configId or tonumber(arg1.id)
	arg0.count = arg1.count or 0
	arg0.date = arg1.get_time or arg1.date or 0
	arg0.newFlag = false
end

function var0.MarkNew(arg0)
	arg0.newFlag = true
end

function var0.ClearNewFlag(arg0)
	arg0.newFlag = false
end

function var0.getDate(arg0)
	if arg0.date > 0 then
		return pg.TimeMgr.GetInstance():STimeDescS(arg0.date, "%Y/%m/%d")
	end
end

function var0.GetOwnCnt(arg0)
	return arg0.count
end

function var0.setCount(arg0, arg1)
	arg0.count = arg1
end

function var0.isNotForSale(arg0)
	return arg0:getConfig("not_for_sale") == 1
end

function var0.isForActivity(arg0)
	return arg0:getConfig("not_for_sale") == 2
end

function var0.addFurnitrueCount(arg0, arg1)
	arg0.count = arg0.count + arg1
end

function var0.canPurchase(arg0)
	return arg0.count < arg0:getConfig("count")
end

function var0.bindConfigTable(arg0)
	return pg.furniture_data_template
end

function var0.bindShopConfigTable(arg0)
	return pg.furniture_shop_template
end

function var0.isFurniture(arg0)
	return arg0:getConfig("type") ~= 0
end

function var0.IsNew(arg0)
	return arg0:getConfig("new") ~= 0
end

function var0.getConfig(arg0, arg1)
	local var0 = arg0:bindConfigTable()[arg0.configId]

	assert(var0, arg0.configId)

	if var0[arg1] then
		return var0[arg1]
	else
		local var1 = arg0:bindShopConfigTable()[arg0.configId]

		if var1 then
			return var1[arg1]
		end
	end
end

function var0.getTypeForComfortable(arg0)
	local var0 = arg0:getConfig("type")
	local var1 = var0.INDEX_TO_COMFORTABLE_TYPE[var0]

	return var1 and var1 or var0.TYPE_FURNITURE
end

function var0.getDeblocking(arg0)
	local var0 = arg0:getConfig("themeId")
	local var1 = pg.backyard_theme_template[var0]

	assert(var1, "pg.backyard_theme_template>>> id" .. var0)

	return var1.deblocking
end

function var0.inTheme(arg0)
	local var0 = arg0:getConfig("themeId")

	if var0 == 0 then
		return false
	end

	local var1 = pg.backyard_theme_template[var0]

	assert(var1, "pg.backyard_theme_template>>id" .. var0)

	return table.contains(var1.ids, arg0.id)
end

function var0.isLock(arg0, arg1)
	return arg0:inTheme() and arg1 < arg0:getDeblocking()
end

function var0.isPaper(arg0)
	local var0 = arg0:getConfig("type")

	return var0 == 4 or var0 == 1
end

function var0.GetThemeName(arg0)
	local var0 = arg0:getConfig("themeId")
	local var1 = pg.backyard_theme_template[var0]

	if var1 then
		return var1.name
	end

	return ""
end

function var0.inTime(arg0)
	local var0 = arg0:getConfig("time")

	return pg.TimeMgr.GetInstance():inTime(var0)
end

function var0.isTimeLimit(arg0)
	local var0 = arg0:getConfig("time")

	return var0 and type(var0) == "table"
end

function var0.isRecordTime(arg0)
	return arg0:getConfig("is_get_time_note") == 1
end

function var0.isDisCount(arg0)
	return (arg0:getConfig("discount") or 0) > 0 and pg.TimeMgr.GetInstance():inTime(arg0:getConfig("discount_time"))
end

function var0.sortSizeFunc(arg0)
	local var0 = arg0:getConfig("size")

	return (var0[1] or 0) * (var0[2] or 0)
end

function var0.getPrice(arg0, arg1)
	local var0 = (100 - (arg0:isDisCount() and arg0:getConfig("discount") or 0)) / 100
	local var1 = arg1 == 4 and arg0:getConfig("gem_price") or arg1 == 6 and arg0:getConfig("dorm_icon_price")

	if var1 then
		local var2 = math.floor(var1 * var0)

		return var1 > 0 and var2 == 0 and 1 or var2
	end
end

function var0.canPurchaseByGem(arg0)
	local var0 = arg0:getPrice(4)

	return var0 and var0 ~= 0
end

function var0.canPurchaseByDormMoeny(arg0)
	local var0 = arg0:getPrice(6)

	return var0 and var0 ~= 0
end

function var0.getSortCurrency(arg0)
	local var0 = 0

	if arg0:canPurchaseByGem() then
		var0 = var0 + 2
	elseif arg0:canPurchaseByDormMoeny() then
		var0 = var0 + 1
	end

	return var0
end

function var0.sortPriceFunc(arg0)
	local var0 = arg0:getConfig("gem_price") or 0
	local var1 = arg0:getConfig("dorm_icon_price") or 0

	if var0 > 0 then
		return var0 + 1000000
	else
		return var1
	end
end

function var0.isMatchSearchKey(arg0, arg1)
	if arg1 == "" or not arg1 then
		return true
	end

	local var0 = arg0:getConfig("name")
	local var1 = arg0:getConfig("describe")

	arg1 = string.lower(arg1)

	local var2 = string.lower(var0)
	local var3 = string.lower(var1)

	if string.find(var2, arg1) or string.find(var2, arg1) then
		return true
	end

	return false
end

function var0.IsShopType(arg0)
	return arg0:bindShopConfigTable()[arg0.configId] ~= nil
end

return var0
