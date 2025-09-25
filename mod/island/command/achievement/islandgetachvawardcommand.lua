local var0_0 = class("IslandGetAchvAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().ids

	pg.ConnectionMgr.GetInstance():Send(21050, {
		id_list = var0_1
	}, 21051, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetAchievementAgency():AddGotIds(var0_1)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.ACHIEVEMENT)

			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_GET_ACHV_AWARD_DONE, {
				dropData = var0_2,
				id = var0_1[1]
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
