local var0 = class("MergeTaskOneStepAwardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().resultList

	if #var0 > 0 then
		local var1 = {}
		local var2 = {}

		for iter0, iter1 in ipairs(var0) do
			if iter1.isWeekTask then
				table.insert(var2, iter1.id)
			else
				table.insert(var1, iter1)
			end
		end

		local var3 = {}

		local function var4(arg0)
			for iter0, iter1 in ipairs(arg0) do
				table.insert(var3, iter1)
			end
		end

		seriesAsync({
			function(arg0)
				if #var1 <= 0 then
					arg0()

					return
				end

				arg0:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
					dontSendMsg = true,
					resultList = var1,
					callback = function(arg0)
						var4(arg0)
						arg0()
					end
				})
			end,
			function(arg0)
				if #var2 <= 0 then
					arg0()

					return
				end

				arg0:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK, {
					dontSendMsg = true,
					ids = var2,
					callback = function(arg0)
						var4(arg0)
						arg0()
					end
				})
			end
		}, function()
			local var0 = _.map(var1, function(arg0)
				return arg0.id
			end)

			arg0:sendNotification(GAME.MERGE_TASK_ONE_STEP_AWARD_DONE, {
				awards = var3,
				taskIds = var0
			})
		end)
	end
end

return var0
