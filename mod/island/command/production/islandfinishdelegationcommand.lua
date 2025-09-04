local var0_0 = class("IslandFinishDelegationCommand", pm.SimpleCommand)

var0_0.END_DELEGATION = "IslandFinishDelegationCommand:END_DELEGATION"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id
	local var3_1 = getProxy(IslandProxy):GetIsland()
	local var4_1 = var3_1:GetBuildingAgency()
	local var5_1 = var3_1:GetCharacterAgency()

	pg.ConnectionMgr.GetInstance():Send(21503, {
		build_id = var1_1,
		area_id = var2_1
	}, 21504, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var4_1:GetBuilding(var1_1)

			if var1_1 == IslandTechnologyAgency.PLACE_ID then
				local var1_2 = var0_2:GetDelegationSlotData(var2_1):GetFormulaId()

				var3_1:GetTechnologyAgency():AddFinishCntByFormulatId(var1_2)
			end

			if arg0_2.return_num and arg0_2.return_num > 0 then
				local var2_2 = var0_2:GetDelegationSlotData(var2_1):GetFormulaId()
				local var3_2 = pg.island_formula[var2_2].commission_cost
				local var4_2 = {}

				for iter0_2, iter1_2 in ipairs(var3_2) do
					table.insert(var4_2, {
						type = DROP_TYPE_ISLAND_ITEM,
						id = iter1_2[1],
						number = iter1_2[2] * arg0_2.return_num
					})
				end

				local var5_2 = IslandDropHelper.AddItems({
					drop_list = var4_2
				})
			end

			var0_2:UpdateDeleationRoleDataBySlotId(var2_1, nil)

			local var6_2

			if #arg0_2.award > 0 then
				local var7_2 = arg0_2.award[1]

				var6_2 = true

				var0_2:UpdateDeleationRewardDataBySlotId(var2_1, var7_2)
			end

			local var8_2 = var5_1:GetShipById(arg0_2.ship_id)

			var8_2:UpdateEnergy(arg0_2.cur_energy)
			var8_2:UpdateEnergyBeginRecoverTime(arg0_2.recover_time)
			var8_2:AddExp(arg0_2.add_exp)
			var3_1:DispatchEvent(var0_0.END_DELEGATION, {
				build_id = var1_1,
				ship_id = arg0_2.ship_id,
				area_id = var2_1,
				remainReward = var6_2
			})
			arg0_1:sendNotification(GAME.ISLAND_FINISH_DELEGATION_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
