local var0 = class("WorldFleetRedeployCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33409, var0, 33410, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(WorldProxy)
			local var1 = nowWorld()

			var1:SetFleets(var0:NetBuildMapFleetList(arg0.group_list))

			local var2 = var1:GetActiveMap()

			var2:SetValid(false)
			var2:UnbindFleets()

			local var3 = arg0.group_list[1].id

			var2.findex = table.indexof(var1.fleets, var1:GetFleet(var3))

			var2:BindFleets(var1.fleets)

			local var4 = var1:CalcOrderCost(WorldConst.OpReqRedeploy)

			var1.staminaMgr:ConsumeStamina(var4)
			var1:SetReqCDTime(WorldConst.OpReqRedeploy, pg.TimeMgr.GetInstance():GetServerTime())
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_2"))
			var1:GetBossProxy():GenFleet()
			arg0:sendNotification(GAME.WORLD_FLEET_REDEPLOY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_fleet_redeploy_error_", arg0.result))
		end
	end)
end

return var0
