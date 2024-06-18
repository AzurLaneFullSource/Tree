local var0_0 = class("WorldMediaCollectionMediator", ContextMediator)

var0_0.BEGIN_STAGE = "WorldMediaCollectionMediator BEGIN_STAGE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.BEGIN_STAGE, function(arg0_2, arg1_2)
		arg0_1.contextData.revertBgm = pg.CriMgr.GetInstance().bgmNow

		arg0_1:sendNotification(GAME.BEGIN_STAGE, arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:UpdateView()
	elseif var0_4 == GAME.BEGIN_STAGE_DONE then
		arg0_4:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_4)
	end
end

return var0_0
