local var0 = class("EducateExtraAttrMediator", import(".base.EducateContextMediator"))

var0.ON_ATTR_ADD = "EducateExtraAttrMediator:ON_ATTR_ADD"

function var0.register(arg0)
	arg0:bind(var0.ON_ATTR_ADD, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_ADD_EXTRA_ATTR, {
			id = arg1.id
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EDUCATE_ADD_EXTRA_ATTR_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EDUCATE_ADD_EXTRA_ATTR_DONE then
		arg0.viewComponent:closeview()
	end
end

return var0
