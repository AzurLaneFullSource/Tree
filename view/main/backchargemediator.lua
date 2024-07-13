local var0_0 = class("BackChargeMediator", import("..base.ContextMediator"))

var0_0.CHARGE = "BackChargeMediator:CHARGE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = getProxy(ShopsProxy):getChargedList()

	if var1_1 then
		arg0_1.viewComponent:setChargedList(var1_1)
	end

	arg0_1:bind(var0_0.CHARGE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.REFUND_CHHARGE, {
			shopId = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		PlayerProxy.UPDATED,
		GAME.CHARGE_SUCCESS,
		GAME.REFUND_INFO_UPDATE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == PlayerProxy.UPDATED then
		-- block empty
	elseif var0_4 == ShopsProxy.CHARGED_LIST_UPDATED then
		-- block empty
	elseif var0_4 == GAME.CHARGE_CONFIRM_FAILED then
		-- block empty
	elseif var0_4 == GAME.CHARGE_SUCCESS then
		arg0_4:sendNotification(GAME.GET_REFUND_INFO)
	elseif var0_4 == GAME.REFUND_INFO_UPDATE then
		arg0_4.viewComponent:refundUpdate()
	end
end

return var0_0
