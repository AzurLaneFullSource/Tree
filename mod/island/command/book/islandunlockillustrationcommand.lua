local var0_0 = class("IslandUnlockIllustrationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().ids

	pg.ConnectionMgr.GetInstance():Send(21343, {
		book_ids = var0_1
	}, 21344, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetBookAgency()
			local var1_2 = var0_2:GetTotalPoints()

			var0_2:AddUnlock(var0_1)

			local var2_2 = var0_2:GetTotalPoints() - var1_2

			if var2_2 > 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_get_collect_point_success", var2_2))
			end

			arg0_1:sendNotification(GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE, {
				ids = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
