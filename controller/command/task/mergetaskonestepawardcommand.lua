local var0_0 = class("MergeTaskOneStepAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().resultList

	if #var0_1 > 0 then
		local var1_1 = {}
		local var2_1 = {}

		for iter0_1, iter1_1 in ipairs(var0_1) do
			if iter1_1.isWeekTask then
				table.insert(var2_1, iter1_1.id)
			else
				table.insert(var1_1, iter1_1)
			end
		end

		local var3_1 = {}

		local function var4_1(arg0_2)
			for iter0_2, iter1_2 in ipairs(arg0_2) do
				table.insert(var3_1, iter1_2)
			end
		end

		seriesAsync({
			function(arg0_3)
				if #var1_1 <= 0 then
					arg0_3()

					return
				end

				arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
					dontSendMsg = true,
					resultList = var1_1,
					callback = function(arg0_4)
						var4_1(arg0_4)
						arg0_3()
					end
				})
			end,
			function(arg0_5)
				if #var2_1 <= 0 then
					arg0_5()

					return
				end

				arg0_1:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK, {
					dontSendMsg = true,
					ids = var2_1,
					callback = function(arg0_6)
						var4_1(arg0_6)
						arg0_5()
					end
				})
			end
		}, function()
			local var0_7 = _.map(var1_1, function(arg0_8)
				return arg0_8.id
			end)

			arg0_1:sendNotification(GAME.MERGE_TASK_ONE_STEP_AWARD_DONE, {
				awards = var3_1,
				taskIds = var0_7
			})
		end)
	end
end

return var0_0
