local var0 = class("ChargeMediator", import("...base.ContextMediator"))

var0.SWITCH_TO_SHOP = "ChargeMediator:SWITCH_TO_SHOP"
var0.CHARGE = "ChargeMediator:CHARGE"
var0.BUY_ITEM = "ChargeMediator:BUY_ITEM"
var0.CLICK_MING_SHI = "ChargeMediator:CLICK_MING_SHI"
var0.GET_CHARGE_LIST = "ChargeMediator:GET_CHARGE_LIST"
var0.ON_SKIN_SHOP = "ChargeMediator:ON_SKIN_SHOP"
var0.OPEN_CHARGE_ITEM_PANEL = "ChargeMediator:OPEN_CHARGE_ITEM_PANEL"
var0.OPEN_CHARGE_ITEM_BOX = "ChargeMediator:OPEN_CHARGE_ITEM_BOX"
var0.OPEN_CHARGE_BIRTHDAY = "ChargeMediator:OPEN_CHARGE_BIRTHDAY"
var0.OPEN_USER_AGREE = "ChargeMediator:OPEN_USER_AGREE"
var0.VIEW_SKIN_PROBABILITY = "ChargeMediator:VIEW_SKIN_PROBABILITY"
var0.OPEN_TEC_SHIP_GIFT_SELL_LAYER = "ChargeMediator:OPEN_TEC_SHIP_GIFT_SELL_LAYER"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var0)
	arg0.viewComponent:checkFreeGiftTag()
	arg0:bind(var0.VIEW_SKIN_PROBABILITY, function(arg0, arg1)
		arg0.contextData.wrap = ChargeScene.TYPE_GIFT

		arg0:sendNotification(GAME.GO_SCENE, SCENE.PROBABILITY_SKINSHOP, {
			commodityId = arg1
		})
	end)
	arg0:bind(var0.GET_CHARGE_LIST, function(arg0)
		arg0:sendNotification(GAME.GET_CHARGE_LIST)
	end)
	arg0:bind(var0.ON_SKIN_SHOP, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:bind(var0.SWITCH_TO_SHOP, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1)
	end)
	arg0:bind(var0.CHARGE, function(arg0, arg1)
		arg0:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1
		})
	end)
	arg0:bind(var0.BUY_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.CLICK_MING_SHI, function(arg0)
		arg0:sendNotification(GAME.CLICK_MING_SHI)
	end)
	arg0:bind(var0.OPEN_CHARGE_ITEM_PANEL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_CHARGE_ITEM_BOX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemBoxMediator,
			viewComponent = ChargeItemBoxLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_CHARGE_BIRTHDAY, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0:bind(var0.OPEN_USER_AGREE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeJPUserAgreeMediator,
			viewComponent = ChargeJPUserAgreeLayer,
			data = {
				contentStr = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_TEC_SHIP_GIFT_SELL_LAYER, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = ChargeTecShipGiftSellMediator,
			viewComponent = ChargeTecShipGiftSellLayer,
			data = {
				showGoodVO = arg1,
				chargedList = arg2
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
		arg0.viewComponent:updateNoRes()
	elseif var0 == ShopsProxy.FIRST_CHARGE_IDS_UPDATED then
		arg0.viewComponent:setFirstChargeIds(var1)
		arg0.viewComponent:updateCurSubView()
	elseif var0 == ShopsProxy.CHARGED_LIST_UPDATED then
		arg0.viewComponent:setChargedList(var1)
		arg0.viewComponent:updateCurSubView()
	elseif var0 == GAME.CHARGE_CONFIRM_FAILED then
		getProxy(ShopsProxy):chargeFailed(var1.payId, var1.bsId)
	elseif var0 == GAME.SHOPPING_DONE then
		if var1.awards and #var1.awards > 0 then
			arg0.viewComponent:unBlurView()
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1.awards
			})
		end

		local var2 = var1.normalList
		local var3 = var1.normalGroupList

		if var2 then
			arg0.viewComponent:setNormalList(var2)
		end

		if var3 then
			arg0.viewComponent:setNormalGroupList(var3)
		end

		local var4 = pg.shop_template[var1.id]

		arg0.viewComponent:checkBuyDone(var1.id)
		arg0.viewComponent:updateCurSubView()
		arg0.viewComponent:checkFreeGiftTag()
	elseif var0 == GAME.USE_ITEM_DONE then
		if table.getCount(var1) ~= 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1
			})
		end
	elseif var0 == GAME.GET_CHARGE_LIST_DONE then
		local var5 = var1.firstChargeIds
		local var6 = var1.chargedList
		local var7 = var1.normalList
		local var8 = var1.normalGroupList

		if var5 then
			arg0.viewComponent:setFirstChargeIds(var5)
		end

		if var6 then
			arg0.viewComponent:setChargedList(var6)
		end

		if var7 then
			arg0.viewComponent:setNormalList(var7)
		end

		if var8 then
			arg0.viewComponent:setNormalGroupList(var8)
		end

		if var5 or var6 or var7 or var8 then
			arg0.viewComponent:updateCurSubView()
		end

		arg0.viewComponent:checkFreeGiftTag()
	elseif var0 == GAME.CLICK_MING_SHI_SUCCESS then
		arg0.viewComponent:playHeartEffect()
	elseif var0 == PlayerResUI.GO_MALL then
		local var9 = ChargeScene.TYPE_DIAMOND

		if var1 then
			var9 = var1.type or ChargeScene.TYPE_DIAMOND
		end

		arg0.viewComponent:switchSubViewByTogger(var9)
		arg0.viewComponent:updateNoRes(var1 and var1.noRes or nil)
	elseif var0 == GAME.CHARGE_SUCCESS then
		arg0.viewComponent:checkBuyDone("damonds")

		local var10 = Goods.Create({
			shop_id = var1.shopId
		}, Goods.TYPE_CHARGE)

		arg0.viewComponent:OnChargeSuccess(var10)
	end
end

return var0
