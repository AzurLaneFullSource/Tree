local var0 = class("NewSkinShopMediator", import("view.base.ContextMediator"))

var0.ON_ATLAS = "NewSkinShopMediator:ON_ATLAS"
var0.ON_INDEX = "NewSkinShopMediator:ON_INDEX"
var0.ON_BACKYARD_SHOP = "NewSkinShopMediator:ON_BACKYARD_SHOP"
var0.GO_SHOPS_LAYER = "NewSkinShopMediator:GO_SHOPS_LAYER"
var0.OPEN_SCENE = "NewSkinShopMediator:OPEN_SCENE"
var0.OPEN_ACTIVITY = "NewSkinShopMediator:OPEN_ACTIVITY"
var0.ON_SHOPPING_BY_ACT = "NewSkinShopMediator:ON_SHOPPING_BY_ACT"
var0.ON_SHOPPING = "NewSkinShopMediator:ON_SHOPPING"
var0.ON_RECORD_ANIM_PREVIEW_BTN = "NewSkinShopMediator:ON_RECORD_ANIM_PREVIEW_BTN"
var0.ON_ITEM_PURCHASE = "NewSkinShopMediator:ON_ITEM_PURCHASE"

function var0.register(arg0)
	arg0:bind(var0.ON_ITEM_PURCHASE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.USE_ITEM, {
			count = 1,
			id = arg1,
			arg = {
				arg2
			}
		})
	end)
	arg0:bind(var0.ON_RECORD_ANIM_PREVIEW_BTN, function(arg0, arg1)
		arg0:sendNotification(GAME.RECORD_SKIN_ANIM_PREVIEW, {
			isOpen = arg1
		})
	end)
	arg0:bind(var0.ON_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.ON_SHOPPING_BY_ACT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SKIN_COUPON_SHOPPING, {
			shopId = arg1,
			cnt = arg2
		})
	end)
	arg0:bind(var0.OPEN_ACTIVITY, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1
		})
	end)
	arg0:bind(var0.GO_SHOPS_LAYER, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg1
		})
	end)
	arg0:bind(var0.OPEN_SCENE, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, arg1[1], arg1[2])
	end)
	arg0:bind(var0.ON_BACKYARD_SHOP, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = {
				topLayer = true,
				page = 5
			}
		}))
	end)
	arg0:bind(var0.ON_ATLAS, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SKINATALAS)
	end)
	arg0:bind(var0.ON_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = SkinIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SKIN_SHOPPIGN_DONE,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		GAME.BUY_FURNITURE_DONE,
		GAME.LOAD_LAYERS,
		GAME.REMOVE_LAYERS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == GAME.SKIN_SHOPPIGN_DONE or var0 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var3 = pg.shop_template[var1.id]

		if var3 and (var3.genre == ShopArgs.SkinShop or var3.genre == ShopArgs.SkinShopTimeLimit) then
			arg0:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var3.effect_args[1],
					timeLimit = var3.genre == ShopArgs.SkinShopTimeLimit
				}
			}))
			arg0.viewComponent:OnShopping(var1.id)
		end
	elseif var0 == GAME.BUY_FURNITURE_DONE then
		arg0.viewComponent:OnFurnitureUpdate(var2[1])
	elseif var0 == GAME.LOAD_LAYERS then
		if var1.context.mediator == NewBackYardShopMediator then
			arg0:sendNotification(PlayerResUI.HIDE)
		end
	elseif var0 == GAME.REMOVE_LAYERS and var1.context.mediator == NewBackYardShopMediator then
		arg0:sendNotification(PlayerResUI.SHOW)
	end
end

return var0
