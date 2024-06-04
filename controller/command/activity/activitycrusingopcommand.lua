local var0 = class("ActivityCrusingOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = getProxy(ActivityProxy)
	local var3 = var2:getActivityById(var0.activity_id)

	if not var3 or var3:isEnd() then
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
			local var0 = {}

			if var0.cmd == 1 then
				-- block empty
			elseif var0.cmd == 2 then
				var0 = PlayerConst.addTranDrop(arg0.award_list)

				table.insert(var3.data1_list, var0.arg1)
			elseif var0.cmd == 3 then
				var0 = PlayerConst.addTranDrop(arg0.award_list)

				table.insert(var3.data2_list, var0.arg1)
			elseif var0.cmd == 4 then
				var0 = PlayerConst.addTranDrop(arg0.award_list)
				var3.data1_list = {}

				for iter0, iter1 in ipairs(pg.battlepass_event_pt[var3.id].target) do
					if iter1 <= var3.data1 then
						table.insert(var3.data1_list, iter1)
					else
						break
					end
				end

				if var3.data2 == 1 then
					var3.data2_list = underscore.rest(var3.data1_list, 1)
				end
			end

			var2:updateActivity(var3)
			arg0:sendNotification(GAME.CRUSING_CMD_DONE, {
				awards = var0,
				callback = var1
			})
		else
			originalPrint(errorTip("", arg0.result))
		end
	end)
end

return var0
