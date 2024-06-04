local var0 = class("PtAwardMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(ActivityMediator.EVENT_PT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_NEW_PT, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.ACT_NEW_PT_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	elseif var0 == ActivityProxy.ACTIVITY_ADDED or var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF and var1:getDataConfig("pt") == arg0.contextData.ptId then
			if arg0.contextData.ptData then
				arg0.contextData.ptData:Update(var1)
			else
				arg0.contextData.ptData = ActivityBossPtData.New(var1)
			end

			arg0.viewComponent:UpdateView()
		end
	elseif var0 == GAME.ACT_NEW_PT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	end
end

function var0.remove(arg0)
	return
end

return var0
