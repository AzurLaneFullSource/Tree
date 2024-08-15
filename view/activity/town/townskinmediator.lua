local var0_0 = class("TownSkinMediator", import("view.base.ContextMediator"))

var0_0.UnlockStoryDone = "TownSkinMediator.UnlockStoryDone"

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		var0_0.UnlockStoryDone,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == var0_0.UnlockStoryDone then
		arg0_3.viewComponent:UpdataStoryState(var1_3)
	elseif var0_3 == ActivityProxy.ACTIVITY_UPDATED and var1_3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TownSkinStory then
		arg0_3.viewComponent:UpdateItemView(var1_3)
	end
end

return var0_0
