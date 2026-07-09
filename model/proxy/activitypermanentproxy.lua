local var0_0 = class("ActivityPermanentProxy", import(".NetProxy"))

var0_0.TYPE_NORMAL_ACTIVITY = 1
var0_0.TYPE_REMASTER_ACTIVITY = 2
var0_0.ACTIVITY_GROUP_RANGES = {
	[var0_0.TYPE_NORMAL_ACTIVITY] = {
		min = 1,
		max = 1999
	},
	[var0_0.TYPE_REMASTER_ACTIVITY] = {
		min = 2000,
		max = 2999
	}
}

function var0_0.register(arg0_1)
	arg0_1:on(11210, function(arg0_2)
		arg0_1.finishActivity = {}
		arg0_1.doingActivities = {}

		underscore.each(arg0_2.permanent_activity, function(arg0_3)
			arg0_1.finishActivity[arg0_3] = true
		end)

		if type(arg0_2.permanent_now) == "number" then
			table.insert(arg0_1.doingActivities, arg0_2.permanent_now)
		else
			for iter0_2, iter1_2 in ipairs(arg0_2.permanent_now) do
				table.insert(arg0_1.doingActivities, iter1_2)
			end
		end
	end)
end

function var0_0.startSelectActivity(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetActivityTypeById(arg1_4)

	for iter0_4 = #arg0_4.doingActivities, 1, -1 do
		if arg0_4.doingActivities[iter0_4] == arg1_4 or var0_4 and arg0_4:GetActivityTypeById(arg0_4.doingActivities[iter0_4]) == var0_4 then
			table.remove(arg0_4.doingActivities, iter0_4)
		end
	end

	table.insert(arg0_4.doingActivities, arg1_4)
end

function var0_0.StopNowActivity(arg0_5, arg1_5)
	if table.contains(arg0_5.doingActivities, arg1_5) then
		table.removebyvalue(arg0_5.doingActivities, arg1_5)
	end
end

function var0_0.finishNowActivity(arg0_6, arg1_6)
	arg0_6.finishActivity[arg1_6] = true

	arg0_6:StopNowActivity(arg1_6)
end

function var0_0.isActivityFinish(arg0_7, arg1_7)
	return arg0_7.finishActivity[arg1_7]
end

function var0_0.IsActivityGroupByType(arg0_8, arg1_8, arg2_8)
	local var0_8 = var0_0.ACTIVITY_GROUP_RANGES[arg2_8]

	return var0_8 and arg1_8 >= var0_8.min and arg1_8 <= var0_8.max
end

function var0_0.GetActivityTypeById(arg0_9, arg1_9)
	local var0_9 = pg.activity_task_permanent[arg1_9]

	if not var0_9 then
		return nil
	end

	for iter0_9, iter1_9 in pairs(var0_0.ACTIVITY_GROUP_RANGES) do
		if arg0_9:IsActivityGroupByType(var0_9.activity_group, iter0_9) then
			return iter0_9
		end
	end

	return nil
end

function var0_0.IsActivityIdByType(arg0_10, arg1_10, arg2_10)
	return arg0_10:GetActivityTypeById(arg1_10) == arg2_10
end

function var0_0.IsNormalActivityId(arg0_11, arg1_11)
	return arg0_11:IsActivityIdByType(arg1_11, var0_0.TYPE_NORMAL_ACTIVITY)
end

function var0_0.getActivityIdsByType(arg0_12, arg1_12)
	arg1_12 = arg1_12 or var0_0.TYPE_NORMAL_ACTIVITY

	return _.select(pg.activity_task_permanent.all, function(arg0_13)
		return arg0_12:IsActivityIdByType(arg0_13, arg1_12)
	end)
end

function var0_0.getDoingActivityId(arg0_14, arg1_14, arg2_14)
	arg1_14 = arg1_14 or var0_0.TYPE_NORMAL_ACTIVITY

	for iter0_14, iter1_14 in ipairs(arg0_14.doingActivities or {}) do
		if (not arg2_14 or arg2_14 == iter1_14) and arg0_14:IsActivityIdByType(iter1_14, arg1_14) then
			return iter1_14
		end
	end

	return nil
end

function var0_0.getDoingActivityById(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15:getDoingActivityId(arg1_15, arg2_15)

	return var0_15 and getProxy(ActivityProxy):getActivityById(var0_15) or nil
end

function var0_0.getDoingActivity(arg0_16, arg1_16)
	if #arg0_16.doingActivities == 0 then
		return nil
	end

	return arg0_16:getDoingActivityById(arg1_16)
end

return var0_0
