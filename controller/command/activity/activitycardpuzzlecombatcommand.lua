local var0_0 = class("ActivityCardPuzzleCombatCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		arg2 = 0,
		activity_id = var0_1.activity_id,
		arg1 = var0_1.arg1,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if not table.contains(var2_1.data2_list, var0_1.arg1) then
				table.insert(var2_1.data2_list, var0_1.arg1)
				getProxy(ActivityProxy):updateActivity(var2_1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
