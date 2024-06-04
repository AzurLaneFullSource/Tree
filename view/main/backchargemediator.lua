local var0 = class("BackChargeMediator", import("..base.ContextMediator"))

var0.CHARGE = "BackChargeMediator:CHARGE"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var0)

	local var1 = getProxy(ShopsProxy):getChargedList()

	if var1 then
		arg0.viewComponent:setChargedList(var1)
	end

	arg0:bind(var0.CHARGE, function(arg0, arg1)
		arg0:sendNotification(GAME.REFUND_CHHARGE, {
			shopId = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.CHARGE_SUCCESS,
		GAME.REFUND_INFO_UPDATE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		-- block empty
	elseif var0 == ShopsProxy.CHARGED_LIST_UPDATED then
		-- block empty
	elseif var0 == GAME.CHARGE_CONFIRM_FAILED then
		-- block empty
	elseif var0 == GAME.CHARGE_SUCCESS then
		arg0:sendNotification(GAME.GET_REFUND_INFO)
	elseif var0 == GAME.REFUND_INFO_UPDATE then
		arg0.viewComponent:refundUpdate()
	end
end

return var0
