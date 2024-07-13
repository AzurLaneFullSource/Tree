local var0_0 = class("AirForceOfDragonEmperyMediator", import("view.base.ContextMediator"))

var0_0.ON_BATTLE = "AirForceOfDragonEmperyMediator ON_BATTLE"
var0_0.ON_ACTIVITY_OPREATION = "AirForceOfDragonEmperyMediator ON_ACTIVITY_OPREATION"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_BATTLE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_AIRFIGHT,
			stageId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_OPREATION, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_3)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

	arg0_1.viewComponent:SetActivityData(var0_1)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.BEGIN_STAGE_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE then
			arg0_5:getViewComponent():SetActivityData(var1_5)
			arg0_5:getViewComponent():UpdateView()
		end
	elseif var0_5 == GAME.BEGIN_STAGE_DONE then
		arg0_5:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards, var1_5.callback)
	end
end

return var0_0
