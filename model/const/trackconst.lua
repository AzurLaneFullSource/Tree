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

return var0_0
