pg = pg or {}

local var0_0 = pg

var0_0.ShipFlagMgr = singletonClass("ShipFlagMgr")

local var1_0 = var0_0.ShipFlagMgr

function var1_0.Init(arg0_1, arg1_1)
	arg0_1.flagDic = {}
	arg0_1.extraInfo = {}

	for iter0_1, iter1_1 in ipairs(ShipStatus.flagList) do
		arg0_1.flagDic[iter1_1] = {}
	end

	print("initializing ShipFlagMgr manager...")
	arg1_1()
end

local var2_0 = {
	inChapter = function()
		local var0_2 = getProxy(ChapterProxy):getActiveChapter()

		return var0_2 and _.map(var0_2:getShips(), function(arg0_3)
			return arg0_3.id
		end) or {}
	end,
	inFleet = function()
		return getProxy(FleetProxy):getAllShipIds(true)
	end,
	inElite = function()
		local var0_5 = {}
		local var1_5 = getProxy(ChapterProxy)
		local var2_5 = getProxy(ActivityProxy)

		if var1_5.mapEliteFleetCache then
			for iter0_5, iter1_5 in pairs(var1_5.mapEliteFleetCache) do
				assert(var0_0.expedition_data_by_map[iter0_5], "Missing Map Config " .. (iter0_5 or "NIL"))

				local var3_5 = var0_0.expedition_data_by_map[iter0_5].on_activity

				if var3_5 == 0 or checkExist(var2_5:getActivityById(var3_5), {
					"isEnd"
				}) == false then
					var0_5[iter0_5] = _.flatten(iter1_5)
				end
			end
		end

		return _.flatten(_.values(var0_5)), var0_5
	end,
	inSupport = function()
		local var0_6 = {}
		local var1_6 = getProxy(ChapterProxy)

		if var1_6.mapSupportFleetCache then
			for iter0_6, iter1_6 in pairs(var1_6.mapSupportFleetCache) do
				assert(var0_0.expedition_data_by_map[iter0_6], "Missing Map Config " .. (iter0_6 or "NIL"))

				var0_6[iter0_6] = _.flatten(iter1_6)
			end
		end

		return _.flatten(_.values(var0_6)), var0_6
	end,
	inActivity = function()
		local var0_7 = {}
		local var1_7 = getProxy(FleetProxy)

		for iter0_7, iter1_7 in pairs(var1_7:getActivityFleets()) do
			var0_7[iter0_7] = _.flatten(_.map(_.values(iter1_7), function(arg0_8)
				return arg0_8.ships
			end))
		end

		return _.flatten(_.values(var0_7)), var0_7
	end,
	inPvP = function()
		local var0_9 = getProxy(FleetProxy):getFleetById(FleetProxy.PVP_FLEET_ID)

		return var0_9 and var0_9:getShipIds() or {}
	end,
	inChallenge = function()
		local var0_10 = getProxy(FleetProxy)
		local var1_10 = var0_10:getFleetById(FleetProxy.CHALLENGE_FLEET_ID)
		local var2_10 = var0_10:getFleetById(FleetProxy.CHALLENGE_SUB_FLEET_ID)
		local var3_10 = var1_10:getShipIds()

		table.insertto(var3_10, var2_10:getShipIds())

		return var3_10
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
		local var0_14 = getProxy(NavalAcademyProxy):getStudents()

		return _.map(underscore.values(var0_14), function(arg0_15)
			return arg0_15 and arg0_15.shipId
		end)
	end,
	inBackyard = function()
		return getProxy(DormProxy):getRawData().shipIds
	end,
	inAdmiral = function()
		return getProxy(PlayerProxy):getRawData().characters
	end,
	inWorld = function()
		local var0_18 = nowWorld()

		if var0_18.type == World.TypeBase then
			return underscore.rest(var0_18.baseShipIds, 1)
		else
			return _.map(var0_18:GetShips(), function(arg0_19)
				return arg0_19.id
			end)
		end
	end,
	isActivityNpc = function()
		return getProxy(BayProxy).activityNpcShipIds
	end,
	inGuildEvent = function()
		local var0_21 = getProxy(GuildProxy):getRawData()

		if var0_21 then
			return var0_21:GetMissionAndAssultFleetShips()
		else
			return {}
		end
	end,
	inGuildBossEvent = function()
		local var0_22 = getProxy(GuildProxy):getRawData()

		if var0_22 then
			return var0_22:GetBossMissionShips()
		else
			return {}
		end
	end
}

function var1_0.MarkShipsFlag(arg0_23, arg1_23, arg2_23, arg3_23)
	for iter0_23, iter1_23 in ipairs(arg2_23) do
		arg0_23.flagDic[arg1_23][iter1_23] = true
	end

	if arg3_23 then
		arg0_23.extraInfo[arg1_23] = arg3_23
	end
end

function var1_0.GetShipFlag(arg0_24, arg1_24, arg2_24, arg3_24)
	arg3_24 = defaultValue(arg3_24, true)

	if type(arg3_24) == "boolean" then
		return arg0_24.flagDic[arg2_24][arg1_24] == arg3_24
	elseif type(arg3_24) == "number" then
		if arg2_24 == "inElite" then
			local var0_24 = arg0_24.extraInfo[arg2_24][arg3_24] or {}

			return _.any(var0_24, function(arg0_25)
				return arg0_25 == arg1_24
			end)
		elseif arg2_24 == "inActivity" then
			local var1_24 = arg0_24.extraInfo[arg2_24][arg3_24] or {}

			return _.any(var1_24, function(arg0_26)
				return arg0_26 == arg1_24
			end)
		elseif arg2_24 == "inSupport" then
			local var2_24 = arg0_24.extraInfo[arg2_24][arg3_24] or {}

			return _.any(var2_24, function(arg0_27)
				return arg0_27 == arg1_24
			end)
		else
			assert(false, "flagName:" .. arg2_24 .. " type error")
		end
	else
		assert(false, "info type error")
	end
end

function var1_0.FilterShips(arg0_28, arg1_28, arg2_28)
	arg2_28 = arg2_28 or underscore.keys(getProxy(BayProxy):getRawData())

	local var0_28 = {}

	for iter0_28, iter1_28 in ipairs(arg2_28) do
		for iter2_28, iter3_28 in pairs(arg1_28) do
			if iter3_28 and arg0_28:GetShipFlag(iter1_28, iter2_28, iter3_28) then
				var0_28[iter1_28] = true

				break
			end
		end
	end

	return _.keys(var0_28)
end

function var1_0.UpdateFlagShips(arg0_29, arg1_29)
	arg0_29.flagDic[arg1_29] = {}

	arg0_29:MarkShipsFlag(arg1_29, var2_0[arg1_29]())
end

function var1_0.ClearShipsFlag(arg0_30, arg1_30)
	arg0_30.flagDic[arg1_30] = {}
end

function var1_0.DebugPrint(arg0_31, arg1_31)
	warning("id:" .. arg1_31 .. " flags:")

	for iter0_31, iter1_31 in ipairs(ShipStatus.flagList) do
		if arg0_31.flagDic[iter1_31][arg1_31] then
			warning(iter1_31)
		end
	end
end

return var1_0
