local var0 = class("Challenge2InitialRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().mode
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
	local var2 = getProxy(FleetProxy):getActivityFleets()[var1.id]
	local var3 = {
		[var0 + 1] = var2[var0 + 1],
		[var0 + 11] = var2[var0 + 11]
	}
	local var4 = {}

	for iter0, iter1 in pairs(var3) do
		if iter1 then
			local var5 = {}

			_.each(iter1.vanguardShips, function(arg0)
				var5[#var5 + 1] = arg0
			end)
			_.each(iter1.mainShips, function(arg0)
				var5[#var5 + 1] = arg0
			end)
			_.each(iter1.subShips, function(arg0)
				var5[#var5 + 1] = arg0
			end)

			local var6 = {}

			for iter2, iter3 in pairs(iter1.commanderIds) do
				table.insert(var6, {
					pos = iter2,
					id = iter3
				})
			end

			local var7 = {
				id = iter0,
				ship_list = var5,
				commanders = var6
			}

			table.insert(var4, var7)
		end
	end

	if not var1 or var1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(24002, {
		activity_id = var1.id,
		group_list = var4,
		mode = var0
	}, 24003, function(arg0)
		if arg0.result == 0 then
			local var0 = function()
				arg0:sendNotification(GAME.CHALLENGE2_INITIAL_DONE, {
					mode = var0
				})
			end

			arg0:sendNotification(GAME.CHALLENGE2_INFO, {
				callback = var0
			})
		end
	end)
end

return var0
