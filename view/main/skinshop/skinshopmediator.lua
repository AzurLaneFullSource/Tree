local var0 = class("SkinShopMediator", import("...base.ContextMediator"))

var0.ON_SHOPPING = "SkinShopMediator:ON_SHOPPING"
var0.GO_SHOPS_LAYER = "SkinShopMediator:GO_SHOPS_LAYER"
var0.OPEN_SCENE = "SkinShopMediator:OPEN_SCENE"
var0.OPEN_ACTIVITY = "SkinShopMediator:OPEN_ACTIVITY"
var0.ON_SHOPPING_BY_ACT = "SkinShopMediator:ON_SHOPPING_BY_ACT"
var0.ON_BACKYARD_SHOP = "SkinShopMediator:ON_BACKYARD_SHOP"
var0.ON_ATLAS = "SkinShopMediator:ON_ATLAS"
var0.ON_INDEX = "SkinShopMediator:ON_INDEX"
var0.ON_RECORD_ANIM_PREVIEW_BTN = "SkinShopMediator:ON_RECORD_ANIM_PREVIEW_BTN"

function var0.register(arg0)
	arg0:bind(var0.ON_RECORD_ANIM_PREVIEW_BTN, function(arg0, arg1)
		arg0:sendNotification(GAME.RECORD_SKIN_ANIM_PREVIEW, {
			isOpen = arg1
		})
	end)
	arg0:bind(var0.ON_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = SkinIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.ON_ATLAS, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SKINATALAS)
	end)
	arg0:bind(var0.ON_BACKYARD_SHOP, function(arg0)
		if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
			local var0 = pg.open_systems_limited[1]

			pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0.name, var0.level))

			return
		end

		arg0:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = {
				page = 5
			}
		}))
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
	arg0:bind(var0.ON_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1,
			count = arg2
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

	local var0 = getProxy(ShipSkinProxy):getSkinList()

	arg0.viewComponent:setSkins(var0)

	local var1 = getProxy(PlayerProxy)

	arg0.viewComponent:setPlayer(var1:getData())

	if arg0.contextData.type == SkinShopScene.SHOP_TYPE_TIMELIMIT then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	arg0.viewComponent:SetEncoreSkins(getProxy(ShipSkinProxy):GetEncoreSkins())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SKIN_SHOPPIGN_DONE,
		PlayerProxy.UPDATED,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		GAME.BUY_FURNITURE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == GAME.SKIN_SHOPPIGN_DONE or var0 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var3 = getProxy(ShipSkinProxy):getSkinList()

		arg0.viewComponent:setSkins(var3)
		arg0.viewComponent:onBuyDone(var1.id)
		arg0.viewComponent:updateShipRect()

		local var4 = pg.shop_template[var1.id]

		if var4 and var4.genre == ShopArgs.SkinShop or var4.genre == ShopArgs.SkinShopTimeLimit then
			arg0:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var4.effect_args[1],
					timeLimit = var4.genre == ShopArgs.SkinShopTimeLimit
				}
			}))
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.BUY_FURNITURE_DONE then
		arg0.viewComponent:OnFurnitureUpdate(var2[1])
	end
end

return var0
