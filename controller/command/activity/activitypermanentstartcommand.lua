local var0 = class("ActivityPermanentStartCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().activity_id

	pg.ConnectionMgr.GetInstance():Send(11206, {
		activity_id = var0
	}, 11207, function(arg0)
		if arg0.result == 0 then
			getProxy(ActivityPermanentProxy):startSelectActivity(var0)
			arg0:sendNotification(GAME.ACTIVITY_PERMANENT_START_DONE, {
				id = var0
			})
		else
			warning("error permanent")
		end
	end)
end

return var0
