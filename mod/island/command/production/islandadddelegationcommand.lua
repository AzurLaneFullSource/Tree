local var0_0 = class("IslandAddDelegationCommand", pm.SimpleCommand)

var0_0.END_DELEGATION = "IslandAddDelegationCommand:END_DELEGATION"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id
	local var3_1 = var0_1.add_num
	local var4_1 = var0_1.extraCost or 0
	local var5_1 = getProxy(IslandProxy):GetIsland()
	local var6_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var7_1 = var5_1:GetBuildingAgency()

	pg.ConnectionMgr.GetInstance():Send(21537, {
		build_id = var1_1,
		area_id = var2_1,
		add_num = var3_1
	}, 21538, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var7_1:GetBuilding(var1_1):GetDelegationSlotData(var2_1)
			local var1_2 = var0_2:GetSlotRoleData()

			var1_2:AddCostList(arg0_2.cost_time_list)
			var1_2:AddExtraList(arg0_2.times_extra)

			local var2_2 = var0_2:GetFormulaId()
			local var3_2 = pg.island_formula[var2_2]
			local var4_2 = var3_2.commission_cost

			for iter0_2, iter1_2 in ipairs(var4_2) do
				var6_1:RemoveItem(iter1_2[1], (iter1_2[2] + var4_1) * var3_1)
			end

			local var5_2 = var5_1:GetCharacterAgency():GetShipById(var1_2.ship_id)
			local var6_2 = math.floor(var3_2.stamina_cost * (1 - IslandProductCostHelper.GetReducePercentInPlace(var1_2.ship_id, var1_1)))
			local var7_2 = math.max(var6_2, 1)
			local var8_2 = var5_2:GetCurrentEnergy() - var7_2 * var3_1

			var5_2:UpdateEnergy(var8_2)
			var5_2:UpdateEnergyBeginRecoverTime(var1_2:GetFinishTime())
			arg0_1:sendNotification(GAME.ISLAND_FINISH_DELEGATION_DONE, {
				slotId = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
