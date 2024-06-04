local var0 = class("VoteFameHallMediator", import("..base.ContextMediator"))

var0.ON_SUBMIT_TASK = "VoteFameHallMediator:ON_SUBMIT_TASK"

function var0.register(arg0)
	arg0:bind(var0.ON_SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0.viewComponent:SetPastVoteData(getProxy(VoteProxy):GetPastVoteData())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:UpdateTips(arg0.viewComponent.year)
		arg0.viewComponent:UpdateBtnsTip()
	end
end

return var0
