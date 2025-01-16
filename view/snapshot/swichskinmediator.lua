local var0_0 = class("SwichSkinMediator", import("..base.ContextMediator"))

var0_0.CHANGE_SKIN = "SwichSkinMediator:CHANGE_SKIN"
var0_0.BUY_ITEM = "SwichSkinMediator:BUY_ITEM"
var0_0.UPDATE_SKINCONFIG = "SwichSkinMediator:UPDATE_SKINCONFIG"
var0_0.BUY_ITEM_BY_ACT = "SwichSkinMediator:BUY_ITEM_BY_ACT"

function var0_0.register(arg0_1)
	arg0_1.shipVO = arg0_1.contextData.shipVO

	if arg0_1.shipVO then
		arg0_1.viewComponent:setShip(arg0_1.shipVO)

		local var0_1 = getProxy(ShipSkinProxy):getSkinList()

		arg0_1.viewComponent:setSkinList(var0_1)
	end

	arg0_1:bind(var0_0.BUY_ITEM_BY_ACT, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.SKIN_COUPON_SHOPPING, {
			shopId = arg1_2,
			cnt = arg2_2
		})
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.SET_SHIP_SKIN, {
			shipId = arg1_3,
			skinId = arg2_3
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1_4,
			count = arg2_4
		})
	end)
	arg0_1:bind(var0_0.UPDATE_SKINCONFIG, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.UPDATE_SKINCONFIG, {
			skinId = arg1_5
		})
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		ShipSkinProxy.SHIP_SKINS_UPDATE,
		GAME.SKIN_SHOPPIGN_DONE,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		BayProxy.SHIP_UPDATED,
		GAME.CHANGE_SKIN_UPDATE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.SKIN_SHOPPIGN_DONE or var0_7 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var2_7 = pg.shop_template[var1_7.id]

		if var2_7 and var2_7.genre == ShopArgs.SkinShop then
			arg0_7:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var2_7.effect_args[1]
				}
			}))
		end
	elseif var0_7 == ShipSkinProxy.SHIP_SKINS_UPDATE then
		local var3_7 = getProxy(ShipSkinProxy):getSkinList()

		arg0_7.viewComponent:setSkinList(var3_7)
		arg0_7.viewComponent:openSelectSkinPanel()
	elseif var0_7 == BayProxy.SHIP_UPDATED then
		if var1_7.id == arg0_7.shipVO.id then
			arg0_7.viewComponent:setShip(var1_7)

			local var4_7 = getProxy(ShipSkinProxy):getSkinList()

			arg0_7.viewComponent:setSkinList(var4_7)
			arg0_7.viewComponent:openSelectSkinPanel()
		end
	elseif var0_7 == GAME.CHANGE_SKIN_UPDATE and var1_7.id == arg0_7.shipVO.id then
		arg0_7.viewComponent:setShip(var1_7)

		local var5_7 = getProxy(ShipSkinProxy):getSkinList()

		arg0_7.viewComponent:setSkinList(var5_7)
		arg0_7.viewComponent:openSelectSkinPanel()
	end
end

return var0_0
