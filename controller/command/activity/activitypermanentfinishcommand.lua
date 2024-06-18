local var0_0 = class("ActivityPermanentFinishCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().activity_id

	pg.ConnectionMgr.GetInstance():Send(11208, {
		activity_id = var0_1
	}, 11209, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(ActivityPermanentProxy):finishNowActivity(var0_1)
			getProxy(ActivityProxy):deleteActivityById(var0_1)
			arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH_DONE, {
				activity_id = var0_1
			})
		else
			warning("error permanent")
		end
	end)
end

return var0_0
