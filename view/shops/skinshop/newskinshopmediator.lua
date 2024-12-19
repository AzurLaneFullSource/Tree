local var0_0 = class("NewSkinShopMediator", import("view.base.ContextMediator"))

var0_0.ON_ATLAS = "NewSkinShopMediator:ON_ATLAS"
var0_0.ON_INDEX = "NewSkinShopMediator:ON_INDEX"
var0_0.ON_BACKYARD_SHOP = "NewSkinShopMediator:ON_BACKYARD_SHOP"
var0_0.GO_SHOPS_LAYER = "NewSkinShopMediator:GO_SHOPS_LAYER"
var0_0.OPEN_SCENE = "NewSkinShopMediator:OPEN_SCENE"
var0_0.OPEN_ACTIVITY = "NewSkinShopMediator:OPEN_ACTIVITY"
var0_0.ON_SHOPPING_BY_ACT = "NewSkinShopMediator:ON_SHOPPING_BY_ACT"
var0_0.ON_SHOPPING = "NewSkinShopMediator:ON_SHOPPING"
var0_0.ON_RECORD_ANIM_PREVIEW_BTN = "NewSkinShopMediator:ON_RECORD_ANIM_PREVIEW_BTN"
var0_0.ON_ITEM_PURCHASE = "NewSkinShopMediator:ON_ITEM_PURCHASE"
var0_0.ON_ITEM_EXPERIENCE = "NewSkinShopMediator:ON_ITEM_EXPERIENCE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ITEM_EXPERIENCE, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_2,
			count = arg3_2,
			arg = {
				arg2_2
			}
		})
	end)
	arg0_1:bind(var0_0.ON_ITEM_PURCHASE, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			count = 1,
			id = arg1_3,
			arg = {
				arg2_3
			}
		})
	end)
	arg0_1:bind(var0_0.ON_RECORD_ANIM_PREVIEW_BTN, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.RECORD_SKIN_ANIM_PREVIEW, {
			isOpen = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1_5,
			count = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_SHOPPING_BY_ACT, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.SKIN_COUPON_SHOPPING, {
			shopId = arg1_6,
			cnt = arg2_6
		})
	end)
	arg0_1:bind(var0_0.OPEN_ACTIVITY, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1_7
		})
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg1_8
		})
	end)
	arg0_1:bind(var0_0.OPEN_SCENE, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_9[1], arg1_9[2])
	end)
	arg0_1:bind(var0_0.ON_BACKYARD_SHOP, function(arg0_10)
		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = {
				topLayer = true,
				page = 5
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_ATLAS, function(arg0_11)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SKINATALAS)
	end)
	arg0_1:bind(var0_0.ON_INDEX, function(arg0_12, arg1_12)
		arg0_1:addSubLayers(Context.New({
			viewComponent = SkinIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_12
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_13)
	return {
		GAME.SKIN_SHOPPIGN_DONE,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		GAME.BUY_FURNITURE_DONE,
		GAME.LOAD_LAYERS,
		GAME.REMOVE_LAYERS
	}
end

function var0_0.handleNotification(arg0_14, arg1_14)
	local var0_14 = arg1_14:getName()
	local var1_14 = arg1_14:getBody()
	local var2_14 = arg1_14:getType()

	if var0_14 == GAME.SKIN_SHOPPIGN_DONE or var0_14 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var3_14 = pg.shop_template[var1_14.id]

		if var3_14 and (var3_14.genre == ShopArgs.SkinShop or var3_14.genre == ShopArgs.SkinShopTimeLimit) then
			arg0_14:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var3_14.effect_args[1],
					timeLimit = var3_14.genre == ShopArgs.SkinShopTimeLimit
				}
			}))
			arg0_14.viewComponent:OnShopping(var1_14.id)
		end
	elseif var0_14 == GAME.BUY_FURNITURE_DONE then
		arg0_14.viewComponent:OnFurnitureUpdate(var2_14[1])
	elseif var0_14 == GAME.LOAD_LAYERS then
		if var1_14.context.mediator == NewBackYardShopMediator then
			arg0_14:sendNotification(PlayerResUI.HIDE)
		end
	elseif var0_14 == GAME.REMOVE_LAYERS and var1_14.context.mediator == NewBackYardShopMediator then
		arg0_14:sendNotification(PlayerResUI.SHOW)
	end
end

return var0_0
