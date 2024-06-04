local var0 = class("EditActivityFleetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.actID
	local var2 = var0.fleets
	local var3 = {}

	for iter0, iter1 in pairs(var2) do
		local var4 = {}

		_.each(iter1.vanguardShips, function(arg0)
			var4[#var4 + 1] = arg0
		end)
		_.each(iter1.mainShips, function(arg0)
			var4[#var4 + 1] = arg0
		end)
		_.each(iter1.subShips, function(arg0)
			var4[#var4 + 1] = arg0
		end)

		local var5 = {}

		for iter2, iter3 in pairs(iter1.commanderIds) do
			table.insert(var5, {
				pos = iter2,
				id = iter3
			})
		end

		local var6 = {
			id = iter0,
			ship_list = var4,
			commanders = var5
		}

		table.insert(var3, var6)
	end

	pg.ConnectionMgr.GetInstance():Send(11204, {
		activity_id = var1,
		group_list = var3
	}, 11205, function(arg0)
		if arg0.result == 0 then
			-- block empty
		end
	end)
end

return var0
