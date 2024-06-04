local var0 = class("AcceptActivityTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	print("accpet activity task...................")

	local var0 = getProxy(ActivityProxy)

	_.each(var0:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_TASK_LIST,
		ActivityConst.ACTIVITY_TYPE_TASK_RES
	}), function(arg0)
		if not arg0:isEnd() then
			updateActivityTaskStatus(arg0)
		end
	end)
	underscore.each(var0:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_PT_CRUSING
	}), function(arg0)
		if not arg0:isEnd() then
			updateCrusingActivityTask(arg0)
		end
	end)
end

return var0
