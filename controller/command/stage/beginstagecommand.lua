local var0_0 = class("BeginStageCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.system

	ys.Battle.BattleGate.Gates[var1_1].Entrance(var0_1, arg0_1)
end

function var0_0.RequestFailStandardProcess(arg0_2, arg1_2)
	if arg1_2.result == 10 then
		pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[10])
	else
		pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_beginStage", arg1_2.result))
		arg0_2:sendNotification(GAME.BEGIN_STAGE_ERRO, arg1_2.result)
	end
end

function var0_0.SendRequest(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	local var0_3 = arg5_3 or {}
	local var1_3 = {
		system = arg0_3,
		ship_id_list = arg1_3,
		data = arg2_3[1],
		data2 = arg2_3[2],
		other_ship_id_list = var0_3
	}

	pg.ConnectionMgr.GetInstance():Send(40001, var1_3, 40002, function(arg0_4)
		if arg0_4.result == 0 then
			arg3_3(arg0_4)
		else
			arg4_3(arg0_4)
		end
	end)
end

function var0_0.DockOverload()
	local var0_5 = getProxy(PlayerProxy):getData()

	if getProxy(BayProxy):getShipCount() >= var0_5:getMaxShipBag() then
		NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

		return true
	end

	return false
end

function var0_0.LegalFleet(arg0_6)
	local var0_6 = getProxy(FleetProxy):getFleetById(arg0_6)

	if var0_6 == nil or var0_6:isEmpty() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_fleetEmpty"))

		return false
	end

	local var1_6, var2_6 = var0_6:isLegalToFight()

	if var1_6 ~= true then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_teamEmpty", Fleet.C_TEAM_NAME[var1_6], var2_6))

		return false
	end

	return true
end

function var0_0.ShipVertify()
	local var0_7 = getProxy(BayProxy):getRawData()

	for iter0_7, iter1_7 in pairs(var0_7) do
		if not iter1_7:attrVertify() then
			BattleVertify.playerShipVertifyFail = true

			break
		end
	end
end

return var0_0
