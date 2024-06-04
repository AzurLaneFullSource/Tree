local var0 = class("NewBulletinBoardMediator", import("..base.ContextMediator"))

var0.SET_STOP_REMIND = "set_stop_remind"
var0.GO_SCENE = "go_scene"
var0.TRACK_OPEN_URL = "track_open_url"

function var0.register(arg0)
	local var0 = getProxy(ServerNoticeProxy)

	var0:setStopNewTip()

	local var1 = var0:getServerNotices(false)

	arg0.viewComponent:initNotices(var1)
	arg0:bind(var0.SET_STOP_REMIND, function(arg0, arg1)
		getProxy(ServerNoticeProxy):setStopRemind(arg1)
	end)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
	arg0:bind(var0.TRACK_OPEN_URL, function(arg0, arg1)
		TrackConst.Track(TrackConst.TRACK_NEW_BULLETIN_OPEN_URL, TrackConst.EVENT_NEW_BULLETIN_OPEN_URL, arg1)
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {}
end

return var0
