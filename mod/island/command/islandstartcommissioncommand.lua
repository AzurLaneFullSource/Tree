local var0_0 = class("IslandStartCommissionCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.buildingId
	local var2_1 = var0_1.commissionId
	local var3_1 = var0_1.shipId
	local var4_1 = var0_1.formulaId
	local var5_1 = var0_1.callback
	local var6_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var1_1)

	if not var6_1 then
		return
	end

	local var7_1 = var6_1:GetCommission(var2_1)
	local var8_1 = var6_1:GetFormula(var4_1)

	if not var7_1 or not var8_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21063, {
		building_id = var1_1,
		appoint_pos = var2_1,
		role_id = var3_1,
		formula_id = var4_1
	}, 21064, function(arg0_2)
		if arg0_2.ret == 0 then
			local var0_2 = IslandProductionCommission.New(arg0_2.appoint_info)

			var6_1:UpdateCommission(var0_2)
			arg0_1:sendNotification(GAME.ISLAND_START_COMMISSION_DONE)

			if var5_1 then
				var5_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
