local var0_0 = class("NewEducateSetCallediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_SET_CALL = "NewEducateSetCallediator:ON_SET_CALL"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SET_CALL, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SET_CALL, {
			id = arg0_1.contextData.char.id,
			name = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.NEW_EDUCATE_SET_CALL_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.NEW_EDUCATE_SET_CALL_DONE then
		arg0_4.viewComponent:closeView()
	end
end

return var0_0
