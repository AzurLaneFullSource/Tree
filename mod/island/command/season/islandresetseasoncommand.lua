local var0_0 = class("IslandResetSeasonCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(21024, {
		type = 0
	}, 21025, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()
			local var1_2 = var0_2:GetSeasonAgency()
			local var2_2 = var1_2:GetHighestRank()
			local var3_2 = arg0_2.season_review and IslandSeasonReview.New(arg0_2.season_review) or nil

			var1_2:Reset(var3_2)
			var0_2:GetOrderAgency():OnSeasonReset(arg0_2.order_sys or {})
			var0_2:GetBuildingAgency():OnSeasonReset()

			local var4_2 = var0_2:GetInventoryAgency():OnSeasonReset()
			local var5_2 = IslandDropHelper.AddItems(arg0_2)
			local var6_2 = var3_2 and var3_2:GetRecordData(IslandSeasonReview.KEYS.PT_RANK) or 0

			if var6_2 ~= 0 and var6_2 < var2_2 then
				IslandAchievementHelper.OnSeasonReset(var6_2)
			end

			arg0_1:sendNotification(GAME.ISLAND_RESET_SEASON_DONE, {
				awards = var5_2.awards,
				pt = var4_2,
				seasonId = var3_2 and var3_2.id or 0,
				rank = var6_2,
				callback = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
