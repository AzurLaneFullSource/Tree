local var0_0 = class("WorldPlace")
local var1_0 = {
	i18n1("碧蓝"),
	i18n1("铁血"),
	i18n1("塞壬")
}
local var2_0 = pg.world_collection_place_template

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.number = arg1_1.number or 0
	arg0_1.unlock = false
	arg0_1.config = var2_0[arg0_1.configId]

	assert(arg0_1.config)
end

function var0_0.setUnlock(arg0_2, arg1_2)
	arg0_2.unlock = arg1_2
end

function var0_0.isUnlock(arg0_3)
	return arg0_3.unlock
end

function var0_0.getNumber(arg0_4)
	return arg0_4.number
end

function var0_0.getDesc(arg0_5)
	if arg0_5:isUnlock() then
		return arg0_5.config.description_known
	else
		return arg0_5.config.description_unknown
	end
end

function var0_0.getCamp(arg0_6)
	return var1_0[tonumber(arg0_6.config.type)]
end

function var0_0.getName(arg0_7)
	if arg0_7:isUnlock() then
		return arg0_7.config.name
	else
		return arg0_7.config.name_unknown
	end
end

function var0_0.getIconPath(arg0_8)
	if arg0_8:isUnlock() then
		return "shipYardIcon/abeikelongbi"
	else
		return "shipYardIcon/unknown"
	end
end

function var0_0.getFullViewImg(arg0_9)
	return "levelmap/map_1"
end

return var0_0
