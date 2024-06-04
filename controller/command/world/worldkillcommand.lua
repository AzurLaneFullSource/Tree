local var0 = class("WorldKillCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(33112, {
		type = 0
	}, 33113, function(arg0)
		local var0

		if arg0.result == 0 then
			getProxy(WorldProxy):BuildWorld(World.TypeFull)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_reset_error_", arg0.result))
		end

		arg0:sendNotification(GAME.WORLD_KILL_DONE, {
			result = arg0.result
		})
	end)
end

return var0
