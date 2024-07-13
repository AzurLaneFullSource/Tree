local var0_0 = class("CommanderCatUtil")

local function var1_0(arg0_1, arg1_1)
	local var0_1 = getProxy(FleetProxy):GetRegularFleets()

	for iter0_1, iter1_1 in pairs(var0_1) do
		for iter2_1, iter3_1 in pairs(iter1_1:getCommanders()) do
			local var1_1 = iter1_1.id % 10

			arg1_1[iter3_1.id].sub = iter1_1:isSubmarineFleet()
			arg1_1[iter3_1.id].fleetId = var1_1
			arg1_1[iter3_1.id].inFleet = true
		end
	end
end

local function var2_0(arg0_2, arg1_2)
	local var0_2 = getProxy(FleetProxy)
	local var1_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	assert(var1_2 and not var1_2:isEnd())

	local var2_2 = var0_2:getActivityFleets()[var1_2.id]

	for iter0_2, iter1_2 in pairs(var2_2) do
		local var3_2 = iter1_2:isSubmarineFleet()
		local var4_2 = iter1_2.id % 10

		for iter2_2, iter3_2 in pairs(iter1_2:getCommanders()) do
			arg1_2[iter3_2.id].sub = var3_2
			arg1_2[iter3_2.id].fleetId = var4_2
			arg1_2[iter3_2.id].inFleet = true
		end
	end
end

local function var3_0(arg0_3, arg1_3)
	assert(arg0_3.chapterId)

	local var0_3 = getProxy(ChapterProxy):getChapterById(arg0_3.chapterId)

	for iter0_3, iter1_3 in pairs(var0_3:getEliteFleetCommanders()) do
		for iter2_3, iter3_3 in pairs(iter1_3) do
			arg1_3[iter3_3].sub = false
			arg1_3[iter3_3].fleetId = iter0_3
			arg1_3[iter3_3].inFleet = true
		end
	end
end

local function var4_0(arg0_4, arg1_4)
	local var0_4 = getProxy(FleetProxy)
	local var1_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	assert(var1_4 and not var1_4:isEnd())

	local var2_4 = var0_4:getActivityFleets()[var1_4.id]

	for iter0_4, iter1_4 in pairs(var2_4) do
		local var3_4 = iter1_4:isSubmarineFleet()
		local var4_4 = iter1_4.id % 10

		for iter2_4, iter3_4 in pairs(iter1_4:getCommanders()) do
			arg1_4[iter3_4.id].sub = var3_4
			arg1_4[iter3_4.id].fleetId = var4_4
			arg1_4[iter3_4.id].inFleet = true
		end
	end
end

local function var5_0(arg0_5, arg1_5)
	local var0_5 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	assert(var0_5)

	local var1_5 = var0_5:GetBossMission():GetFleets()

	for iter0_5, iter1_5 in pairs(var1_5) do
		local var2_5 = arg0_5.fleets[iter0_5] or iter1_5
		local var3_5 = not var2_5:IsMainFleet()

		for iter2_5, iter3_5 in pairs(var2_5:getCommanders()) do
			arg1_5[iter3_5.id].sub = var3_5
			arg1_5[iter3_5.id].fleetId = 1
			arg1_5[iter3_5.id].inFleet = true
		end
	end
end

local function var6_0(arg0_6, arg1_6)
	local var0_6, var1_6 = nowWorld():BuildFormationIds()

	if arg0_6.fleets then
		var1_6 = arg0_6.fleets
	end

	for iter0_6, iter1_6 in pairs(var1_6) do
		local var2_6 = FleetType.Submarine == iter0_6

		for iter2_6, iter3_6 in pairs(iter1_6) do
			local var3_6 = Fleet.New({
				ship_list = {},
				commanders = iter3_6.commanders
			})

			for iter4_6, iter5_6 in pairs(var3_6:getCommanders()) do
				arg1_6[iter5_6.id].sub = var2_6
				arg1_6[iter5_6.id].fleetId = iter2_6
				arg1_6[iter5_6.id].inFleet = true
			end
		end
	end
end

local function var7_0(arg0_7, arg1_7)
	local var0_7 = arg0_7.fleets

	assert(var0_7)

	for iter0_7, iter1_7 in pairs(var0_7) do
		local var1_7 = iter0_7 == #var0_7

		for iter2_7, iter3_7 in pairs(iter1_7:getCommanders()) do
			arg1_7[iter3_7.id].sub = var1_7
			arg1_7[iter3_7.id].fleetId = iter1_7.id
			arg1_7[iter3_7.id].inFleet = true
		end
	end
end

local function var8_0(arg0_8, arg1_8)
	local var0_8 = getProxy(FleetProxy)
	local var1_8 = _.map({
		FleetProxy.CHALLENGE_FLEET_ID,
		FleetProxy.CHALLENGE_SUB_FLEET_ID
	}, function(arg0_9)
		return var0_8:getFleetById(arg0_9)
	end)

	for iter0_8, iter1_8 in pairs(var1_8) do
		local var2_8 = iter1_8:isSubmarineFleet()
		local var3_8 = iter1_8.id

		for iter2_8, iter3_8 in pairs(iter1_8:getCommanders()) do
			arg1_8[iter3_8.id].sub = var2_8
			arg1_8[iter3_8.id].fleetId = var3_8
			arg1_8[iter3_8.id].inFleet = true
		end
	end
end

local function var9_0(arg0_10, arg1_10)
	local var0_10 = getProxy(FleetProxy)
	local var1_10 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

	assert(var1_10 and not var1_10:isEnd())

	local var2_10 = var0_10:getActivityFleets()[var1_10.id]

	for iter0_10, iter1_10 in pairs(var2_10) do
		local var3_10 = iter1_10:isSubmarineFleet()
		local var4_10 = iter1_10.id % 10

		for iter2_10, iter3_10 in pairs(iter1_10:getCommanders()) do
			arg1_10[iter3_10.id].sub = var3_10
			arg1_10[iter3_10.id].fleetId = var4_10
			arg1_10[iter3_10.id].inFleet = true
		end
	end
end

function var0_0.GetCommanderList(arg0_11)
	local var0_11 = getProxy(CommanderProxy):getData()

	if CommanderCatScene.FLEET_TYPE_COMMON == arg0_11.fleetType then
		var1_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_ACTBOSS == arg0_11.fleetType then
		var2_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_HARD_CHAPTER == arg0_11.fleetType then
		var3_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_CHALLENGE == arg0_11.fleetType then
		var4_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_GUILDBOSS == arg0_11.fleetType then
		var5_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_WORLD == arg0_11.fleetType then
		var6_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_BOSSRUSH == arg0_11.fleetType then
		var7_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_LIMIT_CHALLENGE == arg0_11.fleetType then
		var8_0(arg0_11, var0_11)
	elseif CommanderCatScene.FLEET_TYPE_BOSSSINGLE == arg0_11.fleetType then
		var9_0(arg0_11, var0_11)
	end

	local var1_11 = getProxy(ChapterProxy):getActiveChapter()

	if var1_11 then
		_.each(var1_11.fleets, function(arg0_12)
			local var0_12 = arg0_12:getCommanders()

			for iter0_12, iter1_12 in pairs(arg0_12:getCommanders()) do
				var0_11[iter1_12.id].inBattle = true
			end
		end)
	end

	local var2_11 = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.ignoredIds or {}) do
		var2_11[iter1_11] = true
	end

	local var3_11 = {}

	for iter2_11, iter3_11 in pairs(var0_11) do
		if not var2_11[iter2_11] then
			table.insert(var3_11, iter3_11)
		end
	end

	return var3_11
end

function var0_0.GetSkillExpAndCommanderExp(arg0_13, arg1_13)
	local var0_13 = 0
	local var1_13 = 0
	local var2_13 = getProxy(CommanderProxy)

	for iter0_13, iter1_13 in pairs(arg1_13) do
		local var3_13 = var2_13:getCommanderById(iter1_13)

		var1_13 = var1_13 + var3_13:getDestoryedExp(arg0_13.groupId)
		var0_13 = var0_13 + var3_13:getDestoryedSkillExp(arg0_13.groupId)
	end

	return math.floor(var1_13), math.floor(var0_13)
end

function var0_0.AnySSRCommander(arg0_14)
	local var0_14 = getProxy(CommanderProxy)

	if _.any(arg0_14, function(arg0_15)
		return var0_14:RawGetCommanderById(arg0_15):getRarity() >= 5
	end) then
		return true
	end

	return false
end

function var0_0.CalcCommanderConsume(arg0_16)
	local var0_16 = getProxy(CommanderProxy)
	local var1_16 = 0

	for iter0_16, iter1_16 in ipairs(arg0_16) do
		local var2_16 = var0_16:RawGetCommanderById(iter1_16)

		assert(var2_16, iter1_16)

		var1_16 = var1_16 + var2_16:getUpgradeConsume()
	end

	return math.floor(var1_16)
end

function var0_0.SetActive(arg0_17, arg1_17)
	local var0_17 = GetOrAddComponent(arg0_17, typeof(CanvasGroup))

	var0_17.alpha = arg1_17 and 1 or 0
	var0_17.blocksRaycasts = arg1_17
end

function var0_0.CommanderInChapter(arg0_18)
	local var0_18 = getProxy(ChapterProxy):getActiveChapter()

	if var0_18 then
		local var1_18 = var0_18.fleets

		for iter0_18, iter1_18 in pairs(var1_18) do
			local var2_18 = iter1_18:getCommanders()

			if _.any(_.values(var2_18), function(arg0_19)
				return arg0_19.id == arg0_18.id
			end) then
				return true
			end
		end
	end

	return false
end

function var0_0.GetAllTalentNames()
	local var0_20 = {}

	for iter0_20, iter1_20 in ipairs(pg.commander_ability_group.all) do
		local var1_20 = pg.commander_ability_group[iter1_20]

		if var1_20.ability_list and #var1_20.ability_list > 0 then
			local var2_20 = var1_20.ability_list[1]
			local var3_20 = pg.commander_ability_template[var2_20].name

			table.insert(var0_20, {
				id = var1_20.id,
				name = var3_20
			})
		end
	end

	return var0_20
end

function var0_0.ShortenString(arg0_21, arg1_21)
	local function var0_21(arg0_22)
		if not arg0_22 then
			return 0, 1
		elseif arg0_22 > 240 then
			return 4, 1
		elseif arg0_22 > 225 then
			return 3, 1
		elseif arg0_22 > 192 then
			return 2, 1
		elseif arg0_22 < 126 then
			return 1, 0.75
		else
			return 1, 1
		end
	end

	local var1_21 = 1
	local var2_21 = 0
	local var3_21 = 0
	local var4_21 = #arg0_21
	local var5_21 = false

	while var1_21 <= var4_21 do
		local var6_21 = string.byte(arg0_21, var1_21)
		local var7_21, var8_21 = var0_21(var6_21)

		var1_21 = var1_21 + var7_21
		var2_21 = var2_21 + var8_21

		local var9_21 = math.ceil(var2_21)

		if var9_21 == arg1_21 - 1 then
			var3_21 = var1_21
		elseif arg1_21 < var9_21 then
			var5_21 = true

			break
		end
	end

	if var3_21 == 0 or var4_21 < var3_21 or not var5_21 then
		return arg0_21
	end

	return string.sub(arg0_21, 1, var3_21 - 1) .. ".."
end

return var0_0
