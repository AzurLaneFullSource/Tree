local var0_0 = class("ActivityDreamlandOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy)
	local var2_1 = var1_1:getActivityById(var0_1.activity_id)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	print(var0_1.activity_id, var0_1.cmd, var0_1.arg1, var0_1.arg2)
	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd or 0,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1.cmd == DreamlandData.OP_GET_MAP_AWARD then
				table.insert(var2_1.data1_list, var0_1.arg1)
			elseif var0_1.cmd == DreamlandData.OP_GET_EXPLORE_AWARD then
				table.insert(var2_1.data2_list, var0_1.arg1)
			elseif var0_1.cmd == DreamlandData.OP_RECORD_EXPLORE then
				table.insert(var2_1.data3_list, var0_1.arg1)
			end

			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			var1_1:updateActivity(var2_1)
			arg0_1:sendNotification(GAME.ACTIVITY_DREAMLAND_OP_DONE, {
				activity = var2_1,
				cmd = var0_1.cmd,
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
