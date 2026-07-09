local var0_0 = class("NewBattleResultDataExtender")

function var0_0.NeedCloseCamera(arg0_1)
	return arg0_1 ~= SYSTEM_BOSS_RUSH and arg0_1 ~= SYSTEM_BOSS_RUSH_EX and arg0_1 ~= SYSTEM_BOSS_RUSH_COLLABRATE and arg0_1 ~= SYSTEM_ACT_BOSS and arg0_1 ~= SYSTEM_WORLD_BOSS and arg0_1 ~= SYSTEM_BOSS_SINGLE and arg0_1 ~= SYSTEM_BOSS_SINGLE_VARIABLE
end

function var0_0.NeedVibrate(arg0_2)
	local var0_2 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	return ys.Battle.BattleState.IsAutoBotActive() and var0_2 and not arg0_2
end

function var0_0.NeedHelpMessage(arg0_3, arg1_3)
	if (arg0_3 == SYSTEM_SCENARIO or arg0_3 == SYSTEM_ROUTINE or arg0_3 == SYSTEM_SUB_ROUTINE or arg0_3 == SYSTEM_DUEL) and arg1_3 <= 0 then
		return true
	end

	return false
end

function var0_0.GetAutoSkipFlag(arg0_4, arg1_4)
	if arg1_4 == SYSTEM_SCENARIO or arg1_4 == SYSTEM_SCENARIO_SUB_STRIKE then
		local var0_4 = getProxy(ChapterProxy):getActiveChapter()

		return getProxy(ChapterProxy):GetChapterAutoFlag(var0_4.id) == 1
	elseif arg1_4 == SYSTEM_WORLD then
		return nowWorld().isAutoFight
	elseif arg1_4 == SYSTEM_TEST then
		local var1_4 = InDebugBattleLoop

		return tobool(var1_4)
	end

	return arg0_4.autoSkipFlag or false
end

function var0_0.GetExpBuffs(arg0_5)
	local var0_5

	if arg0_5 == SYSTEM_SCENARIO or arg0_5 == SYSTEM_ROUTINE or arg0_5 == SYSTEM_ACT_BOSS or arg0_5 == SYSTEM_HP_SHARE_ACT_BOSS or arg0_5 == SYSTEM_SUB_ROUTINE or arg0_5 == SYSTEM_WORLD or arg0_5 == SYSTEM_BOSS_SINGLE or arg0_5 == SYSTEM_BOSS_SINGLE_VARIABLE then
		var0_5 = _.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function(arg0_6)
			return arg0_6:getConfig("benefit_type") == "rookie_battle_exp"
		end)
	end

	return var0_5
end

function var0_0.GetShipBuffs(arg0_7)
	local var0_7

	if arg0_7 == SYSTEM_SCENARIO or arg0_7 == SYSTEM_ROUTINE or arg0_7 == SYSTEM_ACT_BOSS or arg0_7 == SYSTEM_HP_SHARE_ACT_BOSS or arg0_7 == SYSTEM_SUB_ROUTINE or arg0_7 == SYSTEM_WORLD or arg0_7 == SYSTEM_BOSS_SINGLE or arg0_7 == SYSTEM_BOSS_SINGLE_VARIABLE then
		var0_7 = getProxy(ActivityProxy):getBuffShipList()
	end

	return var0_7
end

local function var1_0()
	local var0_8 = {}
	local var1_8 = getProxy(ChapterProxy):getActiveChapter()
	local var2_8 = var1_8.fleet
	local var3_8 = var2_8[TeamType.Main]
	local var4_8 = var2_8[TeamType.Vanguard]

	for iter0_8, iter1_8 in ipairs(var3_8) do
		table.insert(var0_8, iter1_8)
	end

	for iter2_8, iter3_8 in ipairs(var4_8) do
		table.insert(var0_8, iter3_8)
	end

	local var5_8 = _.detect(var1_8.fleets, function(arg0_9)
		return arg0_9:getFleetType() == FleetType.Submarine
	end)

	if var5_8 then
		local var6_8 = var5_8:getShipsByTeam(TeamType.Submarine, true)

		for iter4_8, iter5_8 in ipairs(var6_8) do
			table.insert(var0_8, iter5_8)
		end
	end

	return var0_8
end

local function var2_0()
	local var0_10 = {}
	local var1_10 = nowWorld():GetActiveMap()
	local var2_10 = var1_10:GetFleet()
	local var3_10 = var2_10:GetTeamShipVOs(TeamType.Main, true)
	local var4_10 = var2_10:GetTeamShipVOs(TeamType.Vanguard, true)

	for iter0_10, iter1_10 in ipairs(var3_10) do
		table.insert(var0_10, iter1_10)
	end

	for iter2_10, iter3_10 in ipairs(var4_10) do
		table.insert(var0_10, iter3_10)
	end

	local var5_10 = var1_10:GetSubmarineFleet()

	if var5_10 then
		local var6_10 = var5_10:GetTeamShipVOs(TeamType.Submarine, true)

		for iter4_10, iter5_10 in ipairs(var6_10) do
			table.insert(var0_10, iter5_10)
		end
	end

	return var0_10
end

local function var3_0(arg0_11)
	local var0_11 = nowWorld():GetBossProxy():GetFleet(arg0_11.bossId)

	return (getProxy(BayProxy):getShipsByFleet(var0_11))
end

local function var4_0(arg0_12)
	local var0_12 = getProxy(FleetProxy):getActivityFleets()[arg0_12.actId]
	local var1_12 = var0_12[arg0_12.mainFleetId]
	local var2_12 = getProxy(BayProxy):getShipsByFleet(var1_12)
	local var3_12 = var0_12[arg0_12.mainFleetId + 10]
	local var4_12 = getProxy(BayProxy):getShipsByFleet(var3_12)

	for iter0_12, iter1_12 in ipairs(var4_12) do
		table.insert(var2_12, iter1_12)
	end

	return var2_12
end

local function var5_0(arg0_13)
	local var0_13 = getProxy(FleetProxy):getActivityFleets()[arg0_13.actId]
	local var1_13 = var0_13[arg0_13.mainFleetId]
	local var2_13 = getProxy(BayProxy):getShipsByFleet(var1_13)
	local var3_13 = var0_13[arg0_13.mainFleetId + 100]
	local var4_13 = getProxy(BayProxy):getShipsByFleet(var3_13)

	for iter0_13, iter1_13 in ipairs(var4_13) do
		table.insert(var2_13, iter1_13)
	end

	return var2_13
end

local function var6_0()
	local var0_14 = {}
	local var1_14 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
	local var2_14 = var1_14:GetMainFleet()

	for iter0_14, iter1_14 in ipairs(var2_14:GetShips()) do
		table.insert(var0_14, iter1_14.ship)
	end

	local var3_14 = var1_14:GetSubFleet()

	for iter2_14, iter3_14 in ipairs(var3_14:GetShips()) do
		table.insert(var0_14, iter3_14.ship)
	end

	return var0_14
end

local function var7_0(arg0_15)
	local var0_15 = arg0_15.actId
	local var1_15 = getProxy(ActivityProxy):getActivityById(var0_15):GetSeriesData()

	assert(var1_15)

	local var2_15 = var1_15:GetStaegLevel()
	local var3_15 = var1_15:GetStageFleets(var1_15:GetMode(), var2_15)
	local var4_15 = getProxy(FleetProxy):getActivityFleets()[var0_15][var3_15]

	return (getProxy(BayProxy):getShipsByFleet(var4_15))
end

local function var8_0(arg0_16)
	local var0_16 = {}
	local var1_16 = getProxy(FleetProxy):getFleetById(FleetProxy.CHALLENGE_FLEET_ID)

	table.insertto(var0_16, getProxy(BayProxy):getShipsByFleet(var1_16))

	local var2_16 = getProxy(FleetProxy):getFleetById(FleetProxy.CHALLENGE_SUB_FLEET_ID)

	table.insertto(var0_16, getProxy(BayProxy):getShipsByFleet(var2_16))

	return var0_16
end

local function var9_0(arg0_17)
	local var0_17 = arg0_17.mainFleetId
	local var1_17 = getProxy(FleetProxy):getFleetById(var0_17)

	return (getProxy(BayProxy):getShipsByFleet(var1_17))
end

function var0_0.GetNewMainShips(arg0_18)
	local var0_18 = arg0_18.system
	local var1_18 = {}

	if var0_18 == SYSTEM_SCENARIO then
		var1_18 = var1_0()
	elseif var0_18 == SYSTEM_WORLD then
		var1_18 = var2_0()
	elseif var0_18 == SYSTEM_WORLD_BOSS then
		var1_18 = var3_0(arg0_18)
	elseif var0_18 == SYSTEM_HP_SHARE_ACT_BOSS or var0_18 == SYSTEM_ACT_BOSS or var0_18 == SYSTEM_ACT_BOSS_SP or var0_18 == SYSTEM_BOSS_EXPERIMENT or var0_18 == SYSTEM_BOSS_SINGLE then
		var1_18 = var4_0(arg0_18)
	elseif var0_18 == SYSTEM_BOSS_SINGLE_VARIABLE then
		var1_18 = var5_0(arg0_18)
	elseif var0_18 == SYSTEM_GUILD then
		var1_18 = var6_0()
	elseif var0_18 == SYSTEM_BOSS_RUSH or var0_18 == SYSTEM_BOSS_RUSH_COLLABRATE or var0_18 == SYSTEM_BOSS_RUSH_EX then
		var1_18 = var7_0(arg0_18)
	elseif var0_18 == SYSTEM_DODGEM or var0_18 == SYSTEM_SUBMARINE_RUN or var0_18 == SYSTEM_REWARD_PERFORM or var0_18 == SYSTEM_AIRFIGHT or var0_18 == SYSTEM_SCENARIO_SUB_STRIKE or var0_18 == SYSTEM_CARDPUZZLE or var0_18 == SYSTEM_CHALLENGE then
		-- block empty
	elseif var0_18 == SYSTEM_LIMIT_CHALLENGE then
		var1_18 = var8_0(arg0_18)
	else
		var1_18 = var9_0(arg0_18)
	end

	local var2_18 = {}

	for iter0_18, iter1_18 in ipairs(var1_18) do
		var2_18[iter1_18.id] = iter1_18
	end

	return var2_18
end

return var0_0
