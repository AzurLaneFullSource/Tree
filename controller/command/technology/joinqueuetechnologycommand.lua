local var0 = class("JoinQueueTechnologyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.pool_id
	local var3 = getProxy(TechnologyProxy)

	if #var3.queue >= TechnologyConst.QUEUE_TOTAL_COUNT then
		return
	end

	local var4 = var3:getTechnologyById(var1)

	if not var4 or not var4:isActivate() or not var4:finishCondition() or var4:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63013, {
		tech_id = var1,
		refresh_id = var2
	}, 63014, function(arg0)
		if arg0.result == 0 then
			var3:moveTechnologyToQueue(var1)
			var3:updateTechnologys(arg0.refresh_list)
			arg0:sendNotification(GAME.JOIN_QUEUE_TECHNOLOGY_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_in_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_stop_erro") .. arg0.result)
		end
	end)
end

return var0
