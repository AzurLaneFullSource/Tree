local var0 = class("BattleGateDebug")

ys.Battle.BattleGateDebug = var0
var0.__name = "BattleGateDebug"

function var0.Entrance(arg0, arg1)
	local var0 = getProxy(FleetProxy):getFleetById(1)

	if var0 == nil or var0:isEmpty() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_fleetEmpty"))

		return
	end

	local var1 = PROLOGUE_DUNGEON
	local var2 = {
		mainFleetId = 1,
		prefabFleet = {},
		stageId = var1,
		system = SYSTEM_DEBUG
	}

	arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var2)
end

function var0.Exit()
	return
end

return var0
