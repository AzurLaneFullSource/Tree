local var0_0 = class("IslandAutomaticCollectionCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var1_1 - 1
	local var3_1 = var0_1.ship_list
	local var4_1 = var0_1.gatherData
	local var5_1 = getProxy(IslandProxy):GetIsland()
	local var6_1 = var5_1:GetBuildingAgency()
	local var7_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	local function var8_1(arg0_2)
		for iter0_2, iter1_2 in pairs(var4_1 or {}) do
			if iter1_2.id == arg0_2 then
				return iter1_2.pos
			end
		end

		return nil
	end

	pg.ConnectionMgr.GetInstance():Send(21539, {
		type = var2_1,
		ship_list = var3_1
	}, 21540, function(arg0_3)
		if arg0_3.result == 0 then
			for iter0_3, iter1_3 in ipairs(arg0_3.ship_list or {}) do
				local var0_3 = var5_1:GetCharacterAgency():GetShipById(iter1_3.ship_id)

				var0_3:UpdateEnergy(iter1_3.cur_power)
				var0_3:UpdateEnergyBeginRecoverTime(iter1_3.recover_time)
				var0_3:AddExp(iter1_3.add_exp)
			end

			for iter2_3, iter3_3 in ipairs(arg0_3.gather_list or {}) do
				local var1_3 = var8_1(iter3_3)

				if var1_3 then
					var5_1:DispatchEvent(IslandGatherCollectAgency.RemoveGatherUnit, {
						unitId = var1_3
					})
				end
			end

			for iter4_3, iter5_3 in ipairs(arg0_3.build_refresh or {}) do
				local var2_3 = var6_1:GetBuilding(iter5_3.build_id)
				local var3_3 = var2_3:GetBuildingCollectData()

				var3_3:SetAllTakeColelct()
				var3_3:UpdateCollectRefreshtTime(iter5_3.refresh_time)

				for iter6_3, iter7_3 in pairs(var3_3:GetCollectSlotDatasDic()) do
					var2_3:UpdateCollectDataBySlotId({
						id = iter7_3.id
					}, 1)
				end
			end

			local var4_3 = IslandDropHelper.AddItems(arg0_3)

			arg0_1:sendNotification(GAME.ISLAND_TAKE_AUTO_COLLECTION_DONE, {
				dropData = var4_3,
				selectType = var1_1
			})
			var7_1:RemoveItem(1, arg0_3.cost_gold)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0
