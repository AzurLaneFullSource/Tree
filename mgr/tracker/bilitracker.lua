local var0_0 = class("BiliTracker")

function var0_0.Ctor(arg0_1, arg1_1)
	return
end

function var0_0.Tracking(arg0_2, arg1_2, arg2_2, arg3_2)
	if arg1_2 == TRACKING_USER_LEVELUP then
		originalPrint("tracking lvl:" .. arg3_2)
		pg.SdkMgr.GetInstance():SdkLevelUp()
	end
end

return var0_0
