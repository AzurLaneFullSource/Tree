local var0_0 = class("ActivityNewPtOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy)
	local var3_1 = var2_1:getActivityById(var0_1.activity_id)

	if not var3_1 or var3_1:isEnd() then
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
			local var0_2 = {}

			if var0_1.cmd == 1 then
				var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)
				var3_1 = var2_1:getActivityById(var0_1.activity_id)

				table.insert(var3_1.data1_list, var0_1.arg1)

				if var3_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PIZZA_PT and var0_1.arg2 and var0_1.arg2 > 0 then
					table.insert(var3_1.data2_list, var0_1.arg2)
				end
			elseif var0_1.cmd == 2 then
				var3_1.data3 = arg0_2.number[1]
			elseif var0_1.cmd == 3 then
				var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)
				var3_1 = var2_1:getActivityById(var0_1.activity_id)

				if var0_1.arg1 and var0_1.arg1 > 0 then
					table.insert(var3_1.data2_list, var0_1.arg1)
				end

				local var1_2 = var0_1.oldBuffId or 0

				for iter0_2, iter1_2 in ipairs(var3_1.data3_list) do
					if iter1_2 == var1_2 then
						var3_1.data3_list[iter0_2] = var0_1.arg2
					end
				end
			elseif var0_1.cmd == 4 then
				var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)
				var3_1 = var2_1:getActivityById(var0_1.activity_id)

				local var2_2 = var3_1:getDataConfig("target")

				for iter2_2, iter3_2 in ipairs(var2_2) do
					if iter3_2 <= var0_1.arg1 then
						if not table.contains(var3_1.data1_list, iter3_2) then
							table.insert(var3_1.data1_list, iter3_2)
						end
					else
						break
					end
				end
			elseif var0_1.cmd == 5 then
				local var3_2 = arg0_2.number[1]

				var3_1.data1 = var3_1.data1 + var3_2

				local var4_2 = getProxy(PlayerProxy)
				local var5_2 = var4_2:getRawData()

				var5_2:consume({
					[id2res(var0_1.arg1)] = var3_2
				})
				var4_2:updatePlayer(var5_2)
			end

			var2_1:updateActivity(var3_1)
			arg0_1:sendNotification(GAME.ACT_NEW_PT_DONE, {
				awards = var0_2,
				callback = var1_1
			})
		else
			originalPrint(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
