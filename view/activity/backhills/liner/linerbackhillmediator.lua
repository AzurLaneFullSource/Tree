local var0_0 = class("LinerBackHillMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0_0.GO_MINIGAME = "GO_MINIGAME"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
	arg0_1:bind(var0_0.GO_MINIGAME, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.GO_MINI_GAME, arg1_2, ...)
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.ACTIVITY_LINER_OP_DONE] = function(arg0_4, arg1_4)
			arg0_4.viewComponent:UpdateView()
		end
	}
end

return var0_0
