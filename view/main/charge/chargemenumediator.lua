local var0 = class("ChargeMenuMediator", import("...base.ContextMediator"))

var0.GO_SKIN_SHOP = "ChargeMenuMediator:GO_SKIN_SHOP"
var0.GO_SUPPLY_SHOP = "ChargeMenuMediator:GO_SUPPLY_SHOP"
var0.GO_CHARGE_SHOP = "ChargeMenuMediator:GO_CHARGE_SHOP"

function var0.register(arg0)
	arg0:bindEvent()
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.CHARGE_SUCCESS,
		GAME.SHOPPING_DONE,
		GAME.REMOVE_LAYER_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:updatePlayerRes(var1)
	elseif var0 == GAME.CHARGE_SUCCESS or var0 == GAME.SHOPPING_DONE then
		arg0.viewComponent:FlushBanner()

		if arg0.viewComponent.lookUpIndex then
			pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_BUY_RECOMMEND, arg0.viewComponent.lookUpIndex))
		end

		if var0 == GAME.CHARGE_SUCCESS then
			local var2 = Goods.Create({
				shop_id = var1.shopId
			}, Goods.TYPE_CHARGE)

			arg0.viewComponent:OnChargeSuccess(var2)
		end
	elseif var0 == GAME.REMOVE_LAYER_DONE then
		arg0.viewComponent:OnRemoveLayer(var1)
	end
end

function var0.bindEvent(arg0)
	arg0:bind(var0.GO_SKIN_SHOP, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:bind(var0.GO_SUPPLY_SHOP, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1)
	end)
	arg0:bind(var0.GO_CHARGE_SHOP, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg1
		})
	end)
end

return var0
