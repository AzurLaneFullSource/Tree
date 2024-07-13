local var0_0 = class("ShamRival", import(".Rival"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1.id
	arg0_1.level = arg1_1.level
	arg0_1.name = arg1_1.name
	arg0_1.vanguardShips = {}
	arg0_1.mainShips = {}

	_.each(arg1_1.ship_list, function(arg0_2)
		local var0_2 = Ship.New(arg0_2)
		local var1_2 = var0_2:getTeamType()

		if var1_2 == TeamType.Vanguard then
			table.insert(arg0_1.vanguardShips, var0_2)
		elseif var1_2 == TeamType.Main then
			table.insert(arg0_1.mainShips, var0_2)
		end
	end)
end

return var0_0
