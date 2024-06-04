local var0 = class("EventGiveUpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id

	if getProxy(EventProxy):findInfoById(var0):IsActivityType() then
		arg0:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
			arg2 = 0,
			cmd = ActivityConst.COLLETION_EVENT_OP_GIVE_UP,
			arg1 = var0,
			arg_list = {}
		})
	else
		pg.ConnectionMgr.GetInstance():Send(13007, {
			id = var0
		}, 13008, function(arg0)
			if arg0.result == 0 then
				var0.OnCancel(var0)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("event_giveup_fail", arg0.result))
			end
		end)
	end
end

function var0.OnCancel(arg0)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_giveup_success"))

	local var0, var1 = getProxy(EventProxy):findInfoById(arg0)

	var0.state = EventInfo.StateNone

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
end

return var0
