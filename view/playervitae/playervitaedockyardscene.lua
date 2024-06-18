local var0_0 = class("PlayerVitaeDockyardScene", import("view.ship.DockyardScene"))

function var0_0.SortShips(arg0_1, arg1_1)
	local var0_1 = getProxy(PlayerProxy):getRawData().characters
	local var1_1 = {}
	local var2_1 = #var0_1 + 1

	for iter0_1, iter1_1 in ipairs(var0_1) do
		var1_1[iter1_1] = var2_1 - iter0_1
	end

	table.insert(arg1_1, function(arg0_2)
		return -(var1_1[arg0_2.id] or 0)
	end)
	table.sort(arg0_1.shipVOs, CompareFuncs(arg1_1))
end

return var0_0
