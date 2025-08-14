local var0_0 = class("LatestSkinShopMediator", import("...base.ContextMediator"))

var0_0.ON_RECORD_ANIM_PREVIEW_BTN = "LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN"
var0_0.OPEN_ACTIVITY = "LatestSkinShopMediator.OPEN_ACTIVITY"
var0_0.ON_SHOPPING_BY_ACT = "LatestSkinShopMediator.ON_SHOPPING_BY_ACT"
var0_0.ON_SHOPPING = "LatestSkinShopMediator.ON_SHOPPING"
var0_0.ON_ITEM_PURCHASE = "LatestSkinShopMediator.ON_ITEM_PURCHASE"
var0_0.GO_SHOPS_LAYER = "LatestSkinShopMediator.GO_SHOPS_LAYER"
var0_0.OPEN_SCENE = "LatestSkinShopMediator.OPEN_SCENE"
var0_0.ON_BACKYARD_SHOP = "LatestSkinShopMediator.ON_BACKYARD_SHOP"
var0_0.ON_ITEM_EXPERIENCE = "LatestSkinShopMediator.ON_ITEM_EXPERIENCE"
var0_0.OPEN_OWN_SKIN_LAYER = "LatestSkinShopMediator.OPEN_OWN_SKIN_LAYER"
var0_0.OPEN_GIFT_PACK_LAYER = "LatestSkinShopMediator.OPEN_GIFT_PACK_LAYER"
var0_0.OPEN_CHARGE_BIRTHDAY = "LatestSkinShopMediator:OPEN_CHARGE_BIRTHDAY"
var0_0.CHARGE = "LatestSkinShopMediator:CHARGE"
var0_0.OPEN_CHARGE_ITEM_PANEL = "LatestSkinShopMediator:OPEN_CHARGE_ITEM_PANEL"
var0_0.OPEN_CHARGE_ITEM_BOX = "LatestSkinShopMediator:OPEN_CHARGE_ITEM_BOX"
var0_0.BUY_ITEM = "LatestSkinShopMediator:BUY_ITEM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_RECORD_ANIM_PREVIEW_BTN, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.RECORD_SKIN_ANIM_PREVIEW, {
			isOpen = arg1_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_ACTIVITY, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_SHOPPING_BY_ACT, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.SKIN_COUPON_SHOPPING, {
			shopId = arg1_4,
			cnt = arg2_4
		})
	end)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1_5,
			count = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_ITEM_PURCHASE, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			count = 1,
			id = arg1_6,
			arg = {
				arg2_6
			}
		})
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg1_7
		})
	end)
	arg0_1:bind(var0_0.OPEN_SCENE, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_8[1], arg1_8[2])
	end)
	arg0_1:bind(var0_0.ON_BACKYARD_SHOP, function(arg0_9)
		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = {
				topLayer = true,
				page = 5
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_ITEM_EXPERIENCE, function(arg0_10, arg1_10, arg2_10, arg3_10)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_10,
			count = arg3_10,
			arg = {
				arg2_10
			}
		})
	end)
	arg0_1:bind(var0_0.OPEN_OWN_SKIN_LAYER, function(arg0_11, arg1_11, arg2_11, arg3_11)
		arg0_1:addSubLayers(Context.New({
			viewComponent = NewSkinAtlasLayer,
			mediator = NewSkinAtlasMediator
		}))
	end)
	arg0_1:bind(var0_0.OPEN_GIFT_PACK_LAYER, function(arg0_12, arg1_12, arg2_12, arg3_12)
		arg0_1:addSubLayers(Context.New({
			viewComponent = LatestSkinGiftPackLayer,
			mediator = LatestSkinGiftPackMediator,
			data = {
				giftPackCommodity = arg1_12,
				skinCommodities = arg2_12,
				skinProbabilitys = arg3_12
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_13, arg1_13)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_14
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_15, arg1_15)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_15
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_BOX, function(arg0_16, arg1_16)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemBoxMediator,
			viewComponent = ChargeItemBoxLayer,
			data = {
				panelConfig = arg1_16
			}
		}))
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_17, arg1_17, arg2_17)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_17,
			count = arg2_17
		})
	end)
end

function var0_0.listNotificationInterests(arg0_18)
	return {
		NewShopMainScene.CLOSE_ALL_LAYER,
		PlayerProxy.UPDATED,
		GAME.SKIN_SHOPPIGN_DONE,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		GAME.BUY_FURNITURE_DONE
	}
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()
	local var2_19 = arg1_19:getType()

	if var0_19 == NewShopMainScene.CLOSE_ALL_LAYER then
		arg0_19.viewComponent:closeView()
	elseif var0_19 == PlayerProxy.UPDATED then
		arg0_19.viewComponent:SetResource()
	elseif var0_19 == GAME.SKIN_SHOPPIGN_DONE or var0_19 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var3_19 = pg.shop_template[var1_19.id]

		if var3_19 and (var3_19.genre == ShopArgs.SkinShop or var3_19.genre == ShopArgs.SkinShopTimeLimit) then
			local var4_19 = var3_19.effect_args[1]

			if pg.ship_skin_template[var4_19].skin_type == ShipSkin.SKIN_TYPE_TB then
				arg0_19:addSubLayers(Context.New({
					mediator = NewSkinTBMediator,
					viewComponent = NewSkinTBLayer,
					data = {
						skinId = var3_19.effect_args[1],
						timeLimit = var3_19.genre == ShopArgs.SkinShopTimeLimit
					}
				}))
			else
				local function var5_19()
					arg0_19:addSubLayers(Context.New({
						mediator = NewSkinMediator,
						viewComponent = NewSkinLayer,
						data = {
							skinId = var3_19.effect_args[1],
							timeLimit = var3_19.genre == ShopArgs.SkinShopTimeLimit
						}
					}))
				end

				if PaintingShowScene.GetSkinShowAble(var4_19) then
					arg0_19:addSubLayers(Context.New({
						mediator = PaintingShowMediator,
						viewComponent = PaintingShowScene,
						data = {
							skinId = var4_19,
							callback = var5_19
						}
					}))
				else
					var5_19()
				end
			end

			arg0_19.viewComponent:OnShopping(var1_19.id)
		end
	elseif var0_19 == GAME.BUY_FURNITURE_DONE then
		arg0_19.viewComponent:OnFurnitureUpdate(var2_19[1])
	end
end

return var0_0
