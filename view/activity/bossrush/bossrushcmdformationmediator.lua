local var0 = class("BossRushCMDFormationMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	local var0 = getProxy(CommanderProxy):getPrefabFleet()

	arg0.viewComponent:updateFleet(arg0.contextData.fleet)
	arg0.viewComponent:setCommanderPrefabs(var0)
	arg0.viewComponent:setCallback(arg0.contextData.callback)
end

function var0.listNotificationInterests(arg0)
	return {
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	elseif var0 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var2 = getProxy(CommanderProxy):getPrefabFleet()

		arg0.viewComponent:setCommanderPrefabs(var2)
	elseif var0 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		arg0.viewComponent:updateRecordFleet()
		arg0.viewComponent:updateDesc()
		arg0.viewComponent:updateRecordPanel()
	end
end

function var0.remove(arg0)
	return
end

return var0
