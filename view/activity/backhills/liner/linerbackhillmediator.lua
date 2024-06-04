local var0 = class("LinerBackHillMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0.GO_MINIGAME = "GO_MINIGAME"

function var0.register(arg0)
	arg0:BindEvent()
	arg0:bind(var0.GO_MINIGAME, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_MINI_GAME, arg1, ...)
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.ACTIVITY_LINER_OP_DONE] = function(arg0, arg1)
			arg0.viewComponent:UpdateView()
		end
	}
end

return var0
