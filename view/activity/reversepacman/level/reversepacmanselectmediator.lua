local var0_0 = class("ReversePacmanSelectMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "ReversePacmanSelectMediator.GO_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, arg2_2)
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
