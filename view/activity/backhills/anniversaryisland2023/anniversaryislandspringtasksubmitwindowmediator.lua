local var0_0 = class("AnniversaryIslandSpringTaskSubmitWindowMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, function(arg0_2)
		arg0_1:sendNotification(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, arg0_1.contextData.task)
	end)
	arg0_1:bind(WorkBenchItemDetailMediator.SHOW_DETAIL, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1_3
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_5.viewComponent:closeView()
	end
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
