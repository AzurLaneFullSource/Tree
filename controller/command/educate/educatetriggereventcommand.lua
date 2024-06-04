local var0 = class("EducateTriggerEventCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback
	local var2 = var0.eventId

	pg.ConnectionMgr.GetInstance():Send(27016, {
		eventid = var2
	}, 27017, function(arg0)
		if arg0.result == 0 then
			EducateHelper.UpdateDropsData(arg0.drops)
			getProxy(EducateProxy):GetEventProxy():RemoveEvent(var2)
			arg0:sendNotification(GAME.EDUCATE_TRIGGER_EVENT_DONE, {
				id = var2,
				drops = arg0.drops,
				cb = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger event error: ", arg0.result))
		end
	end)
end

return var0
