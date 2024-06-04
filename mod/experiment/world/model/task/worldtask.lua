local var0 = class("WorldTask")

var0.STATE_INACTIVE = 0
var0.STATE_ONGOING = 1
var0.STATE_FINISHED = 2
var0.STATE_RECEIVED = 3

local var1 = pg.world_task_data

function var0.type2BgColor(arg0)
	if not var0.Colors then
		var0.Colors = {
			"yellow",
			"red",
			"blue",
			"orange",
			"green",
			"yellow"
		}
	end

	return var0.Colors[arg0 + 1]
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.progress = arg1.progress or 0
	arg0.submiteTime = arg1.submite_time or 0
	arg0.acceptTime = arg1.accept_time or 0
	arg0.followingEntrance = arg1.event_map_id or 0

	assert(var1[arg0.configId], "unfound config......" .. arg0.configId)

	arg0.config = var1[arg0.configId]
	arg0.new = arg1.new or 0

	local var0 = nowWorld()

	if arg0.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		arg0:updateProgress(var0:GetInventoryProxy():GetItemCount(arg0.config.complete_parameter[1]))
	elseif arg0.config.complete_condition == WorldConst.TaskTypePressingMap then
		arg0:updateProgress(var0:GetTargetMapPressingCount(arg0.config.complete_parameter))
	end
end

function var0.DebugPrint(arg0)
	local var0 = {
		"未激活",
		"进行中",
		"已完成未提交",
		"已提交",
		"已过期"
	}

	return string.format("任务 [%s] [id: %s] [状态: %s] [进度: %s/%s] [接受时间: %s] [完成时间: %s]", arg0.config.name, arg0.id, var0[arg0:getState() + 1], arg0:getProgress(), arg0:getMaxProgress(), arg0.acceptTime, arg0.submiteTime)
end

function var0.isNew(arg0)
	return arg0.new == 1
end

function var0.getState(arg0)
	if arg0.acceptTime == 0 then
		return var0.STATE_INACTIVE
	elseif arg0.submiteTime > 0 then
		return var0.STATE_RECEIVED
	elseif arg0:getProgress() >= arg0:getMaxProgress() then
		return var0.STATE_FINISHED
	else
		return var0.STATE_ONGOING
	end
end

function var0.getMaxProgress(arg0)
	return arg0.config.complete_parameter_num
end

function var0.updateProgress(arg0, arg1)
	arg0.progress = arg1
end

function var0.getProgress(arg0)
	return arg0.progress
end

function var0.isAlive(arg0)
	local var0 = arg0:getState()

	return var0 == var0.STATE_ONGOING or var0 == var0.STATE_FINISHED
end

function var0.isFinished(arg0)
	return arg0:getState() == var0.STATE_FINISHED
end

function var0.isReceived(arg0)
	return arg0:getState() == var0.STATE_RECEIVED
end

function var0.canSubmit(arg0)
	if arg0:getState() ~= var0.STATE_FINISHED then
		return false, i18n("this task is not finish or is finished")
	end

	return true
end

function var0.commited(arg0)
	arg0.submiteTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.GetBgColor(arg0)
	return var0.type2BgColor(arg0.config.type)
end

function var0.GetDisplayDrops(arg0)
	local var0 = {}

	_.each(arg0.config.show, function(arg0)
		table.insert(var0, {
			type = arg0[1],
			id = arg0[2],
			count = arg0[3]
		})
	end)

	return var0
end

function var0.GetFollowingAreaId(arg0)
	local var0 = arg0.config.following_region[1]

	return var0 and var0 > 0 and var0 or nil
end

local var2 = {
	[0] = true,
	[6] = true,
	[7] = true
}

function var0.GetFollowingEntrance(arg0)
	if var2[arg0.config.type] then
		return arg0.config.following_map[1]
	else
		return arg0.followingEntrance > 0 and arg0.followingEntrance or nil
	end
end

function var0.IsSpecialType(arg0)
	return arg0.config.type == 5
end

function var0.IsTypeCollection(arg0)
	return arg0.config.type == 6
end

function var0.IsLockMap(arg0)
	return arg0.config.target_map_lock == 1
end

function var0.IsAutoSubmit(arg0)
	return arg0.config.auto_complete == 1
end

function var0.canTrigger(arg0)
	local var0 = nowWorld()
	local var1 = WorldTask.New({
		id = arg0
	})
	local var2 = var0:GetTaskProxy()

	if var2:getTaskById(arg0) then
		return false, i18n("world_sametask_tip")
	elseif var0:GetLevel() < var1.config.need_level then
		return false, i18n1("舰队总等级需达到（缺gametip）" .. var1.config.need_level)
	elseif var2.taskFinishCount < var1.config.need_task_complete then
		return false, i18n1("任务完成数需达到（缺gametip）" .. var1.config.need_task_complete)
	end

	return true
end

var0.taskSortOrder = {
	[var0.STATE_INACTIVE] = 2,
	[var0.STATE_ONGOING] = 1,
	[var0.STATE_FINISHED] = 0,
	[var0.STATE_RECEIVED] = 3
}
var0.sortDic = {
	function(arg0)
		return var0.taskSortOrder[arg0:getState()]
	end,
	function(arg0)
		return arg0.config.type
	end,
	function(arg0)
		return -arg0.config.priority
	end,
	function(arg0)
		return arg0.id
	end
}

return var0
