local var0_0 = class("IslandCharacterAgency", import(".IslandBaseAgency"))

var0_0.ADD_SHIP = "IslandCharacterAgency:ADD_SHIP"
var0_0.SHIP_LEVEL_UP = "IslandCharacterAgency:SHIP_LEVEL_UP"
var0_0.SHIP_GET_STATE = "IslandCharacterAgency:SHIP_GET_STATE"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.ships = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.ship_list or {}) do
		local var0_1 = IslandShip.New(iter1_1)

		arg0_1.ships[var0_1.id] = var0_1
	end
end

function var0_0.GetShips(arg0_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in pairs(arg0_2.ships) do
		table.insert(var0_2, iter1_2)
	end

	return var0_2
end

function var0_0.AddShip(arg0_3, arg1_3)
	arg0_3.ships[arg1_3.id] = arg1_3

	arg0_3:DispatchEvent(var0_0.ADD_SHIP, arg1_3)
end

function var0_0.GetShipById(arg0_4, arg1_4)
	return arg0_4.ships[arg1_4]
end

function var0_0.GetShipByConfigId(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.ships) do
		if iter1_5.configId == arg1_5 then
			return iter1_5
		end
	end

	return nil
end

function var0_0.GetUnlockOrCanUnlockShipConfigIds(arg0_6)
	local var0_6 = {}
	local var1_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.ships) do
		var1_6[iter1_6.configId] = true
	end

	for iter2_6, iter3_6 in ipairs(pg.island_ship.all) do
		if var1_6[iter3_6] or IslandShip.StaticCanUnlock(iter3_6) then
			table.insert(var0_6, iter3_6)
		end
	end

	table.sort(var0_6, CompareFuncs({
		function(arg0_7)
			return var1_6[arg0_7] and 0 or 1
		end,
		function(arg0_8)
			return arg0_8
		end
	}))

	return var0_6
end

function var0_0.ExtraShipAward(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetShipById(arg1_9)
	local var1_9 = var0_9:GetExtraAwardList(arg2_9)
	local var2_9 = var0_9.level

	var0_9:AddExp(var1_9[1])

	if var2_9 < var0_9.level then
		arg0_9:DispatchEvent(IslandCharacterAgency.SHIP_LEVEL_UP, var0_9)
	end

	var0_9:UpdateExtraAwardValue(arg2_9)
end

function var0_0.AddShipState(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:GetShipById(arg1_10)

	var0_10:AddEnergy(arg2_10)

	local var1_10 = var0_10:GetFavoriteGift()

	if table.contains(var1_10, arg1_10) then
		local var2_10 = IslandShip.StaticGetGiftStatue()
		local var3_10 = pg.island_ship_state[var2_10].duration

		if not var0_10:ExistStatus(var2_10) then
			arg0_10:DispatchEvent(IslandCharacterAgency.SHIP_GET_STATE, {
				ship = var0_10,
				status = status
			})
		end

		var0_10:AddStatus(var2_10, var3_10)
	end
end

return var0_0
