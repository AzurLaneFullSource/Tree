local var0_0 = class("IslandSlotHandPlantCommand", pm.SimpleCommand)

var0_0.START_HANDPLANT_DONE = "IslandSlotHandPlantCommand:START_HANDPLANT_DONE"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.slot_list
	local var2_1 = var1_1[1]
	local var3_1 = pg.island_production_slot[var2_1].place
	local var4_1 = var0_1.formula_id
	local var5_1 = pg.island_formula[var4_1]
	local var6_1 = #var1_1
	local var7_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	if not (function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2) do
			local var0_2 = iter1_2[1]
			local var1_2 = iter1_2[2]

			if var7_1:GetItemById(var0_2):GetCount() < var1_2 * var6_1 then
				return false
			end
		end

		return true
	end)(var5_1.cost) then
		pg.TipsMgr.GetInstance():ShowTips("种子数量不够")

		return
	end

	local var8_1 = getProxy(IslandProxy):GetIsland()
	local var9_1 = var8_1:GetBuildingAgency()

	pg.ConnectionMgr.GetInstance():Send(21509, {
		build_id = var3_1,
		slot_list = var1_1,
		formula_id = var4_1
	}, 21510, function(arg0_3)
		if arg0_3.result == 0 then
			for iter0_3, iter1_3 in ipairs(arg0_3.hand_list) do
				var9_1:GetBuilding(var3_1):UpdateHandPlantDataBySlotId(iter1_3)

				local var0_3 = var5_1.cost

				for iter2_3, iter3_3 in ipairs(var0_3) do
					var7_1:RemoveItem(iter3_3[1], iter3_3[2])
				end

				var8_1:DispatchEvent(var0_0.START_HANDPLANT_DONE, {
					build_id = var3_1,
					area_id = iter1_3.id,
					formula_id = var4_1
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0
