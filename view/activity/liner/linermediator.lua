local var0_0 = class("LinerMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "LinerMediator.GO_SCENE"
var0_0.GO_SUBLAYER = "LinerMediator.GO_SUBLAYER"
var0_0.SET_NAME = "LinerMediator.SET_NAME"
var0_0.CLICK_ROOM = "LinerMediator.CLICK_ROOM"
var0_0.CLICK_EVENT = "LinerMediator.CLICK_EVENT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(arg1_3, nil, arg2_3)
	end)
	arg0_1:bind(var0_0.SET_NAME, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			activity_id = arg1_4.actId,
			intValue = arg1_4.intValue or 0,
			strValue = arg1_4.strValue or "",
			callback = arg1_4.callback
		})
	end)
	arg0_1:bind(var0_0.CLICK_ROOM, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 1,
			activity_id = arg1_5,
			arg1 = arg2_5
		})
	end)
	arg0_1:bind(var0_0.CLICK_EVENT, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 1,
			activity_id = arg1_6.actId,
			arg1 = arg1_6.roomId,
			arg2 = arg1_6.eventId,
			callback = arg1_6.callback
		})
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.ACTIVITY_LINER_OP_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.ACTIVITY_LINER_OP_DONE then
		arg0_8.viewComponent:UpdateData()
		arg0_8.viewComponent:UpdateTips()
	end
end

return var0_0
