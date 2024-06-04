local var0 = class("BiliTracker")

function var0.Ctor(arg0, arg1)
	return
end

function var0.Tracking(arg0, arg1, arg2, arg3)
	if arg1 == TRACKING_USER_LEVELUP then
		originalPrint("tracking lvl:" .. arg3)
		pg.SdkMgr.GetInstance():SdkLevelUp()
	end
end

return var0
