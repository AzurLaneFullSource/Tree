local var0_0 = class("SenrankaguraTrainCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = getProxy(ActivityProxy):getActivityById(var1_1)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1_1,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg3 = var0_1.arg3 or 0,
		arg_list = var0_1.arg_list or {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1.cmd == 1 then
				for iter0_2, iter1_2 in pairs(var0_1.arg_list) do
					table.insert(var2_1.data2_list, iter1_2)
				end
			elseif var0_1.cmd == 2 then
				var2_1.data1_list[var0_1.arg1] = var2_1.data1_list[var0_1.arg1] + 1
				var2_1.data1 = var2_1.data1 - var0_1.cost

				for iter2_2, iter3_2 in pairs(var0_1.arg_list) do
					table.insert(var2_1.data2_list, iter3_2)
				end
			end

			getProxy(ActivityProxy):updateActivity(var2_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			arg0_1:sendNotification(GAME.SENRANKAGURA_TRAIN_ACT_OP_DONE, var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
