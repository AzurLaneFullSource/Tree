local var0_0 = class("IslandFishingResultCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.fishId
	local var3_1 = var0_1.weight
	local var4_1 = var0_1.cupType
	local var5_1 = var0_1.fishPointId
	local var6_1 = var0_1.op
	local var7_1 = var0_1.islandId

	pg.ConnectionMgr.GetInstance():Send(21062, {
		island_id = var7_1,
		point_id = var5_1,
		end_result = var6_1
	}, 21063, function(arg0_2)
		if arg0_2.result == 0 then
			if var6_1 == IslandConst.FISHING_OP_SUCCESS then
				getProxy(IslandProxy):GetIsland():GetFishingAgency():AddFish(var2_1, var3_1, var4_1)
				IslandBookHelper.OnFishingEnd(var2_1)
			end

			if var1_1 then
				var1_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
