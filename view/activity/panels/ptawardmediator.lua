local var0_0 = class("PtAwardMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(ActivityMediator.EVENT_PT_OPERATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.ACT_NEW_PT_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == nil then
		-- block empty
	elseif var0_4 == ActivityProxy.ACTIVITY_ADDED or var0_4 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF and var1_4:getDataConfig("pt") == arg0_4.contextData.ptId then
			if arg0_4.contextData.ptData then
				arg0_4.contextData.ptData:Update(var1_4)
			else
				arg0_4.contextData.ptData = ActivityBossPtData.New(var1_4)
			end

			arg0_4.viewComponent:UpdateView()
		end
	elseif var0_4 == GAME.ACT_NEW_PT_DONE then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards)
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
