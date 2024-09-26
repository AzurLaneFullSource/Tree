local var0_0 = class("Dorm3dFurnitureSelectMediator", import("view.base.ContextMediator"))

var0_0.SHOW_CONFIRM_WINDOW = "SHOW_CONFIRM_WINDOW"
var0_0.SHOW_FURNITURE_ACESSES = "SHOW_FURNITURE_ACESSES"
var0_0.OPEN_DROP_LAYER = "OPEN_DROP_LAYER"
var0_0.SHOW_SHOPPING_CONFIRM_WINDOW = "SHOW_SHOPPING_CONFIRM_WINDOW"

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.APARTMENT_REPLACE_FURNITURE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.APARTMENT_REPLACE_FURNITURE, arg1_2)
	end)
	arg0_1:bind(var0_0.SHOW_CONFIRM_WINDOW, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureConfirmWindowMediator,
			viewComponent = Dorm3dFurnitureConfirmWindow,
			data = arg1_3
		}))
	end)
	arg0_1:bind(var0_0.SHOW_FURNITURE_ACESSES, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureAcessesWindowMediator,
			viewComponent = Dorm3dFurnitureAcessesWindow,
			data = arg1_4
		}))
	end)
	arg0_1:bind(var0_0.SHOW_SHOPPING_CONFIRM_WINDOW, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dShoppingConfirmWindowMediator,
			viewComponent = Dorm3dShoppingConfirmWindow,
			data = arg1_5
		}))
	end)
	arg0_1:bind(GAME.SHOPPING, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_6.shopId,
			count = arg1_6.count,
			silentTip = arg1_6.silentTip
		})
	end)
	arg0_1:bind(var0_0.OPEN_DROP_LAYER, function(arg0_7, arg1_7, arg2_7)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dAwardInfoLayer,
			mediator = Dorm3dAwardInfoMediator,
			data = {
				items = arg1_7
			},
			onRemoved = arg2_7
		}))
	end)

	local var0_1 = pg.m02:retrieveMediator(Dorm3dRoomMediator.__cname):getViewComponent()

	arg0_1.viewComponent:SetSceneRoot(var0_1)
	arg0_1.viewComponent:SetRoom(var0_1.room)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT,
		GAME.APARTMENT_REPLACE_FURNITURE_DONE,
		GAME.APARTMENT_REPLACE_FURNITURE_ERROR,
		GAME.SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == ApartmentProxy.UPDATE_ROOM then
		-- block empty
	elseif var0_9 == Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT then
		arg0_9.viewComponent:OnClickFurnitureSlot(var1_9)
	elseif var0_9 == GAME.APARTMENT_REPLACE_FURNITURE_DONE then
		arg0_9.viewComponent:OnReplaceFurnitureDone()
	elseif var0_9 == GAME.APARTMENT_REPLACE_FURNITURE_ERROR then
		arg0_9.viewComponent:OnReplaceFurnitureError()
	elseif var0_9 == GAME.SHOPPING_DONE then
		local var2_9 = var1_9.awards

		if var2_9 and #var2_9 > 0 then
			arg0_9.viewComponent:emit(var0_0.OPEN_DROP_LAYER, var2_9, function()
				local var0_10 = arg1_9:getBody().id
				local var1_10 = pg.shop_template[var0_10].effect_args[1]

				arg0_9.viewComponent.room:AddFurnitureByID(var1_10)
				arg0_9.viewComponent:UpdateDataDisplayFurnitures()
				arg0_9.viewComponent:UpdateView()
			end)
		end
	end
end

function var0_0.remove(arg0_11)
	return
end

return var0_0
