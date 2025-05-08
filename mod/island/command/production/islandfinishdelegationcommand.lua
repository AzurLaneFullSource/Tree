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

			var0_2:UpdateDeleationRoleDataBySlotId(var2_1, nil)

			if #arg0_2.award > 0 then
				local var2_2 = arg0_2.award[1]

				var0_2:UpdateDeleationRewardDataBySlotId(var2_1, var2_2)
			end

			local var3_2 = var5_1:GetShipById(arg0_2.ship_id)

			var3_2:UpdateEnergy(arg0_2.cur_energy)
			var3_2:UpdateEnergyBeginRecoverTime(arg0_2.recover_time)
			var3_2:AddExp(arg0_2.add_exp)
			var3_1:DispatchEvent(var0_0.END_DELEGATION, {
				build_id = var1_1,
				ship_id = arg0_2.ship_id,
				area_id = var2_1
			})
			arg0_1:sendNotification(GAME.ISLAND_FINISH_DELEGATION_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
