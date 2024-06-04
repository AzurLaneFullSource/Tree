local var0 = class("NewBattleResultDataExtender")

function var0.NeedCloseCamera(arg0)
	return arg0 ~= SYSTEM_BOSS_RUSH and arg0 ~= SYSTEM_BOSS_RUSH_EX and arg0 ~= SYSTEM_ACT_BOSS and arg0 ~= SYSTEM_WORLD_BOSS and arg0 ~= SYSTEM_BOSS_SINGLE
end

function var0.NeedVibrate(arg0)
	local var0 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	return ys.Battle.BattleState.IsAutoBotActive() and var0 and not arg0
end

function var0.NeedHelpMessage(arg0, arg1)
	if (arg0 == SYSTEM_SCENARIO or arg0 == SYSTEM_ROUTINE or arg0 == SYSTEM_SUB_ROUTINE or arg0 == SYSTEM_DUEL) and arg1 <= 0 then
		return true
	end

	return false
end

function var0.GetAutoSkipFlag(arg0, arg1)
	if arg1 == SYSTEM_SCENARIO then
		local var0 = getProxy(ChapterProxy):getActiveChapter()

		return getProxy(ChapterProxy):GetChapterAutoFlag(var0.id) == 1
	elseif arg1 == SYSTEM_WORLD then
		return nowWorld().isAutoFight
	end

	return arg0.autoSkipFlag or false
end

function var0.GetExpBuffs(arg0)
	local var0

	if arg0 == SYSTEM_SCENARIO or arg0 == SYSTEM_ROUTINE or arg0 == SYSTEM_ACT_BOSS or arg0 == SYSTEM_HP_SHARE_ACT_BOSS or arg0 == SYSTEM_SUB_ROUTINE or arg0 == SYSTEM_WORLD or arg0 == SYSTEM_BOSS_SINGLE then
		var0 = _.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function(arg0)
			return arg0:getConfig("benefit_type") == "rookie_battle_exp"
		end)
	end

	return var0
end

function var0.GetShipBuffs(arg0)
	local var0

	if arg0 == SYSTEM_SCENARIO or arg0 == SYSTEM_ROUTINE or arg0 == SYSTEM_ACT_BOSS or arg0 == SYSTEM_HP_SHARE_ACT_BOSS or arg0 == SYSTEM_SUB_ROUTINE or arg0 == SYSTEM_WORLD or arg0 == SYSTEM_BOSS_SINGLE then
		var0 = getProxy(ActivityProxy):getBuffShipList()
	end

	return var0
end

local function var1()
	local var0 = {}
	local var1 = getProxy(ChapterProxy):getActiveChapter()
	local var2 = var1.fleet
	local var3 = var2[TeamType.Main]
	local var4 = var2[TeamType.Vanguard]

	for iter0, iter1 in ipairs(var3) do
		table.insert(var0, iter1)
	end

	for iter2, iter3 in ipairs(var4) do
		table.insert(var0, iter3)
	end

	local var5 = _.detect(var1.fleets, function(arg0)
		return arg0:getFleetType() == FleetType.Submarine
	end)

	if var5 then
		local var6 = var5:getShipsByTeam(TeamType.Submarine, true)

		for iter4, iter5 in ipairs(var6) do
			table.insert(var0, iter5)
		end
	end

	return var0
end

local function var2()
	local var0 = {}
	local var1 = nowWorld():GetActiveMap()
	local var2 = var1:GetFleet()
	local var3 = var2:GetTeamShipVOs(TeamType.Main, true)
	local var4 = var2:GetTeamShipVOs(TeamType.Vanguard, true)

	for iter0, iter1 in ipairs(var3) do
		table.insert(var0, iter1)
	end

	for iter2, iter3 in ipairs(var4) do
		table.insert(var0, iter3)
	end

	local var5 = var1:GetSubmarineFleet()

	if var5 then
		local var6 = var5:GetTeamShipVOs(TeamType.Submarine, true)

		for iter4, iter5 in ipairs(var6) do
			table.insert(var0, iter5)
		end
	end

	return var0
end

local function var3(arg0)
	local var0 = nowWorld():GetBossProxy():GetFleet(arg0.bossId)

	return (getProxy(BayProxy):getShipsByFleet(var0))
end

local function var4(arg0)
	local var0 = getProxy(FleetProxy):getActivityFleets()[arg0.actId]
	local var1 = var0[arg0.mainFleetId]
	local var2 = getProxy(BayProxy):getShipsByFleet(var1)
	local var3 = var0[arg0.mainFleetId + 10]
	local var4 = getProxy(BayProxy):getShipsByFleet(var3)

	for iter0, iter1 in ipairs(var4) do
		table.insert(var2, iter1)
	end

	return var2
end

local function var5()
	local var0 = {}
	local var1 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
	local var2 = var1:GetMainFleet()

	for iter0, iter1 in ipairs(var2:GetShips()) do
		table.insert(var0, iter1.ship)
	end

	local var3 = var1:GetSubFleet()

	for iter2, iter3 in ipairs(var3:GetShips()) do
		table.insert(var0, iter3.ship)
	end

	return var0
end

local function var6(arg0)
	local var0 = arg0.actId
	local var1 = getProxy(ActivityProxy):getActivityById(var0):GetSeriesData()

	assert(var1)

	local var2 = var1:GetStaegLevel()
	local var3 = var1:GetFleetIds()
	local var4 = var3[var2]

	if var1:GetMode() == BossRushSeriesData.MODE.SINGLE then
		var4 = var3[1]
	end

	local var5 = getProxy(FleetProxy):getActivityFleets()[var0][var4]

	return (getProxy(BayProxy):getShipsByFleet(var5))
end

local function var7(arg0)
	local var0 = {}
	local var1 = getProxy(FleetProxy):getFleetById(FleetProxy.CHALLENGE_FLEET_ID)

	table.insertto(var0, getProxy(BayProxy):getShipsByFleet(var1))

	local var2 = getProxy(FleetProxy):getFleetById(FleetProxy.CHALLENGE_SUB_FLEET_ID)

	table.insertto(var0, getProxy(BayProxy):getShipsByFleet(var2))

	return var0
end

local function var8(arg0)
	local var0 = arg0.mainFleetId
	local var1 = getProxy(FleetProxy):getFleetById(var0)

	return (getProxy(BayProxy):getShipsByFleet(var1))
end

function var0.GetNewMainShips(arg0)
	local var0 = arg0.system
	local var1 = {}

	if var0 == SYSTEM_SCENARIO then
		var1 = var1()
	elseif var0 == SYSTEM_WORLD then
		var1 = var2()
	elseif var0 == SYSTEM_WORLD_BOSS then
		var1 = var3(arg0)
	elseif var0 == SYSTEM_HP_SHARE_ACT_BOSS or var0 == SYSTEM_ACT_BOSS or var0 == SYSTEM_ACT_BOSS_SP or var0 == SYSTEM_BOSS_EXPERIMENT or var0 == SYSTEM_BOSS_SINGLE then
		var1 = var4(arg0)
	elseif var0 == SYSTEM_GUILD then
		var1 = var5()
	elseif var0 == SYSTEM_BOSS_RUSH or var0 == SYSTEM_BOSS_RUSH_EX then
		var1 = var6(arg0)
	elseif var0 == SYSTEM_DODGEM or var0 == SYSTEM_SUBMARINE_RUN or var0 == SYSTEM_REWARD_PERFORM or var0 == SYSTEM_AIRFIGHT or var0 == SYSTEM_CARDPUZZLE or var0 == SYSTEM_CHALLENGE then
		-- block empty
	elseif var0 == SYSTEM_LIMIT_CHALLENGE then
		var1 = var7(arg0)
	else
		var1 = var8(arg0)
	end

	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		var2[iter1.id] = iter1
	end

	return var2
end

return var0
