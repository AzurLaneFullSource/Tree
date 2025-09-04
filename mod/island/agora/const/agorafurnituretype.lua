local var0_0 = class("AgoraFurnitureType")

var0_0.FOUNDATION = 1
var0_0.BUILDING = 2
var0_0.FURNITURE = 3
var0_0.DECORAION = 4
var0_0.FLOOR = 5
var0_0.TILE = 6
var0_0.COLLECTION = 7
var0_0.TILE_NEW = 8

local var1_0 = {
	[var0_0.FOUNDATION] = i18n("island_agora_label_base"),
	[var0_0.BUILDING] = i18n("island_agora_label_building"),
	[var0_0.FURNITURE] = i18n("island_agora_label_furniture"),
	[var0_0.DECORAION] = i18n("island_agora_label_dec"),
	[var0_0.FLOOR] = i18n("island_agora_label_floor"),
	[var0_0.TILE] = i18n("island_agora_label_tile"),
	[var0_0.COLLECTION] = i18n("island_agora_label_collection"),
	[var0_0.TILE_NEW] = i18n("island_agora_label_tile")
}

function var0_0.Type2CN(arg0_1)
	return var1_0[arg0_1]
end

var0_0.PLACEMENT_TYPE = {
	var0_0.FOUNDATION,
	var0_0.BUILDING,
	var0_0.FURNITURE,
	var0_0.DECORAION,
	var0_0.TILE_NEW,
	var0_0.COLLECTION
}
var0_0.SORT_DEFAULT = 1
var0_0.SORT_RARITY = 2
var0_0.SORT_TIME = 3
var0_0.SORT_CAPACITY = 4
var0_0.SORT_LIST = {
	var0_0.SORT_DEFAULT,
	var0_0.SORT_RARITY,
	var0_0.SORT_TIME,
	var0_0.SORT_CAPACITY
}

local var2_0 = {
	[var0_0.SORT_DEFAULT] = i18n("island_agora_label_default"),
	[var0_0.SORT_RARITY] = i18n("island_agora_label_rarity"),
	[var0_0.SORT_TIME] = i18n("island_agora_label_gettime"),
	[var0_0.SORT_CAPACITY] = i18n("island_agora_label_capacity")
}

function var0_0.Sort2CN(arg0_2)
	return var2_0[arg0_2]
end

return var0_0
