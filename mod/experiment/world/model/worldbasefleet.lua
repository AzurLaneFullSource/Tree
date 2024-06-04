local var0 = class("WorldBaseFleet", import("...BaseEntity"))

var0.Fields = {
	id = "number",
	commanderIds = "table",
	[TeamType.Main] = "table",
	[TeamType.Vanguard] = "table",
	[TeamType.Submarine] = "table"
}

function var0.Build(arg0)
	arg0[TeamType.Main] = {}
	arg0[TeamType.Vanguard] = {}
	arg0[TeamType.Submarine] = {}
	arg0.commanderIds = {}
end

function var0.Setup(arg0, arg1)
	arg0.id = arg1.id

	local var0 = _.map(arg1.ship_list, function(arg0)
		local var0 = WPool:Get(WorldMapShip)

		var0.id = arg0

		return var0
	end)

	arg0:UpdateShips(var0)

	arg0.commanderIds = {}

	for iter0, iter1 in ipairs(arg1.commanders or {}) do
		arg0.commanderIds[iter1.pos] = iter1.id
	end
end

function var0.UpdateShips(arg0, arg1)
	arg0[TeamType.Main] = {}
	arg0[TeamType.Vanguard] = {}
	arg0[TeamType.Submarine] = {}

	_.each(arg1, function(arg0)
		assert(arg0.class == WorldMapShip)

		if arg0:IsValid() then
			arg0.fleetId = arg0.id

			table.insert(arg0[WorldConst.FetchRawShipVO(arg0.id):getTeamType()], arg0)
		end
	end)

	for iter0, iter1 in ipairs({
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}) do
		underscore.each(arg0[iter1], function(arg0)
			arg0.triggers.TeamNumbers = #arg0[iter1]
		end)
	end
end

function var0.IsValid(arg0)
	if arg0:GetFleetType() == FleetType.Submarine then
		return #arg0:GetTeamShips(TeamType.Submarine, true) > 0
	else
		return #arg0:GetTeamShips(TeamType.Vanguard, true) > 0 and #arg0:GetTeamShips(TeamType.Main, true) > 0
	end
end

function var0.GetFleetType(arg0)
	return #arg0[TeamType.Submarine] > 0 and FleetType.Submarine or FleetType.Normal
end

function var0.GetPrefab(arg0)
	return arg0:GetFlagShipVO():getPrefab()
end

function var0.GetShip(arg0, arg1)
	return _.detect(arg0:GetShips(true), function(arg0)
		return arg0.id == arg1
	end)
end

function var0.GetShips(arg0, arg1)
	local var0 = {}

	_.each({
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}, function(arg0)
		for iter0, iter1 in ipairs(arg0[arg0]) do
			if arg1 or iter1:IsAlive() then
				table.insert(var0, iter1)
			end
		end
	end)

	return var0
end

function var0.GetShipVOs(arg0, arg1)
	return _.map(arg0:GetShips(arg1), function(arg0)
		return WorldConst.FetchShipVO(arg0.id)
	end)
end

function var0.GetTeamShips(arg0, arg1, arg2)
	return _(arg0[arg1]):chain():filter(function(arg0)
		return arg2 or arg0:IsAlive()
	end):value()
end

function var0.GetTeamShipVOs(arg0, arg1, arg2)
	return _.map(arg0:GetTeamShips(arg1, arg2), function(arg0)
		return WorldConst.FetchShipVO(arg0.id)
	end)
end

function var0.GetFlagShipVO(arg0)
	if arg0:GetFleetType() == FleetType.Submarine then
		return WorldConst.FetchShipVO(_.detect(arg0[TeamType.Submarine], function(arg0)
			return arg0:IsAlive()
		end).id)
	else
		return WorldConst.FetchShipVO(_.detect(arg0[TeamType.Main], function(arg0)
			return arg0:IsAlive()
		end).id)
	end
end

function var0.IsAlive(arg0)
	return _.any(arg0[TeamType.Main], function(arg0)
		return arg0:IsAlive()
	end) and _.any(arg0[TeamType.Vanguard], function(arg0)
		return arg0:IsAlive()
	end)
end

function var0.GetLevel(arg0)
	local var0 = arg0:GetShips(true)

	return math.floor(_.reduce(var0, 0, function(arg0, arg1)
		return arg0 + WorldConst.FetchRawShipVO(arg1.id).level
	end) / #var0)
end

function var0.BuildFormationIds(arg0)
	local var0 = {
		[TeamType.Main] = {},
		[TeamType.Vanguard] = {},
		[TeamType.Submarine] = {}
	}

	for iter0, iter1 in pairs(var0) do
		var0[iter0] = _.map(arg0:GetTeamShips(iter0), function(arg0)
			return arg0.id
		end)
	end

	var0.commanders = {}

	for iter2, iter3 in pairs(arg0.commanderIds) do
		table.insert(var0.commanders, {
			pos = iter2,
			id = iter3
		})
	end

	return var0
end

function var0.getTeamByName(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0[arg1]) do
		if iter1:IsAlive() then
			table.insert(var0, iter1.id)
		end
	end

	return var0
end

function var0.getFleetType(arg0)
	return arg0:GetFleetType()
end

function var0.getShipVOsDic(arg0)
	local var0 = {}
	local var1 = arg0:GetShipVOs()

	for iter0, iter1 in ipairs(var1) do
		var0[iter1.id] = iter1
	end

	return var0
end

return var0
