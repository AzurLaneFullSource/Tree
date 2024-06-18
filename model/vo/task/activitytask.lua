local var0_0 = class("ActivityTask", import(".Task"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.actId = arg1_1
	arg0_1.id = arg2_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.progress = arg2_1.progress or 0
	arg0_1.acceptTime = arg2_1.accept_time or 0
	arg0_1.submitTime = arg2_1.submit_time or 0
	arg0_1._isOver = false

	arg0_1:initConfig()
end

function var0_0.isFinish(arg0_2)
	return arg0_2:getProgress() >= arg0_2:getConfig("target_num")
end

function var0_0.setOver(arg0_3)
	arg0_3._isOver = true
	arg0_3.progress = arg0_3:getConfig("target_num")
end

function var0_0.isOver(arg0_4)
	return arg0_4._isOver
end

function var0_0.isActivitySubmit(arg0_5)
	if arg0_5.type == 16 and arg0_5.subType == 1006 then
		return true
	elseif arg0_5.type == 6 and arg0_5.subType == 1006 then
		return true
	end

	return false
end

function var0_0.getProgress(arg0_6)
	local var0_6

	if arg0_6:isActivitySubmit() then
		local var1_6 = tonumber(arg0_6:getConfig("target_id"))
		local var2_6 = tonumber(arg0_6:getConfig("target_id_2"))
		local var3_6 = pg.activity_drop_type[var1_6].activity_id
		local var4_6 = getProxy(ActivityProxy):getActivityById(var3_6)

		if var4_6 then
			var0_6 = var4_6:getVitemNumber(var2_6)
		else
			warning("找不到活动数据中物品得的数量")

			var0_6 = 0
		end
	elseif arg0_6.type == 6 and arg0_6.subType == TASK_SUB_TYPE_PT then
		local var5_6 = tonumber(arg0_6:getConfig("target_id_2"))
		local var6_6 = getProxy(ActivityProxy):getActivityById(var5_6)

		if var6_6 then
			var0_6 = var6_6.data1 or 0
		else
			warning("找不到活动数据中物品得的数量")

			var0_6 = 0
		end
	else
		var0_6 = arg0_6.progress

		if var0_6 > arg0_6:getConfig("target_num") then
			var0_6 = arg0_6:getConfig("target_num")
		end
	end

	return var0_6 or 0
end

function var0_0.getTarget(arg0_7)
	return arg0_7.target
end

function var0_0.isReceive(arg0_8)
	return false
end

function var0_0.isSubmit(arg0_9)
	if arg0_9.subType == 1006 then
		return true
	end

	return false
end

function var0_0.getTaskStatus(arg0_10)
	if arg0_10.progress >= arg0_10:getConfig("target_num") then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_11)
	return
end

function var0_0.updateProgress(arg0_12, arg1_12)
	arg0_12.progress = arg1_12
end

function var0_0.isSelectable(arg0_13)
	return false
end

function var0_0.judgeOverflow(arg0_14, arg1_14, arg2_14, arg3_14)
	return false, false
end

function var0_0.IsUrTask(arg0_15)
	return false
end

function var0_0.GetRealType(arg0_16)
	return 6
end

function var0_0.isNew(arg0_17)
	if arg0_17:isFinish() or arg0_17:isOver() or arg0_17:isCircle() then
		return false
	end

	if arg0_17.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA then
		if arg0_17.groupIndex ~= 1 and PlayerPrefs.GetInt("ryza_task_" .. getProxy(PlayerProxy):getRawData().id .. "_" .. arg0_17.id) ~= 1 then
			return true
		end

		return false
	end

	return false
end

function var0_0.changeNew(arg0_18)
	if arg0_18.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA and arg0_18.groupIndex ~= 1 and PlayerPrefs.GetInt("ryza_task_" .. getProxy(PlayerProxy):getRawData().id .. "_" .. arg0_18.id) ~= 1 then
		PlayerPrefs.SetInt("ryza_task_" .. getProxy(PlayerProxy):getRawData().id .. "_" .. arg0_18.id, 1)
	end
end

function var0_0.isCircle(arg0_19)
	if arg0_19.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA then
		if arg0_19.type == 16 and arg0_19.subType == 1006 then
			return true
		elseif arg0_19:isRepeated() then
			return true
		end
	end

	return false
end

function var0_0.isRepeated(arg0_20)
	if arg0_20.type == 16 and arg0_20.subType == 20 then
		return true
	end

	return false
end

function var0_0.isDaily(arg0_21)
	return arg0_21.subType == 415 or arg0_21.subType == 412
end

function var0_0.IsOverflowShipExpItem(arg0_22)
	return false
end

function var0_0.ShowOnTaskScene(arg0_23)
	return false
end

function var0_0.getConfig(arg0_24, arg1_24)
	return arg0_24.configData[arg1_24]
end

function var0_0.isAvatarTask(arg0_25)
	return false
end

function var0_0.initConfig(arg0_26)
	arg0_26.actConfig = pg.activity_template[arg0_26.actId]

	local var0_26 = Activity.Create({
		id = arg0_26.actId
	})

	arg0_26.actType = arg0_26.actConfig.type
	arg0_26.groups = var0_26:GetTaskIdsByDay()

	for iter0_26 = 1, #arg0_26.groups do
		if table.contains(arg0_26.groups[iter0_26], arg0_26.id) then
			arg0_26.groupIndex = iter0_26
		end
	end

	arg0_26.configData = pg.task_data_template[arg0_26.id]
	arg0_26.target = arg0_26.configData.target_num
	arg0_26.type = arg0_26.configData.type
	arg0_26.subType = arg0_26.configData.sub_type
	arg0_26.targetId1 = arg0_26.configData.target_id
	arg0_26.targetId2 = arg0_26.configData.target_id_2
	arg0_26.autoCommit = arg0_26.configData.auto_commit == 1

	if arg0_26.actType == ActivityConst.ACTIVITY_TYPE_TASK_RYZA then
		-- block empty
	end
end

return var0_0
