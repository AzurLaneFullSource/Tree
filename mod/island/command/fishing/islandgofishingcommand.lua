local var0_0 = class("IslandGoFishingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.poolId
	local var2_1 = var0_1.baitId
	local var3_1 = var0_1.islandId
	local var4_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21060, {
		island_id = var3_1,
		point_id = var1_1
	}, 21061, function(arg0_2)
		if arg0_2.result == 0 then
			if var4_1 then
				var4_1(arg0_2.fish_id, arg0_2.weight, arg0_2.gold_state or 0)
			end
		else
			if var4_1 then
				var4_1(0, 0)
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
