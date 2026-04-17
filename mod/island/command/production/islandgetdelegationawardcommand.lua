local var0_0 = class("IslandGetDelegationAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.build_id
	local var3_1 = var0_1.area_id
	local var4_1 = var0_1.type
	local var5_1 = var0_1.callback
	local var6_1 = getProxy(IslandProxy):GetIsland()
	local var7_1 = var6_1:GetBuildingAgency()
	local var8_1 = var6_1:GetCharacterAgency()
	local var9_1 = var0_1.isPost

	pg.ConnectionMgr.GetInstance():Send(21505, {
		build_id = var2_1,
		area_id = var3_1,
		type = var4_1
	}, 21506, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var7_1:GetBuilding(var2_1)

			if var2_1 == IslandTechnologyAgency.PLACE_ID then
				local var1_2 = var0_2:GetDelegationSlotData(var3_1):GetFormulaId()

				var6_1:GetTechnologyAgency():AddFinishCntByFormulatId(var1_2)
			end

			local var2_2 = var0_2:GetShipAddExpData(var3_1)

			var0_2:UpdateDeleationRewardDataBySlotId(var3_1, nil)

			if var4_1 == 1 then
				local var3_2 = var0_2:GetDelegationSlotData(var3_1):GetSlotRoleData()

				if var3_2 then
					var3_2:OnGetAwardMidway(arg0_2.start_time, arg0_2.rest_time_list, arg0_2.get_times)
				end
			end

			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandGetDelegationAward(var9_1 and 1 or 0, arg0_2.drop_list))

			local var4_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.drop_list) do
				table.insert(var4_2, iter1_2)
			end

			table.insert(var4_2, {
				id = 0,
				type = VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT,
				count = arg0_2.pt_award or 0
			})

			local var5_2 = IslandDropHelper.AddItems({
				drop_list = var4_2
			})

			arg0_1:sendNotification(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, {
				slotId = var3_1,
				dropData = var5_2,
				callback = var5_1,
				addShipExpData = var2_2
			})

			if var4_1 == 2 then
				var6_1:DispatchEvent(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, {
					build_id = var2_1,
					area_id = var3_1
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
