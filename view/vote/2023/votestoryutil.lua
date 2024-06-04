local var0 = class("VoteStoryUtil")

var0.ENTER_SCENE = 1
var0.ENTER_MAIN_STAGE = 2
var0.ENTER_SUB_STAGE = 3
var0.ENTER_SCHEDULE = 4
var0.ENTER_HALL = 5
var0.ENTER_EXCHANGE = 6
var0.END = 7

function var0.GetStoryNameByType(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if not var0 or var0:isEnd() then
		return nil
	end

	return var0:getConfig("config_client")[arg0 + 2]
end

function var0.FinalRaceIsEnd()
	local var0 = pg.activity_vote.all

	for iter0 = #var0, 1, -1 do
		local var1 = var0[iter0]
		local var2 = pg.activity_vote[var1]

		if var2.type == VoteConst.RACE_TYPE_FINAL then
			return pg.TimeMgr.GetInstance():GetServerTime() >= pg.TimeMgr.GetInstance():parseTimeFromConfig(var2.time_vote[2])
		end
	end

	return true
end

function var0.AllPreheatStoriesPlayed()
	if var0.FinalRaceIsEnd() then
		return true
	end

	local var0 = {
		var0.ENTER_SCENE,
		var0.ENTER_MAIN_STAGE,
		var0.ENTER_SUB_STAGE,
		var0.ENTER_SCHEDULE,
		var0.ENTER_HALL,
		var0.ENTER_EXCHANGE
	}
	local var1 = _.map(var0, function(arg0)
		return var0.GetStoryNameByType(arg0)
	end)

	return _.all(var1, function(arg0)
		return pg.NewStoryMgr.GetInstance():IsPlayed(arg0)
	end)
end

function var0.Notify(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	if not var0 or var0:isEnd() then
		var0.HandleEndStory()

		return
	end

	local var1 = var0:getConfig("config_id")
	local var2 = pg.activity_vote[var1].type == VoteConst.RACE_TYPE_PRE
	local var3 = {}
	local var4 = {}

	if arg0 == var0.ENTER_SCENE then
		var0.CollectEnterStory(var2, var3)
		var0.CollectEnterGuide(var2, var4)
	elseif var2 and arg0 == var0.ENTER_MAIN_STAGE then
		var0.CollectEnterMainStory(var3)
	elseif var2 and arg0 == var0.ENTER_SUB_STAGE then
		var0.CollectEnterSubStory(var3)
	elseif var2 and arg0 == var0.ENTER_SCHEDULE then
		var0.CollectEnterScheduleStory(var3)
	elseif var2 and arg0 == var0.ENTER_HALL then
		var0.CollectEnterHallStory(var3)
	elseif var2 and arg0 == var0.ENTER_EXCHANGE then
		var0.CollectEnterExchangeStory(var3)
	end

	seriesAsync({
		function(arg0)
			var0.Play(var3, arg0)
		end,
		function(arg0)
			var0.HandleCurrActStory(var0, arg0)
		end,
		function(arg0)
			var0.HandleGuide(var4, arg0)
		end
	})
end

function var0.HandleGuide(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		table.insert(var0, function(arg0)
			pg.NewGuideMgr.GetInstance():Play(iter1, nil, arg0)
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.HandleCurrActStory(arg0, arg1)
	if var0.AllPreheatStoriesPlayed() then
		local var0 = arg0:getConfig("config_client")[1]

		var0.Play({
			var0
		}, arg1)
	else
		arg1()
	end
end

function var0.PreRaceIsEnd()
	local var0

	for iter0, iter1 in ipairs(pg.activity_vote.all) do
		if pg.activity_vote[iter1].type == VoteConst.RACE_TYPE_PRE then
			var0 = iter1

			break
		end
	end

	if not var0 then
		return false
	end

	local var1 = pg.activity_vote[var0]

	return pg.TimeMgr.GetInstance():GetServerTime() >= pg.TimeMgr.GetInstance():parseTimeFromConfig(var1.time_vote[2])
end

function var0.HandleEndStory()
	if getProxy(VoteProxy):IsAllRaceEnd() then
		local var0 = var0.GetStoryNameByType(var0.END)

		var0.Play({
			var0
		})
	elseif var0.PreRaceIsEnd() then
		local var1 = {
			var0.ENTER_SCENE,
			var0.ENTER_MAIN_STAGE,
			var0.ENTER_SUB_STAGE,
			var0.ENTER_SCHEDULE,
			var0.ENTER_HALL,
			var0.ENTER_EXCHANGE
		}
		local var2 = _.map(var1, function(arg0)
			return var0.GetStoryNameByType(arg0)
		end)

		var0.Play(var2)
	end
end

function var0.CollectEnterGuide(arg0, arg1)
	if arg0 then
		local var0 = var0.GetStoryNameByType(var0.ENTER_SCENE)

		if not pg.NewStoryMgr.GetInstance():IsPlayed(var0) then
			table.insert(arg1, "NG0042")
		end
	end
end

function var0.CollectEnterStory(arg0, arg1)
	if arg0 then
		local var0 = var0.GetStoryNameByType(var0.ENTER_SCENE)

		table.insert(arg1, var0)
	else
		local var1 = {
			var0.ENTER_SCENE,
			var0.ENTER_MAIN_STAGE,
			var0.ENTER_SUB_STAGE,
			var0.ENTER_SCHEDULE,
			var0.ENTER_HALL,
			var0.ENTER_EXCHANGE
		}
		local var2 = _.map(var1, function(arg0)
			return var0.GetStoryNameByType(arg0)
		end)

		for iter0, iter1 in ipairs(var2) do
			table.insert(arg1, iter1)
		end

		local var3 = var0.GetPrevRaceStories()

		for iter2, iter3 in ipairs(var3) do
			table.insert(arg1, iter3)
		end
	end
end

function var0.GetPrevRaceStories()
	local var0 = {}
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0, iter1 in ipairs(pg.activity_template.all) do
		local var2 = pg.activity_template[iter1]

		if var2.type == ActivityConst.ACTIVITY_TYPE_VOTE and var1 > pg.TimeMgr.GetInstance():parseTimeFromConfig(var2.time[3]) then
			table.insert(var0, var2.config_client[1])
		end
	end

	return var0
end

function var0.CollectEnterMainStory(arg0)
	local var0 = var0.GetStoryNameByType(var0.ENTER_MAIN_STAGE)

	table.insert(arg0, var0)
end

function var0.CollectEnterSubStory(arg0)
	local var0 = var0.GetStoryNameByType(var0.ENTER_SUB_STAGE)

	table.insert(arg0, var0)
end

function var0.CollectEnterScheduleStory(arg0)
	local var0 = var0.GetStoryNameByType(var0.ENTER_SCHEDULE)

	table.insert(arg0, var0)
end

function var0.CollectEnterHallStory(arg0)
	local var0 = var0.GetStoryNameByType(var0.ENTER_HALL)

	table.insert(arg0, var0)
end

function var0.CollectEnterExchangeStory(arg0)
	local var0 = var0.GetStoryNameByType(var0.ENTER_EXCHANGE)

	table.insert(arg0, var0)
end

function var0.Play(arg0, arg1)
	local var0 = _.select(arg0, function(arg0)
		return not pg.NewStoryMgr.GetInstance():IsPlayed(arg0)
	end)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			pg.NewStoryMgr.GetInstance():Play(iter1, arg0)
		end)
	end

	seriesAsync(var1, arg1)
end

return var0
