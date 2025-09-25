local var0_0 = class("ExitIslandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21204, {
		island_id = var1_1
	}, 21205, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()

			if var0_2:IsPrivate() then
				local var1_2 = var0_2:GetSystemTipInfos()

				getProxy(SystemTipProxy):SetIslandTipData(var1_2.awardCnt, var1_2.emptyCnt, var1_2.timestamps, var1_2.postFlag)
			end

			getProxy(IslandProxy):ExitIsland()
			arg0_1:sendNotification(GAME.ISLAND_EXIT_DONE)

			if var2_1 then
				var2_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
