local var0_0 = class("OilResourceField", import(".BaseResourceField"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg0_1:bindConfigTable()

	table.insert(arg0_1.attrs, ResourceFieldAttr.New(var0_1, i18n("class_attr_store"), "store"))
	table.insert(arg0_1.attrs, ResourceFieldLevelProductAttr.New(var0_1, i18n("class_label_oilfield"), "production", 1))
end

function var0_0.GetKeyWord(arg0_2)
	return "canteen"
end

function var0_0.bindConfigTable(arg0_3)
	return pg.oilfield_template
end

function var0_0.GetUpgradeType(arg0_4)
	return 8
end

function var0_0.GetResourceType(arg0_5)
	return PlayerConst.ResOil
end

function var0_0.getHourProduct(arg0_6)
	return arg0_6:getConfig("hour_time") * arg0_6:getConfig("production")
end

function var0_0.GetName(arg0_7)
	return i18n("school_title_shitang")
end

function var0_0.GetDesc(arg0_8)
	return i18n("naval_academy_res_desc_cateen")
end

function var0_0.GetPlayerRes(arg0_9)
	return getProxy(PlayerProxy):getRawData().oilField
end

return var0_0
