local var0 = class("WorldPlace")
local var1 = {
	i18n1("碧蓝"),
	i18n1("铁血"),
	i18n1("塞壬")
}
local var2 = pg.world_collection_place_template

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.number = arg1.number or 0
	arg0.unlock = false
	arg0.config = var2[arg0.configId]

	assert(arg0.config)
end

function var0.setUnlock(arg0, arg1)
	arg0.unlock = arg1
end

function var0.isUnlock(arg0)
	return arg0.unlock
end

function var0.getNumber(arg0)
	return arg0.number
end

function var0.getDesc(arg0)
	if arg0:isUnlock() then
		return arg0.config.description_known
	else
		return arg0.config.description_unknown
	end
end

function var0.getCamp(arg0)
	return var1[tonumber(arg0.config.type)]
end

function var0.getName(arg0)
	if arg0:isUnlock() then
		return arg0.config.name
	else
		return arg0.config.name_unknown
	end
end

function var0.getIconPath(arg0)
	if arg0:isUnlock() then
		return "shipYardIcon/abeikelongbi"
	else
		return "shipYardIcon/unknown"
	end
end

function var0.getFullViewImg(arg0)
	return "levelmap/map_1"
end

return var0
