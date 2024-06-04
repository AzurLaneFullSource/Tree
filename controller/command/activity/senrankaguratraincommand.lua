local var0 = class("SenrankaguraTrainCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = getProxy(ActivityProxy):getActivityById(var1)

	if not var2 or var2:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1,
		cmd = var0.cmd,
		arg1 = var0.arg1 or 0,
		arg2 = var0.arg2 or 0,
		arg3 = var0.arg3 or 0,
		arg_list = var0.arg_list or {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			if var0.cmd == 1 then
				for iter0, iter1 in pairs(var0.arg_list) do
					table.insert(var2.data2_list, iter1)
				end
			elseif var0.cmd == 2 then
				var2.data1_list[var0.arg1] = var2.data1_list[var0.arg1] + 1
				var2.data1 = var2.data1 - var0.cost

				for iter2, iter3 in pairs(var0.arg_list) do
					table.insert(var2.data2_list, iter3)
				end
			end

			getProxy(ActivityProxy):updateActivity(var2)

			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			arg0:sendNotification(GAME.SENRANKAGURA_TRAIN_ACT_OP_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
