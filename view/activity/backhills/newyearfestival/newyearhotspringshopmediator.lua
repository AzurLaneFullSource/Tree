local var0 = class("NewYearHotSpringShopMediator", import("view.base.ContextMediator"))

var0.ON_ACT_SHOPPING = "NewYearHotSpringShopMediator:ON_ACT_SHOPPING"

function var0.register(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.HOTSPRING_SHOP)

	arg0:TransActivity2ShopData(var0)
	arg0:bind(var0.ON_ACT_SHOPPING, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.ACTIVITY_SHOP_PROGRESS_REWARD, {
			activity_id = arg1,
			cmd = arg2,
			arg1 = arg3,
			arg2 = arg4
		})
	end)
	arg0:bind(GAME.GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
end

function var0.TransActivity2ShopData(arg0, arg1)
	if arg1 and not arg1:isEnd() then
		local var0 = ActivityShop.New(arg1)

		arg0.viewComponent:SetShop(var0)

		return var0
	end
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1.id == ActivityConst.HOTSPRING_SHOP then
			local var2 = var1

			arg0:TransActivity2ShopData(var2)
			arg0.viewComponent:UpdateView()
		end
	elseif var0 == ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, function()
			arg0.viewComponent:OnShoppingDone()
			existCall(var1.callback)
		end)
	end
end

return var0
