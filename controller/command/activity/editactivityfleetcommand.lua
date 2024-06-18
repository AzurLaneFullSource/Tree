local var0_0 = class("EditActivityFleetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.actID
	local var2_1 = var0_1.fleets
	local var3_1 = {}

	for iter0_1, iter1_1 in pairs(var2_1) do
		local var4_1 = {}

		_.each(iter1_1.vanguardShips, function(arg0_2)
			var4_1[#var4_1 + 1] = arg0_2
		end)
		_.each(iter1_1.mainShips, function(arg0_3)
			var4_1[#var4_1 + 1] = arg0_3
		end)
		_.each(iter1_1.subShips, function(arg0_4)
			var4_1[#var4_1 + 1] = arg0_4
		end)

		local var5_1 = {}

		for iter2_1, iter3_1 in pairs(iter1_1.commanderIds) do
			table.insert(var5_1, {
				pos = iter2_1,
				id = iter3_1
			})
		end

		local var6_1 = {
			id = iter0_1,
			ship_list = var4_1,
			commanders = var5_1
		}

		table.insert(var3_1, var6_1)
	end

	pg.ConnectionMgr.GetInstance():Send(11204, {
		activity_id = var1_1,
		group_list = var3_1
	}, 11205, function(arg0_5)
		if arg0_5.result == 0 then
			-- block empty
		end
	end)
end

return var0_0
