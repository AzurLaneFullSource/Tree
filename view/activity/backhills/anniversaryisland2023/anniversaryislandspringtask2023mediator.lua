local var0 = class("AnniversaryIslandSpringTask2023Mediator", import("view.base.ContextMediator"))

var0.SUBMIT_TASK = "activity submit task "
var0.TASK_GO = "activity task go "
var0.SHOW_DETAIL = "activity task show detail"
var0.SHOW_SUBMIT_WINDOW = "AnniversaryIslandSpringTask2023Mediator:SHOW_SUBMIT_WINDOW"

function var0.register(arg0)
	arg0:bind(var0.SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1.actId,
			task_ids = {
				arg1.id
			}
		})
	end)
	arg0:bind(var0.TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1.taskVO
		})
	end)
	arg0:bind(var0.SHOW_DETAIL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1
			}
		}))
	end)
	arg0:bind(var0.SHOW_SUBMIT_WINDOW, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = AnniversaryIslandSpringTaskSubmitWindowMediator,
			viewComponent = AnniversaryIslandSpringTaskSubmitWindow,
			data = {
				task = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK,
		GAME.SUBMIT_AVATAR_TASK_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK then
		arg0.viewComponent:emit(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, var1)
	elseif var0 == GAME.SUBMIT_AVATAR_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, function()
			existCall(var1.callback)

			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)
			local var1 = var0:GetUnlockTaskIds()
			local var2 = var0:GetConfigID()
			local var3 = getProxy(ActivityTaskProxy):getTaskVOsByActId(var2)

			if _.all(var1, function(arg0)
				local var0 = _.detect(var3, function(arg0)
					return arg0:GetConfigID() == arg0
				end)

				return var0 and var0:isOver()
			end) then
				arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.ANNIVERSARY_ISLAND_SPRING)
			end
		end)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		arg0.viewComponent:BuildTaskVOs()
		arg0.viewComponent:UpdateView()
	end
end

function var0.remove(arg0)
	return
end

return var0
