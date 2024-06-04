local var0 = class("ActivityTask", import(".Task"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.actId = arg1
	arg0.id = arg2.id
	arg0.configId = arg0.id
	arg0.progress = arg2.progress or 0
	arg0.acceptTime = arg2.accept_time or 0
	arg0.submitTime = arg2.submit_time or 0
	arg0._isOver = false

	arg0:initConfig()
end

function var0.isFinish(arg0)
	return arg0:getProgress() >= arg0:getConfig("target_num")
end

function var0.setOver(arg0)
	arg0._isOver = true
	arg0.progress = arg0:getConfig("target_num")
end

function var0.isOver(arg0)
	return arg0._isOver
end

function var0.isActivitySubmit(arg0)
	if arg0.type == 16 and arg0.subType == 1006 then
		return true
	elseif arg0.type == 6 and arg0.subType == 1006 then
		return true
	end

	return false
end

function var0.getProgress(arg0)
	local var0

	if arg0:isActivitySubmit() then
		local var1 = tonumber(arg0:getConfig("target_id"))
		local var2 = tonumber(arg0:getConfig("target_id_2"))
		local var3 = pg.activity_drop_type[var1].activity_id
		local var4 = getProxy(ActivityProxy):getActivityById(var3)

		if var4 then
			var0 = var4:getVitemNumber(var2)
		else
			warning("找不到活动数据中物品得的数量")

			var0 = 0
		end
	elseif arg0.type == 6 and arg0.subType == TASK_SUB_TYPE_PT then
		local var5 = tonumber(arg0:getConfig("target_id_2"))
		local var6 = getProxy(ActivityProxy):getActivityById(var5)

		if var6 then
			var0 = var6.data1 or 0
		else
			warning("找不到活动数据中物品得的数量")

			var0 = 0
		end
	else
		var0 = arg0.progress

		if var0 > arg0:getConfig("target_num") then
			var0 = arg0:getConfig("target_num")
		end
	end

	return var0 or 0
end

function var0.getTarget(arg0)
	return arg0.target
end

function var0.isReceive(arg0)
	return false
end

function var0.isSubmit(arg0)
	if arg0.subType == 1006 then
		return true
	end

	return false
end

function var0.getTaskStatus(arg0)
	if arg0.progress >= arg0:getConfig("target_num") then
		return 1
	end

	return 0
end

function var0.onAdded(arg0)
	return
end

function var0.updateProgress(arg0, arg1)
	arg0.progress = arg1
end

function var0.isSelectable(arg0)
	return false
end

function var0.judgeOverflow(arg0, arg1, arg2, arg3)
	return false, false
end

function var0.IsUrTask(arg0)
	return false
end

function var0.GetRealType(arg0)
	return 6
end

function var0.isNew(arg0)
	if arg0:isFinish() or arg0:isOver() or arg0:isCircle() then
		return false
	end

	if arg0.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA then
		if arg0.groupIndex ~= 1 and PlayerPrefs.GetInt("ryza_task_" .. getProxy(PlayerProxy):getRawData().id .. "_" .. arg0.id) ~= 1 then
			return true
		end

		return false
	end

	return false
end

function var0.changeNew(arg0)
	if arg0.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA and arg0.groupIndex ~= 1 and PlayerPrefs.GetInt("ryza_task_" .. getProxy(PlayerProxy):getRawData().id .. "_" .. arg0.id) ~= 1 then
		PlayerPrefs.SetInt("ryza_task_" .. getProxy(PlayerProxy):getRawData().id .. "_" .. arg0.id, 1)
	end
end

function var0.isCircle(arg0)
	if arg0.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA then
		if arg0.type == 16 and arg0.subType == 1006 then
			return true
		elseif arg0:isRepeated() then
			return true
		end
	end

	return false
end

function var0.isRepeated(arg0)
	if arg0.type == 16 and arg0.subType == 20 then
		return true
	end

	return false
end

function var0.isDaily(arg0)
	return arg0.subType == 415 or arg0.subType == 412
end

function var0.IsOverflowShipExpItem(arg0)
	return false
end

function var0.ShowOnTaskScene(arg0)
	return false
end

function var0.getConfig(arg0, arg1)
	return arg0.configData[arg1]
end

function var0.isAvatarTask(arg0)
	return false
end

function var0.initConfig(arg0)
	arg0.actConfig = pg.activity_template[arg0.actId]

	local var0 = Activity.Create({
		id = arg0.actId
	})

	arg0.actType = arg0.actConfig.type
	arg0.groups = var0:GetTaskIdsByDay()

	for iter0 = 1, #arg0.groups do
		if table.contains(arg0.groups[iter0], arg0.id) then
			arg0.groupIndex = iter0
		end
	end

	arg0.configData = pg.task_data_template[arg0.id]
	arg0.target = arg0.configData.target_num
	arg0.type = arg0.configData.type
	arg0.subType = arg0.configData.sub_type
	arg0.targetId1 = arg0.configData.target_id
	arg0.targetId2 = arg0.configData.target_id_2
	arg0.autoCommit = arg0.configData.auto_commit == 1

	if arg0.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA then
		-- block empty
	end
end

return var0
