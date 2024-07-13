local var0_0 = class("EducateExtraAttrMediator", import(".base.EducateContextMediator"))

var0_0.ON_ATTR_ADD = "EducateExtraAttrMediator:ON_ATTR_ADD"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ATTR_ADD, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_ADD_EXTRA_ATTR, {
			id = arg1_2.id
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.EDUCATE_ADD_EXTRA_ATTR_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.EDUCATE_ADD_EXTRA_ATTR_DONE then
		arg0_4.viewComponent:closeview()
	end
end

return var0_0
