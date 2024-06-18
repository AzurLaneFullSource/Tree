local var0_0 = class("Furniture", import("..BaseVO"))

var0_0.TYPE_WALLPAPER = 1
var0_0.TYPE_FURNITURE = 2
var0_0.TYPE_DECORATE = 3
var0_0.TYPE_FLOORPAPER = 4
var0_0.TYPE_MAT = 5
var0_0.TYPE_WALL = 6
var0_0.TYPE_COLLECTION = 7
var0_0.TYPE_STAGE = 8
var0_0.TYPE_ARCH = 9
var0_0.TYPE_WALL_MAT = 10
var0_0.TYPE_MOVEABLE = 11
var0_0.TYPE_TRANSPORT = 12
var0_0.TYPE_RANDOM_CONTROLLER = 13
var0_0.TYPE_FOLLOWER = 14
var0_0.TYPE_LUTE = 15
var0_0.TYPE_RANDOM_SLOT = 16
var0_0.INDEX_TO_COMFORTABLE_TYPE = {
	var0_0.TYPE_WALLPAPER,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_DECORATE,
	var0_0.TYPE_FLOORPAPER,
	var0_0.TYPE_MAT,
	var0_0.TYPE_WALL,
	var0_0.TYPE_COLLECTION,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_WALL,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_FURNITURE,
	var0_0.TYPE_FURNITURE
}
var0_0.INDEX_TO_SHOP_TYPE = {
	{
		var0_0.TYPE_WALLPAPER
	},
	{
		var0_0.TYPE_FLOORPAPER
	},
	{
		var0_0.TYPE_FURNITURE,
		var0_0.TYPE_MAT,
		var0_0.TYPE_COLLECTION,
		var0_0.TYPE_STAGE,
		var0_0.TYPE_ARCH,
		var0_0.TYPE_MOVEABLE,
		var0_0.TYPE_TRANSPORT,
		var0_0.TYPE_RANDOM_CONTROLLER,
		var0_0.TYPE_FOLLOWER,
		var0_0.TYPE_LUTE,
		var0_0.TYPE_RANDOM_SLOT
	},
	{},
	{
		var0_0.TYPE_DECORATE
	},
	{
		var0_0.TYPE_WALL,
		var0_0.TYPE_WALL_MAT
	}
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = tonumber(arg1_1.id)
	arg0_1.configId = arg1_1.configId or tonumber(arg1_1.id)
	arg0_1.count = arg1_1.count or 0
	arg0_1.date = arg1_1.get_time or arg1_1.date or 0
	arg0_1.newFlag = false
end

function var0_0.MarkNew(arg0_2)
	arg0_2.newFlag = true
end

function var0_0.ClearNewFlag(arg0_3)
	arg0_3.newFlag = false
end

function var0_0.getDate(arg0_4)
	if arg0_4.date > 0 then
		return pg.TimeMgr.GetInstance():STimeDescS(arg0_4.date, "%Y/%m/%d")
	end
end

function var0_0.GetOwnCnt(arg0_5)
	return arg0_5.count
end

function var0_0.setCount(arg0_6, arg1_6)
	arg0_6.count = arg1_6
end

function var0_0.isNotForSale(arg0_7)
	return arg0_7:getConfig("not_for_sale") == 1
end

function var0_0.isForActivity(arg0_8)
	return arg0_8:getConfig("not_for_sale") == 2
end

function var0_0.addFurnitrueCount(arg0_9, arg1_9)
	arg0_9.count = arg0_9.count + arg1_9
end

function var0_0.canPurchase(arg0_10)
	return arg0_10.count < arg0_10:getConfig("count")
end

function var0_0.bindConfigTable(arg0_11)
	return pg.furniture_data_template
end

function var0_0.bindShopConfigTable(arg0_12)
	return pg.furniture_shop_template
end

function var0_0.isFurniture(arg0_13)
	return arg0_13:getConfig("type") ~= 0
end

function var0_0.IsNew(arg0_14)
	return arg0_14:getConfig("new") ~= 0
end

function var0_0.getConfig(arg0_15, arg1_15)
	local var0_15 = arg0_15:bindConfigTable()[arg0_15.configId]

	assert(var0_15, arg0_15.configId)

	if var0_15[arg1_15] then
		return var0_15[arg1_15]
	else
		local var1_15 = arg0_15:bindShopConfigTable()[arg0_15.configId]

		if var1_15 then
			return var1_15[arg1_15]
		end
	end
end

function var0_0.getTypeForComfortable(arg0_16)
	local var0_16 = arg0_16:getConfig("type")
	local var1_16 = var0_0.INDEX_TO_COMFORTABLE_TYPE[var0_16]

	return var1_16 and var1_16 or var0_0.TYPE_FURNITURE
end

function var0_0.getDeblocking(arg0_17)
	local var0_17 = arg0_17:getConfig("themeId")
	local var1_17 = pg.backyard_theme_template[var0_17]

	assert(var1_17, "pg.backyard_theme_template>>> id" .. var0_17)

	return var1_17.deblocking
end

function var0_0.inTheme(arg0_18)
	local var0_18 = arg0_18:getConfig("themeId")

	if var0_18 == 0 then
		return false
	end

	local var1_18 = pg.backyard_theme_template[var0_18]

	assert(var1_18, "pg.backyard_theme_template>>id" .. var0_18)

	return table.contains(var1_18.ids, arg0_18.id)
end

function var0_0.isLock(arg0_19, arg1_19)
	return arg0_19:inTheme() and arg1_19 < arg0_19:getDeblocking()
end

function var0_0.isPaper(arg0_20)
	local var0_20 = arg0_20:getConfig("type")

	return var0_20 == 4 or var0_20 == 1
end

function var0_0.GetThemeName(arg0_21)
	local var0_21 = arg0_21:getConfig("themeId")
	local var1_21 = pg.backyard_theme_template[var0_21]

	if var1_21 then
		return var1_21.name
	end

	return ""
end

function var0_0.inTime(arg0_22)
	local var0_22 = arg0_22:getConfig("time")

	return pg.TimeMgr.GetInstance():inTime(var0_22)
end

function var0_0.isTimeLimit(arg0_23)
	local var0_23 = arg0_23:getConfig("time")

	return var0_23 and type(var0_23) == "table"
end

function var0_0.isRecordTime(arg0_24)
	return arg0_24:getConfig("is_get_time_note") == 1
end

function var0_0.isDisCount(arg0_25)
	return (arg0_25:getConfig("discount") or 0) > 0 and pg.TimeMgr.GetInstance():inTime(arg0_25:getConfig("discount_time"))
end

function var0_0.sortSizeFunc(arg0_26)
	local var0_26 = arg0_26:getConfig("size")

	return (var0_26[1] or 0) * (var0_26[2] or 0)
end

function var0_0.getPrice(arg0_27, arg1_27)
	local var0_27 = (100 - (arg0_27:isDisCount() and arg0_27:getConfig("discount") or 0)) / 100
	local var1_27 = arg1_27 == 4 and arg0_27:getConfig("gem_price") or arg1_27 == 6 and arg0_27:getConfig("dorm_icon_price")

	if var1_27 then
		local var2_27 = math.floor(var1_27 * var0_27)

		return var1_27 > 0 and var2_27 == 0 and 1 or var2_27
	end
end

function var0_0.canPurchaseByGem(arg0_28)
	local var0_28 = arg0_28:getPrice(4)

	return var0_28 and var0_28 ~= 0
end

function var0_0.canPurchaseByDormMoeny(arg0_29)
	local var0_29 = arg0_29:getPrice(6)

	return var0_29 and var0_29 ~= 0
end

function var0_0.getSortCurrency(arg0_30)
	local var0_30 = 0

	if arg0_30:canPurchaseByGem() then
		var0_30 = var0_30 + 2
	elseif arg0_30:canPurchaseByDormMoeny() then
		var0_30 = var0_30 + 1
	end

	return var0_30
end

function var0_0.sortPriceFunc(arg0_31)
	local var0_31 = arg0_31:getConfig("gem_price") or 0
	local var1_31 = arg0_31:getConfig("dorm_icon_price") or 0

	if var0_31 > 0 then
		return var0_31 + 1000000
	else
		return var1_31
	end
end

function var0_0.isMatchSearchKey(arg0_32, arg1_32)
	if arg1_32 == "" or not arg1_32 then
		return true
	end

	local var0_32 = arg0_32:getConfig("name")
	local var1_32 = arg0_32:getConfig("describe")

	arg1_32 = string.lower(arg1_32)

	local var2_32 = string.lower(var0_32)
	local var3_32 = string.lower(var1_32)

	if string.find(var2_32, arg1_32) or string.find(var2_32, arg1_32) then
		return true
	end

	return false
end

function var0_0.IsShopType(arg0_33)
	return arg0_33:bindShopConfigTable()[arg0_33.configId] ~= nil
end

return var0_0
