local var0_0 = class("EducateTriggerEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.eventId

	pg.ConnectionMgr.GetInstance():Send(27016, {
		eventid = var2_1
	}, 27017, function(arg0_2)
		if arg0_2.result == 0 then
			EducateHelper.UpdateDropsData(arg0_2.drops)
			getProxy(EducateProxy):GetEventProxy():RemoveEvent(var2_1)
			arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_EVENT_DONE, {
				id = var2_1,
				drops = arg0_2.drops,
				cb = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger event error: ", arg0_2.result))
		end
	end)
end

return var0_0
