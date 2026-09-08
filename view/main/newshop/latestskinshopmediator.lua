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
var0_0.OPEN_GIFT_ACT_LAYER = "LatestSkinShopMediator.OPEN_GIFT_ACT_LAYER"

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
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.PROBABILITY_SKINSHOP, {
			giftPackCommodity = arg1_12,
			skinCommodities = arg2_12,
			skinProbabilitys = arg3_12
		})
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
	arg0_1:bind(var0_0.OPEN_GIFT_ACT_LAYER, function(arg0_18, arg1_18)
		arg0_1:sendNotification(NewShopMainMediator.ON_SUBLAYER_EVENT, {
			NewShopMainMediator.OPEN_GIFT_ACT_LAYER,
			arg1_18
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_19)
	arg0_19.handleDic = {
		[NewShopMainScene.CLOSE_ALL_LAYER] = function(arg0_20, arg1_20)
			arg0_20.viewComponent:closeView()
		end,
		[PlayerProxy.UPDATED] = function(arg0_21, arg1_21)
			arg0_21.viewComponent:SetResource()
		end,
		[GAME.SKIN_SHOPPIGN_DONE] = function(arg0_22, arg1_22)
			local var0_22 = arg1_22:getBody()
			local var1_22 = ShopConst.GetShopConfig(var0_22.id)

			if var1_22 and (var1_22.genre == ShopArgs.SkinShop or var1_22.genre == ShopArgs.SkinShopTimeLimit) then
				local var2_22 = var1_22.effect_args[1]
				local var3_22 = var1_22.genre == ShopArgs.SkinShopTimeLimit

				arg0_22:HandleNewSkin(var0_22.id, var2_22, var3_22)
			end
		end,
		[GAME.SKIN_BY_CHARGE_DONE] = function(arg0_23, arg1_23)
			local var0_23 = arg1_23:getBody()
			local var1_23 = arg0_23.viewComponent.commodities or {}
			local var2_23 = 0

			for iter0_23, iter1_23 in ipairs(var1_23) do
				if var0_23.skinId == iter1_23:getSkinId() then
					var2_23 = iter1_23.id

					break
				end
			end

			print(var0_23.skinId, var2_23)

			if var2_23 > 0 then
				arg0_23:HandleNewSkin(var2_23, var0_23.skinId, false)
			end
		end,
		[GAME.SKIN_COUPON_SHOPPING_DONE] = GAME.SKIN_SHOPPIGN_DONE,
		[GAME.BUY_FURNITURE_DONE] = function(arg0_24, arg1_24)
			local var0_24 = arg1_24:getType()

			arg0_24.viewComponent:OnFurnitureUpdate(var0_24[1])
		end,
		[NewShopMainMediator.NOTI_UPDATE_CURRENT] = function(arg0_25, arg1_25)
			arg0_25.viewComponent:GetAllCommodities()
			arg0_25.viewComponent:Refresh(true)
		end,
		[GAME.CHARGE_OPERATION_DONE] = function(arg0_26, arg1_26)
			local var0_26 = arg1_26:getBody().shopId

			if not getProxy(ShopsProxy):IsSkinTypeCharge(var0_26) then
				arg0_26.viewComponent:closeView()
			end
		end
	}
end

function var0_0.HandleNewSkin(arg0_27, arg1_27, arg2_27, arg3_27)
	if pg.ship_skin_template[arg2_27].skin_type == ShipSkin.SKIN_TYPE_TB then
		arg0_27:addSubLayers(Context.New({
			mediator = NewSkinTBMediator,
			viewComponent = NewSkinTBLayer,
			data = {
				skinId = arg2_27,
				timeLimit = arg3_27
			}
		}))
	elseif PaintingShowScene.GetSkinShowAble(arg2_27) then
		arg0_27:addSubLayers(Context.New({
			mediator = PaintingShowMediator,
			viewComponent = PaintingShowNewSkinScene,
			data = {
				is_shop = true,
				skinId = arg2_27,
				timeLimit = arg3_27
			}
		}))
	else
		arg0_27:addSubLayers(Context.New({
			mediator = NewSkinMediator,
			viewComponent = NewSkinLayer,
			data = {
				skinId = arg2_27,
				timeLimit = arg3_27
			}
		}))
	end

	arg0_27.viewComponent:OnShopping(arg1_27)
	pg.EasyRedDotMgr.GetInstance():TriggerMarks("specialShop")
end

return var0_0
