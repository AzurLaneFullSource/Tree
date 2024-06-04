local var0 = class("WorldBossInformationMediator", import("..base.ContextMediator"))

var0.RETREAT_FLEET = "WorldBossInformationMediator:RETREAT_FLEET"
var0.OnOpenSublayer = "WorldBossInformationMediator:OpenSublayer"

function var0.register(arg0)
	arg0:bind(var0.RETREAT_FLEET, function()
		arg0:sendNotification(GAME.WORLD_RETREAT_FLEET)
	end)
	arg0:bind(var0.OnOpenSublayer, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(arg1, arg2, arg3)
	end)
	arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.WORLD_MAP_OP_DONE,
		GAME.BEGIN_STAGE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	elseif var0 == GAME.WORLD_MAP_OP_DONE then
		-- block empty
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	end
end

return var0
