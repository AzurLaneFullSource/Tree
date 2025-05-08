local var0_0 = class("IslandCancelProductionCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.buildingId
	local var2_1 = var0_1.unitId
	local var3_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var1_1)

	if not var3_1 then
		return
	end

	local var4_1 = var3_1:GetUnit(var2_1)

	if not var4_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21059, {
		building_id = var1_1,
		area_id = var2_1
	}, 21060, function(arg0_2)
		if arg0_2.ret == 0 then
			var4_1:Clear()
			var3_1:UpdateUnit(var4_1)
			arg0_1:sendNotification(GAME.ISLAND_CANCEL_PRODUCTION_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
