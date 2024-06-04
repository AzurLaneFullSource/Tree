local var0 = class("AirForceOfDragonEmperyMediator", import("view.base.ContextMediator"))

var0.ON_BATTLE = "AirForceOfDragonEmperyMediator ON_BATTLE"
var0.ON_ACTIVITY_OPREATION = "AirForceOfDragonEmperyMediator ON_ACTIVITY_OPREATION"

function var0.register(arg0)
	arg0:bind(var0.ON_BATTLE, function(arg0, arg1)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_AIRFIGHT,
			stageId = arg1
		})
	end)
	arg0:bind(var0.ON_ACTIVITY_OPREATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

	arg0.viewComponent:SetActivityData(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.BEGIN_STAGE_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE then
			arg0:getViewComponent():SetActivityData(var1)
			arg0:getViewComponent():UpdateView()
		end
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0
