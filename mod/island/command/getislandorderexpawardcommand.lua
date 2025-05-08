local var0_0 = class("GetIslandOrderExpAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.level
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	if not var3_1:CanGetAward(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("不可领取"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21412, {
		lv = var1_1
	}, 21413, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:UpdateGotAwardList(var1_1)

			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_GET_ORDER_EXP_AWARD_DONE, {
				dropData = var0_2,
				callback = var2_1,
				level = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
