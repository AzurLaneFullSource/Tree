local var0_0 = class("MallMapMediator", import("view.base.ContextMediator"))

var0_0.CHANGE_SCENE = "MallMapMediator.CHANGE_SCENE"
var0_0.GO_SCENE = "MallMapMediator.GO_SCENE"
var0_0.GO_SUBLAYER = "MallMapMediator.GO_SUBLAYER"
var0_0.TRIGGER_POINT = "MallMapMediator.TRIGGER_POINT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CHANGE_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_4, arg1_4, arg2_4)
		arg0_1:addSubLayers(arg1_4, nil, arg2_4)
	end)
	arg0_1:bind(var0_0.TRIGGER_POINT, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg1_5,
			cmd = ActivityMallOPCommand.CMD.TRIGGER_POINT,
			arg1 = arg2_5
		})
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.ACTIVITY_MALL_OP_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.ACTIVITY_MALL_OP_DONE and var1_7.cmd == ActivityMallOPCommand.CMD.TRIGGER_POINT then
		arg0_7.viewComponent:UpdateData()
		arg0_7.viewComponent:UpdateView()
	end
end

return var0_0
