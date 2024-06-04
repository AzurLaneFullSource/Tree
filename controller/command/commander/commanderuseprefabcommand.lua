local var0 = class("CommanderUsePrefabCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.pid
	local var2 = var0.fleetId
	local var3 = getProxy(FleetProxy):getFleetById(var2)
	local var4 = getProxy(CommanderProxy):getPrefabFleetById(var1)

	if var4:isEmpty() or var4:isSame(var3:getCommanders()) then
		return
	end

	local var5 = {
		function(arg0)
			if var3:getCommanderByPos(1) then
				arg0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
					commanderId = 0,
					pos = 1,
					fleetId = var2,
					callback = arg0
				})
			else
				arg0()
			end
		end,
		function(arg0)
			if var3:getCommanderByPos(2) then
				arg0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
					commanderId = 0,
					pos = 2,
					fleetId = var2,
					callback = arg0
				})
			else
				arg0()
			end
		end,
		function(arg0)
			local var0 = var4:getCommanderByPos(1)

			if var0 then
				arg0:sendNotification(GAME.SELECT_FLEET_COMMANDER, {
					pos = 1,
					fleetId = var2,
					commanderId = var0.id,
					callback = arg0
				})
			else
				arg0()
			end
		end,
		function(arg0)
			local var0 = var4:getCommanderByPos(2)

			if var0 then
				arg0:sendNotification(GAME.SELECT_FLEET_COMMANDER, {
					pos = 2,
					fleetId = var2,
					commanderId = var0.id,
					callback = arg0
				})
			else
				arg0()
			end
		end
	}

	seriesAsync(var5, function()
		arg0:sendNotification(GAME.USE_COMMANDER_PREFBA_DONE)
	end)
end

return var0
