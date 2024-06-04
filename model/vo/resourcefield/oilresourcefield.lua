local var0 = class("OilResourceField", import(".BaseResourceField"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	local var0 = arg0:bindConfigTable()

	table.insert(arg0.attrs, ResourceFieldAttr.New(var0, i18n("class_attr_store"), "store"))
	table.insert(arg0.attrs, ResourceFieldLevelProductAttr.New(var0, i18n("class_label_oilfield"), "production", 1))
end

function var0.GetKeyWord(arg0)
	return "canteen"
end

function var0.bindConfigTable(arg0)
	return pg.oilfield_template
end

function var0.GetUpgradeType(arg0)
	return 8
end

function var0.GetResourceType(arg0)
	return PlayerConst.ResOil
end

function var0.getHourProduct(arg0)
	return arg0:getConfig("hour_time") * arg0:getConfig("production")
end

function var0.GetName(arg0)
	return i18n("school_title_shitang")
end

function var0.GetDesc(arg0)
	return i18n("naval_academy_res_desc_cateen")
end

function var0.GetPlayerRes(arg0)
	return getProxy(PlayerProxy):getRawData().oilField
end

return var0
