local var0 = class("Rival", import(".PlayerAttire"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.id = arg1.id
	arg0.level = arg1.level
	arg0.name = arg1.name
	arg0.score = arg1.score or 0
	arg0.rank = arg1.rank
	arg0.vanguardShips = {}
	arg0.mainShips = {}

	local function var0(arg0)
		if arg0:getTeamType() == TeamType.Vanguard then
			table.insert(arg0.vanguardShips, arg0)
		elseif arg0:getTeamType() == TeamType.Main then
			table.insert(arg0.mainShips, arg0)
		end
	end

	for iter0, iter1 in ipairs(arg1.vanguard_ship_list) do
		local var1 = RivalShip.New(iter1)

		var1.isRival = true

		var0(var1)
	end

	for iter2, iter3 in ipairs(arg1.main_ship_list) do
		local var2 = RivalShip.New(iter3)

		var2.isRival = true

		var0(var2)
	end

	arg0.score = arg0.score + SeasonInfo.INIT_POINT
end

function var0.getPainting(arg0)
	local var0 = pg.ship_skin_template[arg0.skinId]

	return var0 and var0.painting or "unknown"
end

function var0.getShips(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.vanguardShips) do
		table.insert(var0, iter1)
	end

	for iter2, iter3 in ipairs(arg0.mainShips) do
		table.insert(var0, iter3)
	end

	return var0
end

function var0.GetGearScoreSum(arg0, arg1)
	local var0

	if arg1 == "main" then
		var0 = arg0.mainShips
	elseif arg1 == "vanguard" then
		var0 = arg0.vanguardShips
	end

	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 + iter1:getShipCombatPower()
	end

	return var1
end

return var0
