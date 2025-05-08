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

	pg.ConnectionMgr.GetInstance():Send(21501, {
		build_id = var1_1,
		area_id = var2_1,
		ship_id = var3_1,
		formula_id = var4_1,
		num = var5_1
	}, 21502, function(arg0_2)
		if arg0_2.result == 0 then
			var7_1:GetBuilding(var1_1):UpdateDeleationRoleDataBySlotId(arg0_2.ship_appoint.id, arg0_2.ship_appoint)
			var6_1:DispatchEvent(var0_0.START_DELEGATION, {
				build_id = var1_1,
				ship_id = var3_1,
				area_id = var2_1
			})
			arg0_1:sendNotification(GAME.ISLAND_START_DELEGATION_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
