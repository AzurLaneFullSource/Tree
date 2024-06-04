local var0 = class("MainRequestActDataSequence")

function var0.Execute(arg0, arg1)
	arg0:RequestReturnAwardAct()
	arg0:RequestActivityTask()
	arg0:RequestColoring()
	arg0:RequestMetaData()
	arg0:RequestManualSignAct()
	arg0:RequestRandomDailyTask()
	arg1()
end

function var0.RequestReturnAwardAct(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RETURN_AWARD)

	if var0 and not var0:isEnd() and (var0.data1 == 0 or var0.data1 == 1 and var0.data2 == 0) then
		pg.m02:sendNotification(GAME.RETURN_AWARD_OP, {
			activity_id = var0.id,
			cmd = ActivityConst.RETURN_AWARD_OP_ACTIVTION
		})
	end

	local var1 = var0

	if var1 and not var1:isEnd() then
		local var2 = var1:ShouldAcceptTasks()

		if var2 and var1:IsInviter() then
			pg.m02:sendNotification(GAME.RETURN_AWARD_OP, {
				activity_id = var1.id,
				cmd = ActivityConst.RETURN_AWARD_OP_ACCEPT_TASK
			})
		elseif var2 and var1:IsReturner() then
			pg.m02:sendNotification(GAME.RETURN_AWARD_OP, {
				activity_id = var1.id,
				cmd = ActivityConst.RETURN_AWARD_OP_RETURNER_GET_AWARD
			})
		end
	end
end

function var0.RequestActivityTask(arg0)
	local var0 = getProxy(ActivityProxy)

	_.each(var0:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_TASK_LIST,
		ActivityConst.ACTIVITY_TYPE_TASK_RES
	}), function(arg0)
		if not arg0:isEnd() then
			updateActivityTaskStatus(arg0)
		end
	end)
	underscore.each(var0:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_PT_CRUSING
	}), function(arg0)
		if not arg0:isEnd() then
			updateCrusingActivityTask(arg0)
		end
	end)
end

function var0.RequestColoring(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var0 and not var0:isEnd() then
		pg.m02:sendNotification(GAME.COLORING_FETCH, {
			activityId = var0.id
		})
	end
end

function var0.RequestMetaData(arg0)
	getProxy(MetaCharacterProxy):requestMetaTacticsInfo()
end

function var0.RequestManualSignAct(arg0)
	local var0 = getProxy(ActivityProxy):getRawData()

	for iter0, iter1 in pairs(var0) do
		if iter1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN and not iter1:TodayIsSigned() then
			pg.m02:sendNotification(GAME.ACT_MANUAL_SIGN, {
				activity_id = iter1.id,
				cmd = ManualSignActivity.OP_SIGN
			})
		end
	end
end

function var0.RequestRandomDailyTask(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RANDOM_DAILY_TASK)

	if not var0 or var0:isEnd() then
		return
	end

	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	if pg.TimeMgr.GetInstance():IsSameDay(var0.data1, var1) then
		return
	end

	pg.m02:sendNotification(GAME.ACT_RANDOM_DAILY_TASK, {
		activity_id = var0.id,
		cmd = ActivityConst.RANDOM_DAILY_TASK_OP_RANDOM
	})
end

return var0
