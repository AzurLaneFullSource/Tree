local var0_0 = class("IslandWildCollectCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.island_id
	local var2_1 = var0_1.fragment_id
	local var3_1 = var0_1.unitId
	local var4_1 = getProxy(IslandProxy):GetIsland()

	pg.ConnectionMgr.GetInstance():Send(21529, {
		island_id = var1_1,
		fragment_id = var2_1
	}, 21530, function(arg0_2)
		if arg0_2.result == 0 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandWildCollect(var2_1))
			var4_1:DispatchEvent(IslandGatherCollectAgency.RemoveGatherUnit, {
				unitId = var3_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
