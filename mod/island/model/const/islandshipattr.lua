local var0_0 = class("IslandShipAttr")

var0_0.MANAGE_KEY = 5
var0_0.COLLECT_KEY = 2
var0_0.ATTRS = {
	"plant",
	"collect",
	"conserve",
	"cooking",
	"manage",
	"machinery"
}
var0_0.ATTRS_CH = {
	i18n("island_ship_attrName_1"),
	i18n("island_ship_attrName_2"),
	i18n("island_ship_attrName_3"),
	i18n("island_ship_attrName_4"),
	i18n("island_ship_attrName_5"),
	i18n("island_ship_attrName_6")
}
var0_0.ATTR_IMAGE = {
	{
		"SSS",
		"SS_"
	},
	{
		"SS",
		"SS_"
	},
	{
		"S",
		"S_"
	},
	{
		"A",
		"A_"
	},
	{
		"B",
		"B_"
	},
	{
		"C",
		"C_"
	},
	{
		"D",
		"D_"
	},
	{
		"E",
		"D_"
	}
}

function var0_0.ToChinese(arg0_1)
	local var0_1 = table.indexof(var0_0.ATTRS, arg0_1)

	return var0_0.ATTRS_CH[var0_1]
end

function var0_0.GetAtrrName(arg0_2)
	return var0_0.ATTRS[arg0_2]
end

function var0_0.Grade2Img(arg0_3)
	return var0_0.ATTR_IMAGE[arg0_3]
end

return var0_0
