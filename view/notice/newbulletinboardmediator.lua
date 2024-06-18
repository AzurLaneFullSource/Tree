local var0_0 = class("NewBulletinBoardMediator", import("..base.ContextMediator"))

var0_0.SET_STOP_REMIND = "set_stop_remind"
var0_0.GO_SCENE = "go_scene"
var0_0.TRACK_OPEN_URL = "track_open_url"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ServerNoticeProxy)

	var0_1:setStopNewTip()

	local var1_1 = var0_1:getServerNotices(false)

	arg0_1.viewComponent:initNotices(var1_1)
	arg0_1:bind(var0_0.SET_STOP_REMIND, function(arg0_2, arg1_2)
		getProxy(ServerNoticeProxy):setStopRemind(arg1_2)
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_1:bind(var0_0.TRACK_OPEN_URL, function(arg0_4, arg1_4)
		TrackConst.Track(TrackConst.TRACK_NEW_BULLETIN_OPEN_URL, TrackConst.EVENT_NEW_BULLETIN_OPEN_URL, arg1_4)
	end)
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {}
end

return var0_0
