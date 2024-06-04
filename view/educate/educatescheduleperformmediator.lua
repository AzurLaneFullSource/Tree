local var0 = class("EducateSchedulePerformMediator", import(".base.EducateContextMediator"))

var0.WEEKDAY_UPDATE = "WEEKDAY_UPDATE"

function var0.register(arg0)
	arg0:bind(var0.WEEKDAY_UPDATE, function(arg0, arg1)
		arg0:sendNotification(EducateProxy.TIME_WEEKDAY_UPDATED, {
			weekDay = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
