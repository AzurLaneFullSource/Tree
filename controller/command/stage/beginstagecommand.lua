local var0 = class("BeginStageCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.system

	ys.Battle.BattleGate.Gates[var1].Entrance(var0, arg0)
end

function var0.RequestFailStandardProcess(arg0, arg1)
	if arg1.result == 10 then
		pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[10])
	else
		pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_beginStage", arg1.result))
		arg0:sendNotification(GAME.BEGIN_STAGE_ERRO, arg1.result)
	end
end

function var0.SendRequest(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg5 or {}
	local var1 = {
		system = arg0,
		ship_id_list = arg1,
		data = arg2[1],
		data2 = arg2[2],
		other_ship_id_list = var0
	}

	pg.ConnectionMgr.GetInstance():Send(40001, var1, 40002, function(arg0)
		if arg0.result == 0 then
			arg3(arg0)
		else
			arg4(arg0)
		end
	end)
end

function var0.DockOverload()
	local var0 = getProxy(PlayerProxy):getData()

	if getProxy(BayProxy):getShipCount() >= var0:getMaxShipBag() then
		NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

		return true
	end

	return false
end

function var0.LegalFleet(arg0)
	local var0 = getProxy(FleetProxy):getFleetById(arg0)

	if var0 == nil or var0:isEmpty() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_fleetEmpty"))

		return false
	end

	local var1, var2 = var0:isLegalToFight()

	if var1 ~= true then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_teamEmpty", Fleet.C_TEAM_NAME[var1], var2))

		return false
	end

	return true
end

function var0.ShipVertify()
	local var0 = getProxy(BayProxy):getRawData()

	for iter0, iter1 in pairs(var0) do
		if not iter1:attrVertify() then
			BattleVertify.playerShipVertifyFail = true

			break
		end
	end
end

return var0
