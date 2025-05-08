local var0_0 = class("IslandFinishTechImmdCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.techId
	local var2_1 = var0_1.callback

	warning("Island Finish Tech Immd", var1_1)
	pg.ConnectionMgr.GetInstance():Send(21522, {
		tech_id = var1_1
	}, 21523, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetTechnologyAgency():GetTechnology(var1_1):AddFinishedCnt()

			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_FINISH_TECH_IMMD_DONE, {
				dropData = var0_2
			})
			existCall(var2_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
