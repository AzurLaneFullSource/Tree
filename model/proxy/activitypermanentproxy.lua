local var0 = class("ActivityPermanentProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0:on(11210, function(arg0)
		arg0.finishActivity = {}

		underscore.each(arg0.permanent_activity, function(arg0)
			arg0.finishActivity[arg0] = true
		end)

		arg0.doingActivity = arg0.permanent_now
	end)
end

function var0.startSelectActivity(arg0, arg1)
	arg0.doingActivity = arg1
end

function var0.finishNowActivity(arg0, arg1)
	arg0.finishActivity[arg1] = true
	arg0.doingActivity = 0
end

function var0.isActivityFinish(arg0, arg1)
	return arg0.finishActivity[arg1]
end

function var0.getDoingActivity(arg0)
	if arg0.doingActivity ~= 0 then
		return getProxy(ActivityProxy):getActivityById(arg0.doingActivity)
	end

	return nil
end

return var0
