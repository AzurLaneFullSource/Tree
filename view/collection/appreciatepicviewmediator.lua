local var0_0 = class("AppreciatePicViewMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.UPDATE_LOADING_PIC_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.UPDATE_LOADING_PIC_DONE then
		arg0_3.viewComponent:updatePanel()
	end
end

return var0_0
