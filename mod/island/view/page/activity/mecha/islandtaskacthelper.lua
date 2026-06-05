local var0_0 = class("IslandTaskActhelper")

var0_0.TASK_STATET_NORMAL = 0
var0_0.TASK_STATET_FINISH = 1
var0_0.TASK_STATET_RECIVED = 2

function var0_0.GetIslandTaskState(arg0_1)
	local var0_1 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
	local var1_1 = 0
	local var2_1 = IslandTask.New({
		id = arg0_1,
		process_list = {}
	}):GetTargetList()[1]

	assert(var2_1, "target no exist")

	local var3_1 = var2_1:GetTargetNum()
	local var4_1 = var0_0.TASK_STATET_NORMAL
	local var5_1 = var0_1:GetTask(arg0_1)

	if var0_1:IsFinishTask(arg0_1) then
		var4_1 = var0_0.TASK_STATET_RECIVED
		var1_1 = var3_1
	elseif var5_1 and var5_1:IsFinish() then
		var4_1 = var0_0.TASK_STATET_FINISH
		var1_1 = var3_1
	end

	if var5_1 then
		var1_1 = var5_1:GetTargetList()[1]:GetProgress()
	end

	return var1_1, var3_1, var4_1
end

function var0_0.GetNDay(arg0_2)
	local var0_2 = arg0_2:getIslandConfig("config_data")
	local var1_2 = arg0_2:getDayIndex()
	local var2_2 = 1

	for iter0_2, iter1_2 in ipairs(var0_2) do
		if _.all(iter1_2, function(arg0_3)
			local var0_3, var1_3, var2_3 = var0_0.GetIslandTaskState(arg0_3)

			return var2_3 == var0_0.TASK_STATET_RECIVED
		end) then
			var2_2 = iter0_2 + 1
		end
	end

	return math.min(#var0_2, math.min(var1_2, var2_2))
end

function var0_0.IsIslandTaskAct(arg0_4)
	if arg0_4:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		return false
	end

	if #arg0_4:getConfig("config_data") <= 0 and pg.island_activity_template[arg0_4.configId] then
		return true
	end

	return false
end

local var1_0 = "_ISLAND_MECHA_TASK_ACT_"

function var0_0.FirstEnter()
	local var0_5 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var1_0 .. var0_5, 0) == 0
end

function var0_0.SetNonFirstEnter(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var1_0 .. var0_6, 1)
	PlayerPrefs.Save()

	local var1_6 = getProxy(ActivityProxy):RawGetActivityById(arg0_6)

	if var1_6 then
		pg.m02:sendNotification(ActivityProxy.ACTIVITY_UPDATED, var1_6)
	end
end

function var0_0.ShouldTipIslandTask(arg0_7)
	if arg0_7:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		return false
	end

	local var0_7 = var0_0.GetNDay(arg0_7)
	local var1_7 = arg0_7:getIslandConfig("config_data")[var0_7] or {}

	return var0_0.FirstEnter() or _.any(var1_7, function(arg0_8)
		local var0_8, var1_8, var2_8 = var0_0.GetIslandTaskState(arg0_8)

		return var2_8 == var0_0.TASK_STATET_FINISH
	end)
end

function var0_0._TriggerTasks(arg0_9)
	local var0_9 = arg0_9:getIslandConfig("config_data")
	local var1_9 = _.flatten(var0_9)
	local var2_9 = {}
	local var3_9 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var4_9 = var3_9:GetTask(iter1_9)

		if not var3_9:IsFinishTask(iter1_9) and not var4_9 then
			table.insert(var2_9, iter1_9)
		end
	end

	if #var2_9 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = var2_9
		})
	end
end

function var0_0.TriggerActTasks(arg0_10)
	local var0_10 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)

	for iter0_10, iter1_10 in ipairs(var0_10) do
		if var0_0.IsIslandTaskAct(iter1_10) then
			var0_0._TriggerTasks(iter1_10)
		end
	end

	arg0_10()
end

return var0_0
