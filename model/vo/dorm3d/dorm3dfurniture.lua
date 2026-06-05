local var0_0 = class("Dorm3dFurniture", import("model.vo.BaseVO"))

var0_0.TYPE = {
	SPECIAL = 99,
	FLOOR = 2,
	DECORATION = 3,
	BED = 4,
	COUCH = 5,
	WALLPAPER = 1,
	TABLE = 6
}
var0_0.TYPE2NAME = {
	"dorm3d_furnitrue_type_wallpaper",
	"dorm3d_furnitrue_type_floor",
	"dorm3d_furnitrue_type_decoration",
	"dorm3d_furnitrue_type_bed",
	"dorm3d_furnitrue_type_couch",
	"dorm3d_furnitrue_type_table",
	[99] = "dorm3d_furnitrue_type_special"
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

	local var1_17 = pg.shop_template[var0_17]

	assert(var1_17, "Missing shopCfg " .. (var0_17 or "NIL"))

	local var2_17 = var1_17.time

	if var2_17 == "always" or var2_17 == "stop" then
		return 0
	end

	return (pg.TimeMgr.GetInstance():parseTimeFromConfig(var2_17[2]))
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

function var0_0.NeedViewTipByFurnitureId(arg0_21)
	local function var0_21(arg0_22)
		local var0_22 = pg.dorm3d_furniture_template[arg0_22].room_id
		local var1_22 = getProxy(ApartmentProxy):getRoom(var0_22)

		return var1_22 and var1_22:HasFurniture(arg0_22)
	end

	return Dorm3dFurniture.GetViewedFlag(arg0_21) == 0 and not var0_21(arg0_21)
end

function var0_0.GetViewedFlag(arg0_23)
	local var0_23 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_23 .. "_dorm3dFurnitureViewed_" .. arg0_23, 0)
end

function var0_0.SetViewedFlag(arg0_24)
	if var0_0.GetViewedFlag(arg0_24) > 0 then
		return
	end

	local var0_24 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_24 .. "_dorm3dFurnitureViewed_" .. arg0_24, 1)
	PlayerPrefs.Save()

	return true
end

function var0_0.IsTimelimitShopTip(arg0_25)
	local var0_25 = arg0_25 and {
		getProxy(ApartmentProxy):getRoom(arg0_25)
	} or underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var0_25, function(arg0_26)
		local var0_26 = pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_26:GetConfigID()] or {}

		return _.any(var0_26, function(arg0_27)
			local var0_27 = Dorm3dFurniture.New({
				configId = arg0_27
			})

			return var0_27:GetEndTime() > 0 and var0_27:InShopTime() and Dorm3dFurniture.GetViewedFlag(arg0_27) == 0
		end)
	end)
end

function var0_0.RecordLastTimelimitShopFurniture()
	local var0_28 = getProxy(PlayerProxy):getRawData().id
	local var1_28 = PlayerPrefs.GetInt(var0_28 .. "_dorm3dTimelimitFurniture", 0)
	local var2_28 = var1_28
	local var3_28 = underscore.values(getProxy(ApartmentProxy).roomData)

	underscore.each(var3_28, function(arg0_29)
		local var0_29 = pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_29:GetConfigID()] or {}

		_.each(var0_29, function(arg0_30)
			local var0_30 = Dorm3dFurniture.New({
				configId = arg0_30
			})

			if var0_30:GetEndTime() > 0 and var0_30:InShopTime() then
				var2_28 = math.max(var2_28, arg0_30)
			end
		end)
	end)

	if var2_28 <= var1_28 then
		return
	end

	PlayerPrefs.SetInt(var0_28 .. "_dorm3dTimelimitFurniture", var2_28)
	PlayerPrefs.Save()
end

function var0_0.IsOnceTimelimitShopTip()
	local var0_31 = getProxy(PlayerProxy):getRawData().id
	local var1_31 = PlayerPrefs.GetInt(var0_31 .. "_dorm3dTimelimitFurniture", 0)
	local var2_31 = underscore.values(getProxy(ApartmentProxy).roomData)

	return underscore.any(var2_31, function(arg0_32)
		local var0_32 = arg0_32:GetFurnitures()
		local var1_32 = pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_32:GetConfigID()] or {}

		return _.any(var1_32, function(arg0_33)
			if arg0_33 <= var1_31 then
				return
			end

			local var0_33 = Dorm3dFurniture.New({
				configId = arg0_33
			})

			return var0_33:GetEndTime() > 0 and var0_33:InShopTime() and not _.detect(var0_32, function(arg0_34)
				return arg0_34:GetConfigID() == arg0_33
			end)
		end)
	end)
end

return var0_0
