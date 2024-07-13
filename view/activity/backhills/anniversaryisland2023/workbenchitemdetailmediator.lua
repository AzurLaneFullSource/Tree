local var0_0 = class("WorkBenchItemDetailMediator", import("view.base.ContextMediator"))

var0_0.SHOW_DETAIL = "SHOW_DETAIL"

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.WORKBENCH_ITEM_GO, function(arg0_2, arg1_2)
		arg0_1.viewComponent:closeView()
		arg0_1:sendNotification(GAME.WORKBENCH_ITEM_GO, arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == nil then
		-- block empty
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
