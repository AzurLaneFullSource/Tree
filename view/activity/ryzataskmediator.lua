﻿local var0_0 = class("RyzaTaskMediator", import("..base.ContextMediator"))

var0_0.SUBMIT_TASK_ALL = "activity submit task all"
var0_0.SUBMIT_TASK = "activity submit task "
var0_0.TASK_GO = "activity task go "
var0_0.SHOW_DETAIL = "activity task show detail"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SUBMIT_TASK_ALL, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1_2.activityId,
			task_ids = arg1_2.ids
		})
	end)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1_3.activityId,
			task_ids = {
				arg1_3.id
			}
		})
	end)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_4.taskVO
		})
	end)
	arg0_1:bind(var0_0.SHOW_DETAIL, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = AtelierMaterialDetailLayer,
			data = {
				material = arg1_5
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.SUBMIT_AVATAR_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.SUBMIT_AVATAR_TASK_DONE then
		if #var1_7.awards > 0 then
			arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_7.awards)
		end

		if var1_7.callback then
			-- block empty
		end

		arg0_7.viewComponent:updateTask(true)
	end
end

return var0_0