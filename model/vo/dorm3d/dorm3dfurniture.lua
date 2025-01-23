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

function var0_0.GetTargetSlotID(arg0_9)
	local var0_9 = arg0_9:GetTargetSlots()[1]

	assert(var0_9, "Missing Target Slot Dorm3dFurniture ID: " .. arg0_9:GetConfigID())

	return var0_9
end

function var0_0.GetIcon(arg0_10)
	return arg0_10:getConfig("icon")
end

function var0_0.GetModel(arg0_11)
	return arg0_11:getConfig("model")
end

function var0_0.GetAcesses(arg0_12)
	local var0_12 = arg0_12:getConfig("acesses")

	if var0_12 == nil or var0_12 == "" then
		return {}
	end

	return var0_12
end

function var0_0.GetShopID(arg0_13)
	return arg0_13:getConfig("shop_id")[1] or 0
end

function var0_0.IsValuable(arg0_14)
	return arg0_14:getConfig("is_exclusive") == 1
end

function var0_0.IsSpecial(arg0_15)
	return arg0_15:getConfig("is_special") == 1
end

function var0_0.InShopTime(arg0_16)
	local var0_16 = arg0_16:GetShopID()

	if var0_16 == 0 then
		return true
	end

	local var1_16 = pg.shop_template[var0_16]

	return pg.TimeMgr.GetInstance():inTime(var1_16.time)
end

function var0_0.GetEndTime(arg0_17)
	local var0_17 = arg0_17:GetShopID()

	if var0_17 == 0 then
		return 0
	end

	local var1_17 = pg.shop_template[var0_17].time

	if var1_17 == "always" or var1_17 == "stop" then
		return 0
	end

	return (pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_17[2]))
end

function var0_0.NeedViewTip(arg0_18)
	local var0_18 = arg0_18 and {
		getProxy(ApartmentProxy):getRoom(arg0_18)
	} or underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var0_18, function(arg0_19)
		return underscore.any(arg0_19:GetFurnitures(), function(arg0_20)
			return Dorm3dFurniture.GetViewedFlag(arg0_20:GetConfigID()) == 0
		end)
	end)
end

function var0_0.GetViewedFlag(arg0_21)
	local var0_21 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_21 .. "_dorm3dFurnitureViewed_" .. arg0_21, 0)
end

function var0_0.SetViewedFlag(arg0_22)
	if var0_0.GetViewedFlag(arg0_22) > 0 then
		return
	end

	local var0_22 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_22 .. "_dorm3dFurnitureViewed_" .. arg0_22, 1)
	PlayerPrefs.Save()

	return true
end

function var0_0.IsTimelimitShopTip(arg0_23)
	local var0_23 = arg0_23 and {
		getProxy(ApartmentProxy):getRoom(arg0_23)
	} or underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var0_23, function(arg0_24)
		local var0_24 = arg0_24:GetFurnitures()
		local var1_24 = pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_24:GetConfigID()] or {}

		return _.any(var1_24, function(arg0_25)
			local var0_25 = Dorm3dFurniture.New({
				configId = arg0_25
			})

			return var0_25:GetEndTime() > 0 and var0_25:InShopTime() and not _.detect(var0_24, function(arg0_26)
				return arg0_26:GetConfigID() == arg0_25
			end)
		end)
	end)
end

function var0_0.RecordLastTimelimitShopFurniture()
	local var0_27 = getProxy(PlayerProxy):getRawData().id
	local var1_27 = PlayerPrefs.GetInt(var0_27 .. "_dorm3dTimelimitFurniture", 0)
	local var2_27 = var1_27
	local var3_27 = underscore.values(getProxy(ApartmentProxy).roomData)

	underscore.each(var3_27, function(arg0_28)
		local var0_28 = pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_28:GetConfigID()] or {}

		_.each(var0_28, function(arg0_29)
			local var0_29 = Dorm3dFurniture.New({
				configId = arg0_29
			})

			if var0_29:GetEndTime() > 0 and var0_29:InShopTime() then
				var2_27 = math.max(var2_27, arg0_29)
			end
		end)
	end)

	if var2_27 <= var1_27 then
		return
	end

	PlayerPrefs.SetInt(var0_27 .. "_dorm3dTimelimitFurniture", var2_27)
	PlayerPrefs.Save()
end

function var0_0.IsOnceTimelimitShopTip()
	local var0_30 = getProxy(PlayerProxy):getRawData().id
	local var1_30 = PlayerPrefs.GetInt(var0_30 .. "_dorm3dTimelimitFurniture", 0)
	local var2_30 = underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var2_30, function(arg0_31)
		local var0_31 = arg0_31:GetFurnitures()
		local var1_31 = pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_31:GetConfigID()] or {}

		return _.any(var1_31, function(arg0_32)
			if arg0_32 <= var1_30 then
				return
			end

			local var0_32 = Dorm3dFurniture.New({
				configId = arg0_32
			})

			return var0_32:GetEndTime() > 0 and var0_32:InShopTime() and not _.detect(var0_31, function(arg0_33)
				return arg0_33:GetConfigID() == arg0_32
			end)
		end)
	end)
end

return var0_0
