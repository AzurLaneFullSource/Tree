local var0 = class("TrackConst")

function var0.GetTrackData(arg0, arg1, ...)
	return {
		system = arg0,
		id = arg1,
		desc = var0.GetDesc(arg0, arg1, ...)
	}
end

function var0.GetDesc(arg0, arg1, ...)
	return var0["Build" .. arg0 .. "Action" .. arg1 .. "Desc"](unpack({
		...
	}))
end

var0.SYSTEM_SHOP = 1
var0.ACTION_ENTER_MAIN = 1
var0.ACTION_ENTER_GIFT = 2
var0.ACTION_BUY_RECOMMEND = 3
var0.ACTION_LOOKUP_RECOMMEND = 4

function var0.Build1Action1Desc(arg0)
	return arg0 and "1" or "0"
end

function var0.Build1Action2Desc(arg0)
	return arg0 and "1" or "0"
end

function var0.Build1Action3Desc(arg0)
	return arg0 .. ""
end

function var0.Build1Action4Desc(arg0)
	return arg0 .. ""
end

local var1 = 1
local var2 = 1
local var3 = 2

function var0.StoryStart(arg0)
	if not arg0 then
		return
	end

	local var0 = {
		type = var1,
		eventId = var2,
		para1 = tostring(arg0)
	}

	pg.m02:sendNotification(GAME.NEW_TRACK, var0)
end

function var0.StorySkip(arg0)
	if not arg0 then
		return
	end

	local var0 = {
		type = var1,
		eventId = var3,
		para1 = tostring(arg0)
	}

	pg.m02:sendNotification(GAME.NEW_TRACK, var0)
end

var0.TRACK_NEW_BULLETIN_OPEN_URL = 2
var0.EVENT_NEW_BULLETIN_OPEN_URL = 1

function var0.Track(arg0, arg1, ...)
	local var0, var1, var2 = ...
	local var3 = {
		type = arg0,
		eventId = arg1,
		para1 = var0,
		para2 = var1,
		para3 = var2
	}

	pg.m02:sendNotification(GAME.NEW_TRACK, var3)
end

function var0.TrackingExitSilentView(arg0, arg1, arg2)
	local var0 = {
		arg3 = 0,
		trackType = 1,
		arg1 = arg0,
		arg2 = arg1,
		arg4 = tostring(arg2)
	}

	pg.m02:sendNotification(GAME.MAIN_SCENE_TRACK, var0)
end

function var0.TrackingTouchBanner(arg0)
	local var0 = {
		arg1 = 0,
		trackType = 2,
		arg2 = 0,
		arg3 = 0,
		arg4 = tostring(arg0)
	}

	pg.m02:sendNotification(GAME.MAIN_SCENE_TRACK, var0)
end

function var0.TrackingSwitchPainting(arg0, arg1)
	local var0 = {
		arg3 = 0,
		trackType = 3,
		arg4 = "",
		arg1 = arg0,
		arg2 = arg1
	}

	pg.m02:sendNotification(GAME.MAIN_SCENE_TRACK, var0)
end

function var0.TrackingUrExchangeFetch(arg0, arg1)
	local var0 = {
		trackType = 1,
		arg1 = arg0,
		arg2 = arg1
	}

	pg.m02:sendNotification(GAME.UR_EXCHANGE_TRACK, var0)
end

function var0.TrackingUrExchangeJump(arg0)
	local var0 = {
		arg1 = 0,
		trackType = 2,
		arg2 = arg0
	}

	pg.m02:sendNotification(GAME.UR_EXCHANGE_TRACK, var0)
end

return var0
