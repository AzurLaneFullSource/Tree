local var0 = class("TransitionMediator", import("..base.ContextMediator"))

var0.FINISH = "TransitionMediator:FINISH"

function var0.register(arg0)
	return
end

function var0.remove(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.LOAD_SCENE_DONE,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.LOAD_SCENE_DONE then
		if var1 == SCENE.TRANSITION then
			arg0.contextData.afterLoadFunc()
		end
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		local var2 = getProxy(ContextProxy):getContextByMediator(BattleMediator)

		if var2 then
			getProxy(ContextProxy):RemoveContext(var2)
		end

		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1)
	end
end

return var0
