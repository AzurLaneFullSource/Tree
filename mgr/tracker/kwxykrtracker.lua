local var0 = class("KwxyKrTracker")

function var0.Ctor(arg0, arg1)
	return
end

function var0.Tracking(arg0, arg1, arg2, arg3, arg4)
	if arg1 == TRACKING_TUTORIAL_COMPLETE_1 then
		pg.SdkMgr.GetInstance():CompletedTutorial()
		pg.SdkMgr.GetInstance():UnlockAchievement()
	elseif arg1 == TRACKING_USER_LEVELUP then
		pg.SdkMgr.GetInstance():SdkLevelUp(arg4, arg3)
	end
end

return var0
