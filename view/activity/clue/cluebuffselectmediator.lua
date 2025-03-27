local var0_0 = class("ClueBuffSelectMediator", import("view.base.ContextMediator"))

var0_0.ON_FLEET_SELECT = "ClueBuffSelectMediator.ON_FLEET_SELECT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_FLEET_SELECT, function(arg0_2, arg1_2)
		arg0_1.viewComponent:ShowNormalFleet(arg1_2)
	end)
	arg0_1.viewComponent:SetStageID(arg0_1.contextData.clueSingleEnemyID)

	local var0_1 = PlayerPrefs.GetString(arg0_1.viewComponent.PLYAER_PREF_KEY .. arg0_1.contextData.clueSingleEnemyID)
	local var1_1 = {}

	if not var0_1 or var0_1 == "" then
		var1_1 = nil
	else
		for iter0_1 in string.gmatch(var0_1, "[^|]+") do
			table.insert(var1_1, tonumber(iter0_1))
		end
	end

	arg0_1.viewComponent:SetPreSelectedBuff(arg0_1.contextData.preSelectedBuffList or arg0_1.contextData.selectedBuffList or var1_1 or {})
	BossSingleBattleFleetSelectMediatorComponent.AttachFleetSelect(arg0_1, ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE, SYSTEM_BOSS_SINGLE_VARIABLE, Fleet.MEGA_SUBMARINE_FLEET_OFFSET)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		local var2_4 = arg1_4:getBody()
		local var3_4 = getProxy(FleetProxy):getActivityFleets()[var2_4.actId]

		arg0_4.contextData.actFleets = var3_4

		arg0_4.viewComponent:updateEditPanel()
		arg0_4.viewComponent:updateCommanderFleet(var3_4[var2_4.fleetId])
	end
end

return var0_0
