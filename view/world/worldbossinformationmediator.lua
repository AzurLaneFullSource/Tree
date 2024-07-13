local var0_0 = class("WorldBossInformationMediator", import("..base.ContextMediator"))

var0_0.RETREAT_FLEET = "WorldBossInformationMediator:RETREAT_FLEET"
var0_0.OnOpenSublayer = "WorldBossInformationMediator:OpenSublayer"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.RETREAT_FLEET, function()
		arg0_1:sendNotification(GAME.WORLD_RETREAT_FLEET)
	end)
	arg0_1:bind(var0_0.OnOpenSublayer, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:addSubLayers(arg1_3, arg2_3, arg3_3)
	end)
	arg0_1.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		PlayerProxy.UPDATED,
		GAME.WORLD_MAP_OP_DONE,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == PlayerProxy.UPDATED then
		arg0_5.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	elseif var0_5 == GAME.WORLD_MAP_OP_DONE then
		-- block empty
	elseif var0_5 == GAME.BEGIN_STAGE_DONE then
		arg0_5:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_5)
	end
end

return var0_0
