local var0 = class("MonopolyPtMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_ADDED,
		GAME.ACT_NEW_PT_DONE,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == ActivityProxy.ACTIVITY_UPDATED or var0 == ActivityProxy.ACTIVITY_ADDED then
		arg0:updateGameUI(var1)
	elseif var0 == GAME.ACT_NEW_PT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	end
end

function var0.updateGameUI(arg0, arg1)
	arg0.viewComponent:updataActivity(arg1)
end

function var0.remove(arg0)
	return
end

return var0
