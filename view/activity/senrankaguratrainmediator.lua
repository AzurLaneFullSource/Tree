local var0 = class("SenrankaguraTrainMediator", import("..base.ContextMediator"))

var0.LEVEL_UP = "level up"
var0.GET_REWARD = "get reward"

function var0.register(arg0)
	arg0:bind(var0.LEVEL_UP, function(arg0, arg1)
		arg0:sendNotification(GAME.SENRANKAGURA_TRAIN_ACT_OP, arg1)
	end)
	arg0:bind(var0.GET_REWARD, function(arg0, arg1)
		arg0:sendNotification(GAME.SENRANKAGURA_TRAIN_ACT_OP, arg1)
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.SENRANKAGURA_TRAIN_ACT_OP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:LevelUp(var0)
		end
	}
end

return var0
