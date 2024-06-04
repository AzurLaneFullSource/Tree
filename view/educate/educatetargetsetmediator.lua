local var0 = class("EducateTargetSetMediator", import(".base.EducateContextMediator"))

var0.ON_TARGET_SET = "EducateTargetSetMediator:ON_TARGET_SET"

function var0.register(arg0)
	arg0:bind(var0.ON_TARGET_SET, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_SET_TARGET, {
			id = arg1.id
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
