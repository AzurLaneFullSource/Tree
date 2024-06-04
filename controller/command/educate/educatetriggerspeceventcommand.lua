local var0 = class("EducateTriggerSpecEventCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback
	local var2 = var0.eventId
	local var3 = pg.child_event_special[var2].type

	pg.ConnectionMgr.GetInstance():Send(27027, {
		spec_events_id = var2
	}, 27028, function(arg0)
		if arg0.result == 0 then
			EducateHelper.UpdateDropsData(arg0.drops)
			getProxy(EducateProxy):GetEventProxy():AddFinishSpecEvent(var2)

			if var3 == EducateSpecialEvent.TYPE_BUBBLE_DISCOUNT then
				getProxy(EducateProxy):GetShopProxy():AddDiscountEventById(var2)
			end

			arg0:sendNotification(GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE, {
				siteId = var0.siteId,
				id = var2,
				type = var3,
				drops = arg0.drops,
				cb = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger specEvent error: ", arg0.result))
		end
	end)
end

return var0
