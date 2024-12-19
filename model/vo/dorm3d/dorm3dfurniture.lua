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
	return arg0_12:getConfig("shop_id")[1] or 0
end

function var0_0.IsValuable(arg0_13)
	return arg0_13:getConfig("is_exclusive") == 1
end

function var0_0.IsSpecial(arg0_14)
	return arg0_14:getConfig("is_special") == 1
end

function var0_0.InShopTime(arg0_15)
	local var0_15 = arg0_15:GetShopID()

	if var0_15 == 0 then
		return true
	end

	local var1_15 = pg.shop_template[var0_15]

	return pg.TimeMgr.GetInstance():inTime(var1_15.time)
end

function var0_0.GetEndTime(arg0_16)
	local var0_16 = arg0_16:GetShopID()

	if var0_16 == 0 then
		return 0
	end

	local var1_16 = pg.shop_template[var0_16].time

	if var1_16 == "always" or var1_16 == "stop" then
		return 0
	end

	return (pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_16[2]))
end

function var0_0.NeedViewTip(arg0_17)
	local var0_17 = arg0_17 and {
		getProxy(ApartmentProxy):getRoom(arg0_17)
	} or underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var0_17, function(arg0_18)
		return underscore.any(arg0_18:GetFurnitures(), function(arg0_19)
			return Dorm3dFurniture.GetViewedFlag(arg0_19:GetConfigID()) == 0
		end)
	end)
end

function var0_0.GetViewedFlag(arg0_20)
	local var0_20 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_20 .. "_dorm3dFurnitureViewed_" .. arg0_20, 0)
end

function var0_0.SetViewedFlag(arg0_21)
	if var0_0.GetViewedFlag(arg0_21) > 0 then
		return
	end

	local var0_21 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_21 .. "_dorm3dFurnitureViewed_" .. arg0_21, 1)

	return true
end

function var0_0.IsTimelimitShopTip(arg0_22)
	local var0_22 = arg0_22 and {
		getProxy(ApartmentProxy):getRoom(arg0_22)
	} or underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var0_22, function(arg0_23)
		local var0_23 = arg0_23:GetFurnitures()
		local var1_23 = pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_23:GetConfigID()] or {}

		return _.any(var1_23, function(arg0_24)
			local var0_24 = Dorm3dFurniture.New({
				configId = arg0_24
			})

			return var0_24:GetEndTime() > 0 and var0_24:InShopTime() and not _.detect(var0_23, function(arg0_25)
				return arg0_25:GetConfigID() == arg0_24
			end)
		end)
	end)
end

return var0_0
