local var0_0 = class("NotTraceableTaskActivity", import("model.vo.ActivityVOs.ITaskActivity"))

function var0_0.GetTaskIdsByDay(arg0_1)
	return arg0_1:getConfig("config_data")
end

function var0_0.GetCurrentDay(arg0_2, arg1_2)
	local var0_2 = 86400
	local var1_2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_2 = arg0_2:getConfig("time")
	local var3_2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var2_2[2])
	local var4_2 = math.ceil((var1_2 - var3_2) / var0_2)
	local var5_2 = arg0_2:getConfig("config_data")

	if var4_2 > #var5_2 then
		var4_2 = #var5_2
	end

	return var4_2
end

return var0_0
