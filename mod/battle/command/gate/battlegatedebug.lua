local var0_0 = class("BattleGateDebug")

ys.Battle.BattleGateDebug = var0_0
var0_0.__name = "BattleGateDebug"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = getProxy(FleetProxy):getFleetById(1)

	if var0_1 == nil or var0_1:isEmpty() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_fleetEmpty"))

		return
	end

	local var1_1 = PROLOGUE_DUNGEON
	local var2_1 = {
		mainFleetId = 1,
		prefabFleet = {},
		stageId = var1_1,
		system = SYSTEM_DEBUG
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var2_1)
end

function var0_0.Exit()
	return
end

return var0_0
