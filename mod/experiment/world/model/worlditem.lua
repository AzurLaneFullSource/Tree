local var0 = class("WorldItem", import(".....model.vo.Item"))

var0.UsageBuff = "usage_world_buff"
var0.UsageDrop = "usage_drop"
var0.UsageLoot = "usage_undefined"
var0.UsageHPRegenerate = "usage_world_healing"
var0.UsageHPRegenerateValue = "usage_world_healing_value"
var0.UsageRecoverAp = "usage_world_recoverAP"
var0.UsageWorldMap = "usage_world_map"
var0.UsageWorldItem = "usage_world_item"
var0.UsageWorldClean = "usage_world_clean"
var0.UsageWorldBuff = "usage_worldSLGbuff"
var0.UsageDropAppointed = "usage_drop_appointed"
var0.UsageWorldFlag = "usage_world_flag"
var0.MoneyId = 100
var0.PortMoneyId = 101

function var0.Ctor(arg0, arg1)
	arg0.type = DROP_TYPE_WORLD_ITEM
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.count = arg1.count
end

function var0.bindConfigTable(arg0)
	return pg.world_item_data_template
end

function var0.getConfigTable(arg0)
	return BaseVO.getConfigTable(arg0)
end

function var0.getWorldItemType(arg0)
	return arg0:getConfig("usage")
end

function var0.getWorldItemOpenDisplay(arg0)
	return arg0:getConfig("open_box")
end

function var0.getItemQuota(arg0)
	return arg0:getConfig("usage_arg")[1]
end

function var0.getItemBuffID(arg0)
	return arg0:getConfig("usage_arg")[2]
end

function var0.getItemRegenerate(arg0)
	return arg0:getConfig("usage_arg")[2]
end

function var0.getItemStaminaRecover(arg0)
	return arg0:getConfig("usage_arg")[1]
end

function var0.getItemWorldBuff(arg0)
	local var0 = arg0:getConfig("usage_arg")

	return var0[1], var0[2]
end

function var0.getItemFlagKey(arg0)
	return arg0:getConfig("usage_arg")[1]
end

function var0.isDesignDrawing(arg0)
	return false
end

return var0
