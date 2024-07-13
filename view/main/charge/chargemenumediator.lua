local var0_0 = class("ChargeMenuMediator", import("...base.ContextMediator"))

var0_0.GO_SKIN_SHOP = "ChargeMenuMediator:GO_SKIN_SHOP"
var0_0.GO_SUPPLY_SHOP = "ChargeMenuMediator:GO_SUPPLY_SHOP"
var0_0.GO_CHARGE_SHOP = "ChargeMenuMediator:GO_CHARGE_SHOP"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		PlayerProxy.UPDATED,
		GAME.CHARGE_SUCCESS,
		GAME.SHOPPING_DONE,
		GAME.REMOVE_LAYER_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == PlayerProxy.UPDATED then
		arg0_3.viewComponent:updatePlayerRes(var1_3)
	elseif var0_3 == GAME.CHARGE_SUCCESS or var0_3 == GAME.SHOPPING_DONE then
		arg0_3.viewComponent:FlushBanner()

		if arg0_3.viewComponent.lookUpIndex then
			pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_BUY_RECOMMEND, arg0_3.viewComponent.lookUpIndex))
		end

		if var0_3 == GAME.CHARGE_SUCCESS then
			local var2_3 = Goods.Create({
				shop_id = var1_3.shopId
			}, Goods.TYPE_CHARGE)

			arg0_3.viewComponent:OnChargeSuccess(var2_3)
		end
	elseif var0_3 == GAME.REMOVE_LAYER_DONE then
		arg0_3.viewComponent:OnRemoveLayer(var1_3)
	end
end

function var0_0.bindEvent(arg0_4)
	arg0_4:bind(var0_0.GO_SKIN_SHOP, function(arg0_5, arg1_5)
		arg0_4:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_4:bind(var0_0.GO_SUPPLY_SHOP, function(arg0_6, arg1_6)
		arg0_4:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_6)
	end)
	arg0_4:bind(var0_0.GO_CHARGE_SHOP, function(arg0_7, arg1_7)
		arg0_4:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg1_7
		})
	end)
end

return var0_0
