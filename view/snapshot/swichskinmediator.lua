local var0 = class("SwichSkinMediator", import("..base.ContextMediator"))

var0.CHANGE_SKIN = "SwichSkinMediator:CHANGE_SKIN"
var0.BUY_ITEM = "SwichSkinMediator:BUY_ITEM"
var0.UPDATE_SKINCONFIG = "SwichSkinMediator:UPDATE_SKINCONFIG"
var0.BUY_ITEM_BY_ACT = "SwichSkinMediator:BUY_ITEM_BY_ACT"

function var0.register(arg0)
	arg0.shipVO = arg0.contextData.shipVO

	if arg0.shipVO then
		arg0.viewComponent:setShip(arg0.shipVO)

		local var0 = getProxy(ShipSkinProxy):getSkinList()

		arg0.viewComponent:setSkinList(var0)
	end

	arg0:bind(var0.BUY_ITEM_BY_ACT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SKIN_COUPON_SHOPPING, {
			shopId = arg1,
			cnt = arg2
		})
	end)
	arg0:bind(var0.CHANGE_SKIN, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SET_SHIP_SKIN, {
			shipId = arg1,
			skinId = arg2
		})
	end)
	arg0:bind(var0.BUY_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.UPDATE_SKINCONFIG, function(arg0, arg1)
		arg0:sendNotification(GAME.UPDATE_SKINCONFIG, {
			skinId = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ShipSkinProxy.SHIP_SKINS_UPDATE,
		GAME.SKIN_SHOPPIGN_DONE,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		BayProxy.SHIP_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SKIN_SHOPPIGN_DONE or var0 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var2 = pg.shop_template[var1.id]

		if var2 and var2.genre == ShopArgs.SkinShop then
			arg0:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var2.effect_args[1]
				}
			}))
		end
	elseif var0 == ShipSkinProxy.SHIP_SKINS_UPDATE then
		local var3 = getProxy(ShipSkinProxy):getSkinList()

		arg0.viewComponent:setSkinList(var3)
		arg0.viewComponent:openSelectSkinPanel()
	elseif var0 == BayProxy.SHIP_UPDATED and var1.id == arg0.shipVO.id then
		arg0.viewComponent:setShip(var1)

		local var4 = getProxy(ShipSkinProxy):getSkinList()

		arg0.viewComponent:setSkinList(var4)
		arg0.viewComponent:openSelectSkinPanel()
	end
end

return var0
