local var0 = class("MsgboxMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	end
end

function var0.remove(arg0)
	return
end

function var0.ShowMsgBox(arg0)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = MsgboxMediator,
		viewComponent = MsgboxLayer,
		data = arg0
	}))
end

return var0
