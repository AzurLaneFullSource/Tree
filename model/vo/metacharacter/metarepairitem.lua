local var0_0 = class("MetaRepairItem", import("..BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.ship_meta_repair
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.itemId = arg0_2:getConfig("item_id")
	arg0_2.totalCnt = arg0_2:getConfig("item_num")
	arg0_2.repairExp = arg0_2:getConfig("repair_exp")

	local var0_2 = arg0_2:getConfig("effect_attr")

	arg0_2.addition = {
		attr = var0_2[1],
		value = var0_2[2]
	}
end

function var0_0.getItemId(arg0_3)
	return arg0_3.itemId
end

function var0_0.getTotalCnt(arg0_4)
	return arg0_4.totalCnt or 0
end

function var0_0.getRepairExp(arg0_5)
	return arg0_5.repairExp
end

function var0_0.getAdditionValue(arg0_6)
	return arg0_6.addition.value
end

return var0_0
