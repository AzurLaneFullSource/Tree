local var0_0 = class("MonopolyOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.autoFlag
	local var2_1 = var0_1.awardCollector
	local var3_1 = getProxy(ActivityProxy)
	local var4_1 = var3_1:getActivityById(var0_1.activity_id)

	if not var4_1 or var4_1:isEnd() then
		return
	end

	if var0_1.cmd == ActivityConst.MONOPOLY_OP_DIALOGUE and arg0_1:IsReadDialogue(var4_1, var0_1.arg1) then
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
			local var0_2 = var3_1:getActivityById(var0_1.activity_id)
			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			if var2_1 then
				var2_1:Add(var1_2)
			end

			local var2_2 = var0_1.cmd

			if var2_2 == ActivityConst.MONOPOLY_OP_AWARD then
				var0_2.data2_list[2] = var0_2.data2_list[2] + 1

				var3_1:updateActivity(var0_2)
				arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
					awards = var1_2,
					autoFlag = var1_1
				})
			else
				if var2_2 == ActivityConst.MONOPOLY_OP_LAST then
					var0_2.data2_list[3] = 1

					if #var1_2 > 0 then
						arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var1_2,
							autoFlag = var1_1,
							callback = function()
								return
							end
						})
					end

					if var0_1.callback then
						var0_1.callback()
					end
				end

				local var3_2 = {}
				local var4_2 = ""

				for iter0_2, iter1_2 in ipairs(arg0_2.number) do
					if iter0_2 > 2 then
						table.insert(var3_2, iter1_2)

						var4_2 = var4_2 .. "-" .. iter1_2
					end
				end

				local var5_2 = arg0_2.number[1]
				local var6_2 = arg0_2.number[2]
				local var7_2 = #var3_2 > 0 and var3_2[#var3_2] or var0_2.data2

				if table.contains(var3_2, 1) then
					var0_2.data1_list[3] = var0_2.data1_list[3] + 1
				end

				if var2_2 == ActivityConst.MONOPOLY_OP_THROW then
					print("点数 : ", var5_2)

					var0_2.data3 = var5_2
					var0_2.data1_list[2] = var0_2.data1_list[2] + 1

					local var8_2 = var0_2:getDataConfig("reward_time")
					local var9_2 = var0_2:getDataConfig("effective_times") or 0
					local var10_2

					if var9_2 ~= 0 then
						var10_2 = math.min(var0_2.data1_list[2], var9_2)
					else
						var10_2 = var0_2.data1_list[2]
					end

					if var8_2 > 0 then
						var0_2.data2_list[1] = math.floor(var10_2 / var8_2)
					else
						var0_2.data2_list[1] = 0
					end

					var3_1:updateActivity(var0_2)

					if var0_1.callback then
						var0_1.callback(var5_2)
					end
				elseif var2_2 == ActivityConst.MONOPOLY_OP_MOVE then
					var0_2.data3 = var5_2
					var0_2.data2 = var7_2
					var0_2.data4 = var6_2

					if var7_2 <= 1 then
						var0_2.data1_list[4] = 0
					end

					var3_1:updateActivity(var0_2)

					if var0_1.callback then
						var0_1.callback(var5_2, var3_2, var6_2)
					end
				elseif var2_2 == ActivityConst.MONOPOLY_OP_TRIGGER then
					local var11_2 = var0_1.callback or function(arg0_4, arg1_4)
						return
					end

					var0_2.data3 = var5_2
					var0_2.data2 = var7_2
					var0_2.data4 = var6_2 or 0

					var3_1:updateActivity(var0_2)

					if #var1_2 > 0 then
						arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var1_2,
							autoFlag = var1_1,
							callback = function()
								var11_2(var3_2, var6_2)
							end
						})
					else
						var11_2(var3_2, var6_2)
					end
				elseif var2_2 == ActivityConst.MONOPOLY_OP_PICK then
					local var12_2 = var0_1.callback or function(arg0_6, arg1_6)
						return
					end

					var0_2.data1_list[4] = var0_1.arg1

					if not table.contains(var0_2.data3_list, var0_1.arg1) then
						table.insert(var0_2.data3_list, var0_1.arg1)
					end

					var3_1:updateActivity(var0_2)

					if #var1_2 > 0 then
						arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var1_2,
							autoFlag = var1_1,
							callback = function()
								var12_2(var3_2, var6_2)
							end
						})
					else
						var12_2(var3_2, var6_2)
					end

					print("cmd : 6", " 路径 ： ", var4_2, "  剩余步数 ： ", var5_2)
				elseif var2_2 == ActivityConst.MONOPOLY_OP_DIALOGUE then
					if not table.contains(var0_2.data4_list, var0_1.arg1) then
						table.insert(var0_2.data4_list, var0_1.arg1)
					end

					var3_1:updateActivity(var0_2)
					print("cmd : 8", " 路径 ： ", var4_2, "  剩余步数 ： ", var5_2)
				elseif var2_2 == ActivityConst.MONOPOLY_OP_AUTO then
					var0_2.data1_list[5] = var0_1.arg1

					var3_1:updateActivity(var0_2)
					print("cmd : 7", " 路径 ： ", var4_2, "  剩余步数 ： ", var5_2)
				elseif var2_2 == ActivityConst.MONOPOLY_OP_ROUND_AWD then
					var0_2.data1_list[6] = var0_1.arg1

					var3_1:updateActivity(var0_2)

					if #var1_2 > 0 then
						arg0_1:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = var1_2,
							autoFlag = var1_1
						})
					end

					print("cmd : 9", " 路径 ： ", var4_2, "  剩余步数 ： ", var5_2)
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

function var0_0.IsReadDialogue(arg0_8, arg1_8, arg2_8)
	return table.contains(arg1_8.data4_list, arg2_8)
end

return var0_0
