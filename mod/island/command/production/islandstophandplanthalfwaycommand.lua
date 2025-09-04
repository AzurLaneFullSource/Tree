local var0_0 = class("IslandStopHandPlantHalfWayCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.slot_list
	local var3_1 = getProxy(IslandProxy):GetIsland()
	local var4_1 = var3_1:GetBuildingAgency()

	pg.ConnectionMgr.GetInstance():Send(21516, {
		build_id = var1_1,
		slot_list = var2_1
	}, 21517, function(arg0_2)
		if arg0_2.result == 0 then
			for iter0_2, iter1_2 in ipairs(var2_1) do
				var4_1:GetBuilding(var1_1):UpdateHandPlantDataBySlotId({
					formula_id = 0,
					end_time = 0,
					state = 0,
					id = iter1_2
				})
				var3_1:DispatchEvent(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, {
					build_id = var1_1,
					area_id = iter1_2
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
