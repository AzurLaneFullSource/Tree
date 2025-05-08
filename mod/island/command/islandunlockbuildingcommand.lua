local var0_0 = class("IslandUnlockBuildingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().buildingId
	local var1_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var2_1 = var1_1:GetBuilding(var0_1)

	if not var2_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21049, {
		building_id = var0_1
	}, 21050, function(arg0_2)
		if arg0_2.ret == 0 then
			var2_1:SetUnlockSystem(true)
			var1_1:UpdateBuilding(var2_1)
			arg0_1:sendNotification(GAME.ISLAND_UNLOCK_BUILDING_DONE, {
				id = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
