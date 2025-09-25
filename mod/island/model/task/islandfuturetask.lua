local var0_0 = class("IslandFutureTask", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.task_id
	arg0_1.configId = arg0_1.id

	arg0_1:InitTimeCfg()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_task
end

function var0_0.InitTimeCfg(arg0_3)
	local var0_3 = arg0_3:getConfig("unlock_time")

	if var0_3 == "always" then
		arg0_3.unlockTime = 0
		arg0_3.endTime = 0
	else
		local var1_3 = pg.TimeMgr.GetInstance()

		arg0_3.unlockTime = var1_3:parseTimeFromConfig(var0_3[1])
		arg0_3.endTime = var1_3:parseTimeFromConfig(var0_3[2])
	end
end

function var0_0.GetUnlockTime(arg0_4)
	return arg0_4.unlockTime
end

function var0_0.IsMatchUnlockTime(arg0_5)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_5.unlockTime
end

function var0_0.InTime(arg0_6)
	if arg0_6.unlockTime == 0 and arg0_6.endTime == 0 then
		return true
	end

	local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0_6 > arg0_6.unlockTime and var0_6 < arg0_6.endTime
end

function var0_0.IsAcceptImmediately(arg0_7)
	return arg0_7:getConfig("trigger_type") == 2 and arg0_7:getConfig("trigger_data") == 0
end

function var0_0.CheckAcceptOnApproach(arg0_8, arg1_8)
	return arg0_8:getConfig("trigger_data") == arg1_8 and arg0_8:getConfig("trigger_type") == 2
end

function var0_0.IsMatchUnlockConditions(arg0_9)
	local var0_9 = arg0_9:getConfig("unlock_condition")

	if var0_9 == "" or #var0_9 == 0 then
		return true
	end

	return underscore.all(var0_9, function(arg0_10)
		return IslandTaskConditionType.IsMatch(arg0_10)
	end)
end

function var0_0.IsUnlock(arg0_11)
	return arg0_11:IsMatchUnlockTime() and arg0_11:IsMatchUnlockConditions()
end

function var0_0.IsUnlockWaitTime(arg0_12)
	if arg0_12.unlockTime == 0 then
		return false
	end

	local var0_12 = arg0_12:getConfig("unlock_condition")

	if var0_12 == "" or #var0_12 == 0 then
		return false
	end

	return arg0_12:IsMatchUnlockConditions() and not arg0_12:IsMatchUnlockTime()
end

return var0_0
