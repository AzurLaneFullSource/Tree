local var0 = class("ActivityBossExchangeTicketCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().stageId

	if not var0 then
		return
	end

	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var1 or var1:isEnd() then
		return
	end

	local var2 = pg.activity_event_worldboss[var1:getConfig("config_id")]

	if not var2 then
		return
	end

	local var3 = getProxy(PlayerProxy):getRawData()
	local var4 = var2.ticket

	if var3:getResource(var4) <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var1.id,
		arg1 = var0,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			getProxy(PlayerProxy):getRawData():consume({
				[id2res(var4)] = 1
			})
			arg0:sendNotification(GAME.ACT_BOSS_NORMAL_UPDATE, {
				num = 1,
				stageId = var0
			})
			arg0:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
