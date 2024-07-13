local var0_0 = class("EducateSchedulePerformMediator", import(".base.EducateContextMediator"))

var0_0.WEEKDAY_UPDATE = "WEEKDAY_UPDATE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.WEEKDAY_UPDATE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(EducateProxy.TIME_WEEKDAY_UPDATED, {
			weekDay = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
