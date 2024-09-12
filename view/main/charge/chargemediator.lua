local var0_0 = class("ChargeMediator", import("...base.ContextMediator"))

var0_0.SWITCH_TO_SHOP = "ChargeMediator:SWITCH_TO_SHOP"
var0_0.CHARGE = "ChargeMediator:CHARGE"
var0_0.BUY_ITEM = "ChargeMediator:BUY_ITEM"
var0_0.CLICK_MING_SHI = "ChargeMediator:CLICK_MING_SHI"
var0_0.GET_CHARGE_LIST = "ChargeMediator:GET_CHARGE_LIST"
var0_0.ON_SKIN_SHOP = "ChargeMediator:ON_SKIN_SHOP"
var0_0.OPEN_CHARGE_ITEM_PANEL = "ChargeMediator:OPEN_CHARGE_ITEM_PANEL"
var0_0.OPEN_CHARGE_ITEM_BOX = "ChargeMediator:OPEN_CHARGE_ITEM_BOX"
var0_0.OPEN_CHARGE_BIRTHDAY = "ChargeMediator:OPEN_CHARGE_BIRTHDAY"
var0_0.OPEN_USER_AGREE = "ChargeMediator:OPEN_USER_AGREE"
var0_0.VIEW_SKIN_PROBABILITY = "ChargeMediator:VIEW_SKIN_PROBABILITY"
var0_0.OPEN_TEC_SHIP_GIFT_SELL_LAYER = "ChargeMediator:OPEN_TEC_SHIP_GIFT_SELL_LAYER"
var0_0.OPEN_BATTLE_UI_SELL_LAYER = "ChargeMediator:OPEN_BATTLE_UI_SELL_LAYER"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)
	arg0_1.viewComponent:checkFreeGiftTag()
	arg0_1:bind(var0_0.VIEW_SKIN_PROBABILITY, function(arg0_2, arg1_2)
		arg0_1.contextData.wrap = ChargeScene.TYPE_GIFT

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.PROBABILITY_SKINSHOP, {
			commodityId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.GET_CHARGE_LIST, function(arg0_3)
		arg0_1:sendNotification(GAME.GET_CHARGE_LIST)
	end)
	arg0_1:bind(var0_0.ON_SKIN_SHOP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
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
end

function var0_0.listNotificationInterests(arg0_15)
	return {
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
		GAME.CHARGE_SUCCESS
	}
end

function var0_0.handleNotification(arg0_16, arg1_16)
	local var0_16 = arg1_16:getName()
	local var1_16 = arg1_16:getBody()

	if var0_16 == PlayerProxy.UPDATED then
		arg0_16.viewComponent:setPlayer(var1_16)
		arg0_16.viewComponent:updateNoRes()
	elseif var0_16 == ShopsProxy.FIRST_CHARGE_IDS_UPDATED then
		arg0_16.viewComponent:setFirstChargeIds(var1_16)
		arg0_16.viewComponent:updateCurSubView()
	elseif var0_16 == ShopsProxy.CHARGED_LIST_UPDATED then
		arg0_16.viewComponent:setChargedList(var1_16)
		arg0_16.viewComponent:updateCurSubView()
	elseif var0_16 == GAME.CHARGE_CONFIRM_FAILED then
		getProxy(ShopsProxy):chargeFailed(var1_16.payId, var1_16.bsId)
	elseif var0_16 == GAME.SHOPPING_DONE then
		if var1_16.awards and #var1_16.awards > 0 then
			arg0_16.viewComponent:unBlurView()
			arg0_16.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_16.awards
			})
		end

		local var2_16 = var1_16.normalList
		local var3_16 = var1_16.normalGroupList

		if var2_16 then
			arg0_16.viewComponent:setNormalList(var2_16)
		end

		if var3_16 then
			arg0_16.viewComponent:setNormalGroupList(var3_16)
		end

		local var4_16 = pg.shop_template[var1_16.id]

		arg0_16.viewComponent:checkBuyDone(var1_16.id)
		arg0_16.viewComponent:updateCurSubView()
		arg0_16.viewComponent:checkFreeGiftTag()
	elseif var0_16 == GAME.USE_ITEM_DONE then
		if table.getCount(var1_16) ~= 0 then
			arg0_16.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_16
			})
		end
	elseif var0_16 == GAME.GET_CHARGE_LIST_DONE then
		local var5_16 = var1_16.firstChargeIds
		local var6_16 = var1_16.chargedList
		local var7_16 = var1_16.normalList
		local var8_16 = var1_16.normalGroupList

		if var5_16 then
			arg0_16.viewComponent:setFirstChargeIds(var5_16)
		end

		if var6_16 then
			arg0_16.viewComponent:setChargedList(var6_16)
		end

		if var7_16 then
			arg0_16.viewComponent:setNormalList(var7_16)
		end

		if var8_16 then
			arg0_16.viewComponent:setNormalGroupList(var8_16)
		end

		if var5_16 or var6_16 or var7_16 or var8_16 then
			arg0_16.viewComponent:updateCurSubView()
		end

		arg0_16.viewComponent:checkFreeGiftTag()
	elseif var0_16 == GAME.CLICK_MING_SHI_SUCCESS then
		arg0_16.viewComponent:playHeartEffect()
	elseif var0_16 == PlayerResUI.GO_MALL then
		local var9_16 = ChargeScene.TYPE_DIAMOND

		if var1_16 then
			var9_16 = var1_16.type or ChargeScene.TYPE_DIAMOND
		end

		arg0_16.viewComponent:switchSubViewByTogger(var9_16)
		arg0_16.viewComponent:updateNoRes(var1_16 and var1_16.noRes or nil)
	elseif var0_16 == GAME.CHARGE_SUCCESS then
		arg0_16.viewComponent:checkBuyDone("damonds")

		local var10_16 = Goods.Create({
			shop_id = var1_16.shopId
		}, Goods.TYPE_CHARGE)

		arg0_16.viewComponent:OnChargeSuccess(var10_16)
	end
end

return var0_0
