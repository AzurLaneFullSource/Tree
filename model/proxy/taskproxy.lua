local var0_0 = class("TaskProxy", import(".NetProxy"))

var0_0.TASK_ADDED = "task added"
var0_0.TASK_UPDATED = "task updated"
var0_0.TASK_REMOVED = "task removed"
var0_0.TASK_FINISH = "task finish"
var0_0.TASK_PROGRESS_UPDATE = "task TASK_PROGRESS_UPDATE"
var0_0.WEEK_TASK_UPDATED = "week task updated"
var0_0.WEEK_TASKS_ADDED = "week tasks added"
var0_0.WEEK_TASKS_DELETED = "week task deleted"
var0_0.WEEK_TASK_RESET = "week task refresh"
mingshiTriggerId = 1
mingshiActivityId = 21
changdaoActivityId = 10006
changdaoTaskStartId = 5031

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.finishData = {}
	arg0_1.tmpInfo = {}

	arg0_1:on(20001, function(arg0_2)
		arg0_1:initTaskInfo(arg0_2.info)
		getProxy(TechnologyProxy):updateBlueprintStates()
	end)
	arg0_1:on(20002, function(arg0_3)
		arg0_1:updateProgress(arg0_3.info)
		arg0_1:sendNotification(GAME.TASK_PROGRESS_UPDATE)
	end)
	arg0_1:on(20003, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.info) do
			local var0_4 = Task.New(iter1_4)

			arg0_1:addTask(var0_4)
		end
	end)
	arg0_1:on(20004, function(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg0_5.id_list) do
			arg0_1:removeTaskById(iter1_5)
		end
	end)
	arg0_1:on(20015, function(arg0_6)
		local var0_6 = arg0_6.time

		arg0_1:sendNotification(GAME.ZERO_HOUR)
	end)

	arg0_1.taskTriggers = {}
	arg0_1.weekTaskProgressInfo = WeekTaskProgress.New()

	arg0_1:on(20101, function(arg0_7)
		arg0_1.weekTaskProgressInfo:Init(arg0_7.info)
		arg0_1:sendNotification(var0_0.WEEK_TASK_RESET)
	end)
	arg0_1:on(20102, function(arg0_8)
		for iter0_8, iter1_8 in ipairs(arg0_8.task) do
			print("update sub task ", iter1_8)

			local var0_8 = WeekPtTask.New(iter1_8)

			arg0_1.weekTaskProgressInfo:UpdateSubTask(var0_8)
			arg0_1:sendNotification(var0_0.WEEK_TASK_UPDATED, {
				id = var0_8.id
			})
		end
	end)
	arg0_1:on(20103, function(arg0_9)
		for iter0_9, iter1_9 in ipairs(arg0_9.id) do
			print("add sub task ", iter1_9)

			local var0_9 = WeekPtTask.New({
				progress = 0,
				id = iter1_9
			})

			arg0_1.weekTaskProgressInfo:AddSubTask(var0_9)
		end

		arg0_1:sendNotification(var0_0.WEEK_TASKS_ADDED)
	end)
	arg0_1:on(20104, function(arg0_10)
		for iter0_10, iter1_10 in ipairs(arg0_10.id) do
			print("remove sub task ", iter1_10)
			arg0_1.weekTaskProgressInfo:RemoveSubTask(iter1_10)
		end

		arg0_1:sendNotification(var0_0.WEEK_TASKS_DELETED)
	end)
	arg0_1:on(20105, function(arg0_11)
		local var0_11 = arg0_11.pt

		arg0_1.weekTaskProgressInfo:UpdateProgress(var0_11)
	end)

	arg0_1.submittingTask = {}
end

function var0_0.initTaskInfo(arg0_12, arg1_12, arg2_12)
	for iter0_12, iter1_12 in ipairs(arg1_12) do
		local var0_12 = Task.New(iter1_12)

		if var0_12:getConfigTable() ~= nil then
			var0_12:display("loaded")

			if var0_12:getTaskStatus() ~= 2 then
				arg0_12.data[var0_12.id] = var0_12
			else
				arg0_12.finishData[var0_12.id] = var0_12
			end

			var0_12:setActId(arg2_12)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(iter1_12.id))
			Debugger.LogWarning("Missing Task Config, id :" .. tostring(iter1_12.id))
		end
	end
end

function var0_0.updateProgress(arg0_13, arg1_13)
	for iter0_13, iter1_13 in ipairs(arg1_13) do
		local var0_13 = arg0_13.data[iter1_13.id]

		print("任务id" .. iter1_13.id .. "更新")

		if var0_13 ~= nil then
			local var1_13 = var0_13:isFinish()

			var0_13.progress = iter1_13.progress

			arg0_13:updateTask(var0_13)

			if not var1_13 then
				arg0_13:sendNotification(var0_0.TASK_PROGRESS_UPDATE, var0_13:clone())
			end
		end
	end
end

function var0_0.initActData(arg0_14, arg1_14, arg2_14)
	arg0_14:initTaskInfo(arg2_14, arg1_14)
end

function var0_0.updateActProgress(arg0_15, arg1_15, arg2_15)
	arg0_15:updateProgress(arg2_15)
end

function var0_0.addActData(arg0_16, arg1_16, arg2_16)
	for iter0_16, iter1_16 in ipairs(arg2_16) do
		local var0_16 = Task.New(iter1_16)

		var0_16:setActId(arg1_16)
		arg0_16:addTask(var0_16)
	end
end

function var0_0.removeActData(arg0_17, arg1_17, arg2_17)
	for iter0_17, iter1_17 in ipairs(arg2_17) do
		arg0_17:removeTaskById(iter1_17.id)
	end
end

function var0_0.clearTimeOut(arg0_18)
	if not arg0_18.datas or #arg0_18.datas == 0 then
		return
	end

	local var0_18 = false
	local var1_18 = {}

	for iter0_18 = #arg0_18.datas, 1, -1 do
		local var2_18 = arg0_18.datas[iter0_18]

		if var2_18:isActivityTask() then
			local var3_18 = var2_18:getActId()
			local var4_18 = getProxy(ActivityProxy):getActivityById(var3_18)

			if not var4_18 or var4_18:isEnd() then
				table.insert(var1_18, var2_18)

				local var5_18 = true
			end
		end
	end

	for iter1_18 = 1, #var1_18 do
		arg0_18:removeTask(var1_18[iter1_18])
	end
end

function var0_0.GetWeekTaskProgressInfo(arg0_19)
	return arg0_19.weekTaskProgressInfo
end

function var0_0.getTasksForBluePrint(arg0_20)
	local var0_20 = {}

	for iter0_20, iter1_20 in pairs(arg0_20.data or {}) do
		var0_20[iter1_20.id] = iter1_20
	end

	for iter2_20, iter3_20 in pairs(arg0_20.finishData) do
		var0_20[iter3_20.id] = iter3_20
	end

	return var0_20
end

function var0_0.addTmpTask(arg0_21, arg1_21)
	arg0_21.tmpInfo[arg1_21.id] = arg1_21
end

function var0_0.checkTmpTask(arg0_22, arg1_22)
	if arg0_22.tmpInfo[arg1_22] then
		arg0_22:addTask(arg0_22.tmpInfo[arg1_22])

		arg0_22.tmpInfo[arg1_22] = nil
	end
end

function var0_0.addTask(arg0_23, arg1_23)
	assert(isa(arg1_23, Task), "should be an instance of Task")

	if arg0_23.data[arg1_23.id] then
		arg0_23:addTmpTask(arg1_23)

		return
	end

	if arg1_23:getConfigTable() == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(arg1_23.id))
		Debugger.LogWarning("Missing Task Config, id :" .. tostring(arg1_23.id))

		return
	end

	arg0_23.data[arg1_23.id] = arg1_23:clone()

	arg0_23.data[arg1_23.id]:display("added")
	arg0_23.data[arg1_23.id]:onAdded()
	arg0_23.facade:sendNotification(var0_0.TASK_ADDED, arg1_23:clone())
	arg0_23:checkAutoSubmitTask(arg1_23)
end

function var0_0.updateTask(arg0_24, arg1_24)
	assert(isa(arg1_24, Task), "should be an instance of Task")

	local var0_24 = arg0_24.data[arg1_24.id]

	assert(var0_24 ~= nil, "task should exist")

	arg0_24.data[arg1_24.id] = arg1_24:clone()
	arg0_24.data[arg1_24.id].acceptTime = var0_24.acceptTime

	arg0_24.data[arg1_24.id]:display("updated")
	arg0_24.facade:sendNotification(var0_0.TASK_UPDATED, arg1_24:clone())
	arg0_24:checkAutoSubmitTask(arg1_24)
end

function var0_0.getTasks(arg0_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25.data) do
		table.insert(var0_25, iter1_25)
	end

	return Clone(var0_25)
end

function var0_0.getTaskById(arg0_26, arg1_26)
	if arg0_26.data[arg1_26] then
		return arg0_26.data[arg1_26]:clone()
	end
end

function var0_0.getFinishTaskById(arg0_27, arg1_27)
	if arg0_27.finishData[arg1_27] then
		return arg0_27.finishData[arg1_27]:clone()
	end
end

function var0_0.getTaskVO(arg0_28, arg1_28)
	return arg0_28:getTaskById(arg1_28) or arg0_28:getFinishTaskById(arg1_28)
end

function var0_0.getCanReceiveCount(arg0_29)
	local var0_29 = 0

	for iter0_29, iter1_29 in pairs(arg0_29.data) do
		if iter1_29:ShowOnTaskScene() and iter1_29:isFinish() and iter1_29:isReceive() == false then
			var0_29 = var0_29 + 1

			local var1_29 = iter1_29:getConfig("award_display")

			for iter2_29, iter3_29 in ipairs(var1_29) do
				local var2_29, var3_29, var4_29 = unpack(iter3_29)

				if not LOCK_UR_SHIP and var2_29 == DROP_TYPE_VITEM and Item.getConfigData(var3_29).virtual_type == 20 then
					local var5_29 = pg.gameset.urpt_chapter_max.description[1]
					local var6_29 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var5_29) or 0
					local var7_29 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0

					if var6_29 + var4_29 - var7_29 > 0 then
						var0_29 = var0_29 - 1
					end
				end
			end
		end
	end

	local var8_29 = arg0_29:GetWeekTaskProgressInfo()

	if var8_29:CanUpgrade() then
		var0_29 = var0_29 + 1
	end

	return var0_29 + var8_29:GetCanSubmitSubTaskCnt()
end

function var0_0.getNotFinishCount(arg0_30, arg1_30)
	local var0_30 = arg1_30 or 3
	local var1_30 = 0

	for iter0_30, iter1_30 in pairs(arg0_30.data) do
		if iter1_30:GetRealType() == var0_30 and iter1_30:isFinish() == false then
			var1_30 = var1_30 + 1
		end
	end

	return var1_30
end

function var0_0.removeTask(arg0_31, arg1_31)
	assert(isa(arg1_31, Task), "should be an instance of Task")
	arg0_31:removeTaskById(arg1_31.id)
end

function var0_0.removeTaskById(arg0_32, arg1_32)
	local var0_32 = arg0_32.data[arg1_32]

	if var0_32 == nil then
		return
	end

	arg0_32.finishData[arg1_32] = arg0_32.data[arg1_32]:clone()
	arg0_32.finishData[arg1_32].submitTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0_32.data[arg1_32] = nil

	arg0_32.facade:sendNotification(var0_0.TASK_REMOVED, var0_32)
	arg0_32:checkTmpTask(arg1_32)
end

function var0_0.getmingshiTaskID(arg0_33, arg1_33)
	local var0_33 = pg.task_data_trigger[mingshiTriggerId]

	if arg1_33 >= var0_33.count then
		local var1_33 = var0_33.task_id

		if var1_33 and not arg0_33:getTaskVO(var1_33) then
			return var1_33
		end
	end

	return 0
end

function var0_0.dealMingshiTouchFlag(arg0_34, arg1_34)
	local var0_34 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0_34 or var0_34:isEnd() then
		return
	end

	local var1_34 = var0_34:getConfig("config_id")
	local var2_34 = var0_34:getConfig("config_data")[1]

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = i18n("mingshi_task_tip_" .. arg1_34)
	})

	local var3_34 = arg0_34:getTaskById(var2_34)

	if var3_34 and var3_34:getTaskStatus() < 1 then
		if not arg0_34.mingshiTouchList then
			arg0_34.mingshiTouchList = {}
		end

		for iter0_34, iter1_34 in pairs(arg0_34.mingshiTouchList) do
			if iter1_34 == arg1_34 then
				return
			end
		end

		for iter2_34, iter3_34 in pairs(var0_34.data1_list) do
			if iter3_34 == arg1_34 then
				return
			end
		end

		table.insert(arg0_34.mingshiTouchList, arg1_34)
		arg0_34:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = mingshiActivityId,
			arg1 = arg1_34
		})
	end
end

function var0_0.mingshiTouchFlagEnabled(arg0_35)
	local var0_35 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0_35 or var0_35:isEnd() then
		return
	end

	local var1_35 = tonumber(var0_35:getConfig("config_id"))
	local var2_35 = tonumber(var0_35:getConfig("config_data")[1])
	local var3_35 = arg0_35:getTaskById(var2_35)

	if var3_35 and var3_35:getTaskStatus() < 1 then
		return true
	end

	if arg0_35:getTaskVO(var1_35) then
		return false
	end

	return true
end

function var0_0.getAcademyTask(arg0_36, arg1_36)
	local var0_36 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var1_36 = _.detect(var0_36, function(arg0_37)
		local var0_37 = arg0_37:getTaskShip()

		return var0_37 and var0_37.groupId == arg1_36
	end)

	if var1_36 and not var1_36:isEnd() then
		return getActivityTask(var1_36, true)
	end
end

function var0_0.isFinishPrevTasks(arg0_38, arg1_38)
	local var0_38 = Task.New({
		id = arg1_38
	}):getConfig("open_need")

	if var0_38 and type(var0_38) == "table" and #var0_38 > 0 then
		return _.all(var0_38, function(arg0_39)
			local var0_39 = arg0_38:getTaskById(arg0_39) or arg0_38:getFinishTaskById(arg0_39)

			return var0_39 and var0_39:isReceive()
		end)
	end

	return true
end

function var0_0.isReceiveTasks(arg0_40, arg1_40)
	return _.all(arg1_40, function(arg0_41)
		local var0_41 = arg0_40:getFinishTaskById(arg0_41)

		return var0_41 and var0_41:isReceive()
	end)
end

function var0_0.pushAutoSubmitTask(arg0_42)
	for iter0_42, iter1_42 in pairs(arg0_42.data) do
		arg0_42:checkAutoSubmitTask(iter1_42)
	end
end

function var0_0.checkAutoSubmitTask(arg0_43, arg1_43)
	if arg1_43:getConfig("auto_commit") == 1 and arg1_43:isFinish() then
		arg0_43:sendNotification(GAME.SUBMIT_TASK, arg1_43.id)
	end
end

function var0_0.addSubmittingTask(arg0_44, arg1_44)
	arg0_44.submittingTask[arg1_44] = true
end

function var0_0.removeSubmittingTask(arg0_45, arg1_45)
	arg0_45.submittingTask[arg1_45] = nil
end

function var0_0.isSubmitting(arg0_46, arg1_46)
	return arg0_46.submittingTask[arg1_46]
end

function var0_0.triggerClientTasks(arg0_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in pairs(arg0_47.data) do
		if iter1_47:isClientTrigger() then
			table.insert(var0_47, iter1_47)
		end
	end

	return var0_47
end

function var0_0.GetBackYardInterActionTaskList(arg0_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.data) do
		if iter1_48:IsBackYardInterActionType() then
			table.insert(var0_48, iter1_48)
		end
	end

	return var0_48
end

function var0_0.GetFlagShipInterActionTaskList(arg0_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in pairs(arg0_49.data) do
		if iter1_49:IsFlagShipInterActionType() then
			table.insert(var0_49, iter1_49)
		end
	end

	return var0_49
end

return var0_0
