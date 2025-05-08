local var0_0 = class("IslandChangeCommissionFormulaCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.buildingId
	local var2_1 = var0_1.commissionId
	local var3_1 = var0_1.formulaId
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var1_1)

	if not var5_1 then
		return
	end

	local var6_1 = var5_1:GetCommission(var2_1)
	local var7_1 = var5_1:GetFormula(var3_1)

	if not var6_1 or not var7_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21061, {
		building_id = var1_1,
		area_id = var2_1,
		formula_id = var3_1
	}, 21062, function(arg0_2)
		if arg0_2.ret == 0 then
			local var0_2 = IslandProductionCommission.New(arg0_2.area_info)

			var5_1:UpdateCommission(var0_2)
			arg0_1:sendNotification(GAME.ISLAND_CHANGE_COMMISSION_FORMULA_DONE)

			if var4_1 then
				var4_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
