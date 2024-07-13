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

function var0_0.timeCall(arg0_3)
	return {
		[ProxyRegister.DayCall] = function(arg0_4)
			arg0_3:resetDailyCount()
			arg0_3:clearChaptersDefeatCount()
		end
	}
end

function var0_0.AddQuickStage(arg0_5, arg1_5)
	arg0_5.quickStages[arg1_5] = true
end

function var0_0.CanQuickBattle(arg0_6, arg1_6)
	return arg0_6.quickStages[arg1_6] == true
end

function var0_0.clearChaptersDefeatCount(arg0_7)
	arg0_7.chapterCountList = {}
end

function var0_0.ifShowDailyTip(arg0_8)
	return arg0_8.dailyTip
end

function var0_0.setDailyTip(arg0_9, arg1_9)
	arg0_9.dailyTip = arg1_9
end

function var0_0.getChapterDefeatCount(arg0_10, arg1_10)
	local var0_10 = _.detect(arg0_10.chapterCountList, function(arg0_11)
		return arg0_11.id == arg1_10
	end)

	return var0_10 and var0_10.count or 0
end

function var0_0.updateChapterDefeatCount(arg0_12, arg1_12)
	local var0_12 = arg0_12:getChapterDefeatCount(arg1_12) + 1
	local var1_12 = _.detect(arg0_12.chapterCountList, function(arg0_13)
		return arg0_13.id == arg1_12
	end)

	if var1_12 then
		var1_12.count = var0_12
	else
		table.insert(arg0_12.chapterCountList, {
			id = arg1_12,
			count = var0_12
		})
	end
end

function var0_0.resetDailyCount(arg0_14)
	local var0_14 = pg.expedition_daily_template
	local var1_14 = pg.TimeMgr.GetInstance():GetServerWeek() == 1

	for iter0_14, iter1_14 in pairs(arg0_14.data) do
		if var0_14[iter0_14].limit_type == 1 or var0_14[iter0_14].limit_type == 2 and var1_14 then
			arg0_14.data[iter0_14] = 0
		end
	end

	arg0_14.eliteCount = 0

	arg0_14:sendNotification(var0_0.ELITE_QUOTA_UPDATE)
end

function var0_0.GetRestEliteCount(arg0_15)
	return math.max(0, pg.gameset.elite_quota.key_value - arg0_15.eliteCount)
end

function var0_0.IsEliteEnabled(arg0_16)
	return arg0_16:GetRestEliteCount() > 0
end

function var0_0.EliteCountPlus(arg0_17)
	arg0_17.eliteCount = math.min(arg0_17.eliteCount + 1, pg.gameset.elite_quota.key_value)

	arg0_17:sendNotification(var0_0.ELITE_QUOTA_UPDATE)
end

return var0_0
