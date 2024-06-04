local var0 = class("WeekTaskProgress", import("..BaseVO"))

function var0.Ctor(arg0)
	return
end

function var0.Init(arg0, arg1)
	arg0.targets = {}
	arg0.dropData = {}
	arg0.index = 0
	arg0.target = 0
	arg0.progress = 0
	arg0.drops = {}
	arg0.subTasks = {}
	arg0.targets = pg.gameset.weekly_target.description
	arg0.dropData = pg.gameset.weekly_drop_client.description
	arg0.progress = arg1.pt or 0

	for iter0, iter1 in ipairs(arg1.task) do
		local var0 = WeekPtTask.New(iter1)

		arg0.subTasks[var0.id] = var0
	end

	local var1 = table.indexof(arg0.targets, arg1.reward_lv)

	arg0:UpdateTarget(var1 or 0)
end

function var0.IsMaximum(arg0)
	return arg0.index >= #arg0.targets
end

function var0.UpdateTarget(arg0, arg1)
	arg0.index = arg1
	arg0.target = arg0.targets[arg1 + 1] or arg0.targets[#arg0.targets]
	arg0.drops = arg0.dropData[arg1 + 1] or arg0.dropData[#arg0.dropData]
end

function var0.CanUpgrade(arg0)
	return arg0.progress >= arg0.target and not arg0:IsMaximum()
end

function var0.Upgrade(arg0)
	if arg0:CanUpgrade() then
		local var0 = arg0.index + 1

		arg0:UpdateTarget(var0)
	end
end

function var0.GetDropList(arg0)
	return arg0.drops
end

function var0.GetPhase(arg0)
	return math.min(arg0.index + 1, #arg0.targets)
end

function var0.GetTotalPhase(arg0)
	return #arg0.targets
end

function var0.GetProgress(arg0)
	return arg0.progress
end

function var0.GetTarget(arg0)
	return arg0.target
end

function var0.UpdateProgress(arg0, arg1)
	arg0.progress = arg1
end

function var0.AddProgress(arg0, arg1)
	arg0.progress = arg0.progress + arg1
end

function var0.GetAllPhaseDrops(arg0)
	return {
		resIcon = "Props/weekly_pt",
		type = 1,
		dropList = arg0.dropData,
		targets = arg0.targets,
		level = arg0.index,
		count = arg0.progress,
		resName = i18n("week_task_pt_name")
	}
end

function var0.ReachMaxPt(arg0)
	return arg0.targets[#arg0.targets] <= arg0.progress
end

function var0.GetSubTasks(arg0)
	return arg0.subTasks
end

function var0.RemoveSubTasks(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:RemoveSubTask(iter1)
	end
end

function var0.RemoveSubTask(arg0, arg1)
	arg0.subTasks[arg1] = nil
end

function var0.AddSubTask(arg0, arg1)
	arg0.subTasks[arg1.id] = arg1
end

function var0.UpdateSubTask(arg0, arg1)
	assert(arg0.subTasks[arg1.id], "should exist task >> " .. arg1.id)

	arg0.subTasks[arg1.id] = arg1
end

function var0.GetSubTask(arg0, arg1)
	return arg0.subTasks[arg1]
end

function var0.AnySubTaskCanSubmit(arg0)
	if arg0:ReachMaxPt() then
		return false
	end

	for iter0, iter1 in pairs(arg0.subTasks) do
		if iter1:isFinish() then
			return true
		end
	end

	return false
end

function var0.GetCanSubmitSubTaskCnt(arg0)
	if arg0:ReachMaxPt() then
		return 0
	end

	local var0 = 0

	for iter0, iter1 in pairs(arg0.subTasks) do
		if iter1:isFinish() then
			var0 = var0 + 1
		end
	end

	return var0
end

return var0
