local var0 = class("RyzaTaskMediator", import("..base.ContextMediator"))

var0.SUBMIT_TASK_ALL = "activity submit task all"
var0.SUBMIT_TASK = "activity submit task "
var0.TASK_GO = "activity task go "
var0.SHOW_DETAIL = "activity task show detail"

function var0.register(arg0)
	arg0:bind(var0.SUBMIT_TASK_ALL, function(arg0, arg1)
		arg0:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1.activityId,
			task_ids = arg1.ids
		})
	end)
	arg0:bind(var0.SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1.activityId,
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
			mediator = AtelierMaterialDetailMediator,
			viewComponent = AtelierMaterialDetailLayer,
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
		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end

		if var1.callback then
			-- block empty
		end

		arg0.viewComponent:updateTask(true)
	end
end

return var0
