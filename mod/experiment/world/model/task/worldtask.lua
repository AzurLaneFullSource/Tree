local var0_0 = class("WorldTask")

var0_0.STATE_INACTIVE = 0
var0_0.STATE_ONGOING = 1
var0_0.STATE_FINISHED = 2
var0_0.STATE_RECEIVED = 3

local var1_0 = pg.world_task_data

function var0_0.type2BgColor(arg0_1)
	if not var0_0.Colors then
		var0_0.Colors = {
			"yellow",
			"red",
			"blue",
			"orange",
			"green",
			"yellow"
		}
	end

	return var0_0.Colors[arg0_1 + 1]
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg1_2.id
	arg0_2.progress = arg1_2.progress or 0
	arg0_2.submiteTime = arg1_2.submite_time or 0
	arg0_2.acceptTime = arg1_2.accept_time or 0
	arg0_2.followingEntrance = arg1_2.event_map_id or 0

	assert(var1_0[arg0_2.configId], "unfound config......" .. arg0_2.configId)

	arg0_2.config = var1_0[arg0_2.configId]
	arg0_2.new = arg1_2.new or 0

	local var0_2 = nowWorld()

	if arg0_2.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		arg0_2:updateProgress(var0_2:GetInventoryProxy():GetItemCount(arg0_2.config.complete_parameter[1]))
	elseif arg0_2.config.complete_condition == WorldConst.TaskTypePressingMap then
		arg0_2:updateProgress(var0_2:GetTargetMapPressingCount(arg0_2.config.complete_parameter))
	end
end

function var0_0.DebugPrint(arg0_3)
	local var0_3 = {
		"未激活",
		"进行中",
		"已完成未提交",
		"已提交",
		"已过期"
	}

	return string.format("任务 [%s] [id: %s] [状态: %s] [进度: %s/%s] [接受时间: %s] [完成时间: %s]", arg0_3.config.name, arg0_3.id, var0_3[arg0_3:getState() + 1], arg0_3:getProgress(), arg0_3:getMaxProgress(), arg0_3.acceptTime, arg0_3.submiteTime)
end

function var0_0.isNew(arg0_4)
	return arg0_4.new == 1
end

function var0_0.getState(arg0_5)
	if arg0_5.acceptTime == 0 then
		return var0_0.STATE_INACTIVE
	elseif arg0_5.submiteTime > 0 then
		return var0_0.STATE_RECEIVED
	elseif arg0_5:getProgress() >= arg0_5:getMaxProgress() then
		return var0_0.STATE_FINISHED
	else
		return var0_0.STATE_ONGOING
	end
end

function var0_0.getMaxProgress(arg0_6)
	return arg0_6.config.complete_parameter_num
end

function var0_0.updateProgress(arg0_7, arg1_7)
	arg0_7.progress = arg1_7
end

function var0_0.getProgress(arg0_8)
	return arg0_8.progress
end

function var0_0.isAlive(arg0_9)
	local var0_9 = arg0_9:getState()

	return var0_9 == var0_0.STATE_ONGOING or var0_9 == var0_0.STATE_FINISHED
end

function var0_0.isFinished(arg0_10)
	return arg0_10:getState() == var0_0.STATE_FINISHED
end

function var0_0.isReceived(arg0_11)
	return arg0_11:getState() == var0_0.STATE_RECEIVED
end

function var0_0.canSubmit(arg0_12)
	if arg0_12:getState() ~= var0_0.STATE_FINISHED then
		return false, i18n("this task is not finish or is finished")
	end

	return true
end

function var0_0.commited(arg0_13)
	arg0_13.submiteTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetBgColor(arg0_14)
	return var0_0.type2BgColor(arg0_14.config.type)
end

function var0_0.GetDisplayDrops(arg0_15)
	local var0_15 = {}

	_.each(arg0_15.config.show, function(arg0_16)
		table.insert(var0_15, {
			type = arg0_16[1],
			id = arg0_16[2],
			count = arg0_16[3]
		})
	end)

	return var0_15
end

function var0_0.GetFollowingAreaId(arg0_17)
	local var0_17 = arg0_17.config.following_region[1]

	return var0_17 and var0_17 > 0 and var0_17 or nil
end

local var2_0 = {
	[0] = true,
	[6] = true,
	[7] = true
}

function var0_0.GetFollowingEntrance(arg0_18)
	if var2_0[arg0_18.config.type] then
		return arg0_18.config.following_map[1]
	else
		return arg0_18.followingEntrance > 0 and arg0_18.followingEntrance or nil
	end
end

function var0_0.IsSpecialType(arg0_19)
	return arg0_19.config.type == 5
end

function var0_0.IsTypeCollection(arg0_20)
	return arg0_20.config.type == 6
end

function var0_0.IsLockMap(arg0_21)
	return arg0_21.config.target_map_lock == 1
end

function var0_0.IsAutoSubmit(arg0_22)
	return arg0_22.config.auto_complete == 1
end

function var0_0.canTrigger(arg0_23)
	local var0_23 = nowWorld()
	local var1_23 = WorldTask.New({
		id = arg0_23
	})
	local var2_23 = var0_23:GetTaskProxy()

	if var2_23:getTaskById(arg0_23) then
		return false, i18n("world_sametask_tip")
	elseif var0_23:GetLevel() < var1_23.config.need_level then
		return false, i18n1("舰队总等级需达到（缺gametip）" .. var1_23.config.need_level)
	elseif var2_23.taskFinishCount < var1_23.config.need_task_complete then
		return false, i18n1("任务完成数需达到（缺gametip）" .. var1_23.config.need_task_complete)
	end

	return true
end

var0_0.taskSortOrder = {
	[var0_0.STATE_INACTIVE] = 2,
	[var0_0.STATE_ONGOING] = 1,
	[var0_0.STATE_FINISHED] = 0,
	[var0_0.STATE_RECEIVED] = 3
}
var0_0.sortDic = {
	function(arg0_24)
		return var0_0.taskSortOrder[arg0_24:getState()]
	end,
	function(arg0_25)
		return arg0_25.config.type
	end,
	function(arg0_26)
		return -arg0_26.config.priority
	end,
	function(arg0_27)
		return arg0_27.id
	end
}

return var0_0
