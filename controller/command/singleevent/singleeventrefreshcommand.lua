local var0_0 = class("SingleEventRefreshCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		activity_id = var0_1.actId
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityById(var0_1.actId)

			var0_2:SetDailyEventIds(arg0_2.number)
			getProxy(ActivityProxy):updateActivity(var0_2)
			pg.m02:sendNotification(GAME.SINGLE_EVENT_REFRESH_DONE, {
				activity = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Refresh single event failed:" .. arg0_2.result)
		end
	end)
end

return var0_0
