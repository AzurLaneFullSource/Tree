local var0 = class("UpdateFleetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.fleet
	local var2 = var0.callback

	assert(isa(var1, Fleet), "should be an instance of Fleet")

	local var3 = getProxy(PlayerProxy)
	local var4 = getProxy(FleetProxy)
	local var5 = var4:getFleetById(var1.id)

	if var5 == nil then
		return
	end

	local var6 = {}

	_.each(var1.vanguardShips, function(arg0)
		var6[#var6 + 1] = arg0
	end)
	_.each(var1.mainShips, function(arg0)
		var6[#var6 + 1] = arg0
	end)
	_.each(var1.subShips, function(arg0)
		var6[#var6 + 1] = arg0
	end)
	pg.ConnectionMgr.GetInstance():Send(12102, {
		id = var1.id,
		ship_list = var6
	}, 12103, function(arg0)
		if arg0.result == 0 then
			var1.name = var5.name

			var4:updateFleet(var1)

			if var1:isEmpty() and var3.combatFleetId == var1.id then
				var3.combatFleetId = 1
			end

			arg0:sendNotification(GAME.UPDATE_FLEET_DONE, var1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("fleet_updateFleet", arg0.result))
		end

		if var2 ~= nil then
			var2()
		end
	end)
end

return var0
