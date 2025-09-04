local var0_0 = class("IslandUnlockTechCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.techId
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21520, {
		tech_id = var1_1
	}, 21521, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()
			local var1_2 = var0_2:GetTechnologyAgency()

			var1_2:RemoveLockId(var1_1)

			local var2_2 = var1_2:GetTechnology(var1_1):GetAbilityId()

			var0_2:GetAblityAgency():AddAblity(var2_2)
			existCall(var2_1)
			arg0_1:sendNotification(GAME.ISLAND_UNLOCK_TECH_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
