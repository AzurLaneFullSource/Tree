local var0_0 = class("VoteProxy", import(".NetProxy"))

var0_0.VOTE_ORDER_BOOK_UPDATE = "VoteProxy:VOTE_ORDER_BOOK_UPDATE"
var0_0.VOTE_ORDER_BOOK_DELETE = "VoteProxy:VOTE_ORDER_BOOK_DELETE"
var0_0.VOTES_COUNT_UPDATE = "VoteProxy:VOTES_COUNT_UPDATE"

function var0_0.register(arg0_1)
	arg0_1.voteGroupList = {}
	arg0_1.tempVoteGroup = {}
end

function var0_0.AddTempVoteGroup(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2.list
	local var1_2 = _.map(var0_2, function(arg0_3)
		return arg0_2:Data2VoteShip(arg0_3, arg2_2)
	end)

	arg0_2.tempVoteGroup[arg2_2] = VoteGroup.New({
		id = arg2_2,
		list = var1_2
	})
end

function var0_0.RawGetTempVoteGroup(arg0_4, arg1_4)
	return arg0_4.tempVoteGroup[arg1_4]
end

function var0_0.RawGetVoteGroupByConfigId(arg0_5, arg1_5)
	return arg0_5.voteGroupList[arg1_5]
end

function var0_0.GetVoteActivityByConfigId(arg0_6, arg1_6)
	local var0_6 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	for iter0_6, iter1_6 in ipairs(var0_6) do
		if iter1_6:getDataConfig("is_in_game") == 1 and iter1_6:getConfig("config_id") == arg1_6 and not iter1_6:isEnd() then
			return iter1_6
		end
	end

	return nil
end

function var0_0.GetVotesByConfigId(arg0_7, arg1_7)
	local var0_7 = arg0_7:GetVoteActivityByConfigId(arg1_7)

	if var0_7 and not var0_7:isEnd() then
		return var0_7.data1
	end

	return 0
end

function var0_0.AddVoteGroup(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8.list
	local var1_8 = _.map(var0_8, function(arg0_9)
		return arg0_8:Data2VoteShip(arg0_9, arg2_8)
	end)

	arg0_8.voteGroupList[arg2_8] = VoteGroup.New({
		id = arg2_8,
		list = var1_8
	})
end

function var0_0.Data2VoteShip(arg0_10, arg1_10, arg2_10)
	if pg.activity_vote_virtual_ship_data[arg1_10.key] then
		return VirtualVoteShip.New(arg1_10, arg2_10)
	elseif ShipGroup.GetGroupConfig(arg1_10.key) ~= nil then
		return VoteShip.New(arg1_10, arg2_10)
	else
		assert(false, arg1_10.key)
	end
end

function var0_0.AnyVoteActIsOpening(arg0_11)
	local var0_11 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	for iter0_11, iter1_11 in ipairs(var0_11) do
		if iter1_11:getDataConfig("is_in_game") == 1 and not iter1_11:isEnd() then
			return true
		end
	end

	return false
end

function var0_0.GetVoteGroupList(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.voteGroupList) do
		table.insert(var0_12, iter1_12)
	end

	return var0_12
end

function var0_0.GetOpeningFunVoteGroup(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.voteGroupList) do
		if iter1_13:IsFunRace() and iter1_13:IsOpening() then
			return iter1_13
		end
	end

	return nil
end

function var0_0.GetOpeningNonFunVoteGroup(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.voteGroupList) do
		if not iter1_14:IsFunRace() and iter1_14:IsOpening() then
			return iter1_14
		end
	end

	return nil
end

function var0_0.IsAllRaceEnd(arg0_15)
	local var0_15 = pg.TimeMgr.GetInstance():GetServerTime()

	return _.all(pg.activity_vote.all, function(arg0_16)
		local var0_16 = pg.activity_vote[arg0_16]
		local var1_16 = var0_16.time_vote

		return var0_16.is_in_game == 1 and var0_15 >= pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_16[2])
	end)
end

function var0_0.GetPastVoteData(arg0_17)
	if not arg0_17.pastVoteData then
		arg0_17.pastVoteData = pg.vote_champion.get_id_list_by_group
	end

	return arg0_17.pastVoteData
end

function var0_0.ExistPastVoteAward(arg0_18)
	local var0_18 = arg0_18:GetPastVoteData()
	local var1_18 = getProxy(AttireProxy)

	for iter0_18, iter1_18 in pairs(var0_18) do
		if _.any(iter1_18, function(arg0_19)
			local var0_19 = pg.vote_champion[arg0_19]
			local var1_19 = getProxy(TaskProxy):getTaskById(var0_19.task)
			local var2_19 = pg.task_data_template[var0_19.task].award_display[1]
			local var3_19 = var1_18:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var2_19[2])

			return var1_19 and var1_19:isFinish() and not var1_19:isReceive() and (var3_19 == nil or not var3_19:isOwned())
		end) then
			return true
		end
	end

	return false
end

function var0_0.IsNewRace(arg0_20, arg1_20)
	if not arg1_20 then
		return false
	end

	local var0_20 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(arg1_20.configId .. "_vote__tip_" .. var0_20, 0) == 0
end

function var0_0.MarkRaceNonNew(arg0_21, arg1_21)
	if not arg1_21 or not arg0_21:IsNewRace(arg1_21) then
		return
	end

	local var0_21 = getProxy(PlayerProxy):getRawData().id
	local var1_21 = PlayerPrefs.SetInt(arg1_21.configId .. "_vote__tip_" .. var0_21, 1)

	PlayerPrefs.Save()
end

return var0_0
