local var0_0 = class("WorldBaseFleet", import("...BaseEntity"))

var0_0.Fields = {
	id = "number",
	commanderIds = "table",
	[TeamType.Main] = "table",
	[TeamType.Vanguard] = "table",
	[TeamType.Submarine] = "table"
}

function var0_0.Build(arg0_1)
	arg0_1[TeamType.Main] = {}
	arg0_1[TeamType.Vanguard] = {}
	arg0_1[TeamType.Submarine] = {}
	arg0_1.commanderIds = {}
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id

	local var0_2 = _.map(arg1_2.ship_list, function(arg0_3)
		local var0_3 = WPool:Get(WorldMapShip)

		var0_3.id = arg0_3

		return var0_3
	end)

	arg0_2:UpdateShips(var0_2)

	arg0_2.commanderIds = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.commanders or {}) do
		arg0_2.commanderIds[iter1_2.pos] = iter1_2.id
	end
end

function var0_0.UpdateShips(arg0_4, arg1_4)
	arg0_4[TeamType.Main] = {}
	arg0_4[TeamType.Vanguard] = {}
	arg0_4[TeamType.Submarine] = {}

	_.each(arg1_4, function(arg0_5)
		assert(arg0_5.class == WorldMapShip)

		if arg0_5:IsValid() then
			arg0_5.fleetId = arg0_4.id

			table.insert(arg0_4[WorldConst.FetchRawShipVO(arg0_5.id):getTeamType()], arg0_5)
		end
	end)

	for iter0_4, iter1_4 in ipairs({
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}) do
		underscore.each(arg0_4[iter1_4], function(arg0_6)
			arg0_6.triggers.TeamNumbers = #arg0_4[iter1_4]
		end)
	end
end

function var0_0.IsValid(arg0_7)
	if arg0_7:GetFleetType() == FleetType.Submarine then
		return #arg0_7:GetTeamShips(TeamType.Submarine, true) > 0
	else
		return #arg0_7:GetTeamShips(TeamType.Vanguard, true) > 0 and #arg0_7:GetTeamShips(TeamType.Main, true) > 0
	end
end

function var0_0.GetFleetType(arg0_8)
	return #arg0_8[TeamType.Submarine] > 0 and FleetType.Submarine or FleetType.Normal
end

function var0_0.GetPrefab(arg0_9)
	return arg0_9:GetFlagShipVO():getPrefab()
end

function var0_0.GetShip(arg0_10, arg1_10)
	return _.detect(arg0_10:GetShips(true), function(arg0_11)
		return arg0_11.id == arg1_10
	end)
end

function var0_0.GetShips(arg0_12, arg1_12)
	local var0_12 = {}

	_.each({
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}, function(arg0_13)
		for iter0_13, iter1_13 in ipairs(arg0_12[arg0_13]) do
			if arg1_12 or iter1_13:IsAlive() then
				table.insert(var0_12, iter1_13)
			end
		end
	end)

	return var0_12
end

function var0_0.GetShipVOs(arg0_14, arg1_14)
	return _.map(arg0_14:GetShips(arg1_14), function(arg0_15)
		return WorldConst.FetchShipVO(arg0_15.id)
	end)
end

function var0_0.GetTeamShips(arg0_16, arg1_16, arg2_16)
	return _(arg0_16[arg1_16]):chain():filter(function(arg0_17)
		return arg2_16 or arg0_17:IsAlive()
	end):value()
end

function var0_0.GetTeamShipVOs(arg0_18, arg1_18, arg2_18)
	return _.map(arg0_18:GetTeamShips(arg1_18, arg2_18), function(arg0_19)
		return WorldConst.FetchShipVO(arg0_19.id)
	end)
end

function var0_0.GetFlagShipVO(arg0_20)
	if arg0_20:GetFleetType() == FleetType.Submarine then
		return WorldConst.FetchShipVO(_.detect(arg0_20[TeamType.Submarine], function(arg0_21)
			return arg0_21:IsAlive()
		end).id)
	else
		return WorldConst.FetchShipVO(_.detect(arg0_20[TeamType.Main], function(arg0_22)
			return arg0_22:IsAlive()
		end).id)
	end
end

function var0_0.IsAlive(arg0_23)
	return _.any(arg0_23[TeamType.Main], function(arg0_24)
		return arg0_24:IsAlive()
	end) and _.any(arg0_23[TeamType.Vanguard], function(arg0_25)
		return arg0_25:IsAlive()
	end)
end

function var0_0.GetLevel(arg0_26)
	local var0_26 = arg0_26:GetShips(true)

	return math.floor(_.reduce(var0_26, 0, function(arg0_27, arg1_27)
		return arg0_27 + WorldConst.FetchRawShipVO(arg1_27.id).level
	end) / #var0_26)
end

function var0_0.BuildFormationIds(arg0_28)
	local var0_28 = {
		[TeamType.Main] = {},
		[TeamType.Vanguard] = {},
		[TeamType.Submarine] = {}
	}

	for iter0_28, iter1_28 in pairs(var0_28) do
		var0_28[iter0_28] = _.map(arg0_28:GetTeamShips(iter0_28), function(arg0_29)
			return arg0_29.id
		end)
	end

	var0_28.commanders = {}

	for iter2_28, iter3_28 in pairs(arg0_28.commanderIds) do
		table.insert(var0_28.commanders, {
			pos = iter2_28,
			id = iter3_28
		})
	end

	return var0_28
end

function var0_0.getTeamByName(arg0_30, arg1_30)
	local var0_30 = {}

	for iter0_30, iter1_30 in ipairs(arg0_30[arg1_30]) do
		if iter1_30:IsAlive() then
			table.insert(var0_30, iter1_30.id)
		end
	end

	return var0_30
end

function var0_0.getFleetType(arg0_31)
	return arg0_31:GetFleetType()
end

function var0_0.getShipVOsDic(arg0_32)
	local var0_32 = {}
	local var1_32 = arg0_32:GetShipVOs()

	for iter0_32, iter1_32 in ipairs(var1_32) do
		var0_32[iter1_32.id] = iter1_32
	end

	return var0_32
end

return var0_0
