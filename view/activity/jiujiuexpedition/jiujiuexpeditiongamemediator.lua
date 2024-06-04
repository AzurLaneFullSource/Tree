local var0 = class("JiuJiuExpeditionGameMediator", import("...base.ContextMediator"))

var0.OPEN_LAYER = "OPEN_LAYER"

function var0.register(arg0)
	arg0:bind(var0.OPEN_LAYER, function(arg0, arg1)
		arg0:addSubLayers(arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	local var0 = {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.BEGIN_STAGE_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}

	table.insertto(var0, var0.super.listNotificationInterests(arg0))

	return var0
end

function var0.handleNotification(arg0, arg1)
	var0.super.handleNotification(arg0, arg1)

	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
		arg0.viewComponent:activityUpdate()
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0
