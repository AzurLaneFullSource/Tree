local var0_0 = class("CityRebuildTasksMediator", import("view.base.ContextMediator"))

var0_0.ON_SUBMIT_TASK = "CityRebuildTasksMediator.ON_SUBMIT_TASK"
var0_0.ON_TASK_SUBMIT_ONESTEP = "CityRebuildTasksMediator.ON_TASK_SUBMIT_ONESTEP"
var0_0.ON_TASK_GO = "CityRebuildTasksMediator.ON_TASK_GO"
var0_0.STORE_ACTIVITY_AWARDS = "CityRebuildTasksMediator.STORE_ACTIVITY_AWARDS"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	arg0_1.submitTaskIndex = 0
	arg0_1.tempAwards = {}
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ON_SUBMIT_TASK, function(arg0_3, arg1_3, arg2_3)
		arg0_2.submitTaskIndex = arg0_2.submitTaskIndex + 1

		arg0_2:sendNotification(GAME.SUBMIT_TASK, arg1_3, arg2_3)
	end)
	arg0_2:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_2.submitTaskIndex = arg0_2.submitTaskIndex + 1

		arg0_2:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_4,
			task_ids = arg2_4,
			callback = arg3_4
		})
	end)
	arg0_2:bind(var0_0.ON_TASK_GO, function(arg0_5, arg1_5, arg2_5)
		arg0_2:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_5
		})
	end)
	arg0_2:bind(var0_0.STORE_ACTIVITY_AWARDS, function(arg0_6, arg1_6, arg2_6)
		arg0_2.storeActivityAwardFlag = arg1_6
		arg0_2.taskCount = arg2_6
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.SUBMIT_TASK_AWARD_DOWN,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.SUBMIT_TASK_AWARD_DOWN then
		arg0_8.submitTaskIndex = arg0_8.submitTaskIndex - 1

		if #var1_8.awards > 0 then
			for iter0_8, iter1_8 in ipairs(var1_8.awards) do
				table.insert(arg0_8.tempAwards, iter1_8)
			end
		end

		onNextTick(function()
			if arg0_8.submitTaskIndex == 0 and #arg0_8.tempAwards > 0 then
				arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_8.tempAwards, function()
					arg0_8.viewComponent:InitData()
				end)

				arg0_8.tempAwards = {}
			end
		end)
	elseif var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		onNextTick(function()
			if arg0_8.submitTaskIndex == 0 and #arg0_8.tempAwards > 0 then
				arg0_8.viewComponent:InitData()
			end
		end)
	end
end

return var0_0
