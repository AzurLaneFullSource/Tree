local var0_0 = class("ReturnAwardOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy)
	local var2_1 = var1_1:getActivityById(var0_1.activity_id)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd or 0,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			if var0_1.cmd == ActivityConst.RETURN_AWARD_OP_ACTIVTION then
				var2_1.data1 = 1
			elseif var0_1.cmd == ActivityConst.RETURN_AWARD_OP_GET_RETRUNERS then
				local var1_2 = {}

				for iter0_2, iter1_2 in ipairs(arg0_2.return_user_list) do
					table.insert(var1_2, Returner.New(iter1_2))
				end

				var2_1:setClientList(var1_2)
			elseif var0_1.cmd == ActivityConst.RETURN_AWARD_OP_GET_AWARD then
				table.insert(var2_1.data1_list, var0_1.arg1)
			elseif var0_1.cmd == ActivityConst.RETURN_AWARD_OP_PUSH_UID then
				var2_1.data2_list[1] = 1

				pg.TipsMgr.GetInstance():ShowTips(i18n("returner_push_success"))
			elseif var0_1.cmd == ActivityConst.RETURN_AWARD_OP_ACCEPT_TASK then
				-- block empty
			elseif var0_1.cmd == ActivityConst.RETURN_AWARD_OP_SET_RETRUNER then
				var2_1.data2 = var0_1.arg1

				pg.TipsMgr.GetInstance():ShowTips(i18n("return_award_bind_success"))
			elseif var0_1.cmd == ActivityConst.RETURN_AWARD_OP_RETURNER_GET_AWARD then
				local var2_2 = pg.activity_template_returnner[var2_1.id].task_list

				var2_1.data4 = math.min(var2_1.data4 + 1, #var2_2)
			elseif var0_1.cmd == ActivityConst.RETURN_AWARD_OP_MATCH then
				var2_1.data2 = arg0_2.number[1]

				pg.TipsMgr.GetInstance():ShowTips(i18n("return_award_bind_success"))
			end

			var1_1:updateActivity(var2_1)
			arg0_1:sendNotification(GAME.RETURN_AWARD_OP_DONE, {
				awards = var0_2,
				id = var2_1.id,
				cmd = var0_1.cmd
			})
		elseif ERROR_MESSAGE[arg0_2.result] then
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result])
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[9999] .. arg0_2.result)
		end
	end)
end

return var0_0
