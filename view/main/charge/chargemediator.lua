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
end

function var0_0.listNotificationInterests(arg0_14)
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

function var0_0.handleNotification(arg0_15, arg1_15)
	local var0_15 = arg1_15:getName()
	local var1_15 = arg1_15:getBody()

	if var0_15 == PlayerProxy.UPDATED then
		arg0_15.viewComponent:setPlayer(var1_15)
		arg0_15.viewComponent:updateNoRes()
	elseif var0_15 == ShopsProxy.FIRST_CHARGE_IDS_UPDATED then
		arg0_15.viewComponent:setFirstChargeIds(var1_15)
		arg0_15.viewComponent:updateCurSubView()
	elseif var0_15 == ShopsProxy.CHARGED_LIST_UPDATED then
		arg0_15.viewComponent:setChargedList(var1_15)
		arg0_15.viewComponent:updateCurSubView()
	elseif var0_15 == GAME.CHARGE_CONFIRM_FAILED then
		getProxy(ShopsProxy):chargeFailed(var1_15.payId, var1_15.bsId)
	elseif var0_15 == GAME.SHOPPING_DONE then
		if var1_15.awards and #var1_15.awards > 0 then
			arg0_15.viewComponent:unBlurView()
			arg0_15.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_15.awards
			})
		end

		local var2_15 = var1_15.normalList
		local var3_15 = var1_15.normalGroupList

		if var2_15 then
			arg0_15.viewComponent:setNormalList(var2_15)
		end

		if var3_15 then
			arg0_15.viewComponent:setNormalGroupList(var3_15)
		end

		local var4_15 = pg.shop_template[var1_15.id]

		arg0_15.viewComponent:checkBuyDone(var1_15.id)
		arg0_15.viewComponent:updateCurSubView()
		arg0_15.viewComponent:checkFreeGiftTag()
	elseif var0_15 == GAME.USE_ITEM_DONE then
		if table.getCount(var1_15) ~= 0 then
			arg0_15.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_15
			})
		end
	elseif var0_15 == GAME.GET_CHARGE_LIST_DONE then
		local var5_15 = var1_15.firstChargeIds
		local var6_15 = var1_15.chargedList
		local var7_15 = var1_15.normalList
		local var8_15 = var1_15.normalGroupList

		if var5_15 then
			arg0_15.viewComponent:setFirstChargeIds(var5_15)
		end

		if var6_15 then
			arg0_15.viewComponent:setChargedList(var6_15)
		end

		if var7_15 then
			arg0_15.viewComponent:setNormalList(var7_15)
		end

		if var8_15 then
			arg0_15.viewComponent:setNormalGroupList(var8_15)
		end

		if var5_15 or var6_15 or var7_15 or var8_15 then
			arg0_15.viewComponent:updateCurSubView()
		end

		arg0_15.viewComponent:checkFreeGiftTag()
	elseif var0_15 == GAME.CLICK_MING_SHI_SUCCESS then
		arg0_15.viewComponent:playHeartEffect()
	elseif var0_15 == PlayerResUI.GO_MALL then
		local var9_15 = ChargeScene.TYPE_DIAMOND

		if var1_15 then
			var9_15 = var1_15.type or ChargeScene.TYPE_DIAMOND
		end

		arg0_15.viewComponent:switchSubViewByTogger(var9_15)
		arg0_15.viewComponent:updateNoRes(var1_15 and var1_15.noRes or nil)
	elseif var0_15 == GAME.CHARGE_SUCCESS then
		arg0_15.viewComponent:checkBuyDone("damonds")

		local var10_15 = Goods.Create({
			shop_id = var1_15.shopId
		}, Goods.TYPE_CHARGE)

		arg0_15.viewComponent:OnChargeSuccess(var10_15)
	end
end

return var0_0
