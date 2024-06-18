local var0_0 = class("DailyLevelProxy", import(".NetProxy"))

var0_0.ELITE_QUOTA_UPDATE = "DailyLevelProxy:ELITE_QUOTA_UPDATE"

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.eliteCount = 0
	arg0_1.chapterCountList = {}
	arg0_1.quickStages = {}

	arg0_1:on(13201, function(arg0_2)
		arg0_1.data = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.count_list) do
			arg0_1.data[iter1_2.id] = iter1_2.count
		end

		arg0_1.eliteCount = arg0_2.elite_expedition_count
		getProxy(ChapterProxy).escortChallengeTimes = arg0_2.escort_expedition_count

		for iter2_2, iter3_2 in ipairs(arg0_2.chapter_count_list) do
			table.insert(arg0_1.chapterCountList, {
				id = iter3_2.id,
				count = iter3_2.count
			})
		end

		for iter4_2, iter5_2 in ipairs(arg0_2.quick_expedition_list) do
			arg0_1:AddQuickStage(iter5_2)
		end

		local var0_2 = pg.expedition_daily_template

		arg0_1.dailyList = _.reverse(Clone(var0_2.all))

		for iter6_2 = #arg0_1.dailyList, 1, -1 do
			local var1_2 = var0_2[arg0_1.dailyList[iter6_2]].limit_period
			local var2_2 = var0_2[arg0_1.dailyList[iter6_2]].id
			local var3_2 = var0_2[arg0_1.dailyList[iter6_2]].limit_time

			if var1_2 and type(var1_2) == "table" and pg.TimeMgr:GetInstance():inTime(var1_2) and var3_2 > (arg0_1.data[var2_2] or 0) then
				arg0_1.dailyTip = true
			end
		end
	end)
end

function var0_0.AddQuickStage(arg0_3, arg1_3)
	arg0_3.quickStages[arg1_3] = true
end

function var0_0.CanQuickBattle(arg0_4, arg1_4)
	return arg0_4.quickStages[arg1_4] == true
end

function var0_0.clearChaptersDefeatCount(arg0_5)
	arg0_5.chapterCountList = {}
end

function var0_0.ifShowDailyTip(arg0_6)
	return arg0_6.dailyTip
end

function var0_0.setDailyTip(arg0_7, arg1_7)
	arg0_7.dailyTip = arg1_7
end

function var0_0.getChapterDefeatCount(arg0_8, arg1_8)
	local var0_8 = _.detect(arg0_8.chapterCountList, function(arg0_9)
		return arg0_9.id == arg1_8
	end)

	return var0_8 and var0_8.count or 0
end

function var0_0.updateChapterDefeatCount(arg0_10, arg1_10)
	local var0_10 = arg0_10:getChapterDefeatCount(arg1_10) + 1
	local var1_10 = _.detect(arg0_10.chapterCountList, function(arg0_11)
		return arg0_11.id == arg1_10
	end)

	if var1_10 then
		var1_10.count = var0_10
	else
		table.insert(arg0_10.chapterCountList, {
			id = arg1_10,
			count = var0_10
		})
	end
end

function var0_0.resetDailyCount(arg0_12)
	local var0_12 = pg.expedition_daily_template
	local var1_12 = pg.TimeMgr.GetInstance():GetServerWeek() == 1

	for iter0_12, iter1_12 in pairs(arg0_12.data) do
		if var0_12[iter0_12].limit_type == 1 or var0_12[iter0_12].limit_type == 2 and var1_12 then
			arg0_12.data[iter0_12] = 0
		end
	end

	arg0_12.eliteCount = 0

	arg0_12:sendNotification(var0_0.ELITE_QUOTA_UPDATE)
end

function var0_0.GetRestEliteCount(arg0_13)
	return math.max(0, pg.gameset.elite_quota.key_value - arg0_13.eliteCount)
end

function var0_0.IsEliteEnabled(arg0_14)
	return arg0_14:GetRestEliteCount() > 0
end

function var0_0.EliteCountPlus(arg0_15)
	arg0_15.eliteCount = math.min(arg0_15.eliteCount + 1, pg.gameset.elite_quota.key_value)

	arg0_15:sendNotification(var0_0.ELITE_QUOTA_UPDATE)
end

return var0_0
