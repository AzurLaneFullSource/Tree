local var0_0 = class("TrackConst")

function var0_0.GetTrackData(arg0_1, arg1_1, ...)
	return {
		system = arg0_1,
		id = arg1_1,
		desc = var0_0.GetDesc(arg0_1, arg1_1, ...)
	}
end

function var0_0.GetDesc(arg0_2, arg1_2, ...)
	return var0_0["Build" .. arg0_2 .. "Action" .. arg1_2 .. "Desc"](unpack({
		...
	}))
end

var0_0.SYSTEM_SHOP = 1
var0_0.ACTION_ENTER_MAIN = 1
var0_0.ACTION_ENTER_GIFT = 2
var0_0.ACTION_BUY_RECOMMEND = 3
var0_0.ACTION_LOOKUP_RECOMMEND = 4

function var0_0.Build1Action1Desc(arg0_3)
	return arg0_3 and "1" or "0"
end

function var0_0.Build1Action2Desc(arg0_4)
	return arg0_4 and "1" or "0"
end

function var0_0.Build1Action3Desc(arg0_5)
	return arg0_5 .. ""
end

function var0_0.Build1Action4Desc(arg0_6)
	return arg0_6 .. ""
end

local var1_0 = 1
local var2_0 = 4
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3

function var0_0.StoryStart(arg0_7)
	if not arg0_7 then
		return
	end

	local var0_7 = {
		type = var1_0,
		eventId = var3_0,
		para1 = tostring(arg0_7)
	}

	pg.m02:sendNotification(GAME.NEW_TRACK, var0_7)
end

function var0_0.StorySkip(arg0_8, arg1_8)
	if not arg0_8 then
		return
	end

	local var0_8 = {
		type = var1_0,
		eventId = var4_0,
		para1 = tostring(arg0_8),
		para2 = tostring(arg1_8 or "0")
	}

	pg.m02:sendNotification(GAME.NEW_TRACK, var0_8)
end

function var0_0.StoryOption(arg0_9, arg1_9)
	if not arg0_9 then
		return
	end

	local var0_9 = {
		type = var5_0,
		eventId = var5_0,
		para1 = tostring(arg0_9),
		para2 = tostring(arg1_9 or "0_0")
	}

	pg.m02:sendNotification(GAME.NEW_TRACK, var0_9)
end

function var0_0.EmojiSend(arg0_10)
	local var0_10 = "777#(%d+)#777"
	local var1_10 = arg0_10:match(var0_10)
	local var2_10 = tonumber(var1_10)

	if var2_10 and var2_10 > 0 then
		local var3_10 = {
			eventId = 0,
			type = var2_0,
			para1 = tostring(var2_10)
		}

		pg.m02:sendNotification(GAME.NEW_TRACK, var3_10)
	end
end

var0_0.TRACK_NEW_BULLETIN_OPEN_URL = 2
var0_0.EVENT_NEW_BULLETIN_OPEN_URL = 1

function var0_0.Track(arg0_11, arg1_11, ...)
	local var0_11, var1_11, var2_11 = ...
	local var3_11 = {
		type = arg0_11,
		eventId = arg1_11,
		para1 = var0_11,
		para2 = var1_11,
		para3 = var2_11
	}

	pg.m02:sendNotification(GAME.NEW_TRACK, var3_11)
end

function var0_0.TrackingExitSilentView(arg0_12, arg1_12, arg2_12)
	local var0_12 = {
		arg3 = 0,
		trackType = 1,
		arg1 = arg0_12,
		arg2 = arg1_12,
		arg4 = tostring(arg2_12)
	}

	pg.m02:sendNotification(GAME.MAIN_SCENE_TRACK, var0_12)
end

function var0_0.TrackingTouchBanner(arg0_13)
	local var0_13 = {
		arg1 = 0,
		trackType = 2,
		arg2 = 0,
		arg3 = 0,
		arg4 = tostring(arg0_13)
	}

	pg.m02:sendNotification(GAME.MAIN_SCENE_TRACK, var0_13)
end

function var0_0.TrackingSwitchPainting(arg0_14, arg1_14)
	local var0_14 = {
		arg3 = 0,
		trackType = 3,
		arg4 = "",
		arg1 = arg0_14,
		arg2 = arg1_14
	}

	pg.m02:sendNotification(GAME.MAIN_SCENE_TRACK, var0_14)
end

function var0_0.TrackingUrExchangeFetch(arg0_15, arg1_15)
	local var0_15 = {
		trackType = 1,
		arg1 = arg0_15,
		arg2 = arg1_15
	}

	pg.m02:sendNotification(GAME.UR_EXCHANGE_TRACK, var0_15)
end

function var0_0.TrackingUrExchangeJump(arg0_16)
	local var0_16 = {
		arg1 = 0,
		trackType = 2,
		arg2 = arg0_16
	}

	pg.m02:sendNotification(GAME.UR_EXCHANGE_TRACK, var0_16)
end

return var0_0
