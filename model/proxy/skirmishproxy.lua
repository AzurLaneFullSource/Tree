local var0 = class("SkirmishProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.data = {}

	arg0:BuildSkirmishData()
end

var0.SkirmishMap = 1250022

function var0.BuildSkirmishData(arg0)
	local var0 = SkirmishVO.bindConfigTable()

	for iter0, iter1 in pairs(var0.all) do
		local var1 = var0[iter1]
		local var2 = SkirmishVO.New(var1.id)

		table.insert(arg0.data, var2)
	end
end

function var0.TryFetchNewTask(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE)

	if var0 and not var0:isEnd() then
		return updateActivityTaskStatus(var0)
	end
end

function var0.UpdateSkirmishProgress(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = getProxy(ActivityProxy)
	local var2 = arg0.data
	local var3 = var1:getActivityById(ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE)
	local var4 = math.min(var3:getDayIndex(), #var2)
	local var5 = false

	for iter0 = #var2, 1, -1 do
		local var6 = var2[iter0]
		local var7 = var6:getConfig("task_id")
		local var8 = var0:getTaskVO(var7)
		local var9

		if var4 < iter0 then
			var9 = SkirmishVO.StateInactive
		elseif var8 then
			if var8:isReceive() then
				var9 = SkirmishVO.StateClear
				var5 = var5 or iter0 <= var4
			elseif not var8:isFinish() then
				var9 = SkirmishVO.StateWorking
				var5 = true
			else
				var9 = SkirmishVO.StateWorking
				var5 = true
			end
		elseif var5 then
			var9 = SkirmishVO.StateClear
		else
			var9 = SkirmishVO.StateActive
		end

		var6:SetState(var9)
	end
end

return var0
