local var0_0 = class("IslandTechBelong")

var0_0.CENTRE = 1
var0_0.TECH = 2
var0_0.COOK = 3
var0_0.FEED = 4
var0_0.PLANT = 5
var0_0.MECHINE = 6
var0_0.Fields = {
	[var0_0.CENTRE] = "centre",
	[var0_0.TECH] = "tech",
	[var0_0.COOK] = "cook",
	[var0_0.FEED] = "feed",
	[var0_0.PLANT] = "plant",
	[var0_0.MECHINE] = "mechine"
}
var0_0.Names = {
	[var0_0.CENTRE] = i18n1("岛屿中枢"),
	[var0_0.TECH] = i18n1("科研"),
	[var0_0.COOK] = i18n1("烹调"),
	[var0_0.FEED] = i18n1("养护"),
	[var0_0.PLANT] = i18n1("种植"),
	[var0_0.MECHINE] = i18n1("机械")
}
var0_0.SPECIAL_SHOW_TYPE = var0_0.CENTRE
var0_0.COMMON_SHOW_TYPES = {
	var0_0.TECH,
	var0_0.COOK,
	var0_0.FEED,
	var0_0.PLANT,
	var0_0.MECHINE
}

return var0_0
