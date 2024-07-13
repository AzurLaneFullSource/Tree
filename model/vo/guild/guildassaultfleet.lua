local var0_0 = class("GuildAssaultFleet", import("..BaseVO"))

function var0_0.GetRealId(arg0_1)
	return tonumber(string.split(tostring(arg0_1), "_")[1])
end

function var0_0.GetUserId(arg0_2)
	return tonumber(string.split(tostring(arg0_2), "_")[2])
end

function var0_0.GetVirtualId(arg0_3, arg1_3)
	return arg1_3 .. "_" .. arg0_3
end

function var0_0.IsSameUserId(arg0_4, arg1_4)
	return var0_0.GetUserId(arg0_4) == var0_0.GetUserId(arg1_4)
end

function var0_0.Ctor(arg0_5, arg1_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in ipairs(arg1_5.ships or {}) do
		var0_5[iter0_5] = GuildAssaultShip.New(iter1_5)
	end

	arg0_5:InitShips(arg1_5.user_id, var0_5)
end

function var0_0.InitShips(arg0_6, arg1_6, arg2_6)
	arg0_6.ships = {}
	arg0_6.userId = arg1_6

	for iter0_6, iter1_6 in pairs(arg2_6) do
		iter1_6.id = var0_0.GetVirtualId(arg0_6.userId, iter1_6.id)
		arg0_6.ships[iter0_6] = iter1_6
	end
end

function var0_0.ClearAllRecommandShip(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.ships) do
		arg0_7:MarkShipBeRecommanded(iter1_7, false)
	end
end

function var0_0.SetRecommendList(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.ships) do
		local var0_8 = var0_0.GetRealId(iter1_8.id)

		if _.any(arg1_8, function(arg0_9)
			return arg0_9 == var0_8
		end) then
			arg0_8:MarkShipBeRecommanded(iter1_8, true)
		end
	end
end

function var0_0.MarkShipBeRecommanded(arg0_10, arg1_10, arg2_10)
	arg1_10.guildRecommand = arg2_10
end

function var0_0.SetShipBeRecommanded(arg0_11, arg1_11, arg2_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.ships) do
		if arg1_11 == var0_0.GetRealId(iter1_11.id) then
			arg0_11:MarkShipBeRecommanded(iter1_11, arg2_11)

			break
		end
	end
end

function var0_0.GetStrongestShip(arg0_12, arg1_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.ships) do
		if iter1_12:getTeamType() == arg1_12 then
			table.insert(var0_12, iter1_12)
		end
	end

	table.sort(var0_12, function(arg0_13, arg1_13)
		return arg0_13.level > arg1_13.level
	end)

	return var0_12[1]
end

function var0_0.GetShipList(arg0_14)
	return arg0_14.ships
end

function var0_0.IsEmpty(arg0_15)
	return table.getCount(arg0_15.ships) == 0
end

function var0_0.ExistShip(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16.ships) do
		if arg1_16 == iter1_16.id then
			return true
		end
	end

	return false
end

function var0_0.GetShipIds(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in pairs(arg0_17.ships) do
		table.insert(var0_17, iter1_17.id)
	end

	return var0_17
end

function var0_0.GetShipById(arg0_18, arg1_18)
	for iter0_18, iter1_18 in pairs(arg0_18.ships) do
		if iter1_18.id == arg1_18 then
			return iter1_18
		end
	end
end

function var0_0.GetShipByRealId(arg0_19, arg1_19, arg2_19)
	local var0_19 = var0_0.GetVirtualId(arg1_19, arg2_19)

	for iter0_19, iter1_19 in pairs(arg0_19.ships) do
		if iter1_19.id == var0_19 then
			return iter1_19
		end
	end
end

function var0_0.GetShipByPos(arg0_20, arg1_20)
	return arg0_20.ships[arg1_20]
end

function var0_0.InsertBayShip(arg0_21, arg1_21, arg2_21)
	arg2_21.id = var0_0.GetVirtualId(arg0_21.userId, arg2_21.id)
	arg0_21.ships[arg1_21] = arg2_21
end

function var0_0.AnyShipChanged(arg0_22, arg1_22)
	for iter0_22 = 1, 2 do
		if arg0_22:PositionIsChanged(arg1_22, iter0_22) then
			return true
		end
	end

	return false
end

function var0_0.PositionIsChanged(arg0_23, arg1_23, arg2_23)
	local function var0_23(arg0_24, arg1_24)
		if arg0_24 and arg1_24 and arg0_24.id == arg1_24.id then
			for iter0_24, iter1_24 in ipairs(arg0_24.equipments) do
				local var0_24 = arg1_24.equipments[iter0_24]
				local var1_24 = iter1_24 and 1 or 0
				local var2_24 = var0_24 and 1 or 0

				if var1_24 ~= var2_24 or var1_24 == var2_24 and var1_24 == 1 and iter1_24.id ~= var0_24.id then
					return true
				end
			end
		end

		return false
	end

	local var1_23 = arg1_23:GetShipByPos(arg2_23)
	local var2_23 = arg0_23:GetShipByPos(arg2_23)

	if (var1_23 and var1_23.id or 0) ~= (var2_23 and var2_23.id or 0) or var0_23(var1_23, var2_23) then
		return true
	end

	return false
end

return var0_0
