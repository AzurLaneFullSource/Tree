local var0 = class("EquipCommanderToFleetCommande", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.commanderId
	local var2 = var0.pos
	local var3 = var0.fleetId
	local var4 = var0.callback
	local var5

	if var1 ~= 0 then
		var5 = getProxy(CommanderProxy):getCommanderById(var1)

		if not var5 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_not_exist"))

			return
		end
	end

	local var6 = getProxy(FleetProxy)
	local var7 = var6:getFleetById(var3)

	if not var7 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_fleet_not_exist"))

		return
	end

	if var1 == 0 and not var7:getCommanderByPos(var2) then
		if var4 then
			var4()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25006, {
		groupid = var3,
		pos = var2,
		commanderid = var1
	}, 25007, function(arg0)
		if arg0.result == 0 then
			var7:updateCommanderByPos(var2, var5)
			var6:updateFleet(var7)

			if var4 then
				var4(var7)
			end

			arg0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_equip_to_fleet_erro", arg0.result))
		end
	end)
end

return var0
