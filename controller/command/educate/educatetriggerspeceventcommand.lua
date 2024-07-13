local var0_0 = class("EducateTriggerSpecEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.eventId
	local var3_1 = pg.child_event_special[var2_1].type

	pg.ConnectionMgr.GetInstance():Send(27027, {
		spec_events_id = var2_1
	}, 27028, function(arg0_2)
		if arg0_2.result == 0 then
			EducateHelper.UpdateDropsData(arg0_2.drops)
			getProxy(EducateProxy):GetEventProxy():AddFinishSpecEvent(var2_1)

			if var3_1 == EducateSpecialEvent.TYPE_BUBBLE_DISCOUNT then
				getProxy(EducateProxy):GetShopProxy():AddDiscountEventById(var2_1)
			end

			arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE, {
				siteId = var0_1.siteId,
				id = var2_1,
				type = var3_1,
				drops = arg0_2.drops,
				cb = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger specEvent error: ", arg0_2.result))
		end
	end)
end

return var0_0
