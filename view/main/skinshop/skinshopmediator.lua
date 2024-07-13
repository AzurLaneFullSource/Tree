local var0_0 = class("SkinShopMediator", import("...base.ContextMediator"))

var0_0.ON_SHOPPING = "SkinShopMediator:ON_SHOPPING"
var0_0.GO_SHOPS_LAYER = "SkinShopMediator:GO_SHOPS_LAYER"
var0_0.OPEN_SCENE = "SkinShopMediator:OPEN_SCENE"
var0_0.OPEN_ACTIVITY = "SkinShopMediator:OPEN_ACTIVITY"
var0_0.ON_SHOPPING_BY_ACT = "SkinShopMediator:ON_SHOPPING_BY_ACT"
var0_0.ON_BACKYARD_SHOP = "SkinShopMediator:ON_BACKYARD_SHOP"
var0_0.ON_ATLAS = "SkinShopMediator:ON_ATLAS"
var0_0.ON_INDEX = "SkinShopMediator:ON_INDEX"
var0_0.ON_RECORD_ANIM_PREVIEW_BTN = "SkinShopMediator:ON_RECORD_ANIM_PREVIEW_BTN"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_RECORD_ANIM_PREVIEW_BTN, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.RECORD_SKIN_ANIM_PREVIEW, {
			isOpen = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_INDEX, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = SkinIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_3
		}))
	end)
	arg0_1:bind(var0_0.ON_ATLAS, function(arg0_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SKINATALAS)
	end)
	arg0_1:bind(var0_0.ON_BACKYARD_SHOP, function(arg0_5)
		if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
			local var0_5 = pg.open_systems_limited[1]

			pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_5.name, var0_5.level))

			return
		end

		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = {
				page = 5
			}
		}))
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
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_8, arg1_8, arg2_8)
		arg0_1:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1_8,
			count = arg2_8
		})
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg1_9
		})
	end)
	arg0_1:bind(var0_0.OPEN_SCENE, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_10[1], arg1_10[2])
	end)

	local var0_1 = getProxy(ShipSkinProxy):getSkinList()

	arg0_1.viewComponent:setSkins(var0_1)

	local var1_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var1_1:getData())

	if arg0_1.contextData.type == SkinShopScene.SHOP_TYPE_TIMELIMIT then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	arg0_1.viewComponent:SetEncoreSkins(getProxy(ShipSkinProxy):GetEncoreSkins())
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		GAME.SKIN_SHOPPIGN_DONE,
		PlayerProxy.UPDATED,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		GAME.BUY_FURNITURE_DONE
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()
	local var2_12 = arg1_12:getType()

	if var0_12 == GAME.SKIN_SHOPPIGN_DONE or var0_12 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var3_12 = getProxy(ShipSkinProxy):getSkinList()

		arg0_12.viewComponent:setSkins(var3_12)
		arg0_12.viewComponent:onBuyDone(var1_12.id)
		arg0_12.viewComponent:updateShipRect()

		local var4_12 = pg.shop_template[var1_12.id]

		if var4_12 and var4_12.genre == ShopArgs.SkinShop or var4_12.genre == ShopArgs.SkinShopTimeLimit then
			arg0_12:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var4_12.effect_args[1],
					timeLimit = var4_12.genre == ShopArgs.SkinShopTimeLimit
				}
			}))
		end
	elseif var0_12 == PlayerProxy.UPDATED then
		arg0_12.viewComponent:setPlayer(var1_12)
	elseif var0_12 == GAME.BUY_FURNITURE_DONE then
		arg0_12.viewComponent:OnFurnitureUpdate(var2_12[1])
	end
end

return var0_0
