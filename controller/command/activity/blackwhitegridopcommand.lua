local var0_0 = class("BlackWhiteGridOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.activityId
	local var3_1 = var0_1.cmd
	local var4_1 = var0_1.score

	if var4_1 < 0 then
		return
	end

	local var5_1 = getProxy(ActivityProxy)
	local var6_1 = var5_1:getActivityById(var2_1)

	if not var6_1 or var6_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2_1,
		arg1 = var1_1,
		arg2 = var4_1,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			if not table.contains(var6_1.data1_list, var1_1) then
				table.insert(var6_1.data1_list, var1_1)
			end

			local var1_2 = table.indexof(var6_1.data1_list, var1_1)

			assert(var1_2)

			var6_1.data2_list[var1_2] = var4_1

			var5_1:updateActivity(var6_1)
			arg0_1:sendNotification(GAME.BLACK_WHITE_GRID_OP_DONE, {
				awards = var0_2
			})
		else
			originalPrint(arg0_2.result)
		end
	end)
end

return var0_0
