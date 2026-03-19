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

			if arg0_2.return_num and arg0_2.return_num > 0 then
				local var1_2 = var0_2:GetDelegationSlotData(var2_1):GetFormulaId()
				local var2_2 = pg.island_formula[var1_2]
				local var3_2 = var0_2:GetDelegationSlotData(var2_1):GetSlotRoleData():GetReturnExtraNum(arg0_2.return_num)
				local var4_2 = var2_2.commission_cost
				local var5_2 = {}

				for iter0_2, iter1_2 in ipairs(var4_2) do
					table.insert(var5_2, {
						type = DROP_TYPE_ISLAND_ITEM,
						id = iter1_2[1],
						number = iter1_2[2] * arg0_2.return_num + var3_2
					})
				end

				local var6_2 = IslandDropHelper.AddItems({
					drop_list = var5_2
				})
			end

			var0_2:UpdateDeleationRoleDataBySlotId(var2_1, nil)

			local var7_2

			if #arg0_2.award > 0 then
				local var8_2 = arg0_2.award[1]

				var7_2 = true

				var0_2:UpdateDeleationRewardDataBySlotId(var2_1, var8_2)
			end

			local var9_2 = var5_1:GetShipById(arg0_2.ship_id)

			var9_2:AddExp(arg0_2.add_exp)

			local var10_2

			if arg0_2.return_num ~= 0 then
				if arg0_2.add_exp > 0 then
					var10_2 = {
						addShipId = arg0_2.ship_id,
						addExp = arg0_2.add_exp
					}
				end

				var9_2:UpdateEnergy(arg0_2.cur_energy)
				var9_2:UpdateEnergyBeginRecoverTime(arg0_2.recover_time)
			end

			var3_1:DispatchEvent(var0_0.END_DELEGATION, {
				build_id = var1_1,
				ship_id = arg0_2.ship_id,
				area_id = var2_1,
				remainReward = var7_2
			})
			arg0_1:sendNotification(GAME.ISLAND_FINISH_DELEGATION_DONE, {
				slotId = var2_1,
				addShipExpData = var10_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
