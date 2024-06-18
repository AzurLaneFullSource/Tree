local var0_0 = class("MainRequestActDataSequence")

function var0_0.Execute(arg0_1, arg1_1)
	arg0_1:RequestReturnAwardAct()
	arg0_1:RequestActivityTask()
	arg0_1:RequestColoring()
	arg0_1:RequestMetaData()
	arg0_1:RequestManualSignAct()
	arg0_1:RequestRandomDailyTask()
	arg1_1()
end

function var0_0.RequestReturnAwardAct(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RETURN_AWARD)

	if var0_2 and not var0_2:isEnd() and (var0_2.data1 == 0 or var0_2.data1 == 1 and var0_2.data2 == 0) then
		pg.m02:sendNotification(GAME.RETURN_AWARD_OP, {
			activity_id = var0_2.id,
			cmd = ActivityConst.RETURN_AWARD_OP_ACTIVTION
		})
	end

	local var1_2 = var0_2

	if var1_2 and not var1_2:isEnd() then
		local var2_2 = var1_2:ShouldAcceptTasks()

		if var2_2 and var1_2:IsInviter() then
			pg.m02:sendNotification(GAME.RETURN_AWARD_OP, {
				activity_id = var1_2.id,
				cmd = ActivityConst.RETURN_AWARD_OP_ACCEPT_TASK
			})
		elseif var2_2 and var1_2:IsReturner() then
			pg.m02:sendNotification(GAME.RETURN_AWARD_OP, {
				activity_id = var1_2.id,
				cmd = ActivityConst.RETURN_AWARD_OP_RETURNER_GET_AWARD
			})
		end
	end
end

function var0_0.RequestActivityTask(arg0_3)
	local var0_3 = getProxy(ActivityProxy)

	_.each(var0_3:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_TASK_LIST,
		ActivityConst.ACTIVITY_TYPE_TASK_RES
	}), function(arg0_4)
		if not arg0_4:isEnd() then
			updateActivityTaskStatus(arg0_4)
		end
	end)
	underscore.each(var0_3:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_PT_CRUSING
	}), function(arg0_5)
		if not arg0_5:isEnd() then
			updateCrusingActivityTask(arg0_5)
		end
	end)
end

function var0_0.RequestColoring(arg0_6)
	local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var0_6 and not var0_6:isEnd() then
		pg.m02:sendNotification(GAME.COLORING_FETCH, {
			activityId = var0_6.id
		})
	end
end

function var0_0.RequestMetaData(arg0_7)
	getProxy(MetaCharacterProxy):requestMetaTacticsInfo()
end

function var0_0.RequestManualSignAct(arg0_8)
	local var0_8 = getProxy(ActivityProxy):getRawData()

	for iter0_8, iter1_8 in pairs(var0_8) do
		if iter1_8:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN and not iter1_8:TodayIsSigned() then
			pg.m02:sendNotification(GAME.ACT_MANUAL_SIGN, {
				activity_id = iter1_8.id,
				cmd = ManualSignActivity.OP_SIGN
			})
		end
	end
end

function var0_0.RequestRandomDailyTask(arg0_9)
	local var0_9 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RANDOM_DAILY_TASK)

	if not var0_9 or var0_9:isEnd() then
		return
	end

	local var1_9 = pg.TimeMgr.GetInstance():GetServerTime()

	if pg.TimeMgr.GetInstance():IsSameDay(var0_9.data1, var1_9) then
		return
	end

	pg.m02:sendNotification(GAME.ACT_RANDOM_DAILY_TASK, {
		activity_id = var0_9.id,
		cmd = ActivityConst.RANDOM_DAILY_TASK_OP_RANDOM
	})
end

return var0_0
