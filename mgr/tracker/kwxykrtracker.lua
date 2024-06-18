local var0_0 = class("KwxyKrTracker")

function var0_0.Ctor(arg0_1, arg1_1)
	return
end

function var0_0.Tracking(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	if arg1_2 == TRACKING_TUTORIAL_COMPLETE_1 then
		pg.SdkMgr.GetInstance():CompletedTutorial()
		pg.SdkMgr.GetInstance():UnlockAchievement()
	elseif arg1_2 == TRACKING_USER_LEVELUP then
		pg.SdkMgr.GetInstance():SdkLevelUp(arg4_2, arg3_2)
	end
end

return var0_0
