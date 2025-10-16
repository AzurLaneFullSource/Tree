local var0_0 = class("GetIslandTaskRandomRefreshCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(21030, {
		type = 0
	}, 21031, function(arg0_2)
		local var0_2 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

		var0_2:UpdateRandomRefreshTask(arg0_2)
		var0_2:TryAcceptAutoTasks()
		arg0_1:sendNotification(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE)
	end)
end

return var0_0
