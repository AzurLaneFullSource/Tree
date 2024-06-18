local var0_0 = class("BackYardConst")

var0_0.MAX_FLOOR_CNT = 2
var0_0.SAME_ID_MODIFY_ID = 79000
var0_0.MAX_UPLOAD_THEME_CNT = 2
var0_0.THEME_TEMPLATE_TYPE_SHOP = 1
var0_0.THEME_TEMPLATE_TYPE_CUSTOM = 2
var0_0.THEME_TEMPLATE_TYPE_COLLECTION = 3
var0_0.THEME_TEMPLATE_USAGE_TYPE_SELF = 1
var0_0.THEME_TEMPLATE_USAGE_TYPE_OTHER = 2
var0_0.THEME_TEMPLATE_SHOP_REFRSH_CNT = 6
var0_0.MAX_COLLECTION_CNT = 30
var0_0.AUTO_REFRESH_THEME_TEMPLATE_TIME = 10
var0_0.MANUAL_REFRESH_THEME_TEMPLATE_TIME = 10
var0_0.DEBUG_THEME = true
var0_0.MAX_USER_THEME = 5
var0_0.DORM_UPDATE_TYPE_UPDATEFOOD = 2
var0_0.DORM_UPDATE_TYPE_SHIP = 4
var0_0.DORM_UPDATE_TYPE_NAME = 8
var0_0.DORM_UPDATE_TYPE_LEVEL = 16
var0_0.DORM_UPDATE_TYPE_FLOOR = 32
var0_0.DORM_UPDATE_TYPE_FURNITURE = 64
var0_0.DORM_UPDATE_TYPE_USEFOOD = 128
var0_0.DORM_UPDATE_TYPE_EXTENDFOOD = 256
var0_0.TIME_TYPE_ALL = 0
var0_0.TIME_TYPE_WEEK = 1
var0_0.TIME_TYPE_MONTH = 2
var0_0.TIME_TYPE_YEAR = 3
var0_0.MAX_MAP_SIZE = Vector2(23, 23)
var0_0.MAX_FEAST_MAP_SIZE = Vector2(25, 25)

function var0_0.ThemeSortIndex2ServerIndex(arg0_1, arg1_1)
	arg1_1 = defaultValue(arg1_1, true)
	arg0_1 = defaultValue(arg0_1, 1)

	if arg0_1 == 1 then
		return 5
	elseif arg0_1 == 2 and arg1_1 then
		return 1
	elseif arg0_1 == 2 and not arg1_1 then
		return 2
	elseif arg0_1 == 3 and arg1_1 then
		return 4
	elseif arg0_1 == 3 and not arg1_1 then
		return 3
	end
end

function var0_0.ServerIndex2ThemeSortIndex(arg0_2)
	if arg0_2 == 5 then
		return 1, true
	elseif arg0_2 == 4 then
		return 3, true
	elseif arg0_2 == 3 then
		return 3, false
	elseif arg0_2 == 2 then
		return 2, false
	elseif arg0_2 == 1 then
		return 2, true
	end
end

return var0_0
