local var0 = class("GuildEvent", import("...BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.active = false
	arg0.startTime = 0
	arg0.clueCount = 0
	arg0.missions = {}
	arg0.boss = nil
	arg0.durTime = pg.guildset.operation_duration_time.key_value
end

function var0.bindConfigTable(arg0)
	return pg.guild_operation_template
end

function var0.GetConsume(arg0)
	return arg0:getConfig("consume")
end

function var0.Active(arg0, arg1)
	arg0:Deactivate()

	arg0.startTime = arg1.start_time
	arg0.endTime = arg0.durTime + arg0.startTime
	arg0.clueCount = arg1.clue_count
	arg0.joinCnt = arg1.join_times
	arg0.isParticipant = arg1.is_participant

	local var0 = {}

	for iter0, iter1 in ipairs(arg1.perfs) do
		var0[iter1.event_id] = iter1.index
	end

	local var1 = {}

	for iter2, iter3 in ipairs(arg1.formation_time) do
		var1[iter3.key] = iter3.value
	end

	local var2 = 0

	local function var3(arg0)
		local var0 = GuildMission.New(arg0)
		local var1 = var0:GetPosition()

		if var1 > var2 then
			var2 = var1
		end

		if not arg0.missions[var1] then
			arg0.missions[var1] = {}
		end

		if var0[var0.id] then
			var0:UpdateNodeAnimFlagIndex(var0[var0.id])
		end

		if var1[var0.id] then
			var0:UpdateFormationTime(var1[var0.id])
		end

		table.insert(arg0.missions[var1], var0)
	end

	for iter4, iter5 in ipairs(arg1.base_events) do
		var3(iter5)
	end

	for iter6, iter7 in ipairs(arg1.completed_events) do
		var3(GuildMission.CompleteData2FullData(iter7))
	end

	arg0.boss = GuildBossMission.New(var2 + 1, arg1.daily_count, arg1.fleets)

	if arg1.boss_event and arg1.boss_event.boss_id ~= 0 then
		arg0.boss:Flush(arg1.boss_event)
	end

	arg0.active = true
end

function var0.IsParticipant(arg0)
	return arg0.isParticipant > 0
end

function var0.GetJoinCnt(arg0)
	return arg0.joinCnt
end

function var0.IncreaseJoinCnt(arg0)
	arg0.isParticipant = 1

	if arg0.joinCnt < arg0:GetMaxJoinCnt() then
		arg0.joinCnt = arg0.joinCnt + 1
	else
		getProxy(GuildProxy):getRawData():ReduceExtraBattleCnt(1)
	end
end

function var0.GetExtraJoinCnt(arg0)
	return getProxy(GuildProxy):getRawData():GetExtraBattleCnt()
end

function var0.IsLimitedJoin(arg0)
	local var0 = arg0:GetJoinCnt()
	local var1 = arg0:GetMaxJoinCnt()
	local var2 = arg0:GetExtraJoinCnt()

	return not (var0 < var1 or var2 > 0)
end

function var0.GetMaxJoinCnt(arg0)
	return pg.guildset.efficiency_param_times.key_value
end

function var0.GetBossMission(arg0)
	return arg0.boss
end

function var0.GetMissions(arg0)
	return arg0.missions
end

function var0.Deactivate(arg0)
	arg0.startTime = 0
	arg0.clueCount = 0
	arg0.missions = {}
	arg0.boss = nil
	arg0.active = false
	arg0.isParticipant = 0
end

function var0.IsExpired(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.endTime
end

function var0.IsActive(arg0)
	return arg0.active == true
end

function var0.GetDesc(arg0)
	return arg0:getConfig("profile")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetScaleDesc(arg0)
	return arg0:getConfig("scale")
end

function var0.GetDisplayMission(arg0)
	return arg0:getConfig("event_type_list")
end

function var0.GetDisplayAward(arg0)
	return arg0:getConfig("award_display")
end

function var0.IsUnlock(arg0, arg1)
	return arg1 >= arg0:getConfig("unlock_guild_level")
end

function var0.GetTheme(arg0)
	return arg0:getConfig("theme")
end

function var0.GetJoinShips(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			if not iter3:IsFinish() then
				local var1 = iter3:GetMyShips()

				for iter4, iter5 in ipairs(var1) do
					table.insert(var0, iter5)
				end
			end
		end
	end

	return var0
end

function var0.GetMissionById(arg0, arg1)
	for iter0, iter1 in pairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3.id == arg1 then
				return iter3
			end
		end
	end

	assert(false)
end

function var0.GetJoinShipCnt(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			var0 = var0 + iter3:GetJoinCnt()
		end
	end

	return var0
end

function var0.GetBossShipIds(arg0)
	local var0 = {}

	if arg0.boss and arg0.boss:IsActive() then
		local var1 = arg0.boss:GetMyShipIds()

		for iter0, iter1 in ipairs(var1) do
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetMissionCnt(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.GetMainMissionCntAndFinishCnt(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3:IsMain() then
				var0 = var0 + 1
			end

			if iter3:IsMain() and iter3:IsFinish() then
				var1 = var1 + 1
			end
		end
	end

	return var0, var1
end

function var0.GetMissionFinishCnt(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3:IsFinish() then
				var0 = var0 + 1
			end
		end
	end

	return var0
end

function var0.GetCanFormationMisstions(arg0)
	local function var0(arg0)
		if arg0:IsFinish() then
			return false
		end

		local var0 = arg0:GetPosition()
		local var1 = arg0.missions[var0 - 1]

		if var1 then
			for iter0, iter1 in pairs(var1) do
				if iter1:IsMain() and iter1:IsFinish() then
					return true
				end
			end
		else
			return true
		end

		return false
	end

	local var1 = {}

	for iter0, iter1 in pairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			if var0(iter3) and iter3:CanFormation() and not iter3:IsFinish() then
				table.insert(var1, iter3)
			end
		end
	end

	return var1
end

function var0.AnyMissionCanFormation(arg0)
	return #arg0:GetCanFormationMisstions() > 0
end

function var0.AnyMissionFirstFleetCanFroamtion(arg0)
	local var0 = arg0:GetCanFormationMisstions()
	local var1 = _.detect(var0, function(arg0)
		return arg0:FirstFleetCanFormation() or arg0:IsFinish() and not arg0:IsFinishedByServer()
	end)

	return var1 ~= nil, var1
end

function var0.GetUnlockMission(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.missions) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3:IsMain() and (iter3:IsFinishedByServer() or iter3:IsFinish()) then
				var0 = iter0
			end
		end
	end

	local var1 = arg0.missions[var0 + 1]

	for iter4, iter5 in ipairs(var1 or {}) do
		if iter5:IsMain() then
			return iter5
		end
	end

	return nil
end

function var0.GetLeftTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.endTime - var0
end

return var0
