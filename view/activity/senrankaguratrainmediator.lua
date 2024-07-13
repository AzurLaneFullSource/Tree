local var0_0 = class("SenrankaguraTrainMediator", import("..base.ContextMediator"))

var0_0.LEVEL_UP = "level up"
var0_0.GET_REWARD = "get reward"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.LEVEL_UP, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SENRANKAGURA_TRAIN_ACT_OP, arg1_2)
	end)
	arg0_1:bind(var0_0.GET_REWARD, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SENRANKAGURA_TRAIN_ACT_OP, arg1_3)
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.SENRANKAGURA_TRAIN_ACT_OP_DONE] = function(arg0_5, arg1_5)
			local var0_5 = arg1_5:getBody()

			arg0_5.viewComponent:LevelUp(var0_5)
		end
	}
end

return var0_0
