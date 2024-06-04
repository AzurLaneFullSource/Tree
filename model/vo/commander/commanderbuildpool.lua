local var0 = class("CommanderBuildPool", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
end

function var0.bindConfigTable(arg0)
	return pg.commander_data_create_material
end

function var0.getName(arg0)
	local var0 = arg0:getConfig("use_item")
	local var1 = Item.New({
		id = var0
	})

	return arg0:getConfig("name") or var1:getConfig("name") or ""
end

function var0.getConsume(arg0)
	local var0 = arg0:getConfig("use_item")
	local var1 = arg0:getConfig("number_1")

	return {
		{
			2,
			var0,
			var1
		}
	}
end

function var0.getConsumeDesc(arg0)
	local var0 = arg0:getConfig("use_gold")
	local var1 = arg0:getConfig("use_item")
	local var2 = arg0:getConfig("number_1")
	local var3 = Item.New({
		id = var1
	})

	return i18n("commander_build_pool_tip", var3:getConfig("name"), var2)
end

function var0.getPrint(arg0)
	return Commander.rarity2Print(arg0.id + 2)
end

function var0.getItemCount(arg0)
	local var0 = arg0:getConfig("use_item")

	return getProxy(BagProxy):getItemCountById(var0)
end

function var0.getRarity(arg0)
	return arg0.id
end

return var0
