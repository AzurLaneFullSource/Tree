local var0 = class("SubmitWeekTaskProgressCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(TaskProxy):GetWeekTaskProgressInfo()

	if not var1:CanUpgrade() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20110, {
		id = 0
	}, 20111, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			var1:Upgrade()
			arg0:sendNotification(GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
