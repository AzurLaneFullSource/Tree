local var0 = class("ShipEvaluationMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	local var0 = getProxy(CollectionProxy)

	arg0.showTrans = arg0.contextData.showTrans
	arg0.groupId = arg0.contextData.groupId

	local var1 = var0:getShipGroup(arg0.groupId)

	arg0.viewComponent:setShipGroup(var1)
	arg0.viewComponent:setShowTrans(arg0.showTrans)
	arg0.viewComponent:flushAll()
	arg0:bind(ShipEvaluationLayer.EVENT_LIKE, function(arg0)
		arg0:sendNotification(GAME.LIKE_SHIP, arg0.groupId)
	end)
	arg0:bind(ShipEvaluationLayer.EVENT_EVA, function(arg0, arg1)
		arg0:sendNotification(GAME.EVALUATE_SHIP, {
			groupId = arg0.groupId,
			content = arg1
		})
	end)
	arg0:bind(ShipEvaluationLayer.EVENT_ZAN, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.ZAN_SHIP_EVALUATION, {
			groupId = arg0.groupId,
			evaId = arg1,
			operation = arg2
		})
	end)
	arg0:bind(ShipEvaluationLayer.EVENT_IMPEACH, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.IMPEACH_SHIP_EVALUATION, {
			groupId = arg0.groupId,
			evaId = arg1,
			reason = arg2
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		CollectionProxy.GROUP_INFO_UPDATE,
		CollectionProxy.GROUP_EVALUATION_UPDATE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == CollectionProxy.GROUP_INFO_UPDATE then
		local var2 = var1

		if arg0.groupId == var2 then
			local var3 = getProxy(CollectionProxy):getShipGroup(var2)

			arg0.viewComponent:setShipGroup(var3)
			arg0.viewComponent:flushHeart()
		end
	elseif var0 == CollectionProxy.GROUP_EVALUATION_UPDATE then
		local var4 = var1

		if arg0.groupId == var4 then
			local var5 = getProxy(CollectionProxy):getShipGroup(var4)

			arg0.viewComponent:setShipGroup(var5)
			arg0.viewComponent:flushEva()
		end
	end
end

return var0
