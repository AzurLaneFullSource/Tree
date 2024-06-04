local var0 = class("WorkBenchItemDetailMediator", import("view.base.ContextMediator"))

var0.SHOW_DETAIL = "SHOW_DETAIL"

function var0.register(arg0)
	arg0:bind(GAME.WORKBENCH_ITEM_GO, function(arg0, arg1)
		arg0.viewComponent:closeView()
		arg0:sendNotification(GAME.WORKBENCH_ITEM_GO, arg1)
	end)
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

return var0
