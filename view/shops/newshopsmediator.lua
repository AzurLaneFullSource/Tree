local var0_0 = class("NewShopsMediator", import("..base.ContextMediator"))

var0_0.ON_SHOPPING = "NewShopsMediator:ON_SHOPPING"
var0_0.REFRESH_STREET_SHOP = "NewShopsMediator:REFRESH_STREET_SHOP"
var0_0.REFRESH_MILITARY_SHOP = "NewShopsMediator:REFRESH_MILITARY_SHOP"
var0_0.ON_SHAM_SHOPPING = "NewShopsMediator:ON_SHAM_SHOPPING"
var0_0.ON_FRAGMENT_SHOPPING = "NewShopsMediator:ON_FRAGMENT_SHOPPING"
var0_0.ON_ACT_SHOPPING = "NewShopsMediator:ON_ACT_SHOPPING"
var0_0.SELL_BLUEPRINT = "NewShopsMediator:SELL_BLUEPRINT"
var0_0.GO_MALL = "NewShopsMediator:GO_MALL"
var0_0.ON_SKIN_SHOP = "NewShopsMediator:ON_SKIN_SHOP"
var0_0.SET_PLAYER_FLAG = "NewShopsMediator:SET_PLAYER_FLAG"
var0_0.ON_GUILD_SHOPPING = "NewShopsMediator:ON_GUILD_SHOPPING"
var0_0.ON_MEDAL_SHOPPING = "NewShopsMediator:ON_MEDAL_SHOPPING"
var0_0.REFRESH_GUILD_SHOP = "NewShopsMediator:REFRESH_GUILD_SHOP"
var0_0.REFRESH_MEDAL_SHOP = "NewShopsMediator:REFRESH_MEDAL_SHOP"
var0_0.ON_GUILD_PURCHASE = "NewShopsMediator:ON_GUILD_PURCHASE"
var0_0.ON_META_SHOP = "NewShopsMediator:ON_META_SHOP"
var0_0.ON_ESKIN_PREVIEW = "NewShopsMediator:ON_ESKIN_PREVIEW"
var0_0.ON_QUOTA_SHOPPING = "NewShopsMediator:ON_QUOTA_SHOPPING"
var0_0.ON_MINI_GAME_SHOP_BUY = "NewShopsMediator:ON_MINI_GAME_SHOP_BUY"
var0_0.ON_MINI_GAME_SHOP_FLUSH = "NewShopsMediator:ON_MINI_GAME_SHOP_FLUSH"
var0_0.MINI_GAME_SHOP_BUY_DONE = "NewShopsMediator:MINI_GAME_SHOP_BUY_DONE"
var0_0.UR_EXCHANGE_TRACKING = "NewShopsMediator:UR_EXCHANGE_TRACKING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_META_SHOP, function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		arg0_1:sendNotification(GAME.ON_META_SHOPPING, {
			activity_id = arg1_2,
			cmd = arg2_2,
			arg1 = arg3_2,
			arg2 = arg4_2
		})
	end)
	arg0_1:bind(var0_0.ON_GUILD_SHOPPING, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.ON_GUILD_SHOP_PURCHASE, {
			goodsId = arg1_3,
			selectedId = arg2_3
		})
	end)
	arg0_1:bind(var0_0.ON_MINI_GAME_SHOP_BUY, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.MINI_GAME_SHOP_BUY, arg1_4)
	end)
	arg0_1:bind(var0_0.ON_MINI_GAME_SHOP_FLUSH, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.MINI_GAME_SHOP_FLUSH, arg1_5)
	end)
	arg0_1:bind(var0_0.ON_MEDAL_SHOPPING, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.ON_MEDAL_SHOP_PURCHASE, {
			goodsId = arg1_6,
			selectedId = arg2_6
		})
	end)
	arg0_1:bind(var0_0.REFRESH_GUILD_SHOP, function(arg0_7, arg1_7)
		local var0_7 = arg1_7 and GuildConst.MANUAL_REFRESH or GuildConst.AUTO_REFRESH

		arg0_1:sendNotification(GAME.GET_GUILD_SHOP, {
			type = var0_7
		})
	end)
	arg0_1:bind(var0_0.REFRESH_MEDAL_SHOP, function(arg0_8)
		arg0_1:sendNotification(GAME.GET_MEDALSHOP, {})
	end)
	arg0_1:bind(var0_0.ON_SKIN_SHOP, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, SCENE.SKINSHOP)
	end)
	arg0_1:bind(var0_0.GO_MALL, function(arg0_10, arg1_10)
		local var0_10 = getProxy(ContextProxy)

		if arg0_1.contextData.fromMediatorName == ChargeMediator.__cname then
			var0_10:getContextByMediator(ChargeMediator):extendData({
				wrap = arg1_10
			})
			arg0_1.viewComponent:closeView()
		else
			pg.m02:sendNotification(GAME.CHANGE_SCENE, SCENE.CHARGE, {
				wrap = arg1_10
			})
		end
	end)
	arg0_1:bind(var0_0.SELL_BLUEPRINT, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.FRAG_SELL, arg1_11)
	end)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1_12,
			cmd = arg2_12,
			arg1 = arg3_12,
			arg2 = arg4_12
		})
	end)
	arg0_1:bind(var0_0.ON_FRAGMENT_SHOPPING, function(arg0_13, arg1_13, arg2_13)
		arg0_1:sendNotification(GAME.FRAG_SHOPPING, {
			id = arg1_13,
			count = arg2_13
		})
	end)
	arg0_1:bind(var0_0.ON_SHAM_SHOPPING, function(arg0_14, arg1_14, arg2_14)
		arg0_1:sendNotification(GAME.SHAM_SHOPPING, {
			id = arg1_14,
			count = arg2_14
		})
	end)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_15, arg1_15, arg2_15)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_15,
			count = arg2_15
		})
	end)
	arg0_1:bind(var0_0.REFRESH_MILITARY_SHOP, function(arg0_16, arg1_16)
		if not arg1_16 then
			arg0_1:sendNotification(GAME.GET_MILITARY_SHOP)
		else
			arg0_1:sendNotification(GAME.REFRESH_MILITARY_SHOP)
		end
	end)
	arg0_1:bind(var0_0.REFRESH_STREET_SHOP, function(arg0_17, arg1_17)
		if not arg1_17 then
			arg0_1:sendNotification(GAME.GET_SHOPSTREET)
		else
			arg0_1:sendNotification(GAME.SHOPPING, {
				count = 1,
				id = arg1_17
			})
		end
	end)
	arg0_1:bind(var0_0.SET_PLAYER_FLAG, function(arg0_18, arg1_18, arg2_18)
		if arg2_18 then
			arg0_1:sendNotification(GAME.COMMON_FLAG, {
				flagID = arg1_18
			})
		else
			arg0_1:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = arg1_18
			})
		end
	end)
	arg0_1:bind(var0_0.ON_ESKIN_PREVIEW, function(arg0_19, arg1_19)
		local var0_19 = pg.equip_skin_template[arg1_19]
		local var1_19 = Ship.New({
			id = var0_19.ship_config_id,
			configId = var0_19.ship_config_id,
			skin_id = var0_19.ship_skin_id
		})
		local var2_19 = {}

		if var0_19.ship_skin_id ~= 0 then
			var2_19 = {
				equipSkinId = 0,
				shipVO = var1_19,
				weaponIds = {},
				weight = arg0_1.contextData.weight and arg0_1.contextData.weight + 1
			}
		else
			var2_19 = {
				shipVO = var1_19,
				weaponIds = Clone(var0_19.weapon_ids),
				equipSkinId = arg1_19,
				weight = arg0_1.contextData.weight and arg0_1.contextData.weight + 1
			}
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = ShipPreviewLayer,
			mediator = ShipPreviewMediator,
			data = var2_19
		}))
	end)
	arg0_1:bind(var0_0.UR_EXCHANGE_TRACKING, function(arg0_20, arg1_20)
		local var0_20 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

		if var0_20 and not var0_20:isEnd() and getProxy(ShopsProxy):getActivityShopById(var0_20:getConfig("config_client").shopId):GetCommodityById(var0_20:getConfig("config_client").goodsId[1]):getConfig("commodity_id") == arg1_20 then
			TrackConst.TrackingUrExchangeFetch(arg1_20, 1)
		end
	end)
	arg0_1.viewComponent:SetShops(arg0_1.contextData.shops)
	arg0_1:bind(var0_0.ON_QUOTA_SHOPPING, function(arg0_21, arg1_21, arg2_21)
		arg0_1:sendNotification(GAME.QUOTA_SHOPPING, {
			id = arg1_21,
			count = arg2_21
		})
	end)
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
	arg0_1.viewComponent:OnUpdateItems(getProxy(BagProxy):getRawData())
end

function var0_0.listNotificationInterests(arg0_22)
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

function var0_0.handleNotification(arg0_23, arg1_23)
	local var0_23 = arg1_23:getName()
	local var1_23 = arg1_23:getBody()

	if var0_23 == PlayerProxy.UPDATED then
		arg0_23.viewComponent:SetPlayer(var1_23)
	elseif var0_23 == ShopsProxy.SHOPPINGSTREET_UPDATE then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHOP_STREET, var1_23.shopStreet)
	elseif var0_23 == GAME.SHOPPING_DONE then
		local var2_23

		if var1_23.shopType == ShopArgs.ShopStreet then
			local var3_23 = getProxy(ShopsProxy):getShopStreet()
			local var4_23 = var3_23:getGoodsById(var1_23.id)

			arg0_23.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHOP_STREET, var3_23, var1_23.id)
		elseif var1_23.shopType == ShopArgs.MilitaryShop then
			local var5_23 = getProxy(ShopsProxy):getMeritorousShop()
			local var6_23 = var5_23.goods[var1_23.id]

			arg0_23.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_MILITARY_SHOP, var5_23, var1_23.id)
		end

		if var1_23.awards and #var1_23.awards > 0 then
			arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)
		end
	elseif var0_23 == ShopsProxy.MERITOROUS_SHOP_UPDATED then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MILITARY_SHOP, var1_23)
	elseif var0_23 == ShopsProxy.SHAM_SHOP_UPDATED then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHAM_SHOP, var1_23)
	elseif var0_23 == GAME.SHAM_SHOPPING_DONE then
		local var7_23 = getProxy(ShopsProxy):getShamShop()

		arg0_23.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHAM_SHOP, var7_23, var1_23.id)
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)
	elseif var0_23 == BagProxy.ITEM_UPDATED then
		local var8_23 = getProxy(BagProxy):getRawData()

		arg0_23.viewComponent:OnUpdateItems(var8_23)
	elseif var0_23 == GAME.FRAG_SHOPPING_DONE then
		local var9_23 = getProxy(ShopsProxy):getFragmentShop()

		arg0_23.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_FRAGMENT, var9_23, var1_23.id)
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)
	elseif var0_23 == ShopsProxy.FRAGMENT_SHOP_UPDATED then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_FRAGMENT, var1_23)
	elseif var0_23 == ShopsProxy.ACTIVITY_SHOP_GOODS_UPDATED then
		local var10_23 = getProxy(ShopsProxy):getActivityShopById(var1_23.activityId)

		arg0_23.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_ACTIVITY, var10_23, var1_23.goodsId)
	elseif var0_23 == ShopsProxy.META_SHOP_GOODS_UPDATED then
		local var11_23 = getProxy(ShopsProxy):GetMetaShop()

		arg0_23.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_META, var11_23, var1_23.goodsId)
	elseif var0_23 == ShopsProxy.ACTIVITY_SHOP_UPDATED then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_ACTIVITY, var1_23.shop)
	elseif var0_23 == ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS then
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards, var1_23.callback)
	elseif var0_23 == GAME.USE_ITEM_DONE then
		if table.getCount(var1_23) ~= 0 then
			arg0_23.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_23
			})
		end
	elseif var0_23 == GAME.FRAG_SELL_DONE then
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)

		local var12_23 = arg0_23.viewComponent.pages[NewShopsScene.TYPE_FRAGMENT]

		if arg0_23.viewComponent.page == var12_23 then
			arg0_23.viewComponent.page:OnFragmentSellUpdate()
		end
	elseif var0_23 == GAME.ON_GUILD_SHOP_PURCHASE_DONE then
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)
	elseif var0_23 == GAME.ON_MEDAL_SHOP_PURCHASE_DONE then
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)
	elseif var0_23 == ShopsProxy.GUILD_SHOP_UPDATED then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_GUILD, var1_23.shop)
	elseif var0_23 == ShopsProxy.MEDAL_SHOP_UPDATED then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MEDAL, var1_23)
	elseif var0_23 == GAME.ON_META_SHOPPING_DONE then
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)
	elseif var0_23 == ShopsProxy.QUOTA_SHOP_UPDATED then
		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_QUOTA, var1_23.shop)
	elseif var0_23 == GAME.QUOTA_SHOPPING_DONE then
		local var13_23 = getProxy(ShopsProxy):getQuotaShop()

		arg0_23.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_QUOTA_SHOP, var13_23, var1_23.id)
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.awards)
	elseif var0_23 == GAME.MINI_GAME_SHOP_BUY_DONE then
		local var14_23 = var1_23.list

		if var14_23 and #var14_23 > 0 then
			arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var14_23)
		end

		local var15_23 = getProxy(ShopsProxy):getMiniShop()

		arg0_23.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MINI_GAME, var15_23)
	end
end

return var0_0
