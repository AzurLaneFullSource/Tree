local var0 = class("Dorm3dFurniture", import("model.vo.BaseVO"))

var0.TYPE = {
	DECORATION = 3,
	FLOOR = 2,
	COUCH = 5,
	BED = 4,
	WALLPAPER = 1,
	TABLE = 6
}
var0.TYPE2NAME = {
	"dorm3d_furnitrue_type_wallpaper",
	"dorm3d_furnitrue_type_floor",
	"dorm3d_furnitrue_type_decoration",
	"dorm3d_furnitrue_type_bed",
	"dorm3d_furnitrue_type_couch",
	"dorm3d_furnitrue_type_table"
}

function var0.bindConfigTable(arg0)
	return pg.dorm3d_furniture_template
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.slotId = arg0.slotId or 0
end

function var0.GetSlotID(arg0)
	return arg0.slotId
end

function var0.SetSlotID(arg0, arg1)
	arg0.slotId = arg1
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.GetTargetSlots(arg0)
	return arg0:getConfig("target_slots")
end

function var0.GetShipGroupId(arg0)
	return arg0:getConfig("char_id")
end

function var0.GetIcon(arg0)
	return arg0:getConfig("icon")
end

function var0.GetModel(arg0)
	return arg0:getConfig("model")
end

function var0.GetAcesses(arg0)
	local var0 = arg0:getConfig("acesses")

	if var0 == nil or var0 == "" then
		return {}
	end

	return var0
end

return var0
