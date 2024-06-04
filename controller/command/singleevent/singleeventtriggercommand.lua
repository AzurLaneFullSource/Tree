local var0 = class("SingleEventTriggerCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0.actId,
		arg1 = var0.eventId
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ActivityProxy):getActivityById(var0.actId)

			var0:AddFinishEvent(var0.eventId)
			getProxy(ActivityProxy):updateActivity(var0)

			local var1 = PlayerConst.addTranDrop(arg0.award_list)

			pg.m02:sendNotification(GAME.SINGLE_EVENT_TRIGGER_DONE, {
				activity = var0,
				eventId = var0.eventId,
				awards = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Trigger single event failed:" .. arg0.result)
		end
	end)
end

return var0
