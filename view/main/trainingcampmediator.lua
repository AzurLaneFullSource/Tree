local var0_0 = class("TrainingCampMediator", import("..base.ContextMediator"))

var0_0.ON_GET = "TrainingCampMediator:ON_GET"
var0_0.ON_GO = "TrainingCampMediator:ON_GO"
var0_0.ON_TRIGGER = "TrainingCampMediator:ON_TRIGGER"
var0_0.ON_SELECTABLE_GET = "TrainingCampMediator:ON_SELECTABLE_GET"
var0_0.ON_UPDATE = "TrainingCampMediator:ON_UPDATE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_UPDATE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
			taskId = arg1_2.id
		})
	end)
	arg0_1:bind(var0_0.ON_SELECTABLE_GET, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, {
			taskId = arg1_3.id,
			index = arg2_3
		})
	end)
	arg0_1:bind(var0_0.ON_GET, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_4.id)
	end)
	arg0_1:bind(var0_0.ON_GO, function(arg0_5, arg1_5)
		local var0_5 = arg1_5:getConfig("scene")

		if var0_5 and #var0_5 > 0 then
			if var0_5[1] == "LEVEL" and var0_5[2] and var0_5[2].chapterid then
				arg0_1:goToLevel(var0_5[2].chapterid)
			elseif SCENE[var0_5[1]] then
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE[var0_5[1]], var0_5[2])
			end
		else
			arg0_1:sendNotification(GAME.TASK_GO, {
				taskVO = arg1_5
			})
		end
	end)
	arg0_1:bind(var0_0.ON_TRIGGER, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_6)
	end)
end

var0_0.TASK_ADDED = "task added"
var0_0.TASK_UPDATED = "task updated"
var0_0.TASK_REMOVED = "task removed"

function var0_0.listNotificationInterests(arg0_7)
	return {
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == TaskProxy.TASK_UPDATED or var0_8 == TaskProxy.TASK_REMOVED then
		arg0_8.viewComponent:switchPageByMediator()
		arg0_8.viewComponent:updateSwitchBtnsTag()
	elseif var0_8 == GAME.SUBMIT_TASK_DONE then
		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8)
		arg0_8.viewComponent:setPhrase()
		arg0_8.viewComponent:updateSwitchBtnsTag()
	elseif var0_8 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_8.viewComponent:tryShowTecFixTip()
		arg0_8.viewComponent:switchPageByMediator()
		arg0_8.viewComponent:updateSwitchBtnsTag()
	end
end

return var0_0
