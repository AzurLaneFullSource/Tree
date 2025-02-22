local var0_0 = class("FetchNpcShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(TaskProxy):getTaskById(var1_1)

	if not var3_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var1_1))

		return
	end

	if not var3_1:isFinish() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_notFinish"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(20205, {
		act_id = var3_1:getActId(),
		task_ids = {
			var3_1.id
		}
	}, 20206, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.award_list) do
				table.insert(var0_2, Drop.New({
					type = iter1_2.type,
					id = iter1_2.id,
					count = iter1_2.number
				}))
			end

			arg0_1:sendNotification(GAME.FETCH_NPC_SHIP_DONE, {
				items = var0_2,
				callback = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0_2.result))
		end
	end)
end

return var0_0
