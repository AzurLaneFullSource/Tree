pg = pg or {}

local var0 = pg

var0.ShipFlagMgr = singletonClass("ShipFlagMgr")

local var1 = var0.ShipFlagMgr

function var1.Init(arg0, arg1)
	arg0.flagDic = {}
	arg0.extraInfo = {}

	for iter0, iter1 in ipairs(ShipStatus.flagList) do
		arg0.flagDic[iter1] = {}
	end

	print("initializing ShipFlagMgr manager...")
	arg1()
end

local var2 = {
	inChapter = function()
		local var0 = getProxy(ChapterProxy):getActiveChapter()

		return var0 and _.map(var0:getShips(), function(arg0)
			return arg0.id
		end) or {}
	end,
	inFleet = function()
		return getProxy(FleetProxy):getAllShipIds(true)
	end,
	inElite = function()
		local var0 = {}
		local var1 = getProxy(ChapterProxy)
		local var2 = getProxy(ActivityProxy)

		if var1.mapEliteFleetCache then
			for iter0, iter1 in pairs(var1.mapEliteFleetCache) do
				assert(var0.expedition_data_by_map[iter0], "Missing Map Config " .. (iter0 or "NIL"))

				local var3 = var0.expedition_data_by_map[iter0].on_activity

				if var3 == 0 or checkExist(var2:getActivityById(var3), {
					"isEnd"
				}) == false then
					var0[iter0] = _.flatten(iter1)
				end
			end
		end

		return _.flatten(_.values(var0)), var0
	end,
	inSupport = function()
		local var0 = {}
		local var1 = getProxy(ChapterProxy)

		if var1.mapSupportFleetCache then
			for iter0, iter1 in pairs(var1.mapSupportFleetCache) do
				assert(var0.expedition_data_by_map[iter0], "Missing Map Config " .. (iter0 or "NIL"))

				var0[iter0] = _.flatten(iter1)
			end
		end

		return _.flatten(_.values(var0)), var0
	end,
	inActivity = function()
		local var0 = {}
		local var1 = getProxy(FleetProxy)

		for iter0, iter1 in pairs(var1:getActivityFleets()) do
			var0[iter0] = _.flatten(_.map(_.values(iter1), function(arg0)
				return arg0.ships
			end))
		end

		return _.flatten(_.values(var0)), var0
	end,
	inPvP = function()
		local var0 = getProxy(FleetProxy):getFleetById(FleetProxy.PVP_FLEET_ID)

		return var0 and var0:getShipIds() or {}
	end,
	inChallenge = function()
		local var0 = getProxy(FleetProxy)
		local var1 = var0:getFleetById(FleetProxy.CHALLENGE_FLEET_ID)
		local var2 = var0:getFleetById(FleetProxy.CHALLENGE_SUB_FLEET_ID)
		local var3 = var1:getShipIds()

		table.insertto(var3, var2:getShipIds())

		return var3
	end,
	inExercise = function()
		return getProxy(MilitaryExerciseProxy):getExerciseFleet():getShipIds()
	end,
	inEvent = function()
		return getProxy(EventProxy):getActiveShipIds()
	end,
	inClass = function()
		return getProxy(NavalAcademyProxy):GetShipIDs()
	end,
	inTactics = function()
		local var0 = getProxy(NavalAcademyProxy):getStudents()

		return _.map(underscore.values(var0), function(arg0)
			return arg0 and arg0.shipId
		end)
	end,
	inBackyard = function()
		return getProxy(DormProxy):getRawData().shipIds
	end,
	inAdmiral = function()
		return getProxy(PlayerProxy):getRawData().characters
	end,
	inWorld = function()
		local var0 = nowWorld()

		if var0.type == World.TypeBase then
			return underscore.rest(var0.baseShipIds, 1)
		else
			return _.map(var0:GetShips(), function(arg0)
				return arg0.id
			end)
		end
	end,
	isActivityNpc = function()
		return getProxy(BayProxy).activityNpcShipIds
	end,
	inGuildEvent = function()
		local var0 = getProxy(GuildProxy):getRawData()

		if var0 then
			return var0:GetMissionAndAssultFleetShips()
		else
			return {}
		end
	end,
	inGuildBossEvent = function()
		local var0 = getProxy(GuildProxy):getRawData()

		if var0 then
			return var0:GetBossMissionShips()
		else
			return {}
		end
	end
}

function var1.MarkShipsFlag(arg0, arg1, arg2, arg3)
	for iter0, iter1 in ipairs(arg2) do
		arg0.flagDic[arg1][iter1] = true
	end

	if arg3 then
		arg0.extraInfo[arg1] = arg3
	end
end

function var1.GetShipFlag(arg0, arg1, arg2, arg3)
	arg3 = defaultValue(arg3, true)

	if type(arg3) == "boolean" then
		return arg0.flagDic[arg2][arg1] == arg3
	elseif type(arg3) == "number" then
		if arg2 == "inElite" then
			local var0 = arg0.extraInfo[arg2][arg3] or {}

			return _.any(var0, function(arg0)
				return arg0 == arg1
			end)
		elseif arg2 == "inActivity" then
			local var1 = arg0.extraInfo[arg2][arg3] or {}

			return _.any(var1, function(arg0)
				return arg0 == arg1
			end)
		elseif arg2 == "inSupport" then
			local var2 = arg0.extraInfo[arg2][arg3] or {}

			return _.any(var2, function(arg0)
				return arg0 == arg1
			end)
		else
			assert(false, "flagName:" .. arg2 .. " type error")
		end
	else
		assert(false, "info type error")
	end
end

function var1.FilterShips(arg0, arg1, arg2)
	arg2 = arg2 or underscore.keys(getProxy(BayProxy):getRawData())

	local var0 = {}

	for iter0, iter1 in ipairs(arg2) do
		for iter2, iter3 in pairs(arg1) do
			if iter3 and arg0:GetShipFlag(iter1, iter2, iter3) then
				var0[iter1] = true

				break
			end
		end
	end

	return _.keys(var0)
end

function var1.UpdateFlagShips(arg0, arg1)
	arg0.flagDic[arg1] = {}

	arg0:MarkShipsFlag(arg1, var2[arg1]())
end

function var1.ClearShipsFlag(arg0, arg1)
	arg0.flagDic[arg1] = {}
end

function var1.DebugPrint(arg0, arg1)
	warning("id:" .. arg1 .. " flags:")

	for iter0, iter1 in ipairs(ShipStatus.flagList) do
		if arg0.flagDic[iter1][arg1] then
			warning(iter1)
		end
	end
end

return var1
