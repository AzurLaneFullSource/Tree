local var0_0 = class("UpdateFleetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.fleet
	local var2_1 = var0_1.callback

	assert(isa(var1_1, Fleet), "should be an instance of Fleet")

	local var3_1 = getProxy(PlayerProxy)
	local var4_1 = getProxy(FleetProxy)
	local var5_1 = var4_1:getFleetById(var1_1.id)

	if var5_1 == nil then
		return
	end

	local var6_1 = {}

	_.each(var1_1.vanguardShips, function(arg0_2)
		var6_1[#var6_1 + 1] = arg0_2
	end)
	_.each(var1_1.mainShips, function(arg0_3)
		var6_1[#var6_1 + 1] = arg0_3
	end)
	_.each(var1_1.subShips, function(arg0_4)
		var6_1[#var6_1 + 1] = arg0_4
	end)
	pg.ConnectionMgr.GetInstance():Send(12102, {
		id = var1_1.id,
		ship_list = var6_1
	}, 12103, function(arg0_5)
		if arg0_5.result == 0 then
			var1_1.name = var5_1.name

			var4_1:updateFleet(var1_1)

			if var1_1:isEmpty() and var3_1.combatFleetId == var1_1.id then
				var3_1.combatFleetId = 1
			end

			arg0_1:sendNotification(GAME.UPDATE_FLEET_DONE, var1_1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("fleet_updateFleet", arg0_5.result))
		end

		if var2_1 ~= nil then
			var2_1()
		end
	end)
end

return var0_0
