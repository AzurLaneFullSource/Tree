local var0_0 = class("IslandGetDelegationAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.build_id
	local var3_1 = var0_1.area_id
	local var4_1 = var0_1.type
	local var5_1 = getProxy(IslandProxy):GetIsland()
	local var6_1 = var5_1:GetBuildingAgency()
	local var7_1 = var5_1:GetCharacterAgency()

	pg.ConnectionMgr.GetInstance():Send(21505, {
		build_id = var2_1,
		area_id = var3_1,
		type = var4_1
	}, 21506, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var6_1:GetBuilding(var2_1)

			var0_2:UpdateDeleationRewardDataBySlotId(var3_1, nil)

			if var4_1 == 1 then
				local var1_2 = var0_2:GetDelegationSlotData(var3_1):GetSlotRoleData()

				if var1_2 then
					var1_2:ResetGetTimes(arg0_2.get_times)
				end
			end

			local var2_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_GET_DELEGATION_AWARD_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
