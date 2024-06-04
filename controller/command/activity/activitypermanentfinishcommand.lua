local var0 = class("ActivityPermanentFinishCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().activity_id

	pg.ConnectionMgr.GetInstance():Send(11208, {
		activity_id = var0
	}, 11209, function(arg0)
		if arg0.result == 0 then
			getProxy(ActivityPermanentProxy):finishNowActivity(var0)
			getProxy(ActivityProxy):deleteActivityById(var0)
			arg0:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH_DONE, {
				activity_id = var0
			})
		else
			warning("error permanent")
		end
	end)
end

return var0
