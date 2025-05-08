local var0_0 = class("IslandUseSpeedupCardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id
	local var3_1 = var0_1.item_id
	local var4_1 = var0_1.num
	local var5_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()

	pg.ConnectionMgr.GetInstance():Send(21513, {
		build_id = var1_1,
		area_id = var2_1,
		item_id = var3_1,
		num = var4_1
	}, 21514, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var5_1:GetBuilding(var1_1):GetDelegationSlotData(var2_1):GetSlotRoleData()

			if var0_2 then
				var0_2:ResetItem_times(arg0_2.item_times)
			end

			arg0_1:sendNotification(GAME.ISLAND_USESPEEDUPCARD_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
