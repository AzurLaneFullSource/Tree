local var0 = class("QuickExchangeBlueprintCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(BagProxy)
	local var2 = {}

	pg.ConnectionMgr.GetInstance():Send(15012, {
		use_list = var0
	}, 15013, function(arg0)
		for iter0, iter1 in ipairs(arg0.ret_list) do
			if iter1.result == 0 then
				local var0 = var0[iter0]

				var1:removeItemById(var0.id, var0.count)

				var2 = table.mergeArray(var2, PlayerConst.addTranDrop(iter1.drop_list))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
			end
		end

		arg0:sendNotification(GAME.QUICK_EXCHANGE_BLUEPRINT_DONE, var2)
	end)
end

return var0
