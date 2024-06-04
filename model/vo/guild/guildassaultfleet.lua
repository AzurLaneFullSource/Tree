local var0 = class("GuildAssaultFleet", import("..BaseVO"))

function var0.GetRealId(arg0)
	return tonumber(string.split(tostring(arg0), "_")[1])
end

function var0.GetUserId(arg0)
	return tonumber(string.split(tostring(arg0), "_")[2])
end

function var0.GetVirtualId(arg0, arg1)
	return arg1 .. "_" .. arg0
end

function var0.IsSameUserId(arg0, arg1)
	return var0.GetUserId(arg0) == var0.GetUserId(arg1)
end

function var0.Ctor(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1.ships or {}) do
		var0[iter0] = GuildAssaultShip.New(iter1)
	end

	arg0:InitShips(arg1.user_id, var0)
end

function var0.InitShips(arg0, arg1, arg2)
	arg0.ships = {}
	arg0.userId = arg1

	for iter0, iter1 in pairs(arg2) do
		iter1.id = var0.GetVirtualId(arg0.userId, iter1.id)
		arg0.ships[iter0] = iter1
	end
end

function var0.ClearAllRecommandShip(arg0)
	for iter0, iter1 in ipairs(arg0.ships) do
		arg0:MarkShipBeRecommanded(iter1, false)
	end
end

function var0.SetRecommendList(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.ships) do
		local var0 = var0.GetRealId(iter1.id)

		if _.any(arg1, function(arg0)
			return arg0 == var0
		end) then
			arg0:MarkShipBeRecommanded(iter1, true)
		end
	end
end

function var0.MarkShipBeRecommanded(arg0, arg1, arg2)
	arg1.guildRecommand = arg2
end

function var0.SetShipBeRecommanded(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.ships) do
		if arg1 == var0.GetRealId(iter1.id) then
			arg0:MarkShipBeRecommanded(iter1, arg2)

			break
		end
	end
end

function var0.GetStrongestShip(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.ships) do
		if iter1:getTeamType() == arg1 then
			table.insert(var0, iter1)
		end
	end

	table.sort(var0, function(arg0, arg1)
		return arg0.level > arg1.level
	end)

	return var0[1]
end

function var0.GetShipList(arg0)
	return arg0.ships
end

function var0.IsEmpty(arg0)
	return table.getCount(arg0.ships) == 0
end

function var0.ExistShip(arg0, arg1)
	for iter0, iter1 in pairs(arg0.ships) do
		if arg1 == iter1.id then
			return true
		end
	end

	return false
end

function var0.GetShipIds(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.ships) do
		table.insert(var0, iter1.id)
	end

	return var0
end

function var0.GetShipById(arg0, arg1)
	for iter0, iter1 in pairs(arg0.ships) do
		if iter1.id == arg1 then
			return iter1
		end
	end
end

function var0.GetShipByRealId(arg0, arg1, arg2)
	local var0 = var0.GetVirtualId(arg1, arg2)

	for iter0, iter1 in pairs(arg0.ships) do
		if iter1.id == var0 then
			return iter1
		end
	end
end

function var0.GetShipByPos(arg0, arg1)
	return arg0.ships[arg1]
end

function var0.InsertBayShip(arg0, arg1, arg2)
	arg2.id = var0.GetVirtualId(arg0.userId, arg2.id)
	arg0.ships[arg1] = arg2
end

function var0.AnyShipChanged(arg0, arg1)
	for iter0 = 1, 2 do
		if arg0:PositionIsChanged(arg1, iter0) then
			return true
		end
	end

	return false
end

function var0.PositionIsChanged(arg0, arg1, arg2)
	local function var0(arg0, arg1)
		if arg0 and arg1 and arg0.id == arg1.id then
			for iter0, iter1 in ipairs(arg0.equipments) do
				local var0 = arg1.equipments[iter0]
				local var1 = iter1 and 1 or 0
				local var2 = var0 and 1 or 0

				if var1 ~= var2 or var1 == var2 and var1 == 1 and iter1.id ~= var0.id then
					return true
				end
			end
		end

		return false
	end

	local var1 = arg1:GetShipByPos(arg2)
	local var2 = arg0:GetShipByPos(arg2)

	if (var1 and var1.id or 0) ~= (var2 and var2.id or 0) or var0(var1, var2) then
		return true
	end

	return false
end

return var0
