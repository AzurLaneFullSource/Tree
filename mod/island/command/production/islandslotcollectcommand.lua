local var0_0 = class("IslandSlotCollectCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id
	local var3_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()

	pg.ConnectionMgr.GetInstance():Send(21507, {
		build_id = var1_1,
		area_id = var2_1
	}, 21508, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:GetBuilding(var1_1):UpdateCollectDataBySlotId(arg0_2.collect_area)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
