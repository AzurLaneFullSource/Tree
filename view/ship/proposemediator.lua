local var0_0 = class("ProposeMediator", import("..base.ContextMediator"))

var0_0.ON_PROPOSE = "ProposeMediator.ON_PROPOSE"
var0_0.RENAME_SHIP = "ProposeMediator.RENAME_SHIP"
var0_0.HIDE_SHIP_MAIN_WORD = "ShipMainMediator.HIDE_SHIP_MAIN_WORD"
var0_0.EXCHANGE_TIARA = "ProposeMediator.EXCHANGE_TIARA"
var0_0.REGISTER_SHIP = "ProposeMediator.REGISTER_SHIP"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(BayProxy)

	if arg0_1.contextData.shipId then
		local var1_1 = var0_1:getShipById(arg0_1.contextData.shipId)

		arg0_1.viewComponent:setShip(var1_1)
	elseif arg0_1.contextData.review then
		arg0_1.viewComponent:setShipGroupID(arg0_1.contextData.group.id)
		arg0_1.viewComponent:setWeddingReviewSkinID(arg0_1.contextData.skinID)
	end

	local var2_1 = getProxy(BagProxy)

	arg0_1.viewComponent:setBagProxy(var2_1)

	local var3_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var3_1)
	arg0_1:bind(var0_0.ON_PROPOSE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.PROPOSE_SHIP, {
			shipId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.RENAME_SHIP, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.RENAME_SHIP, {
			shipId = arg1_3,
			name = arg2_3
		})
	end)
	arg0_1:bind(var0_0.HIDE_SHIP_MAIN_WORD, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.HIDE_Ship_MAIN_SCENE_WORD)
	end)
	arg0_1:bind(var0_0.EXCHANGE_TIARA, function(arg0_5)
		arg0_1:sendNotification(GAME.PROPOSE_EXCHANGE_RING)
	end)
	arg0_1:bind(var0_0.REGISTER_SHIP, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.PROPOSE_REGISTER_SHIP, {
			shipId = arg1_6
		})
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.PROPOSE_SHIP_DONE,
		GAME.RENAME_SHIP_DONE,
		GAME.PROPOSE_EXCHANGE_RING_DONE,
		GAME.PROPOSE_REGISTER_SHIP_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.PROPOSE_SHIP_DONE then
		local var2_8 = var1_8.ship:getProposeSkin()

		if var2_8 then
			arg0_8:sendNotification(GAME.SET_SHIP_SKIN, {
				hideTip = true,
				shipId = var1_8.ship.id,
				skinId = var2_8.id
			})
		end

		arg0_8.viewComponent:setShip(var1_8.ship)
		arg0_8.viewComponent:RingFadeout()
	elseif var0_8 == GAME.RENAME_SHIP_DONE then
		arg0_8.viewComponent:closeView()
	elseif var0_8 == GAME.PROPOSE_EXCHANGE_RING_DONE then
		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.items, function()
			arg0_8.viewComponent:onUpdateItemCount()
		end)
	elseif var0_8 == GAME.PROPOSE_REGISTER_SHIP_DONE and arg0_8.viewComponent.afterRegisterCall then
		arg0_8.viewComponent.afterRegisterCall()
	end
end

return var0_0
