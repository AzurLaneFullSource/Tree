local var0 = class("GuideSendNotifiesPlayer", import(".GuidePlayer"))

function var0.OnExecution(arg0, arg1, arg2)
	local var0 = arg1:GetNotifies()

	for iter0, iter1 in ipairs(var0) do
		pg.m02:sendNotification(iter1.notify, iter1.body)
	end

	arg2()
end

return var0
