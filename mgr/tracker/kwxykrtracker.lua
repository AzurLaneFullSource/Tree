local var0_0 = class("KwxyKrTracker")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.mapping = {
		[TRACKING_TUTORIAL_COMPLETE_1] = "tutorial_complete_1",
		[TRACKING_USER_LEVELUP] = "user_levelup",
		[TRACKING_GUIDE_COMPLETE] = "stdhour1",
		[TRACKING_EXP_LV_10] = "stdlevel10",
		[TRACKING_EXP_LV_20] = "stdlevel20",
		[TRACKING_EXP_LV_30] = "stdlevel30",
		[TRACKING_STRIKE_FAILD] = "stdexhausted",
		[TRACKING_PAY_OIL] = "stdstaminapurchase",
		[TRACKING_PAY_FAILD] = "stdrechargeprompt",
		[TRACKING_PAY_SUCCESS] = "stdrecharge",
		[TRACKING_BUILD_OR_SKIN_FAILD] = "stdlackofdiamonds",
		[TRACKING_COST_300_D] = "stdspend300"
	}
end

function var0_0.Tracking(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	if arg0_2.mapping[arg1_2] == nil then
		return
	end

	if arg1_2 == TRACKING_TUTORIAL_COMPLETE_1 then
		pg.SdkMgr.GetInstance():CompletedTutorial()
		pg.SdkMgr.GetInstance():UnlockAchievement()
	elseif arg1_2 == TRACKING_USER_LEVELUP then
		pg.SdkMgr.GetInstance():SdkLevelUp(arg4_2, arg3_2)
	else
		pg.SdkMgr.GetInstance():EventTrack(arg1_2)
	end
end

return var0_0
