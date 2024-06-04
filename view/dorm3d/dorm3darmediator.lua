local var0 = class("Dorm3dARMediator", import("view.base.ContextMediator"))

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

return var0
