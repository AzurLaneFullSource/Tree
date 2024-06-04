local var0 = class("TaskProxy", import(".NetProxy"))

var0.TASK_ADDED = "task added"
var0.TASK_UPDATED = "task updated"
var0.TASK_REMOVED = "task removed"
var0.TASK_FINISH = "task finish"
var0.TASK_PROGRESS_UPDATE = "task TASK_PROGRESS_UPDATE"
var0.WEEK_TASK_UPDATED = "week task updated"
var0.WEEK_TASKS_ADDED = "week tasks added"
var0.WEEK_TASKS_DELETED = "week task deleted"
var0.WEEK_TASK_RESET = "week task refresh"
mingshiTriggerId = 1
mingshiActivityId = 21
changdaoActivityId = 10006
changdaoTaskStartId = 5031

function var0.register(arg0)
	arg0:on(20001, function(arg0)
		arg0.data = {}
		arg0.finishData = {}
		arg0.tmpInfo = {}

		for iter0, iter1 in ipairs(arg0.info) do
			local var0 = Task.New(iter1)

			if var0:getConfigTable() ~= nil then
				var0:display("loaded")

				if var0:getTaskStatus() ~= 2 then
					arg0.data[var0.id] = var0
				else
					arg0.finishData[var0.id] = var0
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(iter1.id))
				Debugger.LogWarning("Missing Task Config, id :" .. tostring(iter1.id))
			end
		end

		getProxy(TechnologyProxy):updateBlueprintStates()
	end)
	arg0:on(20002, function(arg0)
		for iter0, iter1 in ipairs(arg0.info) do
			local var0 = arg0.data[iter1.id]

			if var0 ~= nil then
				local var1 = var0:isFinish()

				var0.progress = iter1.progress

				arg0:updateTask(var0)

				if not var1 then
					arg0:sendNotification(var0.TASK_PROGRESS_UPDATE, var0:clone())
				end
			end
		end

		arg0:sendNotification(GAME.TASK_PROGRESS_UPDATE)
	end)
	arg0:on(20003, function(arg0)
		for iter0, iter1 in ipairs(arg0.info) do
			local var0 = Task.New(iter1)

			arg0:addTask(var0)
		end
	end)
	arg0:on(20004, function(arg0)
		for iter0, iter1 in ipairs(arg0.id_list) do
			arg0:removeTaskById(iter1)
		end
	end)
	arg0:on(20015, function(arg0)
		local var0 = arg0.time

		arg0:sendNotification(GAME.ZERO_HOUR)
	end)

	arg0.taskTriggers = {}
	arg0.weekTaskProgressInfo = WeekTaskProgress.New()

	arg0:on(20101, function(arg0)
		arg0.weekTaskProgressInfo:Init(arg0.info)
		arg0:sendNotification(var0.WEEK_TASK_RESET)
	end)
	arg0:on(20102, function(arg0)
		for iter0, iter1 in ipairs(arg0.task) do
			print("update sub task ", iter1)

			local var0 = WeekPtTask.New(iter1)

			arg0.weekTaskProgressInfo:UpdateSubTask(var0)
			arg0:sendNotification(var0.WEEK_TASK_UPDATED, {
				id = var0.id
			})
		end
	end)
	arg0:on(20103, function(arg0)
		for iter0, iter1 in ipairs(arg0.id) do
			print("add sub task ", iter1)

			local var0 = WeekPtTask.New({
				progress = 0,
				id = iter1
			})

			arg0.weekTaskProgressInfo:AddSubTask(var0)
		end

		arg0:sendNotification(var0.WEEK_TASKS_ADDED)
	end)
	arg0:on(20104, function(arg0)
		for iter0, iter1 in ipairs(arg0.id) do
			print("remove sub task ", iter1)
			arg0.weekTaskProgressInfo:RemoveSubTask(iter1)
		end

		arg0:sendNotification(var0.WEEK_TASKS_DELETED)
	end)
	arg0:on(20105, function(arg0)
		local var0 = arg0.pt

		arg0.weekTaskProgressInfo:UpdateProgress(var0)
	end)

	arg0.submittingTask = {}
end

function var0.GetWeekTaskProgressInfo(arg0)
	return arg0.weekTaskProgressInfo
end

function var0.getTasksForBluePrint(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data or {}) do
		var0[iter1.id] = iter1
	end

	for iter2, iter3 in pairs(arg0.finishData) do
		var0[iter3.id] = iter3
	end

	return var0
end

function var0.addTmpTask(arg0, arg1)
	arg0.tmpInfo[arg1.id] = arg1
end

function var0.checkTmpTask(arg0, arg1)
	if arg0.tmpInfo[arg1] then
		arg0:addTask(arg0.tmpInfo[arg1])

		arg0.tmpInfo[arg1] = nil
	end
end

function var0.addTask(arg0, arg1)
	assert(isa(arg1, Task), "should be an instance of Task")

	if arg0.data[arg1.id] then
		arg0:addTmpTask(arg1)

		return
	end

	if arg1:getConfigTable() == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(arg1.id))
		Debugger.LogWarning("Missing Task Config, id :" .. tostring(arg1.id))

		return
	end

	arg0.data[arg1.id] = arg1:clone()

	arg0.data[arg1.id]:display("added")
	arg0.data[arg1.id]:onAdded()
	arg0.facade:sendNotification(var0.TASK_ADDED, arg1:clone())
	arg0:checkAutoSubmitTask(arg1)
end

function var0.updateTask(arg0, arg1)
	assert(isa(arg1, Task), "should be an instance of Task")

	local var0 = arg0.data[arg1.id]

	assert(var0 ~= nil, "task should exist")

	arg0.data[arg1.id] = arg1:clone()
	arg0.data[arg1.id].acceptTime = var0.acceptTime

	arg0.data[arg1.id]:display("updated")
	arg0.facade:sendNotification(var0.TASK_UPDATED, arg1:clone())
	arg0:checkAutoSubmitTask(arg1)
end

function var0.getTasks(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		table.insert(var0, iter1)
	end

	return Clone(var0)
end

function var0.getTaskById(arg0, arg1)
	if arg0.data[arg1] then
		return arg0.data[arg1]:clone()
	end
end

function var0.getFinishTaskById(arg0, arg1)
	if arg0.finishData[arg1] then
		return arg0.finishData[arg1]:clone()
	end
end

function var0.getTaskVO(arg0, arg1)
	return arg0:getTaskById(arg1) or arg0:getFinishTaskById(arg1)
end

function var0.getCanReceiveCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:ShowOnTaskScene() and iter1:isFinish() and iter1:isReceive() == false then
			var0 = var0 + 1

			local var1 = iter1:getConfig("award_display")

			for iter2, iter3 in ipairs(var1) do
				local var2, var3, var4 = unpack(iter3)

				if not LOCK_UR_SHIP and var2 == DROP_TYPE_VITEM and Item.getConfigData(var3).virtual_type == 20 then
					local var5 = pg.gameset.urpt_chapter_max.description[1]
					local var6 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var5) or 0
					local var7 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0

					if var6 + var4 - var7 > 0 then
						var0 = var0 - 1
					end
				end
			end
		end
	end

	local var8 = arg0:GetWeekTaskProgressInfo()

	if var8:CanUpgrade() then
		var0 = var0 + 1
	end

	return var0 + var8:GetCanSubmitSubTaskCnt()
end

function var0.getNotFinishCount(arg0, arg1)
	local var0 = arg1 or 3
	local var1 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:GetRealType() == var0 and iter1:isFinish() == false then
			var1 = var1 + 1
		end
	end

	return var1
end

function var0.removeTask(arg0, arg1)
	assert(isa(arg1, Task), "should be an instance of Task")
	arg0:removeTaskById(arg1.id)
end

function var0.removeTaskById(arg0, arg1)
	local var0 = arg0.data[arg1]

	if var0 == nil then
		return
	end

	arg0.finishData[arg1] = arg0.data[arg1]:clone()
	arg0.finishData[arg1].submitTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0.data[arg1] = nil

	arg0.facade:sendNotification(var0.TASK_REMOVED, var0)
	arg0:checkTmpTask(arg1)
end

function var0.getmingshiTaskID(arg0, arg1)
	local var0 = pg.task_data_trigger[mingshiTriggerId]

	if arg1 >= var0.count then
		local var1 = var0.task_id

		if var1 and not arg0:getTaskVO(var1) then
			return var1
		end
	end

	return 0
end

function var0.dealMingshiTouchFlag(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0 or var0:isEnd() then
		return
	end

	local var1 = var0:getConfig("config_id")
	local var2 = var0:getConfig("config_data")[1]

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = i18n("mingshi_task_tip_" .. arg1)
	})

	local var3 = arg0:getTaskById(var2)

	if var3 and var3:getTaskStatus() < 1 then
		if not arg0.mingshiTouchList then
			arg0.mingshiTouchList = {}
		end

		for iter0, iter1 in pairs(arg0.mingshiTouchList) do
			if iter1 == arg1 then
				return
			end
		end

		for iter2, iter3 in pairs(var0.data1_list) do
			if iter3 == arg1 then
				return
			end
		end

		table.insert(arg0.mingshiTouchList, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = mingshiActivityId,
			arg1 = arg1
		})
	end
end

function var0.mingshiTouchFlagEnabled(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0 or var0:isEnd() then
		return
	end

	local var1 = tonumber(var0:getConfig("config_id"))
	local var2 = tonumber(var0:getConfig("config_data")[1])
	local var3 = arg0:getTaskById(var2)

	if var3 and var3:getTaskStatus() < 1 then
		return true
	end

	if arg0:getTaskVO(var1) then
		return false
	end

	return true
end

function var0.getAcademyTask(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var1 = _.detect(var0, function(arg0)
		local var0 = arg0:getTaskShip()

		return var0 and var0.groupId == arg1
	end)

	if var1 and not var1:isEnd() then
		return getActivityTask(var1, true)
	end
end

function var0.isFinishPrevTasks(arg0, arg1)
	local var0 = Task.New({
		id = arg1
	}):getConfig("open_need")

	if var0 and type(var0) == "table" and #var0 > 0 then
		return _.all(var0, function(arg0)
			local var0 = arg0:getTaskById(arg0) or arg0:getFinishTaskById(arg0)

			return var0 and var0:isReceive()
		end)
	end

	return true
end

function var0.isReceiveTasks(arg0, arg1)
	return _.all(arg1, function(arg0)
		local var0 = arg0:getFinishTaskById(arg0)

		return var0 and var0:isReceive()
	end)
end

function var0.pushAutoSubmitTask(arg0)
	for iter0, iter1 in pairs(arg0.data) do
		arg0:checkAutoSubmitTask(iter1)
	end
end

function var0.checkAutoSubmitTask(arg0, arg1)
	if arg1:getConfig("auto_commit") == 1 and arg1:isFinish() then
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end
end

function var0.addSubmittingTask(arg0, arg1)
	arg0.submittingTask[arg1] = true
end

function var0.removeSubmittingTask(arg0, arg1)
	arg0.submittingTask[arg1] = nil
end

function var0.isSubmitting(arg0, arg1)
	return arg0.submittingTask[arg1]
end

function var0.triggerClientTasks(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:isClientTrigger() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetBackYardInterActionTaskList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:IsBackYardInterActionType() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetFlagShipInterActionTaskList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:IsFlagShipInterActionType() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

return var0
