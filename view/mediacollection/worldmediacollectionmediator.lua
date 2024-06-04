local var0 = class("WorldMediaCollectionMediator", ContextMediator)

var0.BEGIN_STAGE = "WorldMediaCollectionMediator BEGIN_STAGE"

function var0.register(arg0)
	arg0:bind(var0.BEGIN_STAGE, function(arg0, arg1)
		arg0.contextData.revertBgm = pg.CriMgr.GetInstance().bgmNow

		arg0:sendNotification(GAME.BEGIN_STAGE, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:UpdateView()
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	end
end

return var0
