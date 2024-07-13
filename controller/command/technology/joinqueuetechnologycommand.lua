local var0_0 = class("JoinQueueTechnologyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.pool_id
	local var3_1 = getProxy(TechnologyProxy)

	if #var3_1.queue >= TechnologyConst.QUEUE_TOTAL_COUNT then
		return
	end

	local var4_1 = var3_1:getTechnologyById(var1_1)

	if not var4_1 or not var4_1:isActivate() or not var4_1:finishCondition() or var4_1:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63013, {
		tech_id = var1_1,
		refresh_id = var2_1
	}, 63014, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:moveTechnologyToQueue(var1_1)
			var3_1:updateTechnologys(arg0_2.refresh_list)
			arg0_1:sendNotification(GAME.JOIN_QUEUE_TECHNOLOGY_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_in_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_stop_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
