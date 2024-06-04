local var0 = class("CommanderCatUtil")

local function var1(arg0, arg1)
	local var0 = getProxy(FleetProxy):GetRegularFleets()

	for iter0, iter1 in pairs(var0) do
		for iter2, iter3 in pairs(iter1:getCommanders()) do
			local var1 = iter1.id % 10

			arg1[iter3.id].sub = iter1:isSubmarineFleet()
			arg1[iter3.id].fleetId = var1
			arg1[iter3.id].inFleet = true
		end
	end
end

local function var2(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	assert(var1 and not var1:isEnd())

	local var2 = var0:getActivityFleets()[var1.id]

	for iter0, iter1 in pairs(var2) do
		local var3 = iter1:isSubmarineFleet()
		local var4 = iter1.id % 10

		for iter2, iter3 in pairs(iter1:getCommanders()) do
			arg1[iter3.id].sub = var3
			arg1[iter3.id].fleetId = var4
			arg1[iter3.id].inFleet = true
		end
	end
end

local function var3(arg0, arg1)
	assert(arg0.chapterId)

	local var0 = getProxy(ChapterProxy):getChapterById(arg0.chapterId)

	for iter0, iter1 in pairs(var0:getEliteFleetCommanders()) do
		for iter2, iter3 in pairs(iter1) do
			arg1[iter3].sub = false
			arg1[iter3].fleetId = iter0
			arg1[iter3].inFleet = true
		end
	end
end

local function var4(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	assert(var1 and not var1:isEnd())

	local var2 = var0:getActivityFleets()[var1.id]

	for iter0, iter1 in pairs(var2) do
		local var3 = iter1:isSubmarineFleet()
		local var4 = iter1.id % 10

		for iter2, iter3 in pairs(iter1:getCommanders()) do
			arg1[iter3.id].sub = var3
			arg1[iter3.id].fleetId = var4
			arg1[iter3.id].inFleet = true
		end
	end
end

local function var5(arg0, arg1)
	local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	assert(var0)

	local var1 = var0:GetBossMission():GetFleets()

	for iter0, iter1 in pairs(var1) do
		local var2 = arg0.fleets[iter0] or iter1
		local var3 = not var2:IsMainFleet()

		for iter2, iter3 in pairs(var2:getCommanders()) do
			arg1[iter3.id].sub = var3
			arg1[iter3.id].fleetId = 1
			arg1[iter3.id].inFleet = true
		end
	end
end

local function var6(arg0, arg1)
	local var0, var1 = nowWorld():BuildFormationIds()

	if arg0.fleets then
		var1 = arg0.fleets
	end

	for iter0, iter1 in pairs(var1) do
		local var2 = FleetType.Submarine == iter0

		for iter2, iter3 in pairs(iter1) do
			local var3 = Fleet.New({
				ship_list = {},
				commanders = iter3.commanders
			})

			for iter4, iter5 in pairs(var3:getCommanders()) do
				arg1[iter5.id].sub = var2
				arg1[iter5.id].fleetId = iter2
				arg1[iter5.id].inFleet = true
			end
		end
	end
end

local function var7(arg0, arg1)
	local var0 = arg0.fleets

	assert(var0)

	for iter0, iter1 in pairs(var0) do
		local var1 = iter0 == #var0

		for iter2, iter3 in pairs(iter1:getCommanders()) do
			arg1[iter3.id].sub = var1
			arg1[iter3.id].fleetId = iter1.id
			arg1[iter3.id].inFleet = true
		end
	end
end

local function var8(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = _.map({
		FleetProxy.CHALLENGE_FLEET_ID,
		FleetProxy.CHALLENGE_SUB_FLEET_ID
	}, function(arg0)
		return var0:getFleetById(arg0)
	end)

	for iter0, iter1 in pairs(var1) do
		local var2 = iter1:isSubmarineFleet()
		local var3 = iter1.id

		for iter2, iter3 in pairs(iter1:getCommanders()) do
			arg1[iter3.id].sub = var2
			arg1[iter3.id].fleetId = var3
			arg1[iter3.id].inFleet = true
		end
	end
end

local function var9(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

	assert(var1 and not var1:isEnd())

	local var2 = var0:getActivityFleets()[var1.id]

	for iter0, iter1 in pairs(var2) do
		local var3 = iter1:isSubmarineFleet()
		local var4 = iter1.id % 10

		for iter2, iter3 in pairs(iter1:getCommanders()) do
			arg1[iter3.id].sub = var3
			arg1[iter3.id].fleetId = var4
			arg1[iter3.id].inFleet = true
		end
	end
end

function var0.GetCommanderList(arg0)
	local var0 = getProxy(CommanderProxy):getData()

	if CommanderCatScene.FLEET_TYPE_COMMON == arg0.fleetType then
		var1(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_ACTBOSS == arg0.fleetType then
		var2(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_HARD_CHAPTER == arg0.fleetType then
		var3(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_CHALLENGE == arg0.fleetType then
		var4(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_GUILDBOSS == arg0.fleetType then
		var5(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_WORLD == arg0.fleetType then
		var6(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_BOSSRUSH == arg0.fleetType then
		var7(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_LIMIT_CHALLENGE == arg0.fleetType then
		var8(arg0, var0)
	elseif CommanderCatScene.FLEET_TYPE_BOSSSINGLE == arg0.fleetType then
		var9(arg0, var0)
	end

	local var1 = getProxy(ChapterProxy):getActiveChapter()

	if var1 then
		_.each(var1.fleets, function(arg0)
			local var0 = arg0:getCommanders()

			for iter0, iter1 in pairs(arg0:getCommanders()) do
				var0[iter1.id].inBattle = true
			end
		end)
	end

	local var2 = {}

	for iter0, iter1 in ipairs(arg0.ignoredIds or {}) do
		var2[iter1] = true
	end

	local var3 = {}

	for iter2, iter3 in pairs(var0) do
		if not var2[iter2] then
			table.insert(var3, iter3)
		end
	end

	return var3
end

function var0.GetSkillExpAndCommanderExp(arg0, arg1)
	local var0 = 0
	local var1 = 0
	local var2 = getProxy(CommanderProxy)

	for iter0, iter1 in pairs(arg1) do
		local var3 = var2:getCommanderById(iter1)

		var1 = var1 + var3:getDestoryedExp(arg0.groupId)
		var0 = var0 + var3:getDestoryedSkillExp(arg0.groupId)
	end

	return math.floor(var1), math.floor(var0)
end

function var0.AnySSRCommander(arg0)
	local var0 = getProxy(CommanderProxy)

	if _.any(arg0, function(arg0)
		return var0:RawGetCommanderById(arg0):getRarity() >= 5
	end) then
		return true
	end

	return false
end

function var0.CalcCommanderConsume(arg0)
	local var0 = getProxy(CommanderProxy)
	local var1 = 0

	for iter0, iter1 in ipairs(arg0) do
		local var2 = var0:RawGetCommanderById(iter1)

		assert(var2, iter1)

		var1 = var1 + var2:getUpgradeConsume()
	end

	return math.floor(var1)
end

function var0.SetActive(arg0, arg1)
	local var0 = GetOrAddComponent(arg0, typeof(CanvasGroup))

	var0.alpha = arg1 and 1 or 0
	var0.blocksRaycasts = arg1
end

function var0.CommanderInChapter(arg0)
	local var0 = getProxy(ChapterProxy):getActiveChapter()

	if var0 then
		local var1 = var0.fleets

		for iter0, iter1 in pairs(var1) do
			local var2 = iter1:getCommanders()

			if _.any(_.values(var2), function(arg0)
				return arg0.id == arg0.id
			end) then
				return true
			end
		end
	end

	return false
end

function var0.GetAllTalentNames()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.commander_ability_group.all) do
		local var1 = pg.commander_ability_group[iter1]

		if var1.ability_list and #var1.ability_list > 0 then
			local var2 = var1.ability_list[1]
			local var3 = pg.commander_ability_template[var2].name

			table.insert(var0, {
				id = var1.id,
				name = var3
			})
		end
	end

	return var0
end

function var0.ShortenString(arg0, arg1)
	local function var0(arg0)
		if not arg0 then
			return 0, 1
		elseif arg0 > 240 then
			return 4, 1
		elseif arg0 > 225 then
			return 3, 1
		elseif arg0 > 192 then
			return 2, 1
		elseif arg0 < 126 then
			return 1, 0.75
		else
			return 1, 1
		end
	end

	local var1 = 1
	local var2 = 0
	local var3 = 0
	local var4 = #arg0
	local var5 = false

	while var1 <= var4 do
		local var6 = string.byte(arg0, var1)
		local var7, var8 = var0(var6)

		var1 = var1 + var7
		var2 = var2 + var8

		local var9 = math.ceil(var2)

		if var9 == arg1 - 1 then
			var3 = var1
		elseif arg1 < var9 then
			var5 = true

			break
		end
	end

	if var3 == 0 or var4 < var3 or not var5 then
		return arg0
	end

	return string.sub(arg0, 1, var3 - 1) .. ".."
end

return var0
