local var0 = class("MonopolyOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy)
	local var2 = var1:getActivityById(var0.activity_id)

	if not var2 or var2:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)
			local var1 = var0.cmd

			if var1 == ActivityConst.MONOPOLY_OP_AWARD then
				var2.data2_list[2] = var2.data2_list[2] + 1

				var1:updateActivity(var2)
				arg0:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
					awards = var0
				})
			else
				if var1 == ActivityConst.MONOPOLY_OP_LAST then
					var2.data2_list[3] = 1

					if #var0 > 0 then
						arg0:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var0,
							callback = function()
								return
							end
						})
					end

					if var0.callback then
						var0.callback()
					end
				end

				local var2 = {}
				local var3 = ""

				for iter0, iter1 in ipairs(arg0.number) do
					if iter0 > 2 then
						table.insert(var2, iter1)

						var3 = var3 .. "-" .. iter1
					end
				end

				local var4 = arg0.number[1]
				local var5 = arg0.number[2]
				local var6 = #var2 > 0 and var2[#var2] or var2.data2

				if table.contains(var2, 1) then
					var2.data1_list[3] = var2.data1_list[3] + 1
				end

				if var1 == ActivityConst.MONOPOLY_OP_THROW then
					var2.data3 = var4
					var2.data1_list[2] = var2.data1_list[2] + 1

					local var7 = var2:getDataConfig("reward_time")
					local var8 = var2:getDataConfig("effective_times") or 0
					local var9

					if var8 ~= 0 then
						var9 = math.min(var2.data1_list[2], var8)
					else
						var9 = var2.data1_list[2]
					end

					if var7 > 0 then
						var2.data2_list[1] = math.floor(var9 / var7)
					else
						var2.data2_list[1] = 0
					end

					var1:updateActivity(var2)

					if var0.callback then
						var0.callback(var4)
					end
				elseif var1 == ActivityConst.MONOPOLY_OP_MOVE then
					var2.data3 = var4
					var2.data2 = var6
					var2.data4 = var5

					var1:updateActivity(var2)

					if var0.callback then
						var0.callback(var4, var2, var5)
					end
				elseif var1 == ActivityConst.MONOPOLY_OP_TRIGGER then
					local var10 = var0.callback or function(arg0, arg1)
						return
					end

					var2.data3 = var4
					var2.data2 = var6
					var2.data4 = var5 or 0

					var1:updateActivity(var2)

					if #var0 > 0 then
						arg0:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var0,
							callback = function()
								var10(var2, var5)
							end
						})
					else
						var10(var2, var5)
					end
				end
			end
		else
			if var0.callback then
				var0.callback()
			end

			originalPrint("Monopoly Activity erro code" .. arg0.result .. " cmd:" .. var0.cmd)
		end
	end)
end

return var0
