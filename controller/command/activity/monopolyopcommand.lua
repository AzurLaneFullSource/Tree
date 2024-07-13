local var0_0 = class("MonopolyOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy)
	local var2_1 = var1_1:getActivityById(var0_1.activity_id)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)
			local var1_2 = var0_1.cmd

			if var1_2 == ActivityConst.MONOPOLY_OP_AWARD then
				var2_1.data2_list[2] = var2_1.data2_list[2] + 1

				var1_1:updateActivity(var2_1)
				arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
					awards = var0_2
				})
			else
				if var1_2 == ActivityConst.MONOPOLY_OP_LAST then
					var2_1.data2_list[3] = 1

					if #var0_2 > 0 then
						arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var0_2,
							callback = function()
								return
							end
						})
					end

					if var0_1.callback then
						var0_1.callback()
					end
				end

				local var2_2 = {}
				local var3_2 = ""

				for iter0_2, iter1_2 in ipairs(arg0_2.number) do
					if iter0_2 > 2 then
						table.insert(var2_2, iter1_2)

						var3_2 = var3_2 .. "-" .. iter1_2
					end
				end

				local var4_2 = arg0_2.number[1]
				local var5_2 = arg0_2.number[2]
				local var6_2 = #var2_2 > 0 and var2_2[#var2_2] or var2_1.data2

				if table.contains(var2_2, 1) then
					var2_1.data1_list[3] = var2_1.data1_list[3] + 1
				end

				if var1_2 == ActivityConst.MONOPOLY_OP_THROW then
					var2_1.data3 = var4_2
					var2_1.data1_list[2] = var2_1.data1_list[2] + 1

					local var7_2 = var2_1:getDataConfig("reward_time")
					local var8_2 = var2_1:getDataConfig("effective_times") or 0
					local var9_2

					if var8_2 ~= 0 then
						var9_2 = math.min(var2_1.data1_list[2], var8_2)
					else
						var9_2 = var2_1.data1_list[2]
					end

					if var7_2 > 0 then
						var2_1.data2_list[1] = math.floor(var9_2 / var7_2)
					else
						var2_1.data2_list[1] = 0
					end

					var1_1:updateActivity(var2_1)

					if var0_1.callback then
						var0_1.callback(var4_2)
					end
				elseif var1_2 == ActivityConst.MONOPOLY_OP_MOVE then
					var2_1.data3 = var4_2
					var2_1.data2 = var6_2
					var2_1.data4 = var5_2

					var1_1:updateActivity(var2_1)

					if var0_1.callback then
						var0_1.callback(var4_2, var2_2, var5_2)
					end
				elseif var1_2 == ActivityConst.MONOPOLY_OP_TRIGGER then
					local var10_2 = var0_1.callback or function(arg0_4, arg1_4)
						return
					end

					var2_1.data3 = var4_2
					var2_1.data2 = var6_2
					var2_1.data4 = var5_2 or 0

					var1_1:updateActivity(var2_1)

					if #var0_2 > 0 then
						arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var0_2,
							callback = function()
								var10_2(var2_2, var5_2)
							end
						})
					else
						var10_2(var2_2, var5_2)
					end
				end
			end
		else
			if var0_1.callback then
				var0_1.callback()
			end

			originalPrint("Monopoly Activity erro code" .. arg0_2.result .. " cmd:" .. var0_1.cmd)
		end
	end)
end

return var0_0
