local var0_0 = class("BackyardFeedMediator", import("...base.ContextMediator"))

var0_0.USE_FOOD = "BackyardFeedMediator:USE_FOOD"
var0_0.BUY_FOOD = "BackyardFeedMediator:BUY_FOOD"
var0_0.EXTEND = "BackyardFeedMediator:EXTEND"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(SettingsProxy)

	arg0_1:bind(var0_0.USE_FOOD, function(arg0_2, arg1_2, arg2_2, arg3_2)
		if arg3_2 then
			var0_1:setBackyardRemind()
			arg0_1.viewComponent:SetIsRemind(var0_1:getBackyardRemind())
		end

		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_2,
			count = arg2_2
		})
	end)
	arg0_1:bind(var0_0.BUY_FOOD, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_3,
			count = arg2_3
		})
	end)
	arg0_1:bind(var0_0.EXTEND, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_4,
			count = arg2_4
		})
	end)
	arg0_1.viewComponent:SetIsRemind(var0_1:getBackyardRemind())
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.ADD_FOOD_DONE,
		DormProxy.DORM_UPDATEED,
		GAME.SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()
	local var2_6 = arg1_6:getType()

	if var0_6 == GAME.ADD_FOOD_DONE then
		arg0_6.viewComponent:OnUsageItem(var1_6.id)
	elseif var0_6 == DormProxy.DORM_UPDATEED and var2_6 == BackYardConst.DORM_UPDATE_TYPE_USEFOOD then
		arg0_6.viewComponent:OnDormUpdated()
	elseif var0_6 == GAME.SHOPPING_DONE then
		arg0_6.viewComponent:OnShopDone()
	end
end

return var0_0
