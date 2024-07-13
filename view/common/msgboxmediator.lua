local var0_0 = class("MsgboxMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == nil then
		-- block empty
	end
end

function var0_0.remove(arg0_4)
	return
end

function var0_0.ShowMsgBox(arg0_5)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = MsgboxMediator,
		viewComponent = MsgboxLayer,
		data = arg0_5
	}))
end

return var0_0
