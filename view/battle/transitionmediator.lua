local var0_0 = class("TransitionMediator", import("..base.ContextMediator"))

var0_0.FINISH = "TransitionMediator:FINISH"

function var0_0.register(arg0_1)
	return
end

function var0_0.remove(arg0_2)
	return
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.LOAD_SCENE_DONE,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.LOAD_SCENE_DONE then
		if var1_4 == SCENE.TRANSITION then
			arg0_4.contextData.afterLoadFunc()
		end
	elseif var0_4 == GAME.BEGIN_STAGE_DONE then
		local var2_4 = getProxy(ContextProxy):getContextByMediator(BattleMediator)

		if var2_4 then
			getProxy(ContextProxy):RemoveContext(var2_4)
		end

		arg0_4:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1_4)
	end
end

return var0_0
