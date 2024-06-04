local var0 = class("TrainingCampMediator", import("..base.ContextMediator"))

var0.ON_GET = "TrainingCampMediator:ON_GET"
var0.ON_GO = "TrainingCampMediator:ON_GO"
var0.ON_TRIGGER = "TrainingCampMediator:ON_TRIGGER"
var0.ON_SELECTABLE_GET = "TrainingCampMediator:ON_SELECTABLE_GET"
var0.ON_UPDATE = "TrainingCampMediator:ON_UPDATE"

function var0.register(arg0)
	arg0:bind(var0.ON_UPDATE, function(arg0, arg1)
		arg0:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
			taskId = arg1.id
		})
	end)
	arg0:bind(var0.ON_SELECTABLE_GET, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SUBMIT_TASK, {
			taskId = arg1.id,
			index = arg2
		})
	end)
	arg0:bind(var0.ON_GET, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end)
	arg0:bind(var0.ON_GO, function(arg0, arg1)
		local var0 = arg1:getConfig("scene")

		if var0 and #var0 > 0 then
			if var0[1] == "LEVEL" and var0[2] and var0[2].chapterid then
				arg0:goToLevel(var0[2].chapterid)
			elseif SCENE[var0[1]] then
				arg0:sendNotification(GAME.GO_SCENE, SCENE[var0[1]], var0[2])
			end
		else
			arg0:sendNotification(GAME.TASK_GO, {
				taskVO = arg1
			})
		end
	end)
	arg0:bind(var0.ON_TRIGGER, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
end

var0.TASK_ADDED = "task added"
var0.TASK_UPDATED = "task updated"
var0.TASK_REMOVED = "task removed"

function var0.listNotificationInterests(arg0)
	return {
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == TaskProxy.TASK_UPDATED or var0 == TaskProxy.TASK_REMOVED then
		arg0.viewComponent:switchPageByMediator()
		arg0.viewComponent:updateSwitchBtnsTag()
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1)
		arg0.viewComponent:setPhrase()
		arg0.viewComponent:updateSwitchBtnsTag()
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0.viewComponent:tryShowTecFixTip()
		arg0.viewComponent:switchPageByMediator()
		arg0.viewComponent:updateSwitchBtnsTag()
	end
end

return var0
