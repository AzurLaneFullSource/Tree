local var0 = class("MetaRepairEffect", import("..BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.ship_meta_repair_effect
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.progress = arg1.progress
	arg0.attrs = {}

	for iter0, iter1 in ipairs(arg0:getConfig("effect_attr")) do
		arg0.attrs[iter1[1]] = iter1[2]
	end

	arg0.words = arg0:getConfig("effect_dialog")
	arg0.descs = string.split(arg0:getConfig("effect_desc"), "|")
	arg0.descs = ""
end

function var0.getAttrAdditionList(arg0)
	return arg0:getConfig("effect_attr")
end

function var0.getAttrAddition(arg0, arg1)
	return arg0.attrs[arg1] or 0
end

function var0.getDescs(arg0)
	return arg0.descs
end

function var0.getWords(arg0)
	return arg0.words
end

return var0
