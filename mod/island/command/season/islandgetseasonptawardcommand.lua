local var0_0 = class("IslandGetSeasonPtAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().pt or 0

	pg.ConnectionMgr.GetInstance():Send(21022, {
		target_pt = var0_1
	}, 21023, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason():AddGotPtAwardList(var0_1)

			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, {
				dropData = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
