local var0_0 = class("MonopolyPtMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_ADDED,
		GAME.ACT_NEW_PT_DONE,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()
	local var2_3 = arg1_3:getType()

	if var0_3 == ActivityProxy.ACTIVITY_UPDATED or var0_3 == ActivityProxy.ACTIVITY_ADDED then
		arg0_3:updateGameUI(var1_3)
	elseif var0_3 == GAME.ACT_NEW_PT_DONE then
		arg0_3.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_3.awards, var1_3.callback)
	elseif var0_3 == GAME.BEGIN_STAGE_DONE then
		arg0_3:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_3)
	end
end

function var0_0.updateGameUI(arg0_4, arg1_4)
	arg0_4.viewComponent:updataActivity(arg1_4)
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
