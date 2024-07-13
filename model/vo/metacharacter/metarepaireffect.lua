local var0_0 = class("MetaRepairEffect", import("..BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.ship_meta_repair_effect
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.progress = arg1_2.progress
	arg0_2.attrs = {}

	for iter0_2, iter1_2 in ipairs(arg0_2:getConfig("effect_attr")) do
		arg0_2.attrs[iter1_2[1]] = iter1_2[2]
	end

	arg0_2.words = arg0_2:getConfig("effect_dialog")
	arg0_2.descs = string.split(arg0_2:getConfig("effect_desc"), "|")
	arg0_2.descs = ""
end

function var0_0.getAttrAdditionList(arg0_3)
	return arg0_3:getConfig("effect_attr")
end

function var0_0.getAttrAddition(arg0_4, arg1_4)
	return arg0_4.attrs[arg1_4] or 0
end

function var0_0.getDescs(arg0_5)
	return arg0_5.descs
end

function var0_0.getWords(arg0_6)
	return arg0_6.words
end

return var0_0
