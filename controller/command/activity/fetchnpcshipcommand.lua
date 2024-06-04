local var0 = class("FetchNpcShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.taskId
	local var2 = var0.callback
	local var3 = getProxy(TaskProxy)
	local var4 = var3:getTaskById(var1)

	if not var4 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var1))

		return
	end

	if not var4:isFinish() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_notFinish"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(20005, {
		id = var4.id,
		choice_award = {}
	}, 20006, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.award_list) do
				table.insert(var0, Drop.New({
					type = iter1.type,
					id = iter1.id,
					count = iter1.number
				}))
			end

			var4.submitTime = 1

			var3:updateTask(var4)
			arg0:sendNotification(GAME.FETCH_NPC_SHIP_DONE, {
				items = var0,
				callback = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0.result))
		end
	end)
end

return var0
