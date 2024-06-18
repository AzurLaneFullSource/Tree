local var0_0 = class("AnniversaryIslandSpringTask2023Mediator", import("view.base.ContextMediator"))

var0_0.SUBMIT_TASK = "activity submit task "
var0_0.TASK_GO = "activity task go "
var0_0.SHOW_DETAIL = "activity task show detail"
var0_0.SHOW_SUBMIT_WINDOW = "AnniversaryIslandSpringTask2023Mediator:SHOW_SUBMIT_WINDOW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1_2.actId,
			task_ids = {
				arg1_2.id
			}
		})
	end)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_3.taskVO
		})
	end)
	arg0_1:bind(var0_0.SHOW_DETAIL, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.SHOW_SUBMIT_WINDOW, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = AnniversaryIslandSpringTaskSubmitWindowMediator,
			viewComponent = AnniversaryIslandSpringTaskSubmitWindow,
			data = {
				task = arg1_5
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK,
		GAME.SUBMIT_AVATAR_TASK_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK then
		arg0_7.viewComponent:emit(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, var1_7)
	elseif var0_7 == GAME.SUBMIT_AVATAR_TASK_DONE then
		arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_7.awards, function()
			existCall(var1_7.callback)

			local var0_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)
			local var1_8 = var0_8:GetUnlockTaskIds()
			local var2_8 = var0_8:GetConfigID()
			local var3_8 = getProxy(ActivityTaskProxy):getTaskVOsByActId(var2_8)

			if _.all(var1_8, function(arg0_9)
				local var0_9 = _.detect(var3_8, function(arg0_10)
					return arg0_10:GetConfigID() == arg0_9
				end)

				return var0_9 and var0_9:isOver()
			end) then
				arg0_7:sendNotification(GAME.CHANGE_SCENE, SCENE.ANNIVERSARY_ISLAND_SPRING)
			end
		end)
	elseif var0_7 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_7.viewComponent:BuildTaskVOs()
		arg0_7.viewComponent:UpdateView()
	end
end

function var0_0.remove(arg0_11)
	return
end

return var0_0
