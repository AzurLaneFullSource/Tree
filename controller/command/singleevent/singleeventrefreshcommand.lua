local var0 = class("SingleEventRefreshCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		activity_id = var0.actId
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ActivityProxy):getActivityById(var0.actId)

			var0:SetDailyEventIds(arg0.number)
			getProxy(ActivityProxy):updateActivity(var0)
			pg.m02:sendNotification(GAME.SINGLE_EVENT_REFRESH_DONE, {
				activity = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Refresh single event failed:" .. arg0.result)
		end
	end)
end

return var0
