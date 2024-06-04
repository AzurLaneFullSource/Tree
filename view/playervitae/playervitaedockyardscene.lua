local var0 = class("PlayerVitaeDockyardScene", import("view.ship.DockyardScene"))

function var0.SortShips(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().characters
	local var1 = {}
	local var2 = #var0 + 1

	for iter0, iter1 in ipairs(var0) do
		var1[iter1] = var2 - iter0
	end

	table.insert(arg1, function(arg0)
		return -(var1[arg0.id] or 0)
	end)
	table.sort(arg0.shipVOs, CompareFuncs(arg1))
end

return var0
