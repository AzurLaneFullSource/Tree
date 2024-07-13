local var0_0 = class("ActivityBossExchangeTicketCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().stageId

	if not var0_1 then
		return
	end

	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var1_1 or var1_1:isEnd() then
		return
	end

	local var2_1 = pg.activity_event_worldboss[var1_1:getConfig("config_id")]

	if not var2_1 then
		return
	end

	local var3_1 = getProxy(PlayerProxy):getRawData()
	local var4_1 = var2_1.ticket

	if var3_1:getResource(var4_1) <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var1_1.id,
		arg1 = var0_1,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(PlayerProxy):getRawData():consume({
				[id2res(var4_1)] = 1
			})
			arg0_1:sendNotification(GAME.ACT_BOSS_NORMAL_UPDATE, {
				num = 1,
				stageId = var0_1
			})
			arg0_1:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
