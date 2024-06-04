local var0 = class("ClassResourceField", import(".BaseResourceField"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	local var0 = arg0:bindConfigTable()

	table.insert(arg0.attrs, ResourceFieldAttr.New(var0, i18n("class_attr_store"), "stock"))
	table.insert(arg0.attrs, ResourceFieldAttr.New(var0, i18n("class_attr_proficiency"), "store"))
	table.insert(arg0.attrs, ResourceFieldPercentAttr.New(var0, i18n("class_attr_getproficiency"), "proficency_get_percent", 1))
	table.insert(arg0.attrs, ResourceFieldProductAttr.New(var0, i18n("class_attr_costproficiency"), "proficency_cost_per_min", 60))
end

function var0.GetKeyWord(arg0)
	return "class"
end

function var0.bindConfigTable(arg0)
	return pg.class_upgrade_template
end

function var0.GetUpgradeType(arg0)
	return 20
end

function var0.GetResourceType(arg0)
	return arg0:getConfig("item_id")
end

function var0.GetMaxProficiency(arg0)
	return arg0:getConfig("store")
end

function var0.GetTranValuePreHour(arg0)
	return arg0:getConfig("proficency_cost_per_min") * 60
end

function var0.GetTarget(arg0)
	local var0 = arg0:GetResourceType()
	local var1 = Item.getConfigData(var0).usage_arg

	return tonumber(var1)
end

function var0.GetExp2ProficiencyRatio(arg0)
	return arg0:getConfig("proficency_get_percent")
end

function var0.GetDesc(arg0)
	return i18n("naval_academy_res_desc_class")
end

function var0.GetName(arg0)
	return i18n("school_title_dajiangtang")
end

function var0.getHourProduct(arg0)
	return 0
end

function var0.GetPlayerRes(arg0)
	return getProxy(PlayerProxy):getRawData().expField
end

function var0.HasRes(arg0)
	return arg0:GetPlayerRes() >= arg0:GetTarget()
end

function var0.GetGenResCnt(arg0)
	local var0 = arg0:GetTarget()
	local var1 = getProxy(PlayerProxy):getData():getResource(PlayerConst.ResClassField)

	return (math.floor(var1 / var0))
end

function var0.GetCanGetResCnt(arg0)
	local var0 = arg0:GetGenResCnt()
	local var1 = arg0:GetResourceType()
	local var2 = Item.getConfigData(var1).max_num - getProxy(BagProxy):getItemCountById(var1)

	return (math.min(var0, var2))
end

function var0.CanGetRes(arg0)
	if arg0:GetCanGetResCnt() <= 0 then
		return false
	end

	return true
end

return var0
