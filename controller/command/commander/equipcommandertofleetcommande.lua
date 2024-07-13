local var0_0 = class("EquipCommanderToFleetCommande", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.commanderId
	local var2_1 = var0_1.pos
	local var3_1 = var0_1.fleetId
	local var4_1 = var0_1.callback
	local var5_1

	if var1_1 ~= 0 then
		var5_1 = getProxy(CommanderProxy):getCommanderById(var1_1)

		if not var5_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_not_exist"))

			return
		end
	end

	local var6_1 = getProxy(FleetProxy)
	local var7_1 = var6_1:getFleetById(var3_1)

	if not var7_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_fleet_not_exist"))

		return
	end

	if var1_1 == 0 and not var7_1:getCommanderByPos(var2_1) then
		if var4_1 then
			var4_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25006, {
		groupid = var3_1,
		pos = var2_1,
		commanderid = var1_1
	}, 25007, function(arg0_2)
		if arg0_2.result == 0 then
			var7_1:updateCommanderByPos(var2_1, var5_1)
			var6_1:updateFleet(var7_1)

			if var4_1 then
				var4_1(var7_1)
			end

			arg0_1:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_equip_to_fleet_erro", arg0_2.result))
		end
	end)
end

return var0_0
