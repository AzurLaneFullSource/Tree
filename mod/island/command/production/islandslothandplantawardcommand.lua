local var0_0 = class("IslandSlotHandPlantAwardCommand", pm.SimpleCommand)

var0_0.START_HANDPLANT_AWARD_DONE = "IslandSlotHandPlantCommand:START_HANDPLANT_AWARD_DONE"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().slot_list
	local var1_1 = var0_1[1]
	local var2_1 = pg.island_production_slot[var1_1].place
	local var3_1 = getProxy(IslandProxy):GetIsland()
	local var4_1 = var3_1:GetBuildingAgency()

	pg.ConnectionMgr.GetInstance():Send(21511, {
		build_id = var2_1,
		area_ids = var0_1
	}, 21512, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.drop_list) do
				table.insert(var0_2, iter1_2)
			end

			local var1_2 = IslandDropHelper.AddItems({
				drop_list = var0_2
			})

			arg0_1:sendNotification(GAME.ISLAND_DROPMAIN_AWARD, {
				dropData = var1_2
			})

			local var2_2 = var4_1:GetBuilding(var2_1)

			for iter2_2, iter3_2 in ipairs(var0_1) do
				var2_2:UpdateHandPlantDataBySlotId({
					formula_id = 0,
					end_time = 0,
					state = 0,
					id = iter3_2
				})
				var3_1:DispatchEvent(var0_0.START_HANDPLANT_AWARD_DONE, {
					build_id = var2_1,
					area_id = iter3_2
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
