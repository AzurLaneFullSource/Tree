local var0 = class("UpdateExerciseFleetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.fleet
	local var2 = var1.vanguardShips
	local var3 = var1.mainShips
	local var4 = var0.callback
	local var5 = getProxy(MilitaryExerciseProxy):getExerciseFleet()
	local var6 = Clone(var5)
	local var7 = getProxy(FleetProxy):getFleetById(1)

	if table.getCount(var3) == 0 or table.getCount(var2) == 0 then
		var2 = var7.vanguardShips
		var3 = var7.mainShips
		arg0.resetFleet = true
	end

	if table.getCount(var2) > 3 or table.getCount(var3) > 3 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(18008, {
		vanguard_ship_id_list = var2,
		main_ship_id_list = var3
	}, 18009, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(MilitaryExerciseProxy)
			local var1 = {}

			_.each(var2, function(arg0)
				table.insert(var1, arg0)
			end)
			_.each(var3, function(arg0)
				table.insert(var1, arg0)
			end)
			var5:updateShips(var1)
			var0:updateExerciseFleet(var5)

			if arg0.resetFleet then
				arg0.resetFleet = nil

				arg0:sendNotification(GAME.EXERCISE_FLEET_RESET, var5)
			end

			arg0:sendNotification(GAME.UPDATE_EXERCISE_FLEET_DONE, {
				oldFleet = var6,
				newFleet = var5
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end

		if var4 then
			var4()
		end
	end)
end

return var0
