local var0_0 = class("Challenge2InitialRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().mode
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
	local var2_1 = getProxy(FleetProxy):getActivityFleets()[var1_1.id]
	local var3_1 = {
		[var0_1 + 1] = var2_1[var0_1 + 1],
		[var0_1 + 11] = var2_1[var0_1 + 11]
	}
	local var4_1 = {}

	for iter0_1, iter1_1 in pairs(var3_1) do
		if iter1_1 then
			local var5_1 = {}

			_.each(iter1_1.vanguardShips, function(arg0_2)
				var5_1[#var5_1 + 1] = arg0_2
			end)
			_.each(iter1_1.mainShips, function(arg0_3)
				var5_1[#var5_1 + 1] = arg0_3
			end)
			_.each(iter1_1.subShips, function(arg0_4)
				var5_1[#var5_1 + 1] = arg0_4
			end)

			local var6_1 = {}

			for iter2_1, iter3_1 in pairs(iter1_1.commanderIds) do
				table.insert(var6_1, {
					pos = iter2_1,
					id = iter3_1
				})
			end

			local var7_1 = {
				id = iter0_1,
				ship_list = var5_1,
				commanders = var6_1
			}

			table.insert(var4_1, var7_1)
		end
	end

	if not var1_1 or var1_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(24002, {
		activity_id = var1_1.id,
		group_list = var4_1,
		mode = var0_1
	}, 24003, function(arg0_5)
		if arg0_5.result == 0 then
			local function var0_5()
				arg0_1:sendNotification(GAME.CHALLENGE2_INITIAL_DONE, {
					mode = var0_1
				})
			end

			arg0_1:sendNotification(GAME.CHALLENGE2_INFO, {
				callback = var0_5
			})
		end
	end)
end

return var0_0
