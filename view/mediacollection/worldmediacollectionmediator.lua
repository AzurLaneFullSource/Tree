local var0_0 = class("WorldMediaCollectionMediator", ContextMediator)

var0_0.BEGIN_STAGE = "WorldMediaCollectionMediator BEGIN_STAGE"
var0_0.ON_ADD_SUBLAYER = "WorldMediaCollectionMediator.ON_ADD_SUBLAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.BEGIN_STAGE, function(arg0_2, arg1_2)
		arg0_1.contextData.revertBgm = pg.CriMgr.GetInstance().bgmNow

		arg0_1:sendNotification(GAME.BEGIN_STAGE, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_ADD_SUBLAYER, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == PlayerProxy.UPDATED then
		arg0_5.viewComponent:UpdateView()
	elseif var0_5 == GAME.BEGIN_STAGE_DONE then
		arg0_5:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_5)
	end
end

return var0_0
