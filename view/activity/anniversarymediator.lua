local var0_0 = class("AnniversaryMediator", import("..base.ContextMediator"))

var0_0.ON_SUBMIT_TASK = "AnniversaryMediator:ON_SUBMIT_TASK"
var0_0.TO_TASK = "AnniversaryMediator:TO_TASK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.TO_TASK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.ANNIVERSARY_TASK_LIST_ID)

	arg0_1.viewComponent:setActivity(var0_1)
	arg0_1:acceptTask(var0_1)

	local var1_1 = arg0_1:getTaskByIds()

	arg0_1.viewComponent:setTaskList(var1_1)
end

function var0_0.acceptTask(arg0_4, arg1_4)
	local var0_4 = getProxy(TaskProxy)
	local var1_4 = arg1_4:getConfig("config_data")
	local var2_4 = pg.TimeMgr.GetInstance()
	local var3_4 = var2_4:DiffDay(arg1_4.data1, var2_4:GetServerTime()) + 1
	local var4_4 = math.clamp(var3_4, 1, #var1_4)
	local var5_4 = arg1_4.data3

	if var5_4 == 0 or var5_4 < var4_4 and _.all(_.flatten({
		var1_4[var5_4]
	}), function(arg0_5)
		return var0_4:getFinishTaskById(arg0_5) ~= nil
	end) then
		arg0_4:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg1_4.id
		})
	end
end

function var0_0.getTaskByIds(arg0_6)
	local var0_6 = {}
	local var1_6 = getProxy(TaskProxy)
	local var2_6 = var1_6:getData()

	for iter0_6, iter1_6 in pairs(var2_6) do
		var0_6[iter1_6.id] = iter1_6
	end

	local var3_6 = var1_6.finishData

	for iter2_6, iter3_6 in pairs(var3_6) do
		var0_6[iter3_6.id] = iter3_6
	end

	return var0_6
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		TaskProxy.TASK_ADDED,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		TaskProxy.TASK_FINISH,
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == TaskProxy.TASK_ADDED or var0_8 == TaskProxy.TASK_UPDATED or var0_8 == TaskProxy.TASK_REMOVED or var0_8 == TaskProxy.TASK_FINISH then
		local var2_8 = arg0_8:getTaskByIds()

		arg0_8.viewComponent:setTaskList(var2_8)
	elseif var0_8 == GAME.SUBMIT_TASK_DONE then
		local var3_8 = getProxy(ActivityProxy):getActivityById(ActivityConst.ANNIVERSARY_TASK_LIST_ID)

		if arg0_8.viewComponent.dateIndex and arg0_8.viewComponent.dateIndex == var3_8.data3 then
			arg0_8.viewComponent:updateTaskGroupDesc(var3_8.data3)
		end

		arg0_8.viewComponent:updateBottomTaskGroup(var3_8.data3)
		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8)
		arg0_8:acceptTask(var3_8)
	elseif var0_8 == ActivityProxy.ACTIVITY_UPDATED and var1_8.id == ActivityConst.ANNIVERSARY_TASK_LIST_ID then
		arg0_8.viewComponent:setActivity(var1_8)
		arg0_8.viewComponent:updateTaskGroups()
		arg0_8.viewComponent:moveToTaskGroup(arg0_8.viewComponent.date, nil, true)
	end
end

return var0_0
