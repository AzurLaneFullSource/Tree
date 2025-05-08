local var0_0 = class("GetIslandProsperityAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().level

	if not getProxy(IslandProxy):GetIsland():CanGetProsperityAwards(var0_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21010, {
		level = var0_1
	}, 21011, function(arg0_2)
		if arg0_2.ret == 0 then
			getProxy(IslandProxy):GetIsland():ReceiveProsperityAwards(var0_1)

			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_PROSPERITY_AWARD_DONE, {
				dropData = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.ret] .. arg0_2.ret)
		end
	end)
end

return var0_0
