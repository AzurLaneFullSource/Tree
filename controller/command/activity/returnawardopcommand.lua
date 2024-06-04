local var0 = class("ReturnAwardOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy)
	local var2 = var1:getActivityById(var0.activity_id)

	if not var2 or var2:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd or 0,
		arg1 = var0.arg1 or 0,
		arg2 = var0.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			if var0.cmd == ActivityConst.RETURN_AWARD_OP_ACTIVTION then
				var2.data1 = 1
			elseif var0.cmd == ActivityConst.RETURN_AWARD_OP_GET_RETRUNERS then
				local var1 = {}

				for iter0, iter1 in ipairs(arg0.return_user_list) do
					table.insert(var1, Returner.New(iter1))
				end

				var2:setClientList(var1)
			elseif var0.cmd == ActivityConst.RETURN_AWARD_OP_GET_AWARD then
				table.insert(var2.data1_list, var0.arg1)
			elseif var0.cmd == ActivityConst.RETURN_AWARD_OP_PUSH_UID then
				var2.data2_list[1] = 1

				pg.TipsMgr.GetInstance():ShowTips(i18n("returner_push_success"))
			elseif var0.cmd == ActivityConst.RETURN_AWARD_OP_ACCEPT_TASK then
				-- block empty
			elseif var0.cmd == ActivityConst.RETURN_AWARD_OP_SET_RETRUNER then
				var2.data2 = var0.arg1

				pg.TipsMgr.GetInstance():ShowTips(i18n("return_award_bind_success"))
			elseif var0.cmd == ActivityConst.RETURN_AWARD_OP_RETURNER_GET_AWARD then
				local var2 = pg.activity_template_returnner[var2.id].task_list

				var2.data4 = math.min(var2.data4 + 1, #var2)
			elseif var0.cmd == ActivityConst.RETURN_AWARD_OP_MATCH then
				var2.data2 = arg0.number[1]

				pg.TipsMgr.GetInstance():ShowTips(i18n("return_award_bind_success"))
			end

			var1:updateActivity(var2)
			arg0:sendNotification(GAME.RETURN_AWARD_OP_DONE, {
				awards = var0,
				id = var2.id,
				cmd = var0.cmd
			})
		elseif ERROR_MESSAGE[arg0.result] then
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result])
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[9999] .. arg0.result)
		end
	end)
end

return var0
