local var0 = class("AssignedShipMediator", import("...base.ContextMediator"))

var0.ON_USE_ITEM = "AssignedShipMediator:ON_USE_ITEM"

function var0.register(arg0)
	arg0:bind(var0.ON_USE_ITEM, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.USE_ITEM, {
			id = arg1,
			count = arg2,
			arg = arg3
		})
	end)
	arg0.viewComponent:setItemVO(arg0.contextData.itemVO)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.USE_ITEM_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.USE_ITEM_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			triggerButton(arg0.viewComponent.backBtn)
		end)
	end
end

return var0
