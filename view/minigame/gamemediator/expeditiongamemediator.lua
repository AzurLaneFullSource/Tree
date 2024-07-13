local var0_0 = class("ExpeditionGameMediator", import(".MiniHubMediator"))

function var0_0.listNotificationInterests(arg0_1)
	local var0_1 = {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.BEGIN_STAGE_DONE
	}

	table.insertto(var0_1, var0_0.super.listNotificationInterests(arg0_1))

	return var0_1
end

function var0_0.handleNotification(arg0_2, arg1_2)
	var0_0.super.handleNotification(arg0_2, arg1_2)

	local var0_2 = arg1_2:getName()
	local var1_2 = arg1_2:getBody()

	if var0_2 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_2.viewComponent:activityUpdate()
	elseif var0_2 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_2.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_2.awards, var1_2.callback)
	elseif var0_2 == GAME.BEGIN_STAGE_DONE then
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_2)
	end
end

return var0_0
