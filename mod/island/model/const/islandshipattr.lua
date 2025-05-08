local var0_0 = class("IslandShipAttr")

var0_0.ATTRS = {
	"farming",
	"collect",
	"catch",
	"manufacture",
	"cooking"
}
var0_0.ATTRS_CH = {
	i18n1("农牧"),
	i18n1("收集"),
	i18n1("水产"),
	i18n1("手工"),
	i18n1("厨艺")
}

function var0_0.ToChinese(arg0_1)
	local var0_1 = table.indexof(var0_0.ATTRS, arg0_1)

	return var0_0.ATTRS_CH[var0_1]
end

return var0_0
