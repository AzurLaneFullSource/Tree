local var0_0 = class("EventStartCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().event
	local var1_1 = var0_1.id
	local var2_1 = var0_1.shipIds
	local var3_1 = getProxy(EventProxy)
	local var4_1 = var0_1:IsActivityType()

	if not var4_1 and not var3_1:CanStartEvent() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	local var5_1, var6_1 = var3_1:CanJoinEvent(var0_1)

	if not var5_1 then
		if var6_1 then
			pg.TipsMgr.GetInstance():ShowTips(var6_1)
		end

		return
	end

	local function var7_1()
		if var4_1 then
			arg0_1:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
				arg2 = 0,
				cmd = ActivityConst.COLLETION_EVENT_OP_JOIN,
				arg1 = var1_1,
				arg_list = var2_1,
				event = var0_1
			})
		else
			pg.ConnectionMgr.GetInstance():Send(13003, {
				id = var1_1,
				ship_id_list = var2_1
			}, 13004, function(arg0_3)
				if arg0_3.result == 0 then
					var0_0.OnStart(var0_1)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("event_start_fail", arg0_3.result))
				end
			end)
		end
	end

	local var8_1 = var0_1:getOilConsume()

	if var8_1 > 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("event_oil_consume", var8_1),
			onYes = var7_1
		})
	else
		var7_1()
	end
end

function var0_0.OnStart(arg0_4)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_start_success"))

	local var0_4 = getProxy(EventProxy)
	local var1_4 = getProxy(PlayerProxy)
	local var2_4 = var1_4:getData()
	local var3_4 = arg0_4:getOilConsume()

	var2_4:consume({
		oil = var3_4
	})
	var1_4:updatePlayer(var2_4)

	arg0_4.finishTime = pg.TimeMgr.GetInstance():GetServerTime() + arg0_4.template.collect_time

	var0_4:updateInfoList({
		arg0_4
	})
end

return var0_0
