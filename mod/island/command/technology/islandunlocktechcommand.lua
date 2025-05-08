local var0_0 = class("IslandUnlockTechCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().techId

	warning("Island Unlock Tech", var0_1)
	pg.ConnectionMgr.GetInstance():Send(21520, {
		tech_id = var0_1
	}, 21521, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()
			local var1_2 = var0_2:GetTechnologyAgency():GetTechnology(var0_1)

			var0_2:GetAblityAgency():AddAblity(var1_2:GetAbilityId())

			local var2_2 = var0_2:GetInventoryAgency()

			for iter0_2, iter1_2 in ipairs(var1_2:GetRecycleItemInfos()) do
				var2_2:RemoveItem(iter1_2.id, iter1_2.count)
			end

			arg0_1:sendNotification(GAME.ISLAND_UNLOCK_TECH_DONE)

			if var1_2:IsAutoType() then
				warning("After Unlock To Finish Immd")
				arg0_1:sendNotification(GAME.ISLAND_FINISH_TECH_IMMD, {
					techId = var0_1
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
