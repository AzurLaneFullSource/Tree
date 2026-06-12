local var0_0 = class("NewShopMainMediator", import("...base.ContextMediator"))

var0_0.OPEN_LAYER = "NewShopMainMediator.OPEN_LAYER"
var0_0.SWITCH_TO_SHOP = "NewShopMainMediator:SWITCH_TO_SHOP"
var0_0.CHARGE = "NewShopMainMediator:CHARGE"
var0_0.BUY_ITEM = "NewShopMainMediator:BUY_ITEM"
var0_0.CLICK_MING_SHI = "NewShopMainMediator:CLICK_MING_SHI"
var0_0.GET_CHARGE_LIST = "NewShopMainMediator:GET_CHARGE_LIST"
var0_0.OPEN_CHARGE_ITEM_PANEL = "NewShopMainMediator:OPEN_CHARGE_ITEM_PANEL"
var0_0.OPEN_CHARGE_ITEM_BOX = "NewShopMainMediator:OPEN_CHARGE_ITEM_BOX"
var0_0.OPEN_CHARGE_BIRTHDAY = "NewShopMainMediator:OPEN_CHARGE_BIRTHDAY"
var0_0.OPEN_USER_AGREE = "NewShopMainMediator:OPEN_USER_AGREE"
var0_0.VIEW_SKIN_PROBABILITY = "NewShopMainMediator:VIEW_SKIN_PROBABILITY"
var0_0.OPEN_TEC_SHIP_GIFT_SELL_LAYER = "NewShopMainMediator:OPEN_TEC_SHIP_GIFT_SELL_LAYER"
var0_0.OPEN_BATTLE_UI_SELL_LAYER = "NewShopMainMediator:OPEN_BATTLE_UI_SELL_LAYER"
var0_0.FAST_BUILD_ITEM_ID = 61004
var0_0.REFRESH_STREET_SHOP = "NewShopMainMediator:REFRESH_STREET_SHOP"
var0_0.REFRESH_MILITARY_SHOP = "NewShopMainMediator:REFRESH_MILITARY_SHOP"
var0_0.ON_SHAM_SHOPPING = "NewShopMainMediator:ON_SHAM_SHOPPING"
var0_0.ON_FRAGMENT_SHOPPING = "NewShopMainMediator:ON_FRAGMENT_SHOPPING"
var0_0.ON_ACT_SHOPPING = "NewShopMainMediator:ON_ACT_SHOPPING"
var0_0.SELL_BLUEPRINT = "NewShopMainMediator:SELL_BLUEPRINT"
var0_0.SET_PLAYER_FLAG = "NewShopMainMediator:SET_PLAYER_FLAG"
var0_0.ON_GUILD_SHOPPING = "NewShopMainMediator:ON_GUILD_SHOPPING"
var0_0.ON_MEDAL_SHOPPING = "NewShopMainMediator:ON_MEDAL_SHOPPING"
var0_0.REFRESH_GUILD_SHOP = "NewShopMainMediator:REFRESH_GUILD_SHOP"
var0_0.REFRESH_MEDAL_SHOP = "NewShopMainMediator:REFRESH_MEDAL_SHOP"
var0_0.ON_META_SHOP = "NewShopMainMediator:ON_META_SHOP"
var0_0.ON_ESKIN_PREVIEW = "NewShopMainMediator:ON_ESKIN_PREVIEW"
var0_0.ON_QUOTA_SHOPPING = "NewShopMainMediator:ON_QUOTA_SHOPPING"
var0_0.ON_MINI_GAME_SHOP_BUY = "NewShopMainMediator:ON_MINI_GAME_SHOP_BUY"
var0_0.ON_MINI_GAME_SHOP_FLUSH = "NewShopMainMediator:ON_MINI_GAME_SHOP_FLUSH"
var0_0.UR_EXCHANGE_TRACKING = "NewShopMainMediator:UR_EXCHANGE_TRACKING"
var0_0.ON_ACT_OPERATION = "NewShopMainMediator.ON_ACT_OPERATION"
var0_0.NOTI_UPDATE_CURRENT = "NewShopMainMediator.NOTI_UPDATE_CURRENT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = arg1_2,
			mediator = arg2_2,
			data = arg3_2
		}))
	end)

	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)
	arg0_1.viewComponent:SetSupplyShopList(arg0_1.contextData.supplyShopList)
	arg0_1.viewComponent:OnInitItems(getProxy(BagProxy):getRawData())
	arg0_1:bind(var0_0.VIEW_SKIN_PROBABILITY, function(arg0_3, arg1_3, arg2_3)
		arg0_1.contextData.warp = arg2_3

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.PROBABILITY_SKINSHOP, {
			commodityId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.GET_CHARGE_LIST, function(arg0_4)
		arg0_1:sendNotification(GAME.GET_CHARGE_LIST)
	end)
	arg0_1:bind(var0_0.SWITCH_TO_SHOP, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_5)
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_6
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_7,
			count = arg2_7
		})
	end)
	arg0_1:bind(var0_0.CLICK_MING_SHI, function(arg0_8)
		arg0_1:sendNotification(GAME.CLICK_MING_SHI)
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_9, arg1_9)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_9
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_BOX, function(arg0_10, arg1_10)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemBoxMediator,
			viewComponent = ChargeItemBoxLayer,
			data = {
				panelConfig = arg1_10
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_11, arg1_11)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_USER_AGREE, function(arg0_12, arg1_12)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeJPUserAgreeMediator,
			viewComponent = ChargeJPUserAgreeLayer,
			data = {
				contentStr = arg1_12
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_TEC_SHIP_GIFT_SELL_LAYER, function(arg0_13, arg1_13, arg2_13)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeTecShipGiftSellMediator,
			viewComponent = ChargeTecShipGiftSellLayer,
			data = {
				showGoodVO = arg1_13,
				chargedList = arg2_13
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_BATTLE_UI_SELL_LAYER, function(arg0_14, arg1_14, arg2_14)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBattleUISellMediator,
			viewComponent = ChargeBattleUISellLayer,
			data = {
				showGoodVO = arg1_14,
				chargedList = arg2_14
			}
		}))
	end)
	arg0_1:bind(var0_0.REFRESH_STREET_SHOP, function(arg0_15, arg1_15)
		if not arg1_15 then
			arg0_1:sendNotification(GAME.GET_SHOPSTREET)
		else
			arg0_1:sendNotification(GAME.SHOPPING, {
				count = 1,
				id = arg1_15
			})
		end
	end)
	arg0_1:bind(var0_0.REFRESH_MILITARY_SHOP, function(arg0_16, arg1_16)
		if not arg1_16 then
			arg0_1:sendNotification(GAME.GET_MILITARY_SHOP)
		else
			arg0_1:sendNotification(GAME.REFRESH_MILITARY_SHOP)
		end
	end)
	arg0_1:bind(var0_0.ON_SHAM_SHOPPING, function(arg0_17, arg1_17, arg2_17)
		arg0_1:sendNotification(GAME.SHAM_SHOPPING, {
			id = arg1_17,
			count = arg2_17
		})
	end)
	arg0_1:bind(var0_0.ON_FRAGMENT_SHOPPING, function(arg0_18, arg1_18, arg2_18)
		arg0_1:sendNotification(GAME.FRAG_SHOPPING, {
			id = arg1_18,
			count = arg2_18
		})
	end)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1_19,
			cmd = arg2_19,
			arg1 = arg3_19,
			arg2 = arg4_19
		})
	end)
	arg0_1:bind(var0_0.ON_ACT_OPERATION, function(arg0_20, arg1_20, arg2_20)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, setmetatable({
			activity_id = arg1_20
		}, {
			__index = arg2_20
		}))
	end)
	arg0_1:bind(var0_0.SELL_BLUEPRINT, function(arg0_21, arg1_21)
		arg0_1:sendNotification(GAME.FRAG_SELL, arg1_21)
	end)
	arg0_1:bind(var0_0.SET_PLAYER_FLAG, function(arg0_22, arg1_22, arg2_22)
		if arg2_22 then
			arg0_1:sendNotification(GAME.COMMON_FLAG, {
				flagID = arg1_22
			})
		else
			arg0_1:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = arg1_22
			})
		end
	end)
	arg0_1:bind(var0_0.ON_GUILD_SHOPPING, function(arg0_23, arg1_23, arg2_23)
		arg0_1:sendNotification(GAME.ON_GUILD_SHOP_PURCHASE, {
			goodsId = arg1_23,
			selectedId = arg2_23
		})
	end)
	arg0_1:bind(var0_0.ON_MEDAL_SHOPPING, function(arg0_24, arg1_24, arg2_24)
		arg0_1:sendNotification(GAME.ON_MEDAL_SHOP_PURCHASE, {
			goodsId = arg1_24,
			selectedId = arg2_24
		})
	end)
	arg0_1:bind(var0_0.REFRESH_GUILD_SHOP, function(arg0_25, arg1_25)
		local var0_25 = arg1_25 and GuildConst.MANUAL_REFRESH or GuildConst.AUTO_REFRESH

		arg0_1:sendNotification(GAME.GET_GUILD_SHOP, {
			type = var0_25
		})
	end)
	arg0_1:bind(var0_0.REFRESH_MEDAL_SHOP, function(arg0_26)
		arg0_1:sendNotification(GAME.GET_MEDALSHOP, {})
	end)
	arg0_1:bind(var0_0.ON_META_SHOP, function(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27)
		arg0_1:sendNotification(GAME.ON_META_SHOPPING, {
			activity_id = arg1_27,
			cmd = arg2_27,
			arg1 = arg3_27,
			arg2 = arg4_27,
			kvargs1 = arg5_27
		})
	end)
	arg0_1:bind(var0_0.ON_ESKIN_PREVIEW, function(arg0_28, arg1_28)
		local var0_28 = pg.equip_skin_template[arg1_28]
		local var1_28 = Ship.New({
			id = var0_28.ship_config_id,
			configId = var0_28.ship_config_id,
			skin_id = var0_28.ship_skin_id
		})
		local var2_28 = {}

		if var0_28.ship_skin_id ~= 0 then
			var2_28 = {
				equipSkinId = 0,
				shipVO = var1_28,
				weaponIds = {}
			}
		else
			var2_28 = {
				shipVO = var1_28,
				weaponIds = Clone(var0_28.weapon_ids),
				equipSkinId = arg1_28
			}
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = ShipPreviewLayer,
			mediator = ShipPreviewMediator,
			data = var2_28
		}))
	end)
	arg0_1:bind(var0_0.ON_QUOTA_SHOPPING, function(arg0_29, arg1_29, arg2_29)
		arg0_1:sendNotification(GAME.QUOTA_SHOPPING, {
			id = arg1_29,
			count = arg2_29
		})
	end)
	arg0_1:bind(var0_0.ON_MINI_GAME_SHOP_BUY, function(arg0_30, arg1_30, arg2_30)
		arg0_1:sendNotification(GAME.MINI_GAME_SHOP_BUY, arg1_30)
	end)
	arg0_1:bind(var0_0.ON_MINI_GAME_SHOP_FLUSH, function(arg0_31, arg1_31, arg2_31)
		arg0_1:sendNotification(GAME.MINI_GAME_SHOP_FLUSH, arg1_31)
	end)
	arg0_1:bind(var0_0.UR_EXCHANGE_TRACKING, function(arg0_32, arg1_32)
		local var0_32 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

		if var0_32 and not var0_32:isEnd() and getProxy(ShopsProxy):getActivityShopById(var0_32:getConfig("config_client").shopId):GetCommodityById(var0_32:getConfig("config_client").goodsId[1]):getConfig("commodity_id") == arg1_32 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrRedeem(arg1_32, 1))
		end
	end)
end

function var0_0.listNotificationInterests(arg0_33)
	return {
		NewShopMainScene.SHOW_OR_HIDE_UI,
		NewShopMainScene.SHOW_OR_HIDE_UI_2,
		NewShopMainScene.CLOSE_VIEW,
		PlayerProxy.UPDATED,
		ShopsProxy.FIRST_CHARGE_IDS_UPDATED,
		ShopsProxy.CHARGED_LIST_UPDATED,
		GAME.CHARGE_CONFIRM_FAILED,
		GAME.GET_CHARGE_LIST_DONE,
		GAME.SHOPPING_DONE,
		GAME.USE_ITEM_DONE,
		GAME.CLICK_MING_SHI_SUCCESS,
		GAME.REMOVE_LAYERS,
		PlayerResUI.GO_MALL,
		GAME.CHARGE_SUCCESS,
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
		ShopsProxy.GUILD_SHOP_ADDED,
		ShopsProxy.MEDAL_SHOP_UPDATED,
		GAME.ON_META_SHOPPING_DONE,
		ShopsProxy.META_SHOP_GOODS_UPDATED,
		ShopsProxy.QUOTA_SHOP_UPDATED,
		GAME.QUOTA_SHOPPING_DONE,
		GAME.MINI_GAME_SHOP_BUY_DONE,
		var0_0.NOTI_UPDATE_CURRENT
	}
end

function var0_0.handleNotification(arg0_34, arg1_34)
	local var0_34 = arg1_34:getName()
	local var1_34 = arg1_34:getBody()

	if var0_34 == NewShopMainScene.SHOW_OR_HIDE_UI then
		arg0_34.viewComponent:ShowOrHideUI(var1_34)
	elseif var0_34 == NewShopMainScene.SHOW_OR_HIDE_UI_2 then
		arg0_34.viewComponent:ShowOrHideUI2(var1_34)
	elseif var0_34 == NewShopMainScene.CLOSE_VIEW then
		arg0_34.viewComponent:closeView()
	elseif var0_34 == PlayerProxy.UPDATED then
		arg0_34.viewComponent:setPlayer(var1_34)
		arg0_34.viewComponent:updateNoRes()
	elseif var0_34 == ShopsProxy.FIRST_CHARGE_IDS_UPDATED then
		arg0_34.viewComponent:setFirstChargeIds(var1_34)
		arg0_34.viewComponent:updateCurSubView()
	elseif var0_34 == ShopsProxy.CHARGED_LIST_UPDATED then
		arg0_34.viewComponent:setChargedList(var1_34)
		arg0_34.viewComponent:updateCurSubView()
	elseif var0_34 == GAME.CHARGE_CONFIRM_FAILED then
		getProxy(ShopsProxy):chargeFailed(var1_34.payId, var1_34.bsId)
	elseif var0_34 == GAME.SHOPPING_DONE then
		local var2_34

		if var1_34.shopType == ShopArgs.ShopStreet then
			local var3_34 = getProxy(ShopsProxy):getShopStreet()
			local var4_34 = var3_34:getGoodsById(var1_34.id)

			arg0_34.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHOP_STREET, var3_34, var1_34.id)
		elseif var1_34.shopType == ShopArgs.MilitaryShop then
			local var5_34 = getProxy(ShopsProxy):getMeritorousShop()
			local var6_34 = var5_34.goods[var1_34.id]

			arg0_34.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_MILITARY_SHOP, var5_34, var1_34.id)
		end

		if var1_34.awards and #var1_34.awards > 0 then
			arg0_34.viewComponent:unBlurView()
			arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
		end

		local var7_34 = var1_34.normalList
		local var8_34 = var1_34.normalGroupList

		if var7_34 then
			arg0_34.viewComponent:setNormalList(var7_34)
		end

		if var8_34 then
			arg0_34.viewComponent:setNormalGroupList(var8_34)
		end

		local var9_34 = pg.shop_template[var1_34.id]

		arg0_34.viewComponent:checkBuyDone(var1_34.id)
		arg0_34.viewComponent:updateCurSubView()
		pg.EasyRedDotMgr.GetInstance():TriggerMarks("specialShop")
	elseif var0_34 == GAME.USE_ITEM_DONE then
		if #var1_34.drops ~= 0 then
			arg0_34.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_34.drops
			})
		end
	elseif var0_34 == GAME.GET_CHARGE_LIST_DONE then
		local var10_34 = var1_34.firstChargeIds
		local var11_34 = var1_34.chargedList
		local var12_34 = var1_34.normalList
		local var13_34 = var1_34.normalGroupList

		if var10_34 then
			arg0_34.viewComponent:setFirstChargeIds(var10_34)
		end

		if var11_34 then
			arg0_34.viewComponent:setChargedList(var11_34)
		end

		if var12_34 then
			arg0_34.viewComponent:setNormalList(var12_34)
		end

		if var13_34 then
			arg0_34.viewComponent:setNormalGroupList(var13_34)
		end

		if var10_34 or var11_34 or var12_34 or var13_34 then
			arg0_34.viewComponent:updateCurSubView()
		end

		pg.EasyRedDotMgr.GetInstance():TriggerMarks("specialShop")
	elseif var0_34 == GAME.CLICK_MING_SHI_SUCCESS then
		arg0_34.viewComponent:playHeartEffect()
	elseif var0_34 == PlayerResUI.GO_MALL then
		local var14_34 = ChargeScene.TYPE_DIAMOND

		if var1_34 then
			var14_34 = var1_34.type or ChargeScene.TYPE_DIAMOND
		end

		arg0_34.viewComponent:switchSubViewByTogger(var14_34)
		arg0_34.viewComponent:updateNoRes(var1_34 and var1_34.noRes or nil)
	elseif var0_34 == GAME.CHARGE_SUCCESS then
		arg0_34.viewComponent:checkBuyDone("damonds")

		local var15_34 = Goods.Create({
			shop_id = var1_34.shopId
		}, Goods.TYPE_CHARGE)

		arg0_34.viewComponent:OnChargeSuccess(var15_34)
	elseif var0_34 == ShopsProxy.SHOPPINGSTREET_UPDATE then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHOP_STREET, var1_34.shopStreet)
	elseif var0_34 == ShopsProxy.MERITOROUS_SHOP_UPDATED then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MILITARY_SHOP, var1_34)
	elseif var0_34 == ShopsProxy.SHAM_SHOP_UPDATED then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHAM_SHOP, var1_34)
	elseif var0_34 == GAME.SHAM_SHOPPING_DONE then
		local var16_34 = getProxy(ShopsProxy):getShamShop()

		arg0_34.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHAM_SHOP, var16_34, var1_34.id)
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
	elseif var0_34 == BagProxy.ITEM_UPDATED then
		local var17_34 = getProxy(BagProxy):getRawData()

		arg0_34.viewComponent:OnUpdateItems(var17_34)
	elseif var0_34 == GAME.FRAG_SHOPPING_DONE then
		local var18_34 = getProxy(ShopsProxy):getFragmentShop()

		arg0_34.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_FRAGMENT, var18_34, var1_34.id)
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
	elseif var0_34 == ShopsProxy.FRAGMENT_SHOP_UPDATED then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_FRAGMENT, var1_34)
	elseif var0_34 == ShopsProxy.ACTIVITY_SHOP_GOODS_UPDATED then
		local var19_34 = getProxy(ShopsProxy):getActivityShopById(var1_34.activityId)

		arg0_34.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_ACTIVITY, var19_34, var1_34.goodsId)
	elseif var0_34 == ShopsProxy.META_SHOP_GOODS_UPDATED then
		local var20_34 = getProxy(ShopsProxy):GetMetaShop()

		arg0_34.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_META, var20_34, var1_34.goodsId)
	elseif var0_34 == ShopsProxy.ACTIVITY_SHOP_UPDATED then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_ACTIVITY, var1_34.shop)
	elseif var0_34 == ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS then
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards, var1_34.callback)
	elseif var0_34 == GAME.USE_ITEM_DONE then
		if #var1_34.drops ~= 0 then
			arg0_34.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_34.drops
			})
		end
	elseif var0_34 == GAME.FRAG_SELL_DONE then
		arg0_34.viewComponent:OnFragmentSellUpdate()
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
	elseif var0_34 == GAME.ON_GUILD_SHOP_PURCHASE_DONE then
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
	elseif var0_34 == GAME.ON_MEDAL_SHOP_PURCHASE_DONE then
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
	elseif var0_34 == ShopsProxy.GUILD_SHOP_UPDATED or var0_34 == ShopsProxy.GUILD_SHOP_ADDED then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_GUILD, var1_34.shop)
	elseif var0_34 == ShopsProxy.MEDAL_SHOP_UPDATED then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MEDAL, var1_34)
	elseif var0_34 == GAME.ON_META_SHOPPING_DONE then
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
	elseif var0_34 == ShopsProxy.QUOTA_SHOP_UPDATED then
		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_QUOTA, var1_34.shop)
	elseif var0_34 == GAME.QUOTA_SHOPPING_DONE then
		local var21_34 = getProxy(ShopsProxy):getQuotaShop()

		arg0_34.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_QUOTA, var21_34, var1_34.id)
		arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_34.awards)
	elseif var0_34 == GAME.MINI_GAME_SHOP_BUY_DONE then
		local var22_34 = var1_34.list

		if var22_34 and #var22_34 > 0 then
			arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var22_34)
		end

		local var23_34 = getProxy(ShopsProxy):getMiniShop()

		arg0_34.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MINI_GAME, var23_34)
	elseif var0_34 == var0_0.NOTI_UPDATE_CURRENT then
		arg0_34.viewComponent:updateCurSubView()
		pg.EasyRedDotMgr.GetInstance():TriggerMarks("specialShop")
	end
end

return var0_0
