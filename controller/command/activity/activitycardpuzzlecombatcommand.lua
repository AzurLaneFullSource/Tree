local var0 = class("ActivityCardPuzzleCombatCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = getProxy(ActivityProxy):getActivityById(var0.activity_id)

	if not var2 or var2:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		arg2 = 0,
		activity_id = var0.activity_id,
		arg1 = var0.arg1,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			if not table.contains(var2.data2_list, var0.arg1) then
				table.insert(var2.data2_list, var0.arg1)
				getProxy(ActivityProxy):updateActivity(var2)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
