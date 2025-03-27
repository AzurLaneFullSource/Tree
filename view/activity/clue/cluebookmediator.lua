local var0_0 = class("ClueBookMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_SUBMIT_ONESTEP = "ClueBookMediator.ON_TASK_SUBMIT_ONESTEP"
var0_0.OPEN_SINGLE_CLUE_GROUP = "ClueBookMediator.OPEN_SINGLE_CLUE_GROUP"
var0_0.OPEN_CLUE_JUMP = "ClueBookMediator.OPEN_CLUE_JUMP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_2,
			task_ids = arg2_2,
			callback = arg3_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_SINGLE_CLUE_GROUP, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = ClueGroupSingleView,
			mediator = ClueGroupSingleMediator,
			data = {
				clueGroupId = arg1_3
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CLUE_JUMP, function(arg0_4, arg1_4)
		arg0_1:sendNotification(ClueMapMediator.OPEN_CLUE_JUMP, {
			jumpID = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		if #var1_6.awards > 0 then
			arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards)
		end

		arg0_6.viewComponent:UpdateView()
	end
end

return var0_0
