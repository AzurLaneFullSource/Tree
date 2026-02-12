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

function var0_0.GetPreloadList(arg0_3)
	local var0_3 = ys.Battle.BattleResourceManager.GetInstance()
	local var1_3 = getProxy(FleetProxy)
	local var2_3 = getProxy(BayProxy)
	local var3_3 = {}
	local var4_3 = var1_3:getFleetById(arg0_3.mainFleetId)
	local var5_3 = var2_3:getShipsByFleet(var4_3)

	for iter0_3, iter1_3 in ipairs(var5_3) do
		table.insert(var3_3, iter1_3)
	end

	local var6_3 = var1_3:getFleetById(11)
	local var7_3 = var6_3:getTeamByName(TeamType.Submarine)

	for iter2_3, iter3_3 in ipairs(var7_3) do
		local var8_3 = var2_3:getShipById(iter3_3)

		table.insert(var3_3, var8_3)
	end

	local var9_3, var10_3 = var0_3.GetPlayerShipResource(var3_3, arg0_3.system)
	local var11_3 = var0_3.GetCommanderBuffRes(var6_3:buildBattleBuffList())

	for iter4_3, iter5_3 in ipairs(var11_3) do
		table.insert(var9_3, iter5_3)
	end

	local var12_3 = pg.aircraft_template.all

	for iter6_3, iter7_3 in ipairs(var12_3) do
		local var13_3 = var0_3.GetAircraftResource(iter7_3, {})

		for iter8_3, iter9_3 in ipairs(var13_3) do
			table.insert(var9_3, iter9_3)
		end
	end

	return var9_3, var10_3
end

return var0_0
