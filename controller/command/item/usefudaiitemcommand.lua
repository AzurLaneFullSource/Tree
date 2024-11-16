local var0_0 = class("UseFudaiItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = var0_1.callback

	if var2_1 == 0 then
		return
	end

	local var4_1 = getProxy(BagProxy)
	local var5_1 = var4_1:getItemById(var1_1)

	if var2_1 > var5_1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(15002, {
		id = var1_1,
		count = var2_1
	}, 15003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			var4_1:removeItemById(var1_1, var2_1)
			assert(var5_1:getConfig("usage") == ItemUsage.DROP or var5_1:getConfig("usage") == ItemUsage.DROP_TEMPLATE or var5_1:getConfig("usage") == ItemUsage.RANDOM_SKIN, "未处理类型")
			existCall(var3_1, PlayerConst.addTranDrop(arg0_2.drop_list))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
			existCall(var3_1)
		end
	end)
end

return var0_0
