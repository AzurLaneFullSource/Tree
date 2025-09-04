local var0_0 = class("IslandWildGatherCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.island_id
	local var2_1 = var0_1.gather_id
	local var3_1 = getProxy(IslandProxy):GetIsland()
	local var4_1 = var0_1.unitId

	pg.ConnectionMgr.GetInstance():Send(21524, {
		island_id = var1_1,
		gather_id = var2_1
	}, 21525, function(arg0_2)
		if arg0_2.result == 0 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandWildGather(var4_1))

			local var0_2 = IslandDropHelper.AddItems({
				drop_list = arg0_2.drop_list
			})

			arg0_1:sendNotification(GAME.ISLAND_DROPMAIN_AWARD, {
				dropData = var0_2
			})
			var3_1:DispatchEvent(IslandGatherCollectAgency.RemoveGatherUnit, {
				unitId = var4_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
