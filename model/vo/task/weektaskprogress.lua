local var0_0 = class("WeekTaskProgress", import("..BaseVO"))

function var0_0.Ctor(arg0_1)
	return
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.targets = {}
	arg0_2.dropData = {}
	arg0_2.index = 0
	arg0_2.target = 0
	arg0_2.progress = 0
	arg0_2.drops = {}
	arg0_2.subTasks = {}
	arg0_2.targets = pg.gameset.weekly_target.description
	arg0_2.dropData = pg.gameset.weekly_drop_client.description
	arg0_2.progress = arg1_2.pt or 0

	for iter0_2, iter1_2 in ipairs(arg1_2.task) do
		local var0_2 = WeekPtTask.New(iter1_2)

		arg0_2.subTasks[var0_2.id] = var0_2
	end

	local var1_2 = table.indexof(arg0_2.targets, arg1_2.reward_lv)

	arg0_2:UpdateTarget(var1_2 or 0)
end

function var0_0.IsMaximum(arg0_3)
	return arg0_3.index >= #arg0_3.targets
end

function var0_0.UpdateTarget(arg0_4, arg1_4)
	arg0_4.index = arg1_4
	arg0_4.target = arg0_4.targets[arg1_4 + 1] or arg0_4.targets[#arg0_4.targets]
	arg0_4.drops = arg0_4.dropData[arg1_4 + 1] or arg0_4.dropData[#arg0_4.dropData]
end

function var0_0.CanUpgrade(arg0_5)
	return arg0_5.progress >= arg0_5.target and not arg0_5:IsMaximum()
end

function var0_0.Upgrade(arg0_6)
	if arg0_6:CanUpgrade() then
		local var0_6 = arg0_6.index + 1

		arg0_6:UpdateTarget(var0_6)
	end
end

function var0_0.GetDropList(arg0_7)
	return arg0_7.drops
end

function var0_0.GetPhase(arg0_8)
	return math.min(arg0_8.index + 1, #arg0_8.targets)
end

function var0_0.GetTotalPhase(arg0_9)
	return #arg0_9.targets
end

function var0_0.GetProgress(arg0_10)
	return arg0_10.progress
end

function var0_0.GetTarget(arg0_11)
	return arg0_11.target
end

function var0_0.UpdateProgress(arg0_12, arg1_12)
	arg0_12.progress = arg1_12
end

function var0_0.AddProgress(arg0_13, arg1_13)
	arg0_13.progress = arg0_13.progress + arg1_13
end

function var0_0.GetAllPhaseDrops(arg0_14)
	return {
		resIcon = "Props/weekly_pt",
		type = 1,
		dropList = arg0_14.dropData,
		targets = arg0_14.targets,
		level = arg0_14.index,
		count = arg0_14.progress,
		resName = i18n("week_task_pt_name")
	}
end

function var0_0.ReachMaxPt(arg0_15)
	return arg0_15.targets[#arg0_15.targets] <= arg0_15.progress
end

function var0_0.GetSubTasks(arg0_16)
	return arg0_16.subTasks
end

function var0_0.RemoveSubTasks(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(arg1_17) do
		arg0_17:RemoveSubTask(iter1_17)
	end
end

function var0_0.RemoveSubTask(arg0_18, arg1_18)
	arg0_18.subTasks[arg1_18] = nil
end

function var0_0.AddSubTask(arg0_19, arg1_19)
	arg0_19.subTasks[arg1_19.id] = arg1_19
end

function var0_0.UpdateSubTask(arg0_20, arg1_20)
	assert(arg0_20.subTasks[arg1_20.id], "should exist task >> " .. arg1_20.id)

	arg0_20.subTasks[arg1_20.id] = arg1_20
end

function var0_0.GetSubTask(arg0_21, arg1_21)
	return arg0_21.subTasks[arg1_21]
end

function var0_0.AnySubTaskCanSubmit(arg0_22)
	if arg0_22:ReachMaxPt() then
		return false
	end

	for iter0_22, iter1_22 in pairs(arg0_22.subTasks) do
		if iter1_22:isFinish() then
			return true
		end
	end

	return false
end

function var0_0.GetCanSubmitSubTaskCnt(arg0_23)
	if arg0_23:ReachMaxPt() then
		return 0
	end

	local var0_23 = 0

	for iter0_23, iter1_23 in pairs(arg0_23.subTasks) do
		if iter1_23:isFinish() then
			var0_23 = var0_23 + 1
		end
	end

	return var0_23
end

return var0_0
