local var0 = class("UseFudaiItemCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = var0.callback

	if var2 == 0 then
		return
	end

	local var4 = getProxy(BagProxy)
	local var5 = var4:getItemById(var1)

	if var2 > var5.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(15002, {
		id = var1,
		count = var2
	}, 15003, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			var4:removeItemById(var1, var2)
			assert(var5:getConfig("usage") == ItemUsage.DROP or var5:getConfig("usage") == ItemUsage.DROP_TEMPLATE, "未处理类型")
			existCall(var3, PlayerConst.addTranDrop(arg0.drop_list))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
			existCall(var3)
		end
	end)
end

return var0
