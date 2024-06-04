local var0 = class("ActivityNewPtOPCommand", pm.SimpleCommand)

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
				var0 = PlayerConst.addTranDrop(arg0.award_list)
				var3 = var2:getActivityById(var0.activity_id)

				table.insert(var3.data1_list, var0.arg1)

				if var3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PIZZA_PT and var0.arg2 and var0.arg2 > 0 then
					table.insert(var3.data2_list, var0.arg2)
				end
			elseif var0.cmd == 2 then
				var3.data3 = arg0.number[1]
			elseif var0.cmd == 3 then
				var0 = PlayerConst.addTranDrop(arg0.award_list)
				var3 = var2:getActivityById(var0.activity_id)

				if var0.arg1 and var0.arg1 > 0 then
					table.insert(var3.data2_list, var0.arg1)
				end

				local var1 = var0.oldBuffId or 0

				for iter0, iter1 in ipairs(var3.data3_list) do
					if iter1 == var1 then
						var3.data3_list[iter0] = var0.arg2
					end
				end
			elseif var0.cmd == 4 then
				var0 = PlayerConst.addTranDrop(arg0.award_list)
				var3 = var2:getActivityById(var0.activity_id)

				local var2 = var3:getDataConfig("target")

				for iter2, iter3 in ipairs(var2) do
					if iter3 <= var0.arg1 then
						if not table.contains(var3.data1_list, iter3) then
							table.insert(var3.data1_list, iter3)
						end
					else
						break
					end
				end
			elseif var0.cmd == 5 then
				local var3 = arg0.number[1]

				var3.data1 = var3.data1 + var3

				local var4 = getProxy(PlayerProxy)
				local var5 = var4:getRawData()

				var5:consume({
					[id2res(var0.arg1)] = var3
				})
				var4:updatePlayer(var5)
			end

			var2:updateActivity(var3)
			arg0:sendNotification(GAME.ACT_NEW_PT_DONE, {
				awards = var0,
				callback = var1
			})
		else
			originalPrint(errorTip("", arg0.result))
		end
	end)
end

return var0
