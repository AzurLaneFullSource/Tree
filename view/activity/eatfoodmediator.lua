local var0_0 = class("EatFoodMediator", import("..base.ContextMediator"))

var0_0.GAME_HIT_AREA = "game hit score"
var0_0.GAME_CLOSE = "game close"
var0_0.GAME_RESULT = "game result"
var0_0.HIT_AREA = "EatFoodMediator:event hit area"
var0_0.LEAVE_GAME = "EatFoodMediato:event leave game"
var0_0.RESULT = "EatFoodMediato:event result"

function var0_0.register(arg0_1)
	arg0_1:bind(EatFoodMediator.GAME_HIT_AREA, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(EatFoodMediator.HIT_AREA, arg1_2)
	end)
	arg0_1:bind(EatFoodMediator.GAME_CLOSE, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(EatFoodMediator.LEAVE_GAME, arg1_3)
	end)
	arg0_1:bind(EatFoodMediator.GAME_RESULT, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(EatFoodMediator.RESULT, arg1_4)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()
end

return var0_0
