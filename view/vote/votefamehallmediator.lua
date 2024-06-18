local var0_0 = class("VoteFameHallMediator", import("..base.ContextMediator"))

var0_0.ON_SUBMIT_TASK = "VoteFameHallMediator:ON_SUBMIT_TASK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2)
	end)
	arg0_1.viewComponent:SetPastVoteData(getProxy(VoteProxy):GetPastVoteData())
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.SUBMIT_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.SUBMIT_TASK_DONE then
		arg0_4.viewComponent:UpdateTips(arg0_4.viewComponent.year)
		arg0_4.viewComponent:UpdateBtnsTip()
	end
end

return var0_0
