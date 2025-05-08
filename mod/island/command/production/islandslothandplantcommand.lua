local var0_0 = class("IslandSlotHandPlantCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id
	local var3_1 = var0_1.formula_id
	local var4_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()

	pg.ConnectionMgr.GetInstance():Send(21509, {
		build_id = var1_1,
		area_id = var2_1,
		formula_id = var3_1
	}, 21510, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:GetBuilding(var1_1):UpdateDeleationRoleDataBySlotId(arg0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
