local var0_0 = class("LaunchBallTaskMediator", import("..base.ContextMediator"))

var0_0.SUBMIT_ALL = "SUBMIT_ALL"

function var0_0.register(arg0_1)
	arg0_1:bind(LaunchBallTaskMediator.SUBMIT_ALL, function(arg0_2, arg1_2)
		arg0_1.submit = #arg1_2
		arg0_1.awards = {}

		for iter0_2 = 1, #arg1_2 do
			arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2[iter0_2].id)
		end
	end)
end

function var0_0.onUIAvalible(arg0_3)
	return
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.SUBMIT_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.SUBMIT_AVATAR_TASK_DONE then
		if #var1_5.awards > 0 then
			arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards)
		end

		if var1_5.callback then
			-- block empty
		end

		arg0_5.viewComponent:updateTask(true)
	elseif var0_5 == GAME.SUBMIT_TASK_DONE then
		if arg0_5.submit and arg0_5.submit > 0 then
			for iter0_5 = 1, #var1_5 do
				table.insert(arg0_5.awards, var1_5[iter0_5])
			end

			arg0_5.submit = arg0_5.submit - 1

			if arg0_5.submit == 0 then
				arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_5.awards, function()
					arg0_5.viewComponent:updateTasks()
				end)
			end
		else
			arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5, function()
				arg0_5.viewComponent:updateTasks()
			end)
		end
	end
end

return var0_0
