local var0_0 = class("GuideSendNotifiesPlayer", import(".GuidePlayer"))

function var0_0.OnExecution(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1:GetNotifies()

	for iter0_1, iter1_1 in ipairs(var0_1) do
		pg.m02:sendNotification(iter1_1.notify, iter1_1.body)
	end

	arg2_1()
end

return var0_0
