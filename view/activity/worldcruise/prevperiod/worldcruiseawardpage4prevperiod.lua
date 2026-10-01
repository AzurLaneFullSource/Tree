local var0_0 = class("WorldCruiseAwardPage4PrevPeriod", import("..pages.WorldCruiseAwardPage"))

function var0_0.getUIName(arg0_1)
	return "WorldCruiseAwardPage4PrevPeriod"
end

function var0_0.UpdateActivity(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING):GetPreviousPeriodAct()

	arg0_2.activity = var0_2

	assert(var0_2, "prev period crusing activity is nil")

	for iter0_2, iter1_2 in pairs(var0_2:GetCrusingInfo()) do
		arg0_2[iter0_2] = iter1_2
	end
end

function var0_0.Flush(arg0_3)
	arg0_3:UpdateActivity()
	var0_0.super.Flush(arg0_3, nil)
end

return var0_0
