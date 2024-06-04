local var0 = class("LaunchBallTaskMediator", import("..base.ContextMediator"))

var0.SUBMIT_ALL = "SUBMIT_ALL"

function var0.register(arg0)
	arg0:bind(LaunchBallTaskMediator.SUBMIT_ALL, function(arg0, arg1)
		arg0.submit = #arg1
		arg0.awards = {}

		for iter0 = 1, #arg1 do
			arg0:sendNotification(GAME.SUBMIT_TASK, arg1[iter0].id)
		end
	end)
end

function var0.onUIAvalible(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_AVATAR_TASK_DONE then
		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end

		if var1.callback then
			-- block empty
		end

		arg0.viewComponent:updateTask(true)
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		if arg0.submit and arg0.submit > 0 then
			for iter0 = 1, #var1 do
				table.insert(arg0.awards, var1[iter0])
			end

			arg0.submit = arg0.submit - 1

			if arg0.submit == 0 then
				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0.awards, function()
					arg0.viewComponent:updateTasks()
				end)
			end
		else
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
				arg0.viewComponent:updateTasks()
			end)
		end
	end
end

return var0
