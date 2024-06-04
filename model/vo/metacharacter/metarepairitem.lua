local var0 = class("MetaRepairItem", import("..BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.ship_meta_repair
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.itemId = arg0:getConfig("item_id")
	arg0.totalCnt = arg0:getConfig("item_num")
	arg0.repairExp = arg0:getConfig("repair_exp")

	local var0 = arg0:getConfig("effect_attr")

	arg0.addition = {
		attr = var0[1],
		value = var0[2]
	}
end

function var0.getItemId(arg0)
	return arg0.itemId
end

function var0.getTotalCnt(arg0)
	return arg0.totalCnt or 0
end

function var0.getRepairExp(arg0)
	return arg0.repairExp
end

function var0.getAdditionValue(arg0)
	return arg0.addition.value
end

return var0
