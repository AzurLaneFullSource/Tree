local var0_0 = class("GhostSkinMediator", import("view.base.ContextMediator"))

var0_0.UnlockStoryDone = "GhostSkinMediator.UnlockStoryDone"
var0_0.ON_TASK_SUBMIT = "event on task submit"
var0_0.ON_TASK_GO = "event on task go"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2.id, arg2_2)
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		var0_0.UnlockStoryDone,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == var0_0.UnlockStoryDone then
		arg0_5.viewComponent:UpdataStoryState(var1_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TownSkinStory then
			arg0_5.viewComponent:UpdateItemView(var1_5)
		end
	elseif var0_5 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards, function()
			arg0_5.viewComponent:OnUpdateFlush(var1_5)
			arg0_5.viewComponent:DisplayBigTask()
		end)
	end
end

return var0_0
