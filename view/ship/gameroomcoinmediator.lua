local var0_0 = class("GameRoomCoinMediator", import("..base.ContextMediator"))

var0_0.CHANGE_VISIBLE = "GameRoomCoinMediator:CHANGE_VISIBLE"
var0_0.CHANGE_COIN_NUM = "GameRoomCoinMediator:CHANGE COIN COUNT"

function var0_0.register(arg0_1)
	arg0_1:bind(GameRoomCoinMediator.CHANGE_COIN_NUM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GAME_COIN_COUNT_CHANGE, arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GameRoomCoinMediator.CHANGE_VISIBLE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GameRoomCoinMediator.CHANGE_VISIBLE then
		arg0_4.viewComponent:changeVisible(var1_4)
	end
end

return var0_0
