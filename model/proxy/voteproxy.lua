local var0 = class("VoteProxy", import(".NetProxy"))

var0.VOTE_ORDER_BOOK_UPDATE = "VoteProxy:VOTE_ORDER_BOOK_UPDATE"
var0.VOTE_ORDER_BOOK_DELETE = "VoteProxy:VOTE_ORDER_BOOK_DELETE"
var0.VOTES_COUNT_UPDATE = "VoteProxy:VOTES_COUNT_UPDATE"

function var0.register(arg0)
	arg0.voteGroupList = {}
	arg0.tempVoteGroup = {}
end

function var0.AddTempVoteGroup(arg0, arg1, arg2)
	local var0 = arg1.list
	local var1 = _.map(var0, function(arg0)
		return arg0:Data2VoteShip(arg0, arg2)
	end)

	arg0.tempVoteGroup[arg2] = VoteGroup.New({
		id = arg2,
		list = var1
	})
end

function var0.RawGetTempVoteGroup(arg0, arg1)
	return arg0.tempVoteGroup[arg1]
end

function var0.RawGetVoteGroupByConfigId(arg0, arg1)
	return arg0.voteGroupList[arg1]
end

function var0.GetVoteActivityByConfigId(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	for iter0, iter1 in ipairs(var0) do
		if iter1:getDataConfig("is_in_game") == 1 and iter1:getConfig("config_id") == arg1 and not iter1:isEnd() then
			return iter1
		end
	end

	return nil
end

function var0.GetVotesByConfigId(arg0, arg1)
	local var0 = arg0:GetVoteActivityByConfigId(arg1)

	if var0 and not var0:isEnd() then
		return var0.data1
	end

	return 0
end

function var0.AddVoteGroup(arg0, arg1, arg2)
	local var0 = arg1.list
	local var1 = _.map(var0, function(arg0)
		return arg0:Data2VoteShip(arg0, arg2)
	end)

	arg0.voteGroupList[arg2] = VoteGroup.New({
		id = arg2,
		list = var1
	})
end

function var0.Data2VoteShip(arg0, arg1, arg2)
	if pg.activity_vote_virtual_ship_data[arg1.key] then
		return VirtualVoteShip.New(arg1, arg2)
	elseif ShipGroup.GetGroupConfig(arg1.key) ~= nil then
		return VoteShip.New(arg1, arg2)
	else
		assert(false, arg1.key)
	end
end

function var0.AnyVoteActIsOpening(arg0)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	for iter0, iter1 in ipairs(var0) do
		if iter1:getDataConfig("is_in_game") == 1 and not iter1:isEnd() then
			return true
		end
	end

	return false
end

function var0.GetVoteGroupList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.voteGroupList) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.GetOpeningFunVoteGroup(arg0)
	for iter0, iter1 in pairs(arg0.voteGroupList) do
		if iter1:IsFunRace() and iter1:IsOpening() then
			return iter1
		end
	end

	return nil
end

function var0.GetOpeningNonFunVoteGroup(arg0)
	for iter0, iter1 in pairs(arg0.voteGroupList) do
		if not iter1:IsFunRace() and iter1:IsOpening() then
			return iter1
		end
	end

	return nil
end

function var0.IsAllRaceEnd(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return _.all(pg.activity_vote.all, function(arg0)
		local var0 = pg.activity_vote[arg0]
		local var1 = var0.time_vote

		return var0.is_in_game == 1 and var0 >= pg.TimeMgr.GetInstance():parseTimeFromConfig(var1[2])
	end)
end

function var0.GetPastVoteData(arg0)
	if not arg0.pastVoteData then
		arg0.pastVoteData = pg.vote_champion.get_id_list_by_group
	end

	return arg0.pastVoteData
end

function var0.ExistPastVoteAward(arg0)
	local var0 = arg0:GetPastVoteData()
	local var1 = getProxy(AttireProxy)

	for iter0, iter1 in pairs(var0) do
		if _.any(iter1, function(arg0)
			local var0 = pg.vote_champion[arg0]
			local var1 = getProxy(TaskProxy):getTaskById(var0.task)
			local var2 = pg.task_data_template[var0.task].award_display[1]
			local var3 = var1:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var2[2])

			return var1 and var1:isFinish() and not var1:isReceive() and (var3 == nil or not var3:isOwned())
		end) then
			return true
		end
	end

	return false
end

function var0.IsNewRace(arg0, arg1)
	if not arg1 then
		return false
	end

	local var0 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(arg1.configId .. "_vote__tip_" .. var0, 0) == 0
end

function var0.MarkRaceNonNew(arg0, arg1)
	if not arg1 or not arg0:IsNewRace(arg1) then
		return
	end

	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = PlayerPrefs.SetInt(arg1.configId .. "_vote__tip_" .. var0, 1)

	PlayerPrefs.Save()
end

return var0
