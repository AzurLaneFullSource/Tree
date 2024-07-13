local var0_0 = class("CrusingWindowMediator", import("view.base.ContextMediator"))

var0_0.GO_CRUSING = "CrusingWindowMediator.GO_CRUSING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_CRUSING, function(arg0_2)
		arg0_1.contextData.onClose = nil

		arg0_1.viewComponent:closeView()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.remove(arg0_4)
	if arg0_4.contextData.onClose then
		arg0_4.contextData.onClose()
	end
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
end

return var0_0
