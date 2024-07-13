local var0_0 = class("CommanderUsePrefabCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.pid
	local var2_1 = var0_1.fleetId
	local var3_1 = getProxy(FleetProxy):getFleetById(var2_1)
	local var4_1 = getProxy(CommanderProxy):getPrefabFleetById(var1_1)

	if var4_1:isEmpty() or var4_1:isSame(var3_1:getCommanders()) then
		return
	end

	local var5_1 = {
		function(arg0_2)
			if var3_1:getCommanderByPos(1) then
				arg0_1:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
					commanderId = 0,
					pos = 1,
					fleetId = var2_1,
					callback = arg0_2
				})
			else
				arg0_2()
			end
		end,
		function(arg0_3)
			if var3_1:getCommanderByPos(2) then
				arg0_1:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
					commanderId = 0,
					pos = 2,
					fleetId = var2_1,
					callback = arg0_3
				})
			else
				arg0_3()
			end
		end,
		function(arg0_4)
			local var0_4 = var4_1:getCommanderByPos(1)

			if var0_4 then
				arg0_1:sendNotification(GAME.SELECT_FLEET_COMMANDER, {
					pos = 1,
					fleetId = var2_1,
					commanderId = var0_4.id,
					callback = arg0_4
				})
			else
				arg0_4()
			end
		end,
		function(arg0_5)
			local var0_5 = var4_1:getCommanderByPos(2)

			if var0_5 then
				arg0_1:sendNotification(GAME.SELECT_FLEET_COMMANDER, {
					pos = 2,
					fleetId = var2_1,
					commanderId = var0_5.id,
					callback = arg0_5
				})
			else
				arg0_5()
			end
		end
	}

	seriesAsync(var5_1, function()
		arg0_1:sendNotification(GAME.USE_COMMANDER_PREFBA_DONE)
	end)
end

return var0_0
