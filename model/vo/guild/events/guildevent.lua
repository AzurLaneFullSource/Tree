local var0_0 = class("GuildEvent", import("...BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.active = false
	arg0_1.startTime = 0
	arg0_1.clueCount = 0
	arg0_1.missions = {}
	arg0_1.boss = nil
	arg0_1.durTime = pg.guildset.operation_duration_time.key_value
end

function var0_0.bindConfigTable(arg0_2)
	return pg.guild_operation_template
end

function var0_0.GetConsume(arg0_3)
	return arg0_3:getConfig("consume")
end

function var0_0.Active(arg0_4, arg1_4)
	arg0_4:Deactivate()

	arg0_4.startTime = arg1_4.start_time
	arg0_4.endTime = arg0_4.durTime + arg0_4.startTime
	arg0_4.clueCount = arg1_4.clue_count
	arg0_4.joinCnt = arg1_4.join_times
	arg0_4.isParticipant = arg1_4.is_participant

	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg1_4.perfs) do
		var0_4[iter1_4.event_id] = iter1_4.index
	end

	local var1_4 = {}

	for iter2_4, iter3_4 in ipairs(arg1_4.formation_time) do
		var1_4[iter3_4.key] = iter3_4.value
	end

	local var2_4 = 0

	local function var3_4(arg0_5)
		local var0_5 = GuildMission.New(arg0_5)
		local var1_5 = var0_5:GetPosition()

		if var1_5 > var2_4 then
			var2_4 = var1_5
		end

		if not arg0_4.missions[var1_5] then
			arg0_4.missions[var1_5] = {}
		end

		if var0_4[var0_5.id] then
			var0_5:UpdateNodeAnimFlagIndex(var0_4[var0_5.id])
		end

		if var1_4[var0_5.id] then
			var0_5:UpdateFormationTime(var1_4[var0_5.id])
		end

		table.insert(arg0_4.missions[var1_5], var0_5)
	end

	for iter4_4, iter5_4 in ipairs(arg1_4.base_events) do
		var3_4(iter5_4)
	end

	for iter6_4, iter7_4 in ipairs(arg1_4.completed_events) do
		var3_4(GuildMission.CompleteData2FullData(iter7_4))
	end

	arg0_4.boss = GuildBossMission.New(var2_4 + 1, arg1_4.daily_count, arg1_4.fleets)

	if arg1_4.boss_event and arg1_4.boss_event.boss_id ~= 0 then
		arg0_4.boss:Flush(arg1_4.boss_event)
	end

	arg0_4.active = true
end

function var0_0.IsParticipant(arg0_6)
	return arg0_6.isParticipant > 0
end

function var0_0.GetJoinCnt(arg0_7)
	return arg0_7.joinCnt
end

function var0_0.IncreaseJoinCnt(arg0_8)
	arg0_8.isParticipant = 1

	if arg0_8.joinCnt < arg0_8:GetMaxJoinCnt() then
		arg0_8.joinCnt = arg0_8.joinCnt + 1
	else
		getProxy(GuildProxy):getRawData():ReduceExtraBattleCnt(1)
	end
end

function var0_0.GetExtraJoinCnt(arg0_9)
	return getProxy(GuildProxy):getRawData():GetExtraBattleCnt()
end

function var0_0.IsLimitedJoin(arg0_10)
	local var0_10 = arg0_10:GetJoinCnt()
	local var1_10 = arg0_10:GetMaxJoinCnt()
	local var2_10 = arg0_10:GetExtraJoinCnt()

	return not (var0_10 < var1_10 or var2_10 > 0)
end

function var0_0.GetMaxJoinCnt(arg0_11)
	return pg.guildset.efficiency_param_times.key_value
end

function var0_0.GetBossMission(arg0_12)
	return arg0_12.boss
end

function var0_0.GetMissions(arg0_13)
	return arg0_13.missions
end

function var0_0.Deactivate(arg0_14)
	arg0_14.startTime = 0
	arg0_14.clueCount = 0
	arg0_14.missions = {}
	arg0_14.boss = nil
	arg0_14.active = false
	arg0_14.isParticipant = 0
end

function var0_0.IsExpired(arg0_15)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_15.endTime
end

function var0_0.IsActive(arg0_16)
	return arg0_16.active == true
end

function var0_0.GetDesc(arg0_17)
	return arg0_17:getConfig("profile")
end

function var0_0.GetName(arg0_18)
	return arg0_18:getConfig("name")
end

function var0_0.GetScaleDesc(arg0_19)
	return arg0_19:getConfig("scale")
end

function var0_0.GetDisplayMission(arg0_20)
	return arg0_20:getConfig("event_type_list")
end

function var0_0.GetDisplayAward(arg0_21)
	return arg0_21:getConfig("award_display")
end

function var0_0.IsUnlock(arg0_22, arg1_22)
	return arg1_22 >= arg0_22:getConfig("unlock_guild_level")
end

function var0_0.GetTheme(arg0_23)
	return arg0_23:getConfig("theme")
end

function var0_0.GetJoinShips(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in ipairs(arg0_24.missions) do
		for iter2_24, iter3_24 in ipairs(iter1_24) do
			if not iter3_24:IsFinish() then
				local var1_24 = iter3_24:GetMyShips()

				for iter4_24, iter5_24 in ipairs(var1_24) do
					table.insert(var0_24, iter5_24)
				end
			end
		end
	end

	return var0_24
end

function var0_0.GetMissionById(arg0_25, arg1_25)
	for iter0_25, iter1_25 in pairs(arg0_25.missions) do
		for iter2_25, iter3_25 in ipairs(iter1_25) do
			if iter3_25.id == arg1_25 then
				return iter3_25
			end
		end
	end

	assert(false)
end

function var0_0.GetJoinShipCnt(arg0_26)
	local var0_26 = 0

	for iter0_26, iter1_26 in pairs(arg0_26.missions) do
		for iter2_26, iter3_26 in ipairs(iter1_26) do
			var0_26 = var0_26 + iter3_26:GetJoinCnt()
		end
	end

	return var0_26
end

function var0_0.GetBossShipIds(arg0_27)
	local var0_27 = {}

	if arg0_27.boss and arg0_27.boss:IsActive() then
		local var1_27 = arg0_27.boss:GetMyShipIds()

		for iter0_27, iter1_27 in ipairs(var1_27) do
			table.insert(var0_27, iter1_27)
		end
	end

	return var0_27
end

function var0_0.GetMissionCnt(arg0_28)
	local var0_28 = 0

	for iter0_28, iter1_28 in pairs(arg0_28.missions) do
		for iter2_28, iter3_28 in ipairs(iter1_28) do
			var0_28 = var0_28 + 1
		end
	end

	return var0_28
end

function var0_0.GetMainMissionCntAndFinishCnt(arg0_29)
	local var0_29 = 0
	local var1_29 = 0

	for iter0_29, iter1_29 in pairs(arg0_29.missions) do
		for iter2_29, iter3_29 in ipairs(iter1_29) do
			if iter3_29:IsMain() then
				var0_29 = var0_29 + 1
			end

			if iter3_29:IsMain() and iter3_29:IsFinish() then
				var1_29 = var1_29 + 1
			end
		end
	end

	return var0_29, var1_29
end

function var0_0.GetMissionFinishCnt(arg0_30)
	local var0_30 = 0

	for iter0_30, iter1_30 in pairs(arg0_30.missions) do
		for iter2_30, iter3_30 in ipairs(iter1_30) do
			if iter3_30:IsFinish() then
				var0_30 = var0_30 + 1
			end
		end
	end

	return var0_30
end

function var0_0.GetCanFormationMisstions(arg0_31)
	local function var0_31(arg0_32)
		if arg0_32:IsFinish() then
			return false
		end

		local var0_32 = arg0_32:GetPosition()
		local var1_32 = arg0_31.missions[var0_32 - 1]

		if var1_32 then
			for iter0_32, iter1_32 in pairs(var1_32) do
				if iter1_32:IsMain() and iter1_32:IsFinish() then
					return true
				end
			end
		else
			return true
		end

		return false
	end

	local var1_31 = {}

	for iter0_31, iter1_31 in pairs(arg0_31.missions) do
		for iter2_31, iter3_31 in ipairs(iter1_31) do
			if var0_31(iter3_31) and iter3_31:CanFormation() and not iter3_31:IsFinish() then
				table.insert(var1_31, iter3_31)
			end
		end
	end

	return var1_31
end

function var0_0.AnyMissionCanFormation(arg0_33)
	return #arg0_33:GetCanFormationMisstions() > 0
end

function var0_0.AnyMissionFirstFleetCanFroamtion(arg0_34)
	local var0_34 = arg0_34:GetCanFormationMisstions()
	local var1_34 = _.detect(var0_34, function(arg0_35)
		return arg0_35:FirstFleetCanFormation() or arg0_35:IsFinish() and not arg0_35:IsFinishedByServer()
	end)

	return var1_34 ~= nil, var1_34
end

function var0_0.GetUnlockMission(arg0_36)
	local var0_36 = 0

	for iter0_36, iter1_36 in pairs(arg0_36.missions) do
		for iter2_36, iter3_36 in ipairs(iter1_36) do
			if iter3_36:IsMain() and (iter3_36:IsFinishedByServer() or iter3_36:IsFinish()) then
				var0_36 = iter0_36
			end
		end
	end

	local var1_36 = arg0_36.missions[var0_36 + 1]

	for iter4_36, iter5_36 in ipairs(var1_36 or {}) do
		if iter5_36:IsMain() then
			return iter5_36
		end
	end

	return nil
end

function var0_0.GetLeftTime(arg0_37)
	local var0_37 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_37.endTime - var0_37
end

return var0_0
