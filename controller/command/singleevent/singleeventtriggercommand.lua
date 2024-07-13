local var0_0 = class("SingleEventTriggerCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0_1.actId,
		arg1 = var0_1.eventId
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityById(var0_1.actId)

			var0_2:AddFinishEvent(var0_1.eventId)
			getProxy(ActivityProxy):updateActivity(var0_2)

			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			pg.m02:sendNotification(GAME.SINGLE_EVENT_TRIGGER_DONE, {
				activity = var0_2,
				eventId = var0_1.eventId,
				awards = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Trigger single event failed:" .. arg0_2.result)
		end
	end)
end

return var0_0
