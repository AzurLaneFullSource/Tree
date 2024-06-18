local var0_0 = class("CommanderBuildPool", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.commander_data_create_material
end

function var0_0.getName(arg0_3)
	local var0_3 = arg0_3:getConfig("use_item")
	local var1_3 = Item.New({
		id = var0_3
	})

	return arg0_3:getConfig("name") or var1_3:getConfig("name") or ""
end

function var0_0.getConsume(arg0_4)
	local var0_4 = arg0_4:getConfig("use_item")
	local var1_4 = arg0_4:getConfig("number_1")

	return {
		{
			2,
			var0_4,
			var1_4
		}
	}
end

function var0_0.getConsumeDesc(arg0_5)
	local var0_5 = arg0_5:getConfig("use_gold")
	local var1_5 = arg0_5:getConfig("use_item")
	local var2_5 = arg0_5:getConfig("number_1")
	local var3_5 = Item.New({
		id = var1_5
	})

	return i18n("commander_build_pool_tip", var3_5:getConfig("name"), var2_5)
end

function var0_0.getPrint(arg0_6)
	return Commander.rarity2Print(arg0_6.id + 2)
end

function var0_0.getItemCount(arg0_7)
	local var0_7 = arg0_7:getConfig("use_item")

	return getProxy(BagProxy):getItemCountById(var0_7)
end

function var0_0.getRarity(arg0_8)
	return arg0_8.id
end

return var0_0
