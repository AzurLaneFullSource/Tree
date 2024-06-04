local var0 = class("ShamRival", import(".Rival"))

function var0.Ctor(arg0, arg1)
	var0.super.super.Ctor(arg0, arg1)

	arg0.id = arg1.id
	arg0.level = arg1.level
	arg0.name = arg1.name
	arg0.vanguardShips = {}
	arg0.mainShips = {}

	_.each(arg1.ship_list, function(arg0)
		local var0 = Ship.New(arg0)
		local var1 = var0:getTeamType()

		if var1 == TeamType.Vanguard then
			table.insert(arg0.vanguardShips, var0)
		elseif var1 == TeamType.Main then
			table.insert(arg0.mainShips, var0)
		end
	end)
end

return var0
