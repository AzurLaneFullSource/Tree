local var0_0 = class("ClassResourceField", import(".BaseResourceField"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg0_1:bindConfigTable()

	table.insert(arg0_1.attrs, ResourceFieldAttr.New(var0_1, i18n("class_attr_store"), "stock"))
	table.insert(arg0_1.attrs, ResourceFieldAttr.New(var0_1, i18n("class_attr_proficiency"), "store"))
	table.insert(arg0_1.attrs, ResourceFieldPercentAttr.New(var0_1, i18n("class_attr_getproficiency"), "proficency_get_percent", 1))
	table.insert(arg0_1.attrs, ResourceFieldProductAttr.New(var0_1, i18n("class_attr_costproficiency"), "proficency_cost_per_min", 60))
end

function var0_0.GetKeyWord(arg0_2)
	return "class"
end

function var0_0.bindConfigTable(arg0_3)
	return pg.class_upgrade_template
end

function var0_0.GetUpgradeType(arg0_4)
	return 20
end

function var0_0.GetResourceType(arg0_5)
	return arg0_5:getConfig("item_id")
end

function var0_0.GetMaxProficiency(arg0_6)
	return arg0_6:getConfig("store")
end

function var0_0.GetTranValuePreHour(arg0_7)
	return arg0_7:getConfig("proficency_cost_per_min") * 60
end

function var0_0.GetTarget(arg0_8)
	local var0_8 = arg0_8:GetResourceType()
	local var1_8 = Item.getConfigData(var0_8).usage_arg

	return tonumber(var1_8)
end

function var0_0.GetExp2ProficiencyRatio(arg0_9)
	return arg0_9:getConfig("proficency_get_percent")
end

function var0_0.GetDesc(arg0_10)
	return i18n("naval_academy_res_desc_class")
end

function var0_0.GetName(arg0_11)
	return i18n("school_title_dajiangtang")
end

function var0_0.getHourProduct(arg0_12)
	return 0
end

function var0_0.GetPlayerRes(arg0_13)
	return getProxy(PlayerProxy):getRawData().expField
end

function var0_0.HasRes(arg0_14)
	return arg0_14:GetPlayerRes() >= arg0_14:GetTarget()
end

function var0_0.GetGenResCnt(arg0_15)
	local var0_15 = arg0_15:GetTarget()
	local var1_15 = getProxy(PlayerProxy):getData():getResource(PlayerConst.ResClassField)

	return (math.floor(var1_15 / var0_15))
end

function var0_0.GetCanGetResCnt(arg0_16)
	local var0_16 = arg0_16:GetGenResCnt()
	local var1_16 = arg0_16:GetResourceType()
	local var2_16 = Item.getConfigData(var1_16).max_num - getProxy(BagProxy):getItemCountById(var1_16)

	return (math.min(var0_16, var2_16))
end

function var0_0.CanGetRes(arg0_17)
	if arg0_17:GetCanGetResCnt() <= 0 then
		return false
	end

	return true
end

return var0_0
