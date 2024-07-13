local var0_0 = class("BossRushCMDFormationMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = getProxy(CommanderProxy):getPrefabFleet()

	arg0_1.viewComponent:updateFleet(arg0_1.contextData.fleet)
	arg0_1.viewComponent:setCommanderPrefabs(var0_1)
	arg0_1.viewComponent:setCallback(arg0_1.contextData.callback)
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == nil then
		-- block empty
	elseif var0_3 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var2_3 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_3.viewComponent:setCommanderPrefabs(var2_3)
	elseif var0_3 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		arg0_3.viewComponent:updateRecordFleet()
		arg0_3.viewComponent:updateDesc()
		arg0_3.viewComponent:updateRecordPanel()
	end
end

function var0_0.remove(arg0_4)
	return
end

return var0_0
