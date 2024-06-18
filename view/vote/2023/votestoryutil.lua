local var0_0 = class("VoteStoryUtil")

var0_0.ENTER_SCENE = 1
var0_0.ENTER_MAIN_STAGE = 2
var0_0.ENTER_SUB_STAGE = 3
var0_0.ENTER_SCHEDULE = 4
var0_0.ENTER_HALL = 5
var0_0.ENTER_EXCHANGE = 6
var0_0.END = 7

function var0_0.GetStoryNameByType(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if not var0_1 or var0_1:isEnd() then
		return nil
	end

	return var0_1:getConfig("config_client")[arg0_1 + 2]
end

function var0_0.FinalRaceIsEnd()
	local var0_2 = pg.activity_vote.all

	for iter0_2 = #var0_2, 1, -1 do
		local var1_2 = var0_2[iter0_2]
		local var2_2 = pg.activity_vote[var1_2]

		if var2_2.type == VoteConst.RACE_TYPE_FINAL then
			return pg.TimeMgr.GetInstance():GetServerTime() >= pg.TimeMgr.GetInstance():parseTimeFromConfig(var2_2.time_vote[2])
		end
	end

	return true
end

function var0_0.AllPreheatStoriesPlayed()
	if var0_0.FinalRaceIsEnd() then
		return true
	end

	local var0_3 = {
		var0_0.ENTER_SCENE,
		var0_0.ENTER_MAIN_STAGE,
		var0_0.ENTER_SUB_STAGE,
		var0_0.ENTER_SCHEDULE,
		var0_0.ENTER_HALL,
		var0_0.ENTER_EXCHANGE
	}
	local var1_3 = _.map(var0_3, function(arg0_4)
		return var0_0.GetStoryNameByType(arg0_4)
	end)

	return _.all(var1_3, function(arg0_5)
		return pg.NewStoryMgr.GetInstance():IsPlayed(arg0_5)
	end)
end

function var0_0.Notify(arg0_6)
	local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	if not var0_6 or var0_6:isEnd() then
		var0_0.HandleEndStory()

		return
	end

	local var1_6 = var0_6:getConfig("config_id")
	local var2_6 = pg.activity_vote[var1_6].type == VoteConst.RACE_TYPE_PRE
	local var3_6 = {}
	local var4_6 = {}

	if arg0_6 == var0_0.ENTER_SCENE then
		var0_0.CollectEnterStory(var2_6, var3_6)
		var0_0.CollectEnterGuide(var2_6, var4_6)
	elseif var2_6 and arg0_6 == var0_0.ENTER_MAIN_STAGE then
		var0_0.CollectEnterMainStory(var3_6)
	elseif var2_6 and arg0_6 == var0_0.ENTER_SUB_STAGE then
		var0_0.CollectEnterSubStory(var3_6)
	elseif var2_6 and arg0_6 == var0_0.ENTER_SCHEDULE then
		var0_0.CollectEnterScheduleStory(var3_6)
	elseif var2_6 and arg0_6 == var0_0.ENTER_HALL then
		var0_0.CollectEnterHallStory(var3_6)
	elseif var2_6 and arg0_6 == var0_0.ENTER_EXCHANGE then
		var0_0.CollectEnterExchangeStory(var3_6)
	end

	seriesAsync({
		function(arg0_7)
			var0_0.Play(var3_6, arg0_7)
		end,
		function(arg0_8)
			var0_0.HandleCurrActStory(var0_6, arg0_8)
		end,
		function(arg0_9)
			var0_0.HandleGuide(var4_6, arg0_9)
		end
	})
end

function var0_0.HandleGuide(arg0_10, arg1_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10) do
		table.insert(var0_10, function(arg0_11)
			pg.NewGuideMgr.GetInstance():Play(iter1_10, nil, arg0_11)
		end)
	end

	seriesAsync(var0_10, arg1_10)
end

function var0_0.HandleCurrActStory(arg0_12, arg1_12)
	if var0_0.AllPreheatStoriesPlayed() then
		local var0_12 = arg0_12:getConfig("config_client")[1]

		var0_0.Play({
			var0_12
		}, arg1_12)
	else
		arg1_12()
	end
end

function var0_0.PreRaceIsEnd()
	local var0_13

	for iter0_13, iter1_13 in ipairs(pg.activity_vote.all) do
		if pg.activity_vote[iter1_13].type == VoteConst.RACE_TYPE_PRE then
			var0_13 = iter1_13

			break
		end
	end

	if not var0_13 then
		return false
	end

	local var1_13 = pg.activity_vote[var0_13]

	return pg.TimeMgr.GetInstance():GetServerTime() >= pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_13.time_vote[2])
end

function var0_0.HandleEndStory()
	if getProxy(VoteProxy):IsAllRaceEnd() then
		local var0_14 = var0_0.GetStoryNameByType(var0_0.END)

		var0_0.Play({
			var0_14
		})
	elseif var0_0.PreRaceIsEnd() then
		local var1_14 = {
			var0_0.ENTER_SCENE,
			var0_0.ENTER_MAIN_STAGE,
			var0_0.ENTER_SUB_STAGE,
			var0_0.ENTER_SCHEDULE,
			var0_0.ENTER_HALL,
			var0_0.ENTER_EXCHANGE
		}
		local var2_14 = _.map(var1_14, function(arg0_15)
			return var0_0.GetStoryNameByType(arg0_15)
		end)

		var0_0.Play(var2_14)
	end
end

function var0_0.CollectEnterGuide(arg0_16, arg1_16)
	if arg0_16 then
		local var0_16 = var0_0.GetStoryNameByType(var0_0.ENTER_SCENE)

		if not pg.NewStoryMgr.GetInstance():IsPlayed(var0_16) then
			table.insert(arg1_16, "NG0042")
		end
	end
end

function var0_0.CollectEnterStory(arg0_17, arg1_17)
	if arg0_17 then
		local var0_17 = var0_0.GetStoryNameByType(var0_0.ENTER_SCENE)

		table.insert(arg1_17, var0_17)
	else
		local var1_17 = {
			var0_0.ENTER_SCENE,
			var0_0.ENTER_MAIN_STAGE,
			var0_0.ENTER_SUB_STAGE,
			var0_0.ENTER_SCHEDULE,
			var0_0.ENTER_HALL,
			var0_0.ENTER_EXCHANGE
		}
		local var2_17 = _.map(var1_17, function(arg0_18)
			return var0_0.GetStoryNameByType(arg0_18)
		end)

		for iter0_17, iter1_17 in ipairs(var2_17) do
			table.insert(arg1_17, iter1_17)
		end

		local var3_17 = var0_0.GetPrevRaceStories()

		for iter2_17, iter3_17 in ipairs(var3_17) do
			table.insert(arg1_17, iter3_17)
		end
	end
end

function var0_0.GetPrevRaceStories()
	local var0_19 = {}
	local var1_19 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_19, iter1_19 in ipairs(pg.activity_template.all) do
		local var2_19 = pg.activity_template[iter1_19]

		if var2_19.type == ActivityConst.ACTIVITY_TYPE_VOTE and var1_19 > pg.TimeMgr.GetInstance():parseTimeFromConfig(var2_19.time[3]) then
			table.insert(var0_19, var2_19.config_client[1])
		end
	end

	return var0_19
end

function var0_0.CollectEnterMainStory(arg0_20)
	local var0_20 = var0_0.GetStoryNameByType(var0_0.ENTER_MAIN_STAGE)

	table.insert(arg0_20, var0_20)
end

function var0_0.CollectEnterSubStory(arg0_21)
	local var0_21 = var0_0.GetStoryNameByType(var0_0.ENTER_SUB_STAGE)

	table.insert(arg0_21, var0_21)
end

function var0_0.CollectEnterScheduleStory(arg0_22)
	local var0_22 = var0_0.GetStoryNameByType(var0_0.ENTER_SCHEDULE)

	table.insert(arg0_22, var0_22)
end

function var0_0.CollectEnterHallStory(arg0_23)
	local var0_23 = var0_0.GetStoryNameByType(var0_0.ENTER_HALL)

	table.insert(arg0_23, var0_23)
end

function var0_0.CollectEnterExchangeStory(arg0_24)
	local var0_24 = var0_0.GetStoryNameByType(var0_0.ENTER_EXCHANGE)

	table.insert(arg0_24, var0_24)
end

function var0_0.Play(arg0_25, arg1_25)
	local var0_25 = _.select(arg0_25, function(arg0_26)
		return not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_26)
	end)
	local var1_25 = {}

	for iter0_25, iter1_25 in ipairs(var0_25) do
		table.insert(var1_25, function(arg0_27)
			pg.NewStoryMgr.GetInstance():Play(iter1_25, arg0_27)
		end)
	end

	seriesAsync(var1_25, arg1_25)
end

return var0_0
