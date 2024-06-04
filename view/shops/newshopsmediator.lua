local var0 = class("NewShopsMediator", import("..base.ContextMediator"))

var0.ON_SHOPPING = "NewShopsMediator:ON_SHOPPING"
var0.REFRESH_STREET_SHOP = "NewShopsMediator:REFRESH_STREET_SHOP"
var0.REFRESH_MILITARY_SHOP = "NewShopsMediator:REFRESH_MILITARY_SHOP"
var0.ON_SHAM_SHOPPING = "NewShopsMediator:ON_SHAM_SHOPPING"
var0.ON_FRAGMENT_SHOPPING = "NewShopsMediator:ON_FRAGMENT_SHOPPING"
var0.ON_ACT_SHOPPING = "NewShopsMediator:ON_ACT_SHOPPING"
var0.SELL_BLUEPRINT = "NewShopsMediator:SELL_BLUEPRINT"
var0.GO_MALL = "NewShopsMediator:GO_MALL"
var0.ON_SKIN_SHOP = "NewShopsMediator:ON_SKIN_SHOP"
var0.SET_PLAYER_FLAG = "NewShopsMediator:SET_PLAYER_FLAG"
var0.ON_GUILD_SHOPPING = "NewShopsMediator:ON_GUILD_SHOPPING"
var0.ON_MEDAL_SHOPPING = "NewShopsMediator:ON_MEDAL_SHOPPING"
var0.REFRESH_GUILD_SHOP = "NewShopsMediator:REFRESH_GUILD_SHOP"
var0.REFRESH_MEDAL_SHOP = "NewShopsMediator:REFRESH_MEDAL_SHOP"
var0.ON_GUILD_PURCHASE = "NewShopsMediator:ON_GUILD_PURCHASE"
var0.ON_META_SHOP = "NewShopsMediator:ON_META_SHOP"
var0.ON_ESKIN_PREVIEW = "NewShopsMediator:ON_ESKIN_PREVIEW"
var0.ON_QUOTA_SHOPPING = "NewShopsMediator:ON_QUOTA_SHOPPING"
var0.ON_MINI_GAME_SHOP_BUY = "NewShopsMediator:ON_MINI_GAME_SHOP_BUY"
var0.ON_MINI_GAME_SHOP_FLUSH = "NewShopsMediator:ON_MINI_GAME_SHOP_FLUSH"
var0.MINI_GAME_SHOP_BUY_DONE = "NewShopsMediator:MINI_GAME_SHOP_BUY_DONE"
var0.UR_EXCHANGE_TRACKING = "NewShopsMediator:UR_EXCHANGE_TRACKING"

function var0.register(arg0)
	arg0:bind(var0.ON_META_SHOP, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.ON_META_SHOPPING, {
			activity_id = arg1,
			cmd = arg2,
			arg1 = arg3,
			arg2 = arg4
		})
	end)
	arg0:bind(var0.ON_GUILD_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.ON_GUILD_SHOP_PURCHASE, {
			goodsId = arg1,
			selectedId = arg2
		})
	end)
	arg0:bind(var0.ON_MINI_GAME_SHOP_BUY, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.MINI_GAME_SHOP_BUY, arg1)
	end)
	arg0:bind(var0.ON_MINI_GAME_SHOP_FLUSH, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.MINI_GAME_SHOP_FLUSH, arg1)
	end)
	arg0:bind(var0.ON_MEDAL_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.ON_MEDAL_SHOP_PURCHASE, {
			goodsId = arg1,
			selectedId = arg2
		})
	end)
	arg0:bind(var0.REFRESH_GUILD_SHOP, function(arg0, arg1)
		local var0 = arg1 and GuildConst.MANUAL_REFRESH or GuildConst.AUTO_REFRESH

		arg0:sendNotification(GAME.GET_GUILD_SHOP, {
			type = var0
		})
	end)
	arg0:bind(var0.REFRESH_MEDAL_SHOP, function(arg0)
		arg0:sendNotification(GAME.GET_MEDALSHOP, {})
	end)
	arg0:bind(var0.ON_SKIN_SHOP, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.SKINSHOP)
	end)
	arg0:bind(var0.GO_MALL, function(arg0, arg1)
		local var0 = getProxy(ContextProxy)

		if arg0.contextData.fromMediatorName == ChargeMediator.__cname then
			var0:getContextByMediator(ChargeMediator):extendData({
				wrap = arg1
			})
			arg0.viewComponent:closeView()
		else
			pg.m02:sendNotification(GAME.CHANGE_SCENE, SCENE.CHARGE, {
				wrap = arg1
			})
		end
	end)
	arg0:bind(var0.SELL_BLUEPRINT, function(arg0, arg1)
		arg0:sendNotification(GAME.FRAG_SELL, arg1)
	end)
	arg0:bind(var0.ON_ACT_SHOPPING, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1,
			cmd = arg2,
			arg1 = arg3,
			arg2 = arg4
		})
	end)
	arg0:bind(var0.ON_FRAGMENT_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.FRAG_SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.ON_SHAM_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHAM_SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.ON_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.REFRESH_MILITARY_SHOP, function(arg0, arg1)
		if not arg1 then
			arg0:sendNotification(GAME.GET_MILITARY_SHOP)
		else
			arg0:sendNotification(GAME.REFRESH_MILITARY_SHOP)
		end
	end)
	arg0:bind(var0.REFRESH_STREET_SHOP, function(arg0, arg1)
		if not arg1 then
			arg0:sendNotification(GAME.GET_SHOPSTREET)
		else
			arg0:sendNotification(GAME.SHOPPING, {
				count = 1,
				id = arg1
			})
		end
	end)
	arg0:bind(var0.SET_PLAYER_FLAG, function(arg0, arg1, arg2)
		if arg2 then
			arg0:sendNotification(GAME.COMMON_FLAG, {
				flagID = arg1
			})
		else
			arg0:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = arg1
			})
		end
	end)
	arg0:bind(var0.ON_ESKIN_PREVIEW, function(arg0, arg1)
		local var0 = pg.equip_skin_template[arg1]
		local var1 = Ship.New({
			id = var0.ship_config_id,
			configId = var0.ship_config_id,
			skin_id = var0.ship_skin_id
		})
		local var2 = {}

		if var0.ship_skin_id ~= 0 then
			var2 = {
				equipSkinId = 0,
				shipVO = var1,
				weaponIds = {},
				weight = arg0.contextData.weight and arg0.contextData.weight + 1
			}
		else
			var2 = {
				shipVO = var1,
				weaponIds = Clone(var0.weapon_ids),
				equipSkinId = arg1,
				weight = arg0.contextData.weight and arg0.contextData.weight + 1
			}
		end

		arg0:addSubLayers(Context.New({
			viewComponent = ShipPreviewLayer,
			mediator = ShipPreviewMediator,
			data = var2
		}))
	end)
	arg0:bind(var0.UR_EXCHANGE_TRACKING, function(arg0, arg1)
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

		if var0 and not var0:isEnd() and getProxy(ShopsProxy):getActivityShopById(var0:getConfig("config_client").shopId):GetCommodityById(var0:getConfig("config_client").goodsId[1]):getConfig("commodity_id") == arg1 then
			TrackConst.TrackingUrExchangeFetch(arg1, 1)
		end
	end)
	arg0.viewComponent:SetShops(arg0.contextData.shops)
	arg0:bind(var0.ON_QUOTA_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.QUOTA_SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
	arg0.viewComponent:OnUpdateItems(getProxy(BagProxy):getRawData())
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.SHOPPING_DONE,
		ShopsProxy.SHOPPINGSTREET_UPDATE,
		ShopsProxy.MERITOROUS_SHOP_UPDATED,
		ShopsProxy.SHAM_SHOP_UPDATED,
		GAME.SHAM_SHOPPING_DONE,
		BagProxy.ITEM_UPDATED,
		GAME.FRAG_SHOPPING_DONE,
		ShopsProxy.FRAGMENT_SHOP_UPDATED,
		ShopsProxy.ACTIVITY_SHOP_GOODS_UPDATED,
		ShopsProxy.ACTIVITY_SHOP_UPDATED,
		GAME.FRAG_SELL_DONE,
		ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS,
		GAME.USE_ITEM_DONE,
		GAME.ON_GUILD_SHOP_PURCHASE_DONE,
		GAME.ON_MEDAL_SHOP_PURCHASE_DONE,
		ShopsProxy.GUILD_SHOP_UPDATED,
		ShopsProxy.MEDAL_SHOP_UPDATED,
		GAME.ON_META_SHOPPING_DONE,
		ShopsProxy.META_SHOP_GOODS_UPDATED,
		ShopsProxy.QUOTA_SHOP_UPDATED,
		GAME.QUOTA_SHOPPING_DONE,
		GAME.MINI_GAME_SHOP_BUY_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:SetPlayer(var1)
	elseif var0 == ShopsProxy.SHOPPINGSTREET_UPDATE then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHOP_STREET, var1.shopStreet)
	elseif var0 == GAME.SHOPPING_DONE then
		local var2

		if var1.shopType == ShopArgs.ShopStreet then
			local var3 = getProxy(ShopsProxy):getShopStreet()
			local var4 = var3:getGoodsById(var1.id)

			arg0.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHOP_STREET, var3, var1.id)
		elseif var1.shopType == ShopArgs.MilitaryShop then
			local var5 = getProxy(ShopsProxy):getMeritorousShop()
			local var6 = var5.goods[var1.id]

			arg0.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_MILITARY_SHOP, var5, var1.id)
		end

		if var1.awards and #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end
	elseif var0 == ShopsProxy.MERITOROUS_SHOP_UPDATED then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MILITARY_SHOP, var1)
	elseif var0 == ShopsProxy.SHAM_SHOP_UPDATED then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHAM_SHOP, var1)
	elseif var0 == GAME.SHAM_SHOPPING_DONE then
		local var7 = getProxy(ShopsProxy):getShamShop()

		arg0.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHAM_SHOP, var7, var1.id)
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == BagProxy.ITEM_UPDATED then
		local var8 = getProxy(BagProxy):getRawData()

		arg0.viewComponent:OnUpdateItems(var8)
	elseif var0 == GAME.FRAG_SHOPPING_DONE then
		local var9 = getProxy(ShopsProxy):getFragmentShop()

		arg0.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_FRAGMENT, var9, var1.id)
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == ShopsProxy.FRAGMENT_SHOP_UPDATED then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_FRAGMENT, var1)
	elseif var0 == ShopsProxy.ACTIVITY_SHOP_GOODS_UPDATED then
		local var10 = getProxy(ShopsProxy):getActivityShopById(var1.activityId)

		arg0.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_ACTIVITY, var10, var1.goodsId)
	elseif var0 == ShopsProxy.META_SHOP_GOODS_UPDATED then
		local var11 = getProxy(ShopsProxy):GetMetaShop()

		arg0.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_META, var11, var1.goodsId)
	elseif var0 == ShopsProxy.ACTIVITY_SHOP_UPDATED then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_ACTIVITY, var1.shop)
	elseif var0 == ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == GAME.USE_ITEM_DONE then
		if table.getCount(var1) ~= 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1
			})
		end
	elseif var0 == GAME.FRAG_SELL_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)

		local var12 = arg0.viewComponent.pages[NewShopsScene.TYPE_FRAGMENT]

		if arg0.viewComponent.page == var12 then
			arg0.viewComponent.page:OnFragmentSellUpdate()
		end
	elseif var0 == GAME.ON_GUILD_SHOP_PURCHASE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == GAME.ON_MEDAL_SHOP_PURCHASE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == ShopsProxy.GUILD_SHOP_UPDATED then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_GUILD, var1.shop)
	elseif var0 == ShopsProxy.MEDAL_SHOP_UPDATED then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MEDAL, var1)
	elseif var0 == GAME.ON_META_SHOPPING_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == ShopsProxy.QUOTA_SHOP_UPDATED then
		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_QUOTA, var1.shop)
	elseif var0 == GAME.QUOTA_SHOPPING_DONE then
		local var13 = getProxy(ShopsProxy):getQuotaShop()

		arg0.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_QUOTA_SHOP, var13, var1.id)
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == GAME.MINI_GAME_SHOP_BUY_DONE then
		local var14 = var1.list

		if var14 and #var14 > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var14)
		end

		local var15 = getProxy(ShopsProxy):getMiniShop()

		arg0.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MINI_GAME, var15)
	end
end

return var0
