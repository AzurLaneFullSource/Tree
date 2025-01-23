local var0_0 = class("NewEducateSelectMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "NewEducateSelectMediator:GO_SCENE"
var0_0.GO_SUBLAYER = "NewEducateSelectMediator.GO_SUBLAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(arg1_3, nil, arg2_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
end

return var0_0
