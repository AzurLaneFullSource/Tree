local var0 = class("TecSpeedUpMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.USE_TEC_SPEEDUP_ITEM_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.USE_TEC_SPEEDUP_ITEM_DONE then
		arg0.viewComponent:closeView()
	end
end

return var0
