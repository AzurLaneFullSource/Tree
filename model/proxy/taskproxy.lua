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
	arg0_1:on(20001, function(arg0_2)
		arg0_1.data = {}
		arg0_1.finishData = {}
		arg0_1.tmpInfo = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.info) do
			local var0_2 = Task.New(iter1_2)

			if var0_2:getConfigTable() ~= nil then
				var0_2:display("loaded")

				if var0_2:getTaskStatus() ~= 2 then
					arg0_1.data[var0_2.id] = var0_2
				else
					arg0_1.finishData[var0_2.id] = var0_2
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(iter1_2.id))
				Debugger.LogWarning("Missing Task Config, id :" .. tostring(iter1_2.id))
			end
		end

		getProxy(TechnologyProxy):updateBlueprintStates()
	end)
	arg0_1:on(20002, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.info) do
			local var0_3 = arg0_1.data[iter1_3.id]

			if var0_3 ~= nil then
				local var1_3 = var0_3:isFinish()

				var0_3.progress = iter1_3.progress

				arg0_1:updateTask(var0_3)

				if not var1_3 then
					arg0_1:sendNotification(var0_0.TASK_PROGRESS_UPDATE, var0_3:clone())
				end
			end
		end

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

function var0_0.GetWeekTaskProgressInfo(arg0_12)
	return arg0_12.weekTaskProgressInfo
end

function var0_0.getTasksForBluePrint(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.data or {}) do
		var0_13[iter1_13.id] = iter1_13
	end

	for iter2_13, iter3_13 in pairs(arg0_13.finishData) do
		var0_13[iter3_13.id] = iter3_13
	end

	return var0_13
end

function var0_0.addTmpTask(arg0_14, arg1_14)
	arg0_14.tmpInfo[arg1_14.id] = arg1_14
end

function var0_0.checkTmpTask(arg0_15, arg1_15)
	if arg0_15.tmpInfo[arg1_15] then
		arg0_15:addTask(arg0_15.tmpInfo[arg1_15])

		arg0_15.tmpInfo[arg1_15] = nil
	end
end

function var0_0.addTask(arg0_16, arg1_16)
	assert(isa(arg1_16, Task), "should be an instance of Task")

	if arg0_16.data[arg1_16.id] then
		arg0_16:addTmpTask(arg1_16)

		return
	end

	if arg1_16:getConfigTable() == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(arg1_16.id))
		Debugger.LogWarning("Missing Task Config, id :" .. tostring(arg1_16.id))

		return
	end

	arg0_16.data[arg1_16.id] = arg1_16:clone()

	arg0_16.data[arg1_16.id]:display("added")
	arg0_16.data[arg1_16.id]:onAdded()
	arg0_16.facade:sendNotification(var0_0.TASK_ADDED, arg1_16:clone())
	arg0_16:checkAutoSubmitTask(arg1_16)
end

function var0_0.updateTask(arg0_17, arg1_17)
	assert(isa(arg1_17, Task), "should be an instance of Task")

	local var0_17 = arg0_17.data[arg1_17.id]

	assert(var0_17 ~= nil, "task should exist")

	arg0_17.data[arg1_17.id] = arg1_17:clone()
	arg0_17.data[arg1_17.id].acceptTime = var0_17.acceptTime

	arg0_17.data[arg1_17.id]:display("updated")
	arg0_17.facade:sendNotification(var0_0.TASK_UPDATED, arg1_17:clone())
	arg0_17:checkAutoSubmitTask(arg1_17)
end

function var0_0.getTasks(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.data) do
		table.insert(var0_18, iter1_18)
	end

	return Clone(var0_18)
end

function var0_0.getTaskById(arg0_19, arg1_19)
	if arg0_19.data[arg1_19] then
		return arg0_19.data[arg1_19]:clone()
	end
end

function var0_0.getFinishTaskById(arg0_20, arg1_20)
	if arg0_20.finishData[arg1_20] then
		return arg0_20.finishData[arg1_20]:clone()
	end
end

function var0_0.getTaskVO(arg0_21, arg1_21)
	return arg0_21:getTaskById(arg1_21) or arg0_21:getFinishTaskById(arg1_21)
end

function var0_0.getCanReceiveCount(arg0_22)
	local var0_22 = 0

	for iter0_22, iter1_22 in pairs(arg0_22.data) do
		if iter1_22:ShowOnTaskScene() and iter1_22:isFinish() and iter1_22:isReceive() == false then
			var0_22 = var0_22 + 1

			local var1_22 = iter1_22:getConfig("award_display")

			for iter2_22, iter3_22 in ipairs(var1_22) do
				local var2_22, var3_22, var4_22 = unpack(iter3_22)

				if not LOCK_UR_SHIP and var2_22 == DROP_TYPE_VITEM and Item.getConfigData(var3_22).virtual_type == 20 then
					local var5_22 = pg.gameset.urpt_chapter_max.description[1]
					local var6_22 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var5_22) or 0
					local var7_22 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0

					if var6_22 + var4_22 - var7_22 > 0 then
						var0_22 = var0_22 - 1
					end
				end
			end
		end
	end

	local var8_22 = arg0_22:GetWeekTaskProgressInfo()

	if var8_22:CanUpgrade() then
		var0_22 = var0_22 + 1
	end

	return var0_22 + var8_22:GetCanSubmitSubTaskCnt()
end

function var0_0.getNotFinishCount(arg0_23, arg1_23)
	local var0_23 = arg1_23 or 3
	local var1_23 = 0

	for iter0_23, iter1_23 in pairs(arg0_23.data) do
		if iter1_23:GetRealType() == var0_23 and iter1_23:isFinish() == false then
			var1_23 = var1_23 + 1
		end
	end

	return var1_23
end

function var0_0.removeTask(arg0_24, arg1_24)
	assert(isa(arg1_24, Task), "should be an instance of Task")
	arg0_24:removeTaskById(arg1_24.id)
end

function var0_0.removeTaskById(arg0_25, arg1_25)
	local var0_25 = arg0_25.data[arg1_25]

	if var0_25 == nil then
		return
	end

	arg0_25.finishData[arg1_25] = arg0_25.data[arg1_25]:clone()
	arg0_25.finishData[arg1_25].submitTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0_25.data[arg1_25] = nil

	arg0_25.facade:sendNotification(var0_0.TASK_REMOVED, var0_25)
	arg0_25:checkTmpTask(arg1_25)
end

function var0_0.getmingshiTaskID(arg0_26, arg1_26)
	local var0_26 = pg.task_data_trigger[mingshiTriggerId]

	if arg1_26 >= var0_26.count then
		local var1_26 = var0_26.task_id

		if var1_26 and not arg0_26:getTaskVO(var1_26) then
			return var1_26
		end
	end

	return 0
end

function var0_0.dealMingshiTouchFlag(arg0_27, arg1_27)
	local var0_27 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0_27 or var0_27:isEnd() then
		return
	end

	local var1_27 = var0_27:getConfig("config_id")
	local var2_27 = var0_27:getConfig("config_data")[1]

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = i18n("mingshi_task_tip_" .. arg1_27)
	})

	local var3_27 = arg0_27:getTaskById(var2_27)

	if var3_27 and var3_27:getTaskStatus() < 1 then
		if not arg0_27.mingshiTouchList then
			arg0_27.mingshiTouchList = {}
		end

		for iter0_27, iter1_27 in pairs(arg0_27.mingshiTouchList) do
			if iter1_27 == arg1_27 then
				return
			end
		end

		for iter2_27, iter3_27 in pairs(var0_27.data1_list) do
			if iter3_27 == arg1_27 then
				return
			end
		end

		table.insert(arg0_27.mingshiTouchList, arg1_27)
		arg0_27:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = mingshiActivityId,
			arg1 = arg1_27
		})
	end
end

function var0_0.mingshiTouchFlagEnabled(arg0_28)
	local var0_28 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0_28 or var0_28:isEnd() then
		return
	end

	local var1_28 = tonumber(var0_28:getConfig("config_id"))
	local var2_28 = tonumber(var0_28:getConfig("config_data")[1])
	local var3_28 = arg0_28:getTaskById(var2_28)

	if var3_28 and var3_28:getTaskStatus() < 1 then
		return true
	end

	if arg0_28:getTaskVO(var1_28) then
		return false
	end

	return true
end

function var0_0.getAcademyTask(arg0_29, arg1_29)
	local var0_29 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var1_29 = _.detect(var0_29, function(arg0_30)
		local var0_30 = arg0_30:getTaskShip()

		return var0_30 and var0_30.groupId == arg1_29
	end)

	if var1_29 and not var1_29:isEnd() then
		return getActivityTask(var1_29, true)
	end
end

function var0_0.isFinishPrevTasks(arg0_31, arg1_31)
	local var0_31 = Task.New({
		id = arg1_31
	}):getConfig("open_need")

	if var0_31 and type(var0_31) == "table" and #var0_31 > 0 then
		return _.all(var0_31, function(arg0_32)
			local var0_32 = arg0_31:getTaskById(arg0_32) or arg0_31:getFinishTaskById(arg0_32)

			return var0_32 and var0_32:isReceive()
		end)
	end

	return true
end

function var0_0.isReceiveTasks(arg0_33, arg1_33)
	return _.all(arg1_33, function(arg0_34)
		local var0_34 = arg0_33:getFinishTaskById(arg0_34)

		return var0_34 and var0_34:isReceive()
	end)
end

function var0_0.pushAutoSubmitTask(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		arg0_35:checkAutoSubmitTask(iter1_35)
	end
end

function var0_0.checkAutoSubmitTask(arg0_36, arg1_36)
	if arg1_36:getConfig("auto_commit") == 1 and arg1_36:isFinish() then
		arg0_36:sendNotification(GAME.SUBMIT_TASK, arg1_36.id)
	end
end

function var0_0.addSubmittingTask(arg0_37, arg1_37)
	arg0_37.submittingTask[arg1_37] = true
end

function var0_0.removeSubmittingTask(arg0_38, arg1_38)
	arg0_38.submittingTask[arg1_38] = nil
end

function var0_0.isSubmitting(arg0_39, arg1_39)
	return arg0_39.submittingTask[arg1_39]
end

function var0_0.triggerClientTasks(arg0_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(arg0_40.data) do
		if iter1_40:isClientTrigger() then
			table.insert(var0_40, iter1_40)
		end
	end

	return var0_40
end

function var0_0.GetBackYardInterActionTaskList(arg0_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in pairs(arg0_41.data) do
		if iter1_41:IsBackYardInterActionType() then
			table.insert(var0_41, iter1_41)
		end
	end

	return var0_41
end

function var0_0.GetFlagShipInterActionTaskList(arg0_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in pairs(arg0_42.data) do
		if iter1_42:IsFlagShipInterActionType() then
			table.insert(var0_42, iter1_42)
		end
	end

	return var0_42
end

return var0_0
