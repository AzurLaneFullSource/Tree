local var0_0 = class("Rival", import(".PlayerAttire"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1.id
	arg0_1.level = arg1_1.level
	arg0_1.name = arg1_1.name
	arg0_1.score = arg1_1.score or 0
	arg0_1.rank = arg1_1.rank
	arg0_1.vanguardShips = {}
	arg0_1.mainShips = {}

	local function var0_1(arg0_2)
		if arg0_2:getTeamType() == TeamType.Vanguard then
			table.insert(arg0_1.vanguardShips, arg0_2)
		elseif arg0_2:getTeamType() == TeamType.Main then
			table.insert(arg0_1.mainShips, arg0_2)
		end
	end

	for iter0_1, iter1_1 in ipairs(arg1_1.vanguard_ship_list) do
		local var1_1 = RivalShip.New(iter1_1)

		var1_1.isRival = true

		var0_1(var1_1)
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.main_ship_list) do
		local var2_1 = RivalShip.New(iter3_1)

		var2_1.isRival = true

		var0_1(var2_1)
	end

	arg0_1.score = arg0_1.score + SeasonInfo.INIT_POINT
end

function var0_0.getPainting(arg0_3)
	local var0_3 = pg.ship_skin_template[arg0_3.skinId]

	return var0_3 and var0_3.painting or "unknown"
end

function var0_0.getShips(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.vanguardShips) do
		table.insert(var0_4, iter1_4)
	end

	for iter2_4, iter3_4 in ipairs(arg0_4.mainShips) do
		table.insert(var0_4, iter3_4)
	end

	return var0_4
end

function var0_0.GetGearScoreSum(arg0_5, arg1_5)
	local var0_5

	if arg1_5 == "main" then
		var0_5 = arg0_5.mainShips
	elseif arg1_5 == "vanguard" then
		var0_5 = arg0_5.vanguardShips
	end

	local var1_5 = 0

	for iter0_5, iter1_5 in ipairs(var0_5) do
		var1_5 = var1_5 + iter1_5:getShipCombatPower()
	end

	return var1_5
end

return var0_0
