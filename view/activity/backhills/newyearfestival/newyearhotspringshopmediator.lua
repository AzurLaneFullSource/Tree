local var0_0 = class("NewYearHotSpringShopMediator", import("view.base.ContextMediator"))

var0_0.ON_ACT_SHOPPING = "NewYearHotSpringShopMediator:ON_ACT_SHOPPING"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.HOTSPRING_SHOP)

	arg0_1:TransActivity2ShopData(var0_1)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		arg0_1:sendNotification(GAME.ACTIVITY_SHOP_PROGRESS_REWARD, {
			activity_id = arg1_2,
			cmd = arg2_2,
			arg1 = arg3_2,
			arg2 = arg4_2
		})
	end)
	arg0_1:bind(GAME.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
end

function var0_0.TransActivity2ShopData(arg0_4, arg1_4)
	if arg1_4 and not arg1_4:isEnd() then
		local var0_4 = ActivityShop.New(arg1_4)

		arg0_4.viewComponent:SetShop(var0_4)

		return var0_4
	end
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_6.id == ActivityConst.HOTSPRING_SHOP then
			local var2_6 = var1_6

			arg0_6:TransActivity2ShopData(var2_6)
			arg0_6.viewComponent:UpdateView()
		end
	elseif var0_6 == ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards, function()
			arg0_6.viewComponent:OnShoppingDone()
			existCall(var1_6.callback)
		end)
	end
end

return var0_0
