local var0_0 = class("NewShopMainMediator", import("...base.ContextMediator"))

var0_0.OPEN_LAYER = "NewShopMainMediator.OPEN_LAYER"
var0_0.SWITCH_TO_SHOP = "NewShopMainMediator.SWITCH_TO_SHOP"
var0_0.CHARGE = "NewShopMainMediator.CHARGE"
var0_0.BUY_ITEM = "NewShopMainMediator.BUY_ITEM"
var0_0.CLICK_MING_SHI = "NewShopMainMediator.CLICK_MING_SHI"
var0_0.GET_CHARGE_LIST = "NewShopMainMediator.GET_CHARGE_LIST"
var0_0.OPEN_CHARGE_ITEM_PANEL = "NewShopMainMediator.OPEN_CHARGE_ITEM_PANEL"
var0_0.OPEN_CHARGE_ITEM_BOX = "NewShopMainMediator.OPEN_CHARGE_ITEM_BOX"
var0_0.OPEN_CHARGE_BIRTHDAY = "NewShopMainMediator.OPEN_CHARGE_BIRTHDAY"
var0_0.OPEN_USER_AGREE = "NewShopMainMediator.OPEN_USER_AGREE"
var0_0.VIEW_SKIN_PROBABILITY = "NewShopMainMediator.VIEW_SKIN_PROBABILITY"
var0_0.OPEN_TEC_SHIP_GIFT_SELL_LAYER = "NewShopMainMediator.OPEN_TEC_SHIP_GIFT_SELL_LAYER"
var0_0.OPEN_BATTLE_UI_SELL_LAYER = "NewShopMainMediator.OPEN_BATTLE_UI_SELL_LAYER"
var0_0.FAST_BUILD_ITEM_ID = 61004
var0_0.REFRESH_STREET_SHOP = "NewShopMainMediator.REFRESH_STREET_SHOP"
var0_0.REFRESH_MILITARY_SHOP = "NewShopMainMediator.REFRESH_MILITARY_SHOP"
var0_0.ON_SHAM_SHOPPING = "NewShopMainMediator.ON_SHAM_SHOPPING"
var0_0.ON_FRAGMENT_SHOPPING = "NewShopMainMediator.ON_FRAGMENT_SHOPPING"
var0_0.ON_ACT_SHOPPING = "NewShopMainMediator.ON_ACT_SHOPPING"
var0_0.SELL_BLUEPRINT = "NewShopMainMediator.SELL_BLUEPRINT"
var0_0.SET_PLAYER_FLAG = "NewShopMainMediator.SET_PLAYER_FLAG"
var0_0.ON_GUILD_SHOPPING = "NewShopMainMediator.ON_GUILD_SHOPPING"
var0_0.ON_MEDAL_SHOPPING = "NewShopMainMediator.ON_MEDAL_SHOPPING"
var0_0.REFRESH_GUILD_SHOP = "NewShopMainMediator.REFRESH_GUILD_SHOP"
var0_0.REFRESH_MEDAL_SHOP = "NewShopMainMediator.REFRESH_MEDAL_SHOP"
var0_0.ON_META_SHOP = "NewShopMainMediator.ON_META_SHOP"
var0_0.ON_ESKIN_PREVIEW = "NewShopMainMediator.ON_ESKIN_PREVIEW"
var0_0.ON_QUOTA_SHOPPING = "NewShopMainMediator.ON_QUOTA_SHOPPING"
var0_0.ON_MINI_GAME_SHOP_BUY = "NewShopMainMediator.ON_MINI_GAME_SHOP_BUY"
var0_0.ON_MINI_GAME_SHOP_FLUSH = "NewShopMainMediator.ON_MINI_GAME_SHOP_FLUSH"
var0_0.UR_EXCHANGE_TRACKING = "NewShopMainMediator.UR_EXCHANGE_TRACKING"
var0_0.ON_ACT_OPERATION = "NewShopMainMediator.ON_ACT_OPERATION"
var0_0.NOTI_UPDATE_CURRENT = "NewShopMainMediator.NOTI_UPDATE_CURRENT"
var0_0.OPEN_GIFT_ACT_LAYER = "NewShopMainMediator.OPEN_GIFT_ACT_LAYER"
var0_0.ON_SUBLAYER_EVENT = "NewShopMainMediator.ON_SUBLAYER_EVENT"

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
	arg0_1:bind(var0_0.OPEN_GIFT_ACT_LAYER, function(arg0_33, arg1_33)
		arg0_1:OpenGiftActLayer(arg1_33)
	end)
end

function var0_0.OpenGiftActLayer(arg0_34, arg1_34)
	local var0_34 = getProxy(ActivityProxy):getActivityById(arg1_34)

	switch(var0_34:getConfig("type"), {
		[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
			arg0_34.viewComponent:emit(NewShopMainMediator.OPEN_LAYER, ChargeActGiftLayer, ChargeActGiftMediator, {
				actId = var0_34.id
			})
		end,
		[ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE] = function()
			local var0_36 = pg.activity_giftpackage[var0_34:getConfig("config_id")]
			local var1_36 = Goods.Create({
				id = var0_36.shop_id
			}, Goods.TYPE_GIFT_PACKAGE_ACT)
			local var2_36 = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = var1_36:getConfig("effect_args")[1]
			})
			local var3_36 = var1_36:GetPrice()
			local var4_36 = {}
			local var5_36 = getProxy(ShipSkinProxy)

			for iter0_36, iter1_36 in ipairs(var0_36.skin) do
				table.insert(var4_36, Drop.New({
					count = 1,
					type = DROP_TYPE_SKIN,
					id = iter1_36,
					got = var5_36:hasNonLimitSkin(iter1_36),
					special = underscore.any(var0_36.special_skin, function(arg0_37)
						return iter1_36 == arg0_37
					end)
				}))
			end

			local var6_36 = underscore.all(var0_36.special_skin, function(arg0_38)
				return var5_36:hasNonLimitSkin(arg0_38)
			end)
			local var7_36 = {
				isMonthCard = false,
				isChargeType = false,
				isLocalPrice = false,
				commodity = var1_36,
				icon = var2_36:getIcon(),
				name = var2_36:getName(),
				tipExtra = i18n("charge_title_getskin"),
				extraItems = var4_36,
				descExtra = var0_36[var6_36 and "desc_2" or "desc_1"],
				price = var3_36,
				tagType = var1_36:getConfig("tag"),
				onYes = function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("charge_scene_buy_confirm", var3_36, var2_36:getName()),
						onYes = function()
							arg0_34.viewComponent:emit(NewShopMainMediator.ON_ACT_OPERATION, var0_34.id, {
								cmd = 1,
								costDrop = Drop.New({
									type = DROP_TYPE_RESOURCE,
									id = PlayerConst.ResDiamond,
									count = var3_36
								})
							})
						end
					})
				end
			}

			arg0_34.viewComponent:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_PANEL, var7_36)
		end
	}, function()
		assert(false)
	end)
end

function var0_0.initNotificationHandleDic(arg0_42)
	arg0_42.handleDic = {
		[NewShopMainScene.SHOW_OR_HIDE_UI] = function(arg0_43, arg1_43)
			arg0_43.viewComponent:ShowOrHideUI(arg1_43:getBody())
		end,
		[NewShopMainScene.SHOW_OR_HIDE_UI_2] = function(arg0_44, arg1_44)
			arg0_44.viewComponent:ShowOrHideUI2(arg1_44:getBody())
		end,
		[NewShopMainScene.CLOSE_VIEW] = function(arg0_45, arg1_45)
			arg0_45.viewComponent:closeView()
		end,
		[PlayerProxy.UPDATED] = function(arg0_46, arg1_46)
			local var0_46 = arg1_46:getBody()

			arg0_46.viewComponent:setPlayer(var0_46)
			arg0_46.viewComponent:updateNoRes()
		end,
		[ShopsProxy.FIRST_CHARGE_IDS_UPDATED] = function(arg0_47, arg1_47)
			arg0_47.viewComponent:setFirstChargeIds(arg1_47:getBody())
			arg0_47.viewComponent:updateCurSubView()
		end,
		[ShopsProxy.CHARGED_LIST_UPDATED] = function(arg0_48, arg1_48)
			arg0_48.viewComponent:setChargedList(arg1_48:getBody())
			arg0_48.viewComponent:updateCurSubView()
		end,
		[GAME.CHARGE_CONFIRM_FAILED] = function(arg0_49, arg1_49)
			local var0_49 = arg1_49:getBody()

			getProxy(ShopsProxy):chargeFailed(var0_49.payId, var0_49.bsId)
		end,
		[GAME.SHOPPING_DONE] = function(arg0_50, arg1_50)
			local var0_50 = arg1_50:getBody()
			local var1_50

			if var0_50.shopType == ShopArgs.ShopStreet then
				local var2_50 = getProxy(ShopsProxy):getShopStreet()
				local var3_50 = var2_50:getGoodsById(var0_50.id)

				arg0_50.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHOP_STREET, var2_50, var0_50.id)
			elseif var0_50.shopType == ShopArgs.MilitaryShop then
				local var4_50 = getProxy(ShopsProxy):getMeritorousShop()
				local var5_50 = var4_50.goods[var0_50.id]

				arg0_50.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_MILITARY_SHOP, var4_50, var0_50.id)
			end

			if var0_50.awards and #var0_50.awards > 0 then
				arg0_50.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_50.awards)
			end

			local var6_50 = var0_50.normalList
			local var7_50 = var0_50.normalGroupList

			if var6_50 then
				arg0_50.viewComponent:setNormalList(var6_50)
			end

			if var7_50 then
				arg0_50.viewComponent:setNormalGroupList(var7_50)
			end

			local var8_50 = pg.shop_template[var0_50.id]

			arg0_50.viewComponent:checkBuyDone(var0_50.id)
			arg0_50.viewComponent:updateCurSubView()
			pg.EasyRedDotMgr.GetInstance():TriggerMarks("specialShop")
		end,
		[GAME.USE_ITEM_DONE] = function(arg0_51, arg1_51)
			local var0_51 = arg1_51:getBody()

			if #var0_51.drops ~= 0 then
				arg0_51.viewComponent:emit(BaseUI.ON_AWARD, {
					items = var0_51.drops
				})
			end
		end,
		[GAME.GET_CHARGE_LIST_DONE] = function(arg0_52, arg1_52)
			local var0_52 = arg1_52:getBody()
			local var1_52 = var0_52.firstChargeIds
			local var2_52 = var0_52.chargedList
			local var3_52 = var0_52.normalList
			local var4_52 = var0_52.normalGroupList

			if var1_52 then
				arg0_52.viewComponent:setFirstChargeIds(var1_52)
			end

			if var2_52 then
				arg0_52.viewComponent:setChargedList(var2_52)
			end

			if var3_52 then
				arg0_52.viewComponent:setNormalList(var3_52)
			end

			if var4_52 then
				arg0_52.viewComponent:setNormalGroupList(var4_52)
			end

			if var1_52 or var2_52 or var3_52 or var4_52 then
				arg0_52.viewComponent:updateCurSubView()
			end

			pg.EasyRedDotMgr.GetInstance():TriggerMarks("specialShop")
		end,
		[GAME.CLICK_MING_SHI_SUCCESS] = function(arg0_53, arg1_53)
			arg0_53.viewComponent:playHeartEffect()
		end,
		[PlayerResUI.GO_MALL] = function(arg0_54, arg1_54)
			local var0_54 = arg1_54:getBody()
			local var1_54 = ChargeScene.TYPE_DIAMOND

			if var0_54 then
				var1_54 = var0_54.type or ChargeScene.TYPE_DIAMOND
			end

			arg0_54.viewComponent:switchSubViewByTogger(var1_54)
			arg0_54.viewComponent:updateNoRes(var0_54 and var0_54.noRes or nil)
		end,
		[GAME.CHARGE_SUCCESS] = function(arg0_55, arg1_55)
			local var0_55 = arg1_55:getBody()

			arg0_55.viewComponent:checkBuyDone("damonds")

			local var1_55 = Goods.Create({
				shop_id = var0_55.shopId
			}, Goods.TYPE_CHARGE)

			arg0_55.viewComponent:OnChargeSuccess(var1_55)
		end,
		[ShopsProxy.SHOPPINGSTREET_UPDATE] = function(arg0_56, arg1_56)
			local var0_56 = arg1_56:getBody()

			arg0_56.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHOP_STREET, var0_56.shopStreet)
		end,
		[ShopsProxy.MERITOROUS_SHOP_UPDATED] = function(arg0_57, arg1_57)
			arg0_57.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MILITARY_SHOP, arg1_57:getBody())
		end,
		[ShopsProxy.SHAM_SHOP_UPDATED] = function(arg0_58, arg1_58)
			arg0_58.viewComponent:OnUpdateShop(NewShopsScene.TYPE_SHAM_SHOP, arg1_58:getBody())
		end,
		[GAME.SHAM_SHOPPING_DONE] = function(arg0_59, arg1_59)
			local var0_59 = arg1_59:getBody()
			local var1_59 = getProxy(ShopsProxy):getShamShop()

			arg0_59.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_SHAM_SHOP, var1_59, var0_59.id)
			arg0_59.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_59.awards)
		end,
		[BagProxy.ITEM_UPDATED] = function(arg0_60, arg1_60)
			local var0_60 = getProxy(BagProxy):getRawData()

			arg0_60.viewComponent:OnUpdateItems(var0_60)
		end,
		[GAME.FRAG_SHOPPING_DONE] = function(arg0_61, arg1_61)
			local var0_61 = arg1_61:getBody()
			local var1_61 = getProxy(ShopsProxy):getFragmentShop()

			arg0_61.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_FRAGMENT, var1_61, var0_61.id)
			arg0_61.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_61.awards)
		end,
		[ShopsProxy.FRAGMENT_SHOP_UPDATED] = function(arg0_62, arg1_62)
			arg0_62.viewComponent:OnUpdateShop(NewShopsScene.TYPE_FRAGMENT, arg1_62:getBody())
		end,
		[ShopsProxy.ACTIVITY_SHOP_GOODS_UPDATED] = function(arg0_63, arg1_63)
			local var0_63 = arg1_63:getBody()
			local var1_63 = getProxy(ShopsProxy):getActivityShopById(var0_63.activityId)

			arg0_63.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_ACTIVITY, var1_63, var0_63.goodsId)
		end,
		[ShopsProxy.META_SHOP_GOODS_UPDATED] = function(arg0_64, arg1_64)
			local var0_64 = arg1_64:getBody()
			local var1_64 = getProxy(ShopsProxy):GetMetaShop()

			arg0_64.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_META, var1_64, var0_64.goodsId)
		end,
		[ShopsProxy.ACTIVITY_SHOP_UPDATED] = function(arg0_65, arg1_65)
			local var0_65 = arg1_65:getBody()

			arg0_65.viewComponent:OnUpdateShop(NewShopsScene.TYPE_ACTIVITY, var0_65.shop)
		end,
		[ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS] = function(arg0_66, arg1_66)
			local var0_66 = arg1_66:getBody()

			arg0_66.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_66.awards, var0_66.callback)
		end,
		[GAME.FRAG_SELL_DONE] = function(arg0_67, arg1_67)
			local var0_67 = arg1_67:getBody()

			arg0_67.viewComponent:OnFragmentSellUpdate()
			arg0_67.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_67.awards)
		end,
		[GAME.ON_GUILD_SHOP_PURCHASE_DONE] = function(arg0_68, arg1_68)
			local var0_68 = arg1_68:getBody()

			arg0_68.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_68.awards)
		end,
		[GAME.ON_MEDAL_SHOP_PURCHASE_DONE] = function(arg0_69, arg1_69)
			local var0_69 = arg1_69:getBody()

			arg0_69.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_69.awards)
		end,
		[ShopsProxy.GUILD_SHOP_UPDATED] = function(arg0_70, arg1_70)
			local var0_70 = arg1_70:getBody()

			arg0_70.viewComponent:OnUpdateShop(NewShopsScene.TYPE_GUILD, var0_70.shop)
		end,
		[ShopsProxy.GUILD_SHOP_ADDED] = function(arg0_71, arg1_71)
			local var0_71 = arg1_71:getBody()

			arg0_71.viewComponent:OnUpdateShop(NewShopsScene.TYPE_GUILD, var0_71.shop)
		end,
		[ShopsProxy.MEDAL_SHOP_UPDATED] = function(arg0_72, arg1_72)
			arg0_72.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MEDAL, arg1_72:getBody())
		end,
		[GAME.ON_META_SHOPPING_DONE] = function(arg0_73, arg1_73)
			local var0_73 = arg1_73:getBody()

			arg0_73.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_73.awards)
		end,
		[ShopsProxy.QUOTA_SHOP_UPDATED] = function(arg0_74, arg1_74)
			local var0_74 = arg1_74:getBody()

			arg0_74.viewComponent:OnUpdateShop(NewShopsScene.TYPE_QUOTA, var0_74.shop)
		end,
		[GAME.QUOTA_SHOPPING_DONE] = function(arg0_75, arg1_75)
			local var0_75 = arg1_75:getBody()
			local var1_75 = getProxy(ShopsProxy):getQuotaShop()

			arg0_75.viewComponent:OnUpdateCommodity(NewShopsScene.TYPE_QUOTA, var1_75, var0_75.id)
			arg0_75.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_75.awards)
		end,
		[GAME.MINI_GAME_SHOP_BUY_DONE] = function(arg0_76, arg1_76)
			local var0_76 = arg1_76:getBody().list

			if var0_76 and #var0_76 > 0 then
				arg0_76.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_76)
			end

			local var1_76 = getProxy(ShopsProxy):getMiniShop()

			arg0_76.viewComponent:OnUpdateShop(NewShopsScene.TYPE_MINI_GAME, var1_76)
		end,
		[var0_0.NOTI_UPDATE_CURRENT] = function(arg0_77, arg1_77)
			arg0_77.viewComponent:updateCurSubView()
			pg.EasyRedDotMgr.GetInstance():TriggerMarks("specialShop")
		end,
		[var0_0.ON_SUBLAYER_EVENT] = function(arg0_78, arg1_78)
			local var0_78 = arg1_78:getBody()

			arg0_78.viewComponent:emit(unpackEx(var0_78))
		end
	}
end

return var0_0
