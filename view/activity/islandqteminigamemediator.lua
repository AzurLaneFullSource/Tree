local var0 = class("IslandQTEMiniGameMediator", import("..base.ContextMediator"))

var0.GAME_FINISH = "IslandQTEMiniGameMediator.GAME_FINISH"

function var0.register(arg0)
	arg0:bind(var0.GAME_FINISH, function(arg0, arg1)
		arg0.contextData.finishCallback(arg1 or 0)
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
