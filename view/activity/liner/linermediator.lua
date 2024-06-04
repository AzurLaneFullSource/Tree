local var0 = class("LinerMediator", import("view.base.ContextMediator"))

var0.GO_SCENE = "LinerMediator.GO_SCENE"
var0.GO_SUBLAYER = "LinerMediator.GO_SUBLAYER"
var0.SET_NAME = "LinerMediator.SET_NAME"
var0.CLICK_ROOM = "LinerMediator.CLICK_ROOM"
var0.CLICK_EVENT = "LinerMediator.CLICK_EVENT"

function var0.register(arg0)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
	arg0:bind(var0.GO_SUBLAYER, function(arg0, arg1, arg2)
		arg0:addSubLayers(arg1, nil, arg2)
	end)
	arg0:bind(var0.SET_NAME, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			activity_id = arg1.actId,
			intValue = arg1.intValue or 0,
			strValue = arg1.strValue or "",
			callback = arg1.callback
		})
	end)
	arg0:bind(var0.CLICK_ROOM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 1,
			activity_id = arg1,
			arg1 = arg2
		})
	end)
	arg0:bind(var0.CLICK_EVENT, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 1,
			activity_id = arg1.actId,
			arg1 = arg1.roomId,
			arg2 = arg1.eventId,
			callback = arg1.callback
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ACTIVITY_LINER_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ACTIVITY_LINER_OP_DONE then
		arg0.viewComponent:UpdateData()
		arg0.viewComponent:UpdateTips()
	end
end

return var0
