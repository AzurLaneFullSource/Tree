local var0 = class("ExpeditionGameMediator", import(".MiniHubMediator"))

function var0.listNotificationInterests(arg0)
	local var0 = {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.BEGIN_STAGE_DONE
	}

	table.insertto(var0, var0.super.listNotificationInterests(arg0))

	return var0
end

function var0.handleNotification(arg0, arg1)
	var0.super.handleNotification(arg0, arg1)

	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		arg0.viewComponent:activityUpdate()
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	end
end

return var0
