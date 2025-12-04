local var0_0 = class("IslandExchangeLureCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.lureId
	local var2_1 = var0_1.fishPointId
	local var3_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21064, {
		bait_id = var1_1
	}, 21065, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetFishingAgency()

			if var2_1 then
				local var1_2 = var0_2:GetBaitId()

				pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandFishingChangeLure(var2_1, var1_2, var1_1))
			end

			var0_2:UpdateBaitId(var1_1)

			if var3_1 then
				var3_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
