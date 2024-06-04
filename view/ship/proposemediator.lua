local var0 = class("ProposeMediator", import("..base.ContextMediator"))

var0.ON_PROPOSE = "ProposeMediator.ON_PROPOSE"
var0.RENAME_SHIP = "ProposeMediator.RENAME_SHIP"
var0.HIDE_SHIP_MAIN_WORD = "ShipMainMediator.HIDE_SHIP_MAIN_WORD"
var0.EXCHANGE_TIARA = "ProposeMediator.EXCHANGE_TIARA"
var0.REGISTER_SHIP = "ProposeMediator.REGISTER_SHIP"

function var0.register(arg0)
	local var0 = getProxy(BayProxy)

	if arg0.contextData.shipId then
		local var1 = var0:getShipById(arg0.contextData.shipId)

		arg0.viewComponent:setShip(var1)
	elseif arg0.contextData.review then
		arg0.viewComponent:setShipGroupID(arg0.contextData.group.id)
		arg0.viewComponent:setWeddingReviewSkinID(arg0.contextData.skinID)
	end

	local var2 = getProxy(BagProxy)

	arg0.viewComponent:setBagProxy(var2)

	local var3 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var3)
	arg0:bind(var0.ON_PROPOSE, function(arg0, arg1)
		arg0:sendNotification(GAME.PROPOSE_SHIP, {
			shipId = arg1
		})
	end)
	arg0:bind(var0.RENAME_SHIP, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.RENAME_SHIP, {
			shipId = arg1,
			name = arg2
		})
	end)
	arg0:bind(var0.HIDE_SHIP_MAIN_WORD, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.HIDE_Ship_MAIN_SCENE_WORD)
	end)
	arg0:bind(var0.EXCHANGE_TIARA, function(arg0)
		arg0:sendNotification(GAME.PROPOSE_EXCHANGE_RING)
	end)
	arg0:bind(var0.REGISTER_SHIP, function(arg0, arg1)
		arg0:sendNotification(GAME.PROPOSE_REGISTER_SHIP, {
			shipId = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.PROPOSE_SHIP_DONE,
		GAME.RENAME_SHIP_DONE,
		GAME.PROPOSE_EXCHANGE_RING_DONE,
		GAME.PROPOSE_REGISTER_SHIP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.PROPOSE_SHIP_DONE then
		local var2 = var1.ship:getProposeSkin()

		if var2 then
			arg0:sendNotification(GAME.SET_SHIP_SKIN, {
				hideTip = true,
				shipId = var1.ship.id,
				skinId = var2.id
			})
		end

		arg0.viewComponent:setShip(var1.ship)
		arg0.viewComponent:RingFadeout()
	elseif var0 == GAME.RENAME_SHIP_DONE then
		arg0.viewComponent:closeView()
	elseif var0 == GAME.PROPOSE_EXCHANGE_RING_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.items, function()
			arg0.viewComponent:onUpdateItemCount()
		end)
	elseif var0 == GAME.PROPOSE_REGISTER_SHIP_DONE and arg0.viewComponent.afterRegisterCall then
		arg0.viewComponent.afterRegisterCall()
	end
end

return var0
