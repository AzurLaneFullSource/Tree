local var0_0 = class("ReversePacmanGameMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "ReversePacmanGameMediator.GO_SCENE"
var0_0.GO_SUBLAYER = "ReversePacmanGameMediator.GO_SUBLAYER"
var0_0.SETTLE_GAME = "ReversePacmanGameMediator.SETTLE_GAME"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, arg2_2)
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(arg1_3, nil, arg2_3)
	end)
	arg0_1:bind(var0_0.SETTLE_GAME, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.REVERSE_PACMAN_PASS_LEVEL, {
			actId = arg1_4.actId,
			levelId = arg1_4.levelId,
			time = arg1_4.time
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.REVERSE_PACMAN_PASS_LEVEL_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.REVERSE_PACMAN_PASS_LEVEL_DONE then
		arg0_6.viewComponent:ShowSettlePanel(var1_6.awards)
	end
end

return var0_0
