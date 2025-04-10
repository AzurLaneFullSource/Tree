local var0_0 = class("Dorm3dShopMediator", import("view.base.ContextMediator"))

var0_0.OPEN_DETAIL = "Dorm3dShopMediator.OPEN_DETAIL"
var0_0.SHOW_SHOPPING_CONFIRM_WINDOW = "Dorm3dShopMediator.SHOW_SHOPPING_CONFIRM_WINDOW"
var0_0.OPEN_ROOM_UNLOCK_WINDOW = "Dorm3dShopMediator.OPEN_ROOM_UNLOCK_WINDOW"
var0_0.OPEN_DROP_LAYER = "Dorm3dShopMediator.OPEN_DROP_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_DETAIL, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dShopDetailWindow,
			mediator = Dorm3dShopDetailMediator,
			data = {
				shopCfg = arg1_2,
				groupId = arg2_2,
				changeCount = arg3_2
			}
		}))
	end)
	arg0_1:bind(var0_0.SHOW_SHOPPING_CONFIRM_WINDOW, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dShoppingConfirmWindow,
			mediator = Dorm3dShoppingConfirmWindowMediator,
			data = arg1_3
		}))
	end)
	arg0_1:bind(var0_0.OPEN_ROOM_UNLOCK_WINDOW, function(arg0_4, arg1_4, arg2_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dRoomUnlockWindow,
			mediator = Dorm3dRoomUnlockWindowMediator,
			data = {
				roomId = arg1_4,
				groupId = arg2_4
			}
		}))
	end)
	arg0_1:bind(GAME.SHOPPING, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_5.shopId,
			count = arg1_5.count,
			silentTip = arg1_5.silentTip
		})
	end)
	arg0_1:bind(var0_0.OPEN_DROP_LAYER, function(arg0_6, arg1_6, arg2_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dAwardInfoLayer,
			mediator = Dorm3dAwardInfoMediator,
			data = {
				items = arg1_6
			},
			onRemoved = arg2_6
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		PlayerProxy.UPDATED,
		GAME.SHOPPING_DONE,
		GAME.APARTMENT_ROOM_INVITE_UNLOCK_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == PlayerProxy.UPDATED then
		arg0_8.viewComponent:ShowResUI()
	elseif var0_8 == GAME.SHOPPING_DONE then
		local var2_8 = arg1_8:getBody().awards

		for iter0_8, iter1_8 in ipairs(var2_8) do
			iter1_8.count = arg0_8.viewComponent.showCount
		end

		if var2_8 and #var2_8 > 0 then
			arg0_8.viewComponent:emit(var0_0.OPEN_DROP_LAYER, var2_8, function()
				local var0_9 = var1_8.id
				local var1_9 = pg.shop_template[var0_9]
			end)
		end

		arg0_8.viewComponent:SetPageBtns()
		arg0_8.viewComponent:RefreshPage()
	elseif var0_8 == GAME.APARTMENT_ROOM_INVITE_UNLOCK_DONE then
		arg0_8.viewComponent:SetPageBtns()
		arg0_8.viewComponent:RefreshPage()
	end
end

return var0_0
