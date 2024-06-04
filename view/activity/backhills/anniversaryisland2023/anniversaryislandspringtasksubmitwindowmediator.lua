local var0 = class("AnniversaryIslandSpringTaskSubmitWindowMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, function(arg0)
		arg0:sendNotification(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, arg0.contextData.task)
	end)
	arg0:bind(WorkBenchItemDetailMediator.SHOW_DETAIL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_AVATAR_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_AVATAR_TASK_DONE then
		arg0.viewComponent:closeView()
	end
end

function var0.remove(arg0)
	return
end

return var0
