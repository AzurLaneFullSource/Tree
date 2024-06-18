local var0_0 = class("EventGiveUpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	if getProxy(EventProxy):findInfoById(var0_1):IsActivityType() then
		arg0_1:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
			arg2 = 0,
			cmd = ActivityConst.COLLETION_EVENT_OP_GIVE_UP,
			arg1 = var0_1,
			arg_list = {}
		})
	else
		pg.ConnectionMgr.GetInstance():Send(13007, {
			id = var0_1
		}, 13008, function(arg0_2)
			if arg0_2.result == 0 then
				var0_0.OnCancel(var0_1)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("event_giveup_fail", arg0_2.result))
			end
		end)
	end
end

function var0_0.OnCancel(arg0_3)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_giveup_success"))

	local var0_3, var1_3 = getProxy(EventProxy):findInfoById(arg0_3)

	var0_3.state = EventInfo.StateNone

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
end

return var0_0
