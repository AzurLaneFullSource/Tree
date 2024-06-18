local var0_0 = class("AssignedShipMediator", import("...base.ContextMediator"))

var0_0.ON_USE_ITEM = "AssignedShipMediator:ON_USE_ITEM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_USE_ITEM, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_2,
			count = arg2_2,
			arg = arg3_2
		})
	end)
	arg0_1.viewComponent:setItemVO(arg0_1.contextData.itemVO)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.USE_ITEM_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.USE_ITEM_DONE then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4, function()
			triggerButton(arg0_4.viewComponent.backBtn)
		end)
	end
end

return var0_0
