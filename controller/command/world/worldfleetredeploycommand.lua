local var0_0 = class("WorldFleetRedeployCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33409, var0_1, 33410, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(WorldProxy)
			local var1_2 = nowWorld()

			var1_2:SetFleets(var0_2:NetBuildMapFleetList(arg0_2.group_list))

			local var2_2 = var1_2:GetActiveMap()

			var2_2:SetValid(false)
			var2_2:UnbindFleets()

			local var3_2 = arg0_2.group_list[1].id

			var2_2.findex = table.indexof(var1_2.fleets, var1_2:GetFleet(var3_2))

			var2_2:BindFleets(var1_2.fleets)

			local var4_2 = var1_2:CalcOrderCost(WorldConst.OpReqRedeploy)

			var1_2.staminaMgr:ConsumeStamina(var4_2)
			var1_2:SetReqCDTime(WorldConst.OpReqRedeploy, pg.TimeMgr.GetInstance():GetServerTime())
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_2"))
			var1_2:GetBossProxy():GenFleet()
			arg0_1:sendNotification(GAME.WORLD_FLEET_REDEPLOY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_fleet_redeploy_error_", arg0_2.result))
		end
	end)
end

return var0_0
