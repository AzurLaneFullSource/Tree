local var0 = class("AnniversaryMediator", import("..base.ContextMediator"))

var0.ON_SUBMIT_TASK = "AnniversaryMediator:ON_SUBMIT_TASK"
var0.TO_TASK = "AnniversaryMediator:TO_TASK"

function var0.register(arg0)
	arg0:bind(var0.TO_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:bind(var0.ON_SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ANNIVERSARY_TASK_LIST_ID)

	arg0.viewComponent:setActivity(var0)
	arg0:acceptTask(var0)

	local var1 = arg0:getTaskByIds()

	arg0.viewComponent:setTaskList(var1)
end

function var0.acceptTask(arg0, arg1)
	local var0 = getProxy(TaskProxy)
	local var1 = arg1:getConfig("config_data")
	local var2 = pg.TimeMgr.GetInstance()
	local var3 = var2:DiffDay(arg1.data1, var2:GetServerTime()) + 1
	local var4 = math.clamp(var3, 1, #var1)
	local var5 = arg1.data3

	if var5 == 0 or var5 < var4 and _.all(_.flatten({
		var1[var5]
	}), function(arg0)
		return var0:getFinishTaskById(arg0) ~= nil
	end) then
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg1.id
		})
	end
end

function var0.getTaskByIds(arg0)
	local var0 = {}
	local var1 = getProxy(TaskProxy)
	local var2 = var1:getData()

	for iter0, iter1 in pairs(var2) do
		var0[iter1.id] = iter1
	end

	local var3 = var1.finishData

	for iter2, iter3 in pairs(var3) do
		var0[iter3.id] = iter3
	end

	return var0
end

function var0.listNotificationInterests(arg0)
	return {
		TaskProxy.TASK_ADDED,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		TaskProxy.TASK_FINISH,
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == TaskProxy.TASK_ADDED or var0 == TaskProxy.TASK_UPDATED or var0 == TaskProxy.TASK_REMOVED or var0 == TaskProxy.TASK_FINISH then
		local var2 = arg0:getTaskByIds()

		arg0.viewComponent:setTaskList(var2)
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		local var3 = getProxy(ActivityProxy):getActivityById(ActivityConst.ANNIVERSARY_TASK_LIST_ID)

		if arg0.viewComponent.dateIndex and arg0.viewComponent.dateIndex == var3.data3 then
			arg0.viewComponent:updateTaskGroupDesc(var3.data3)
		end

		arg0.viewComponent:updateBottomTaskGroup(var3.data3)
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1)
		arg0:acceptTask(var3)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED and var1.id == ActivityConst.ANNIVERSARY_TASK_LIST_ID then
		arg0.viewComponent:setActivity(var1)
		arg0.viewComponent:updateTaskGroups()
		arg0.viewComponent:moveToTaskGroup(arg0.viewComponent.date, nil, true)
	end
end

return var0
