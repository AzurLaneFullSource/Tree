local var0_0 = class("IslandTechBelong")

var0_0.CENTRE = 1
var0_0.GATHER = 2
var0_0.PLANT = 3
var0_0.FEED = 4
var0_0.COOK = 5
var0_0.MECHINE = 6
var0_0.Fields = {
	[var0_0.CENTRE] = "centre",
	[var0_0.GATHER] = "gather",
	[var0_0.COOK] = "cook",
	[var0_0.FEED] = "feed",
	[var0_0.PLANT] = "plant",
	[var0_0.MECHINE] = "mechine"
}
var0_0.Names = {
	[var0_0.CENTRE] = i18n("island_tech_type_1"),
	[var0_0.GATHER] = i18n("island_ship_attrName_2"),
	[var0_0.COOK] = i18n("island_ship_attrName_4"),
	[var0_0.FEED] = i18n("island_ship_attrName_3"),
	[var0_0.PLANT] = i18n("island_ship_attrName_1"),
	[var0_0.MECHINE] = i18n("island_ship_attrName_6")
}
var0_0.SPECIAL_SHOW_TYPE = var0_0.CENTRE
var0_0.COMMON_SHOW_TYPES = {
	var0_0.GATHER,
	var0_0.PLANT,
	var0_0.FEED,
	var0_0.COOK,
	var0_0.MECHINE
}

return var0_0
