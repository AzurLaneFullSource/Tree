local var0_0 = class("IslandStartDelegationCommand", pm.SimpleCommand)

var0_0.START_DELEGATION = "IslandStartDelegationCommand:START_DELEGATION"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id
	local var3_1 = var0_1.ship_id
	local var4_1 = var0_1.formula_id
	local var5_1 = var0_1.num
	local var6_1 = getProxy(IslandProxy):GetIsland()
	local var7_1 = var6_1:GetBuildingAgency()
	local var8_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var9_1 = var0_1.extraCost or 0

	pg.ConnectionMgr.GetInstance():Send(21501, {
		build_id = var1_1,
		area_id = var2_1,
		ship_id = var3_1,
		formula_id = var4_1,
		num = var5_1
	}, 21502, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var7_1:GetBuilding(var1_1)

			var0_2:UpdateDeleationRoleDataBySlotId(arg0_2.ship_appoint.id, arg0_2.ship_appoint)

			local var1_2 = var6_1:GetCharacterAgency():GetShipById(var3_1)

			var1_2:UpdateEnergy(arg0_2.ship_power)

			local var2_2 = var0_2:GetDelegationSlotData(arg0_2.ship_appoint.id)
			local var3_2 = var2_2:GetRoleDelegateFinishTime()

			var1_2:UpdateEnergyBeginRecoverTime(var3_2)

			local var4_2 = var1_1 == IslandTechnologyAgency.PLACE_ID and IslandShip.STATE_DELEGATION or IslandShip.STATE_TECHNOLOGY

			var1_2:UpdateState(var4_2, var1_1)

			local var5_2 = var2_2:GetFormulaId()
			local var6_2 = pg.island_formula[var5_2].commission_cost

			for iter0_2, iter1_2 in ipairs(var6_2) do
				var8_1:RemoveItem(iter1_2[1], (iter1_2[2] + var9_1) * var5_1)
			end

			var6_1:DispatchEvent(var0_0.START_DELEGATION, {
				build_id = var1_1,
				ship_id = var3_1,
				area_id = var2_1
			})
			arg0_1:sendNotification(GAME.ISLAND_START_DELEGATION_DONE, {
				slotId = var2_1
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandStartDelegation(var3_1, var1_1, var2_1, var4_1, var5_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
