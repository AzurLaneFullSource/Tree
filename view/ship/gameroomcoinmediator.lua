local var0 = class("GameRoomCoinMediator", import("..base.ContextMediator"))

var0.CHANGE_VISIBLE = "GameRoomCoinMediator:CHANGE_VISIBLE"
var0.CHANGE_COIN_NUM = "GameRoomCoinMediator:CHANGE COIN COUNT"

function var0.register(arg0)
	arg0:bind(GameRoomCoinMediator.CHANGE_COIN_NUM, function(arg0, arg1)
		arg0:sendNotification(GAME.GAME_COIN_COUNT_CHANGE, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GameRoomCoinMediator.CHANGE_VISIBLE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GameRoomCoinMediator.CHANGE_VISIBLE then
		arg0.viewComponent:changeVisible(var1)
	end
end

return var0
