local var0_0 = class("IslandObjectTaskHudHelper")

var0_0.TYPE_NORMAL = 0
var0_0.TYPE_ACCEPT = 1
var0_0.TYPE_TARGET = 2
var0_0.TYPE_SUBMIT = 3

function var0_0.BuildData(arg0_1)
	var0_0.objectAcceptData = {}
	var0_0.objectTargetData = {}
	var0_0.objectSubmitData = {}

	for iter0_1, iter1_1 in ipairs(arg0_1) do
		local var0_1, var1_1, var2_1 = var0_0.GetLinkObjectsByTaskId(iter1_1)

		if var0_1 then
			if not var0_0.objectAcceptData[var0_1] then
				var0_0.objectAcceptData[var0_1] = {}
			end

			table.insert(var0_0.objectAcceptData[var0_1], iter1_1)
		end

		if var1_1 then
			if not var0_0.objectSubmitData[var1_1] then
				var0_0.objectSubmitData[var1_1] = {}
			end

			table.insert(var0_0.objectSubmitData[var1_1], iter1_1)
		end

		for iter2_1, iter3_1 in pairs(var2_1) do
			if not var0_0.objectTargetData[iter2_1] then
				var0_0.objectTargetData[iter2_1] = {}
			end

			table.insert(var0_0.objectTargetData[iter2_1], iter3_1)
		end
	end
end

function var0_0.GetLinkObjectsByTaskId(arg0_2)
	local var0_2 = pg.island_task[arg0_2]
	local var1_2
	local var2_2
	local var3_2 = {}

	if var0_2.trigger_type == 1 and var0_2.trigger_data ~= 0 then
		var1_2 = var0_2.trigger_data
	end

	if var0_2.complete_type == 1 and var0_2.complete_data ~= 0 then
		var2_2 = var0_2.complete_data
	end

	for iter0_2, iter1_2 in ipairs(var0_2.target_id) do
		local var4_2 = pg.island_task_target[iter1_2]

		if table.contains(IslandTaskTargetType.GetObjectLinkTypes(), var4_2.type) then
			var3_2[var4_2.target_param[1]] = {
				arg0_2,
				iter1_2
			}
		end
	end

	return var1_2, var2_2, var3_2
end

function var0_0.CheckSubmit(arg0_3)
	local var0_3 = var0_0.objectSubmitData[arg0_3]

	if var0_3 and #var0_3 > 0 then
		local var1_3 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
		local var2_3 = underscore.select(var0_3, function(arg0_4)
			local var0_4 = var1_3:GetTask(arg0_4)

			return var0_4 and var0_4:IsFinish()
		end)

		return var0_0.GetFirstPriorityId(var2_3)
	end

	return nil
end

function var0_0.CheckAccept(arg0_5)
	local var0_5 = var0_0.objectAcceptData[arg0_5]

	if var0_5 and #var0_5 > 0 then
		local var1_5 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
		local var2_5 = underscore.select(var0_5, function(arg0_6)
			local var0_6 = var1_5:GetFutureTask(arg0_6)

			return var0_6 and var0_6:IsUnlock()
		end)

		return var0_0.GetFirstPriorityId(var2_5)
	end

	return nil
end

function var0_0.CheckTarget(arg0_7)
	local var0_7 = var0_0.objectTargetData[arg0_7]

	if var0_7 and #var0_7 > 0 then
		local var1_7 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
		local var2_7 = underscore.select(var0_7, function(arg0_8)
			local var0_8 = var1_7:GetTask(arg0_8[1])

			return var0_8 and not var0_8:GetTargetById(arg0_8[2]):IsFinish()
		end)
		local var3_7 = underscore.map(var2_7, function(arg0_9)
			return arg0_9[1]
		end)

		return var0_0.GetFirstPriorityId(var3_7)
	end

	return nil
end

function var0_0.GetFirstPriorityId(arg0_10)
	table.sort(arg0_10, CompareFuncs({
		function(arg0_11)
			local var0_11 = IslandTaskType.Type2ShowType[pg.island_task[arg0_11].type]

			return IslandTaskType.GetHudPriority(var0_11)
		end,
		function(arg0_12)
			return arg0_12
		end
	}))

	return arg0_10[1]
end

function var0_0.GetObjectTaskHud(arg0_13)
	local var0_13 = var0_0.CheckSubmit(arg0_13)

	if var0_13 then
		return var0_0.TYPE_SUBMIT, var0_13
	end

	local var1_13 = var0_0.CheckAccept(arg0_13)

	if var1_13 then
		return var0_0.TYPE_ACCEPT, var1_13
	end

	local var2_13 = var0_0.CheckTarget(arg0_13)

	if var2_13 then
		return var0_0.TYPE_TARGET, var2_13
	end

	return var0_0.TYPE_NORMAL, nil
end

function var0_0.GetHudDislayInfoByTaskId(arg0_14)
	local var0_14 = IslandTaskType.Type2ShowType[pg.island_task[arg0_14].type]

	return switch(var0_14, {
		[IslandTaskType.SHOW_MAIN] = function()
			return "hud_main", "39befe"
		end,
		[IslandTaskType.SHOW_BRANCH] = function()
			return "hud_branch", "e67ad5"
		end,
		[IslandTaskType.SHOW_DAILY] = function()
			return "hud_dayly", "b4a0e6"
		end,
		[IslandTaskType.SHOW_WEEKLY] = function()
			return "hud_weekly", "7ed38f"
		end,
		[IslandTaskType.SHOW_ACTIVITY] = function()
			return "hud_activity", "eed073"
		end
	}, function()
		assert(false, "not exist task showType: " .. var0_14)
	end)
end

var0_0.TaskProcessToHudIcon = {
	[var0_0.TYPE_ACCEPT] = "icon_accept",
	[var0_0.TYPE_TARGET] = "icon_inprocess",
	[var0_0.TYPE_SUBMIT] = "icon_inprocess"
}

return var0_0
