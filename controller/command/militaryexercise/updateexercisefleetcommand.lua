local var0_0 = class("UpdateExerciseFleetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.fleet
	local var2_1 = var1_1.vanguardShips
	local var3_1 = var1_1.mainShips
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(MilitaryExerciseProxy):getExerciseFleet()
	local var6_1 = Clone(var5_1)
	local var7_1 = getProxy(FleetProxy):getFleetById(1)

	if table.getCount(var3_1) == 0 or table.getCount(var2_1) == 0 then
		var2_1 = var7_1.vanguardShips
		var3_1 = var7_1.mainShips
		arg0_1.resetFleet = true
	end

	if table.getCount(var2_1) > 3 or table.getCount(var3_1) > 3 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(18008, {
		vanguard_ship_id_list = var2_1,
		main_ship_id_list = var3_1
	}, 18009, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(MilitaryExerciseProxy)
			local var1_2 = {}

			_.each(var2_1, function(arg0_3)
				table.insert(var1_2, arg0_3)
			end)
			_.each(var3_1, function(arg0_4)
				table.insert(var1_2, arg0_4)
			end)
			var5_1:updateShips(var1_2)
			var0_2:updateExerciseFleet(var5_1)

			if arg0_1.resetFleet then
				arg0_1.resetFleet = nil

				arg0_1:sendNotification(GAME.EXERCISE_FLEET_RESET, var5_1)
			end

			arg0_1:sendNotification(GAME.UPDATE_EXERCISE_FLEET_DONE, {
				oldFleet = var6_1,
				newFleet = var5_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end

		if var4_1 then
			var4_1()
		end
	end)
end

return var0_0
