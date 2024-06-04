local var0 = class("EventStartCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.shipIds
	local var3 = getProxy(EventProxy)
	local var4 = var3:findInfoById(var1)
	local var5 = var4:IsActivityType()

	if not var5 and var3.busyFleetNums >= var3.maxFleetNums then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	local var6, var7 = var3:CanJoinEvent(var4)

	if not var6 then
		if var7 then
			pg.TipsMgr.GetInstance():ShowTips(var7)
		end

		return
	end

	local function var8()
		if var5 then
			arg0:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
				arg2 = 0,
				cmd = ActivityConst.COLLETION_EVENT_OP_JOIN,
				arg1 = var1,
				arg_list = var2
			})
		else
			pg.ConnectionMgr.GetInstance():Send(13003, {
				id = var1,
				ship_id_list = var2
			}, 13004, function(arg0)
				if arg0.result == 0 then
					var0.OnStart(var1)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("event_start_fail", arg0.result))
				end
			end)
		end
	end

	local var9 = var4:getOilConsume()

	if var9 > 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("event_oil_consume", var9),
			onYes = var8
		})
	else
		var8()
	end
end

function var0.OnStart(arg0)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_start_success"))

	local var0 = getProxy(EventProxy):findInfoById(arg0)
	local var1 = getProxy(PlayerProxy)
	local var2 = var1:getData()

	var0.finishTime = pg.TimeMgr.GetInstance():GetServerTime() + var0.template.collect_time
	var0.state = EventInfo.StateActive

	local var3 = var0:getOilConsume()

	var2:consume({
		oil = var3
	})
	var1:updatePlayer(var2)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
end

return var0
