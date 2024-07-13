local var0_0 = class("SkirmishProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.data = {}

	arg0_1:BuildSkirmishData()
end

var0_0.SkirmishMap = 1250022

function var0_0.BuildSkirmishData(arg0_2)
	local var0_2 = SkirmishVO.bindConfigTable()

	for iter0_2, iter1_2 in pairs(var0_2.all) do
		local var1_2 = var0_2[iter1_2]
		local var2_2 = SkirmishVO.New(var1_2.id)

		table.insert(arg0_2.data, var2_2)
	end
end

function var0_0.TryFetchNewTask(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE)

	if var0_3 and not var0_3:isEnd() then
		return updateActivityTaskStatus(var0_3)
	end
end

function var0_0.UpdateSkirmishProgress(arg0_4)
	local var0_4 = getProxy(TaskProxy)
	local var1_4 = getProxy(ActivityProxy)
	local var2_4 = arg0_4.data
	local var3_4 = var1_4:getActivityById(ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE)
	local var4_4 = math.min(var3_4:getDayIndex(), #var2_4)
	local var5_4 = false

	for iter0_4 = #var2_4, 1, -1 do
		local var6_4 = var2_4[iter0_4]
		local var7_4 = var6_4:getConfig("task_id")
		local var8_4 = var0_4:getTaskVO(var7_4)
		local var9_4

		if var4_4 < iter0_4 then
			var9_4 = SkirmishVO.StateInactive
		elseif var8_4 then
			if var8_4:isReceive() then
				var9_4 = SkirmishVO.StateClear
				var5_4 = var5_4 or iter0_4 <= var4_4
			elseif not var8_4:isFinish() then
				var9_4 = SkirmishVO.StateWorking
				var5_4 = true
			else
				var9_4 = SkirmishVO.StateWorking
				var5_4 = true
			end
		elseif var5_4 then
			var9_4 = SkirmishVO.StateClear
		else
			var9_4 = SkirmishVO.StateActive
		end

		var6_4:SetState(var9_4)
	end
end

return var0_0
