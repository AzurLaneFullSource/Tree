local var0_0 = class("JiuJiuExpeditionGameMediator", import("...base.ContextMediator"))

var0_0.OPEN_LAYER = "OPEN_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	local var0_3 = {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.BEGIN_STAGE_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}

	table.insertto(var0_3, var0_0.super.listNotificationInterests(arg0_3))

	return var0_3
end

function var0_0.handleNotification(arg0_4, arg1_4)
	var0_0.super.handleNotification(arg0_4, arg1_4)

	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == ActivityProxy.ACTIVITY_UPDATED and var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
		arg0_4.viewComponent:activityUpdate()
	elseif var0_4 == GAME.BEGIN_STAGE_DONE then
		arg0_4:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_4)
	elseif var0_4 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards, var1_4.callback)
	end
end

return var0_0
