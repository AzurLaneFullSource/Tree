local var0_0 = class("WorldKillCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.ConnectionMgr.GetInstance():Send(33112, {
		type = 0
	}, 33113, function(arg0_2)
		local var0_2

		if arg0_2.result == 0 then
			getProxy(WorldProxy):BuildWorld(World.TypeFull)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_reset_error_", arg0_2.result))
		end

		arg0_1:sendNotification(GAME.WORLD_KILL_DONE, {
			result = arg0_2.result
		})
	end)
end

return var0_0
