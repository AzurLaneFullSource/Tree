local var0 = class("BlackWhiteGridOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.activityId
	local var3 = var0.cmd
	local var4 = var0.score

	if var4 < 0 then
		return
	end

	local var5 = getProxy(ActivityProxy)
	local var6 = var5:getActivityById(var2)

	if not var6 or var6:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2,
		arg1 = var1,
		arg2 = var4,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			if not table.contains(var6.data1_list, var1) then
				table.insert(var6.data1_list, var1)
			end

			local var1 = table.indexof(var6.data1_list, var1)

			assert(var1)

			var6.data2_list[var1] = var4

			var5:updateActivity(var6)
			arg0:sendNotification(GAME.BLACK_WHITE_GRID_OP_DONE, {
				awards = var0
			})
		else
			originalPrint(arg0.result)
		end
	end)
end

return var0
