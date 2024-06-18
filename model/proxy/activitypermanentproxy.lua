local var0_0 = class("ActivityPermanentProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:on(11210, function(arg0_2)
		arg0_1.finishActivity = {}

		underscore.each(arg0_2.permanent_activity, function(arg0_3)
			arg0_1.finishActivity[arg0_3] = true
		end)

		arg0_1.doingActivity = arg0_2.permanent_now
	end)
end

function var0_0.startSelectActivity(arg0_4, arg1_4)
	arg0_4.doingActivity = arg1_4
end

function var0_0.finishNowActivity(arg0_5, arg1_5)
	arg0_5.finishActivity[arg1_5] = true
	arg0_5.doingActivity = 0
end

function var0_0.isActivityFinish(arg0_6, arg1_6)
	return arg0_6.finishActivity[arg1_6]
end

function var0_0.getDoingActivity(arg0_7)
	if arg0_7.doingActivity ~= 0 then
		return getProxy(ActivityProxy):getActivityById(arg0_7.doingActivity)
	end

	return nil
end

return var0_0
