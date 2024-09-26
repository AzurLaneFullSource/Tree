local var0_0 = class("Dorm3dFurniture", import("model.vo.BaseVO"))

var0_0.TYPE = {
	DECORATION = 3,
	FLOOR = 2,
	COUCH = 5,
	BED = 4,
	WALLPAPER = 1,
	TABLE = 6
}
var0_0.TYPE2NAME = {
	"dorm3d_furnitrue_type_wallpaper",
	"dorm3d_furnitrue_type_floor",
	"dorm3d_furnitrue_type_decoration",
	"dorm3d_furnitrue_type_bed",
	"dorm3d_furnitrue_type_couch",
	"dorm3d_furnitrue_type_table"
}

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_furniture_template
end

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2)

	arg0_2.slotId = arg0_2.slotId or 0
end

function var0_0.GetSlotID(arg0_3)
	return arg0_3.slotId
end

function var0_0.SetSlotID(arg0_4, arg1_4)
	arg0_4.slotId = arg1_4
end

function var0_0.GetName(arg0_5)
	return arg0_5:getConfig("name")
end

function var0_0.GetType(arg0_6)
	return arg0_6:getConfig("type")
end

function var0_0.GetRarity(arg0_7)
	return arg0_7:getConfig("rarity")
end

function var0_0.GetTargetSlots(arg0_8)
	return arg0_8:getConfig("target_slots")
end

function var0_0.GetIcon(arg0_9)
	return arg0_9:getConfig("icon")
end

function var0_0.GetModel(arg0_10)
	return arg0_10:getConfig("model")
end

function var0_0.GetAcesses(arg0_11)
	local var0_11 = arg0_11:getConfig("acesses")

	if var0_11 == nil or var0_11 == "" then
		return {}
	end

	return var0_11
end

function var0_0.GetShopID(arg0_12)
	local var0_12 = arg0_12:getConfig("shop_id")
	local var1_12 = getProxy(ApartmentProxy):GetFurnitureShopCount(arg0_12:GetConfigID())

	return var0_12[1]
end

function var0_0.IsValuable(arg0_13)
	return arg0_13:getConfig("is_exclusive") == 1
end

function var0_0.NeedViewTip(arg0_14)
	local var0_14 = arg0_14 and {
		getProxy(ApartmentProxy):getRoom(arg0_14)
	} or underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var0_14, function(arg0_15)
		return underscore.any(arg0_15:GetFurnitures(), function(arg0_16)
			return Dorm3dFurniture.GetViewedFlag(arg0_16:GetConfigID()) == 0
		end)
	end)
end

function var0_0.GetViewedFlag(arg0_17)
	local var0_17 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_17 .. "_dorm3dFurnitureViewed_" .. arg0_17, 0)
end

function var0_0.SetViewedFlag(arg0_18)
	if var0_0.GetViewedFlag(arg0_18) > 0 then
		return
	end

	local var0_18 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_18 .. "_dorm3dFurnitureViewed_" .. arg0_18, 1)

	return true
end

return var0_0
