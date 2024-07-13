local var0_0 = class("AcceptActivityTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	print("accpet activity task...................")

	local var0_1 = getProxy(ActivityProxy)

	_.each(var0_1:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_TASK_LIST,
		ActivityConst.ACTIVITY_TYPE_TASK_RES
	}), function(arg0_2)
		if not arg0_2:isEnd() then
			updateActivityTaskStatus(arg0_2)
		end
	end)
	underscore.each(var0_1:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_PT_CRUSING
	}), function(arg0_3)
		if not arg0_3:isEnd() then
			updateCrusingActivityTask(arg0_3)
		end
	end)
end

return var0_0
