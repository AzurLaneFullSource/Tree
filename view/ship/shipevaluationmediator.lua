local var0_0 = class("ShipEvaluationMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = getProxy(CollectionProxy)

	arg0_1.showTrans = arg0_1.contextData.showTrans
	arg0_1.groupId = arg0_1.contextData.groupId

	local var1_1 = var0_1:getShipGroup(arg0_1.groupId)

	arg0_1.viewComponent:setShipGroup(var1_1)
	arg0_1.viewComponent:setShowTrans(arg0_1.showTrans)
	arg0_1.viewComponent:flushAll()
	arg0_1:bind(ShipEvaluationLayer.EVENT_LIKE, function(arg0_2)
		arg0_1:sendNotification(GAME.LIKE_SHIP, arg0_1.groupId)
	end)
	arg0_1:bind(ShipEvaluationLayer.EVENT_EVA, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.EVALUATE_SHIP, {
			groupId = arg0_1.groupId,
			content = arg1_3
		})
	end)
	arg0_1:bind(ShipEvaluationLayer.EVENT_ZAN, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.ZAN_SHIP_EVALUATION, {
			groupId = arg0_1.groupId,
			evaId = arg1_4,
			operation = arg2_4
		})
	end)
	arg0_1:bind(ShipEvaluationLayer.EVENT_IMPEACH, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.IMPEACH_SHIP_EVALUATION, {
			groupId = arg0_1.groupId,
			evaId = arg1_5,
			reason = arg2_5
		})
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		CollectionProxy.GROUP_INFO_UPDATE,
		CollectionProxy.GROUP_EVALUATION_UPDATE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == CollectionProxy.GROUP_INFO_UPDATE then
		local var2_7 = var1_7

		if arg0_7.groupId == var2_7 then
			local var3_7 = getProxy(CollectionProxy):getShipGroup(var2_7)

			arg0_7.viewComponent:setShipGroup(var3_7)
			arg0_7.viewComponent:flushHeart()
		end
	elseif var0_7 == CollectionProxy.GROUP_EVALUATION_UPDATE then
		local var4_7 = var1_7

		if arg0_7.groupId == var4_7 then
			local var5_7 = getProxy(CollectionProxy):getShipGroup(var4_7)

			arg0_7.viewComponent:setShipGroup(var5_7)
			arg0_7.viewComponent:flushEva()
		end
	end
end

return var0_0
