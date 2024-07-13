local var0_0 = class("TaskOneStepSubmitOPCommand", pm.SimpleCommand)

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

		seriesAsync({
			function(arg0_2)
				if #var1_1 > 0 then
					pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
						resultList = var0_1,
						callback = arg0_2
					})
				else
					arg0_2()
				end
			end,
			function(arg0_3)
				if #var2_1 > 0 then
					arg0_1:emit(TaskMediator.ON_BATCH_SUBMIT_WEEK_TASK, var2_1, arg0_3)
				else
					arg0_3()
				end
			end
		})
	end
end

return var0_0
