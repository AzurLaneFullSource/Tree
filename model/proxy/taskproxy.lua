local var0_0 = class("TaskProxy", import(".NetProxy"))

var0_0.TASK_ADDED = "task added"
var0_0.TASK_UPDATED = "task updated"
var0_0.TASK_REMOVED = "task removed"
var0_0.TASK_DELETE = "task deleted"
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
	end)
	arg0_1:on(20003, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.info) do
			local var0_4 = Task.New(iter1_4)

			arg0_1:addTask(var0_4)
		end
	end)
	arg0_1:on(20004, function(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg0_5.id_list) do
			arg0_1:deleteTaskById(iter1_5)
		end
	end)
	arg0_1:on(20015, function(arg0_6)
		pg.proxyRegister.dayProto = true
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

function var0_0.timeCall(arg0_12)
	return {
		[ProxyRegister.DayCall] = function(arg0_13)
			arg0_12:sendNotification(GAME.ACCEPT_ACTIVITY_TASK)
			arg0_12:sendNotification(GAME.ZERO_HOUR_OP_DONE)
		end
	}
end

function var0_0.initTaskInfo(arg0_14, arg1_14, arg2_14, arg3_14)
	for iter0_14, iter1_14 in ipairs(arg1_14) do
		local var0_14 = Task.New(iter1_14)

		if var0_14:getConfigTable() ~= nil then
			var0_14:display("loaded")

			if var0_14:getTaskStatus() ~= 2 then
				arg0_14.data[var0_14.id] = var0_14
			else
				arg0_14.finishData[var0_14.id] = var0_14
			end

			var0_14:setActId(arg2_14)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(iter1_14.id))
			Debugger.LogWarning("Missing Task Config, id :" .. tostring(iter1_14.id))
		end
	end

	if arg3_14 and #arg3_14 > 0 then
		for iter2_14, iter3_14 in ipairs(arg3_14) do
			local var1_14 = Task.New({
				id = iter3_14
			})

			if var1_14:getConfigTable() ~= nil then
				var1_14:display("loaded")

				arg0_14.finishData[var1_14.id] = var1_14

				var1_14:setActId(arg2_14)
				var1_14:setTaskFinish()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(iter3_14.id))
				Debugger.LogWarning("Missing Task Config, id :" .. tostring(iter3_14.id))
			end
		end
	end
end

function var0_0.updateProgress(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg1_15) do
		local var0_15 = arg0_15.data[iter1_15.id]

		if var0_15 ~= nil then
			local var1_15 = var0_15:isFinish()

			var0_15.progress = iter1_15.progress

			arg0_15:updateTask(var0_15)

			if not var1_15 then
				arg0_15:sendNotification(var0_0.TASK_PROGRESS_UPDATE, var0_15:clone())
			end
		end
	end
end

function var0_0.initActData(arg0_16, arg1_16, arg2_16, arg3_16)
	arg0_16:initTaskInfo(arg2_16, arg1_16, arg3_16)
end

function var0_0.updateActProgress(arg0_17, arg1_17, arg2_17)
	arg0_17:updateProgress(arg2_17)
end

function var0_0.addActData(arg0_18, arg1_18, arg2_18)
	for iter0_18, iter1_18 in ipairs(arg2_18) do
		local var0_18 = Task.New(iter1_18)

		var0_18:setActId(arg1_18)
		arg0_18:addTask(var0_18)
	end
end

function var0_0.removeActData(arg0_19, arg1_19, arg2_19)
	for iter0_19, iter1_19 in ipairs(arg2_19) do
		arg0_19:deleteTaskById(iter1_19.id)
	end
end

function var0_0.clearTimeOut(arg0_20)
	if not arg0_20.datas or #arg0_20.datas == 0 then
		return
	end

	local var0_20 = false
	local var1_20 = {}

	for iter0_20 = #arg0_20.datas, 1, -1 do
		local var2_20 = arg0_20.datas[iter0_20]

		if var2_20:isActivityTask() then
			local var3_20 = var2_20:getActId()
			local var4_20 = getProxy(ActivityProxy):getActivityById(var3_20)

			if not var4_20 or var4_20:isEnd() then
				table.insert(var1_20, var2_20)

				local var5_20 = true
			end
		end
	end

	for iter1_20 = 1, #var1_20 do
		arg0_20:deleteTask(var1_20[iter1_20])
	end
end

function var0_0.GetWeekTaskProgressInfo(arg0_21)
	return arg0_21.weekTaskProgressInfo
end

function var0_0.getTasksForBluePrint(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in pairs(arg0_22.data or {}) do
		var0_22[iter1_22.id] = iter1_22
	end

	for iter2_22, iter3_22 in pairs(arg0_22.finishData) do
		var0_22[iter3_22.id] = iter3_22
	end

	return var0_22
end

function var0_0.addTmpTask(arg0_23, arg1_23)
	arg0_23.tmpInfo[arg1_23.id] = arg1_23
end

function var0_0.checkTmpTask(arg0_24, arg1_24)
	if arg0_24.tmpInfo[arg1_24] then
		arg0_24:addTask(arg0_24.tmpInfo[arg1_24])

		arg0_24.tmpInfo[arg1_24] = nil
	end
end

function var0_0.addTask(arg0_25, arg1_25)
	assert(isa(arg1_25, Task), "should be an instance of Task")

	if arg0_25.data[arg1_25.id] then
		arg0_25:addTmpTask(arg1_25)

		return
	end

	if arg1_25:getConfigTable() == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_notfound_error") .. tostring(arg1_25.id))
		Debugger.LogWarning("Missing Task Config, id :" .. tostring(arg1_25.id))

		return
	end

	arg0_25.data[arg1_25.id] = arg1_25:clone()

	arg0_25.data[arg1_25.id]:display("added")
	arg0_25.data[arg1_25.id]:onAdded()
	arg0_25.facade:sendNotification(var0_0.TASK_ADDED, arg1_25:clone())
	arg0_25:checkAutoSubmitTask(arg0_25.data[arg1_25.id])
end

function var0_0.updateTask(arg0_26, arg1_26)
	assert(isa(arg1_26, Task), "should be an instance of Task")

	local var0_26 = arg0_26.data[arg1_26.id]

	assert(var0_26 ~= nil, "task should exist")

	arg0_26.data[arg1_26.id] = arg1_26:clone()
	arg0_26.data[arg1_26.id].acceptTime = var0_26.acceptTime

	arg0_26.data[arg1_26.id]:display("updated")
	arg0_26.facade:sendNotification(var0_0.TASK_UPDATED, arg1_26:clone())
	arg0_26:checkAutoSubmitTask(arg0_26.data[arg1_26.id])
end

function var0_0.getTasks(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(arg0_27.data) do
		table.insert(var0_27, iter1_27)
	end

	return Clone(var0_27)
end

function var0_0.getFinishTasks(arg0_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in pairs(arg0_28.finishData) do
		table.insert(var0_28, iter1_28)
	end

	return Clone(var0_28)
end

function var0_0.getTaskById(arg0_29, arg1_29)
	if arg0_29.data[arg1_29] then
		return arg0_29.data[arg1_29]:clone()
	end
end

function var0_0.getFinishTaskById(arg0_30, arg1_30)
	if arg0_30.finishData[arg1_30] then
		return arg0_30.finishData[arg1_30]:clone()
	end
end

function var0_0.removeFinishTaskById(arg0_31, arg1_31)
	if arg0_31.finishData[arg1_31] then
		arg0_31.finishData[arg1_31] = nil
	end
end

function var0_0.getTaskVO(arg0_32, arg1_32)
	return arg0_32:getTaskById(arg1_32) or arg0_32:getFinishTaskById(arg1_32)
end

function var0_0.getCanReceiveCount(arg0_33)
	local var0_33 = 0

	for iter0_33, iter1_33 in pairs(arg0_33.data) do
		if iter1_33:ShowOnTaskScene() and iter1_33:isFinish() and iter1_33:isReceive() == false then
			var0_33 = var0_33 + 1

			local var1_33 = iter1_33:getConfig("award_display")

			for iter2_33, iter3_33 in ipairs(var1_33) do
				local var2_33, var3_33, var4_33 = unpack(iter3_33)

				if not LOCK_UR_SHIP and var2_33 == DROP_TYPE_VITEM and Item.getConfigData(var3_33).virtual_type == 20 then
					local var5_33 = pg.gameset.urpt_chapter_max.description[1]
					local var6_33 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var5_33) or 0
					local var7_33 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0

					if var6_33 + var4_33 - var7_33 > 0 then
						var0_33 = var0_33 - 1
					end
				end
			end
		end
	end

	local var8_33 = arg0_33:GetWeekTaskProgressInfo()

	if var8_33:CanUpgrade() then
		var0_33 = var0_33 + 1
	end

	return var0_33 + var8_33:GetCanSubmitSubTaskCnt()
end

function var0_0.getNotFinishCount(arg0_34, arg1_34)
	local var0_34 = arg1_34 or 3
	local var1_34 = 0

	for iter0_34, iter1_34 in pairs(arg0_34.data) do
		if iter1_34:GetRealType() == var0_34 and iter1_34:isFinish() == false then
			var1_34 = var1_34 + 1
		end
	end

	return var1_34
end

function var0_0.removeTask(arg0_35, arg1_35)
	assert(isa(arg1_35, Task), "should be an instance of Task")
	arg0_35:removeTaskById(arg1_35.id)
end

function var0_0.removeTaskById(arg0_36, arg1_36)
	local var0_36 = arg0_36.data[arg1_36]

	if var0_36 == nil then
		return
	end

	if var0_36:isCircle() then
		return
	end

	arg0_36.finishData[arg1_36] = arg0_36.data[arg1_36]:clone()
	arg0_36.finishData[arg1_36].submitTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0_36.data[arg1_36] = nil

	arg0_36:sendNotification(var0_0.TASK_REMOVED, var0_36)
	arg0_36:checkTmpTask(arg1_36)
end

function var0_0.deleteTask(arg0_37, arg1_37)
	assert(isa(arg1_37, Task), "should be an instance of Task")
	arg0_37:deleteTaskById(arg1_37.id)
end

function var0_0.deleteTaskById(arg0_38, arg1_38)
	if arg0_38.submittingTask[arg1_38] then
		print("正在提交的任务不予删除，id:" .. arg1_38)

		return
	end

	local var0_38 = arg0_38.data[arg1_38] or arg0_38.finishData[arg1_38]

	arg0_38.data[arg1_38] = nil
	arg0_38.finishData[arg1_38] = nil

	if tobool(var0_38) then
		arg0_38:sendNotification(var0_0.TASK_DELETE, var0_38)
	end
end

function var0_0.getmingshiTaskID(arg0_39, arg1_39)
	local var0_39 = pg.task_data_trigger[mingshiTriggerId]

	if arg1_39 >= var0_39.count then
		local var1_39 = var0_39.task_id

		if var1_39 and not arg0_39:getTaskVO(var1_39) then
			return var1_39
		end
	end

	return 0
end

function var0_0.dealMingshiTouchFlag(arg0_40, arg1_40)
	local var0_40 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0_40 or var0_40:isEnd() then
		return
	end

	local var1_40 = var0_40:getConfig("config_id")
	local var2_40 = var0_40:getConfig("config_data")[1]

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = i18n("mingshi_task_tip_" .. arg1_40)
	})

	local var3_40 = arg0_40:getTaskById(var2_40)

	if var3_40 and var3_40:getTaskStatus() < 1 then
		if not arg0_40.mingshiTouchList then
			arg0_40.mingshiTouchList = {}
		end

		for iter0_40, iter1_40 in pairs(arg0_40.mingshiTouchList) do
			if iter1_40 == arg1_40 then
				return
			end
		end

		for iter2_40, iter3_40 in pairs(var0_40.data1_list) do
			if iter3_40 == arg1_40 then
				return
			end
		end

		table.insert(arg0_40.mingshiTouchList, arg1_40)
		arg0_40:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = mingshiActivityId,
			arg1 = arg1_40
		})
	end
end

function var0_0.mingshiTouchFlagEnabled(arg0_41)
	local var0_41 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if not var0_41 or var0_41:isEnd() then
		return
	end

	local var1_41 = tonumber(var0_41:getConfig("config_id"))
	local var2_41 = tonumber(var0_41:getConfig("config_data")[1])
	local var3_41 = arg0_41:getTaskById(var2_41)

	if var3_41 and var3_41:getTaskStatus() < 1 then
		return true
	end

	if arg0_41:getTaskVO(var1_41) then
		return false
	end

	return true
end

function var0_0.getAcademyTask(arg0_42, arg1_42)
	local var0_42 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var1_42 = _.detect(var0_42, function(arg0_43)
		local var0_43 = arg0_43:getTaskShip()

		return var0_43 and var0_43.groupId == arg1_42
	end)

	if var1_42 and not var1_42:isEnd() then
		return getActivityTask(var1_42, true)
	end
end

function var0_0.isFinishPrevTasks(arg0_44, arg1_44)
	local var0_44 = Task.New({
		id = arg1_44
	}):getConfig("open_need")

	if var0_44 and type(var0_44) == "table" and #var0_44 > 0 then
		return _.all(var0_44, function(arg0_45)
			local var0_45 = arg0_44:getTaskById(arg0_45) or arg0_44:getFinishTaskById(arg0_45)

			return var0_45 and var0_45:isReceive()
		end)
	end

	return true
end

function var0_0.isReceiveTasks(arg0_46, arg1_46)
	return _.all(arg1_46, function(arg0_47)
		local var0_47 = arg0_46:getFinishTaskById(arg0_47)

		return var0_47 and var0_47:isReceive()
	end)
end

function var0_0.pushAutoSubmitTask(arg0_48)
	for iter0_48, iter1_48 in pairs(arg0_48.data) do
		arg0_48:checkAutoSubmitTask(iter1_48)
	end
end

function var0_0.checkAutoSubmitTask(arg0_49, arg1_49)
	if arg1_49:getConfig("auto_commit") == 1 and arg1_49:isFinish() and not arg1_49:getAutoSubmit() then
		arg1_49:setAutoSubmit(true)
		arg0_49:sendNotification(GAME.SUBMIT_TASK, arg1_49.id, function(arg0_50)
			if arg0_50 and arg1_49:IsCommanderManualType() then
				getProxy(CommanderManualProxy):TaskAutoSubmitCall(arg1_49.id)
			end
		end)
	end
end

function var0_0.addSubmittingTask(arg0_51, arg1_51)
	arg0_51.submittingTask[arg1_51] = true
end

function var0_0.removeSubmittingTask(arg0_52, arg1_52)
	arg0_52.submittingTask[arg1_52] = nil
end

function var0_0.isSubmitting(arg0_53, arg1_53)
	return arg0_53.submittingTask[arg1_53]
end

function var0_0.triggerClientTasks(arg0_54)
	local var0_54 = {}

	for iter0_54, iter1_54 in pairs(arg0_54.data) do
		if iter1_54:isClientTrigger() then
			table.insert(var0_54, iter1_54)
		end
	end

	return var0_54
end

function var0_0.GetBackYardInterActionTaskList(arg0_55)
	local var0_55 = {}

	for iter0_55, iter1_55 in pairs(arg0_55.data) do
		if iter1_55:IsBackYardInterActionType() then
			table.insert(var0_55, iter1_55)
		end
	end

	return var0_55
end

function var0_0.GetFlagShipInterActionTaskList(arg0_56)
	local var0_56 = {}

	for iter0_56, iter1_56 in pairs(arg0_56.data) do
		if iter1_56:IsFlagShipInterActionType() then
			table.insert(var0_56, iter1_56)
		end
	end

	return var0_56
end

return var0_0
