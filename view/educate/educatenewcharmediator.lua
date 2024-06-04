local var0 = class("EducateNewCharMediator", import(".base.EducateContextMediator"))

var0.ON_SET_CALL = "EducateNewCharMediator:ON_SET_CALL"

function var0.register(arg0)
	arg0:bind(var0.ON_SET_CALL, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_SET_CALL, {
			name = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EDUCATE_SET_CALL_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EDUCATE_SET_CALL_DONE then
		arg0.viewComponent:closeView()
	end
end

return var0
