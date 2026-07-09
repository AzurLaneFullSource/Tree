local var0_0 = class("ActivityPermanentStopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.activity_id
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(11208, {
		typ = 2,
		activity_id = var1_1
	}, 11209, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(ActivityPermanentProxy):StopNowActivity(var1_1)

			if getProxy(ActivityProxy):RawGetActivityById(var1_1) then
				getProxy(ActivityProxy):deleteActivityById(var1_1)
			end

			arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_STOP_DONE, {
				activity_id = var1_1
			})
			existCall(var2_1)
		else
			warning("error permanent")
		end
	end)
end

return var0_0
