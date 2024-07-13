local var0_0 = class("WorldItem", import(".....model.vo.Item"))

var0_0.UsageBuff = "usage_world_buff"
var0_0.UsageDrop = "usage_drop"
var0_0.UsageLoot = "usage_undefined"
var0_0.UsageHPRegenerate = "usage_world_healing"
var0_0.UsageHPRegenerateValue = "usage_world_healing_value"
var0_0.UsageRecoverAp = "usage_world_recoverAP"
var0_0.UsageWorldMap = "usage_world_map"
var0_0.UsageWorldItem = "usage_world_item"
var0_0.UsageWorldClean = "usage_world_clean"
var0_0.UsageWorldBuff = "usage_worldSLGbuff"
var0_0.UsageDropAppointed = "usage_drop_appointed"
var0_0.UsageWorldFlag = "usage_world_flag"
var0_0.MoneyId = 100
var0_0.PortMoneyId = 101

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.type = DROP_TYPE_WORLD_ITEM
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.count = arg1_1.count
end

function var0_0.bindConfigTable(arg0_2)
	return pg.world_item_data_template
end

function var0_0.getConfigTable(arg0_3)
	return BaseVO.getConfigTable(arg0_3)
end

function var0_0.getWorldItemType(arg0_4)
	return arg0_4:getConfig("usage")
end

function var0_0.getWorldItemOpenDisplay(arg0_5)
	return arg0_5:getConfig("open_box")
end

function var0_0.getItemQuota(arg0_6)
	return arg0_6:getConfig("usage_arg")[1]
end

function var0_0.getItemBuffID(arg0_7)
	return arg0_7:getConfig("usage_arg")[2]
end

function var0_0.getItemRegenerate(arg0_8)
	return arg0_8:getConfig("usage_arg")[2]
end

function var0_0.getItemStaminaRecover(arg0_9)
	return arg0_9:getConfig("usage_arg")[1]
end

function var0_0.getItemWorldBuff(arg0_10)
	local var0_10 = arg0_10:getConfig("usage_arg")

	return var0_10[1], var0_10[2]
end

function var0_0.getItemFlagKey(arg0_11)
	return arg0_11:getConfig("usage_arg")[1]
end

function var0_0.isDesignDrawing(arg0_12)
	return false
end

return var0_0
