local var0 = class("DailyLevelProxy", import(".NetProxy"))

var0.ELITE_QUOTA_UPDATE = "DailyLevelProxy:ELITE_QUOTA_UPDATE"

function var0.register(arg0)
	arg0.data = {}
	arg0.eliteCount = 0
	arg0.chapterCountList = {}
	arg0.quickStages = {}

	arg0:on(13201, function(arg0)
		arg0.data = {}

		for iter0, iter1 in ipairs(arg0.count_list) do
			arg0.data[iter1.id] = iter1.count
		end

		arg0.eliteCount = arg0.elite_expedition_count
		getProxy(ChapterProxy).escortChallengeTimes = arg0.escort_expedition_count

		for iter2, iter3 in ipairs(arg0.chapter_count_list) do
			table.insert(arg0.chapterCountList, {
				id = iter3.id,
				count = iter3.count
			})
		end

		for iter4, iter5 in ipairs(arg0.quick_expedition_list) do
			arg0:AddQuickStage(iter5)
		end

		local var0 = pg.expedition_daily_template

		arg0.dailyList = _.reverse(Clone(var0.all))

		for iter6 = #arg0.dailyList, 1, -1 do
			local var1 = var0[arg0.dailyList[iter6]].limit_period
			local var2 = var0[arg0.dailyList[iter6]].id
			local var3 = var0[arg0.dailyList[iter6]].limit_time

			if var1 and type(var1) == "table" and pg.TimeMgr:GetInstance():inTime(var1) and var3 > (arg0.data[var2] or 0) then
				arg0.dailyTip = true
			end
		end
	end)
end

function var0.AddQuickStage(arg0, arg1)
	arg0.quickStages[arg1] = true
end

function var0.CanQuickBattle(arg0, arg1)
	return arg0.quickStages[arg1] == true
end

function var0.clearChaptersDefeatCount(arg0)
	arg0.chapterCountList = {}
end

function var0.ifShowDailyTip(arg0)
	return arg0.dailyTip
end

function var0.setDailyTip(arg0, arg1)
	arg0.dailyTip = arg1
end

function var0.getChapterDefeatCount(arg0, arg1)
	local var0 = _.detect(arg0.chapterCountList, function(arg0)
		return arg0.id == arg1
	end)

	return var0 and var0.count or 0
end

function var0.updateChapterDefeatCount(arg0, arg1)
	local var0 = arg0:getChapterDefeatCount(arg1) + 1
	local var1 = _.detect(arg0.chapterCountList, function(arg0)
		return arg0.id == arg1
	end)

	if var1 then
		var1.count = var0
	else
		table.insert(arg0.chapterCountList, {
			id = arg1,
			count = var0
		})
	end
end

function var0.resetDailyCount(arg0)
	local var0 = pg.expedition_daily_template
	local var1 = pg.TimeMgr.GetInstance():GetServerWeek() == 1

	for iter0, iter1 in pairs(arg0.data) do
		if var0[iter0].limit_type == 1 or var0[iter0].limit_type == 2 and var1 then
			arg0.data[iter0] = 0
		end
	end

	arg0.eliteCount = 0

	arg0:sendNotification(var0.ELITE_QUOTA_UPDATE)
end

function var0.GetRestEliteCount(arg0)
	return math.max(0, pg.gameset.elite_quota.key_value - arg0.eliteCount)
end

function var0.IsEliteEnabled(arg0)
	return arg0:GetRestEliteCount() > 0
end

function var0.EliteCountPlus(arg0)
	arg0.eliteCount = math.min(arg0.eliteCount + 1, pg.gameset.elite_quota.key_value)

	arg0:sendNotification(var0.ELITE_QUOTA_UPDATE)
end

return var0
