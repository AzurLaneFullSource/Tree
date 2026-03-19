local var0_0 = class("NewEducateSelectMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "NewEducateSelectMediator:GO_SCENE"
var0_0.GO_SUBLAYER = "NewEducateSelectMediator.GO_SUBLAYER"
var0_0.SWITCH_DIFFICULTY = "NewEducateSelectMediator.SWITCH_DIFFICULTY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(arg1_3, nil, arg2_3)
	end)
	arg0_1:bind(var0_0.SWITCH_DIFFICULTY, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH, {
			id = arg1_4.id,
			difficulty = arg1_4.difficulty,
			callback = arg1_4.callback
		})
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
