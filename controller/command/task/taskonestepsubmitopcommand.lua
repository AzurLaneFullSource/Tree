local var0 = class("TaskOneStepSubmitOPCommand", pm.SimpleCommand)

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

		seriesAsync({
			function(arg0)
				if #var1 > 0 then
					pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
						resultList = var0,
						callback = arg0
					})
				else
					arg0()
				end
			end,
			function(arg0)
				if #var2 > 0 then
					arg0:emit(TaskMediator.ON_BATCH_SUBMIT_WEEK_TASK, var2, arg0)
				else
					arg0()
				end
			end
		})
	end
end

return var0
