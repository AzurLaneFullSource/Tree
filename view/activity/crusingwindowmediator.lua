local var0 = class("CrusingWindowMediator", import("view.base.ContextMediator"))

var0.GO_CRUSING = "CrusingWindowMediator.GO_CRUSING"

function var0.register(arg0)
	arg0:bind(var0.GO_CRUSING, function(arg0)
		arg0.contextData.onClose = nil

		arg0.viewComponent:closeView()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.remove(arg0)
	if arg0.contextData.onClose then
		arg0.contextData.onClose()
	end
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
