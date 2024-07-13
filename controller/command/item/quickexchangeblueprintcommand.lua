local var0_0 = class("QuickExchangeBlueprintCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(BagProxy)
	local var2_1 = {}

	pg.ConnectionMgr.GetInstance():Send(15012, {
		use_list = var0_1
	}, 15013, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.ret_list) do
			if iter1_2.result == 0 then
				local var0_2 = var0_1[iter0_2]

				var1_1:removeItemById(var0_2.id, var0_2.count)

				var2_1 = table.mergeArray(var2_1, PlayerConst.addTranDrop(iter1_2.drop_list))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
			end
		end

		arg0_1:sendNotification(GAME.QUICK_EXCHANGE_BLUEPRINT_DONE, var2_1)
	end)
end

return var0_0
