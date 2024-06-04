local var0 = class("BackyardFeedMediator", import("...base.ContextMediator"))

var0.USE_FOOD = "BackyardFeedMediator:USE_FOOD"
var0.BUY_FOOD = "BackyardFeedMediator:BUY_FOOD"
var0.EXTEND = "BackyardFeedMediator:EXTEND"

function var0.register(arg0)
	local var0 = getProxy(SettingsProxy)

	arg0:bind(var0.USE_FOOD, function(arg0, arg1, arg2, arg3)
		if arg3 then
			var0:setBackyardRemind()
			arg0.viewComponent:SetIsRemind(var0:getBackyardRemind())
		end

		arg0:sendNotification(GAME.USE_ITEM, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.BUY_FOOD, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.EXTEND, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0.viewComponent:SetIsRemind(var0:getBackyardRemind())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ADD_FOOD_DONE,
		DormProxy.DORM_UPDATEED,
		GAME.SHOPPING_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == GAME.ADD_FOOD_DONE then
		arg0.viewComponent:OnUsageItem(var1.id)
	elseif var0 == DormProxy.DORM_UPDATEED and var2 == BackYardConst.DORM_UPDATE_TYPE_USEFOOD then
		arg0.viewComponent:OnDormUpdated()
	elseif var0 == GAME.SHOPPING_DONE then
		arg0.viewComponent:OnShopDone()
	end
end

return var0
