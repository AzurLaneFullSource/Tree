local var0_0 = class("AiriJPTracker")

function var0_0.Ctor(arg0_1)
	arg0_1.mapping = {
		[TRACKING_ROLE_CREATE] = "role_create",
		[TRACKING_ROLE_LOGIN] = "role_login",
		[TRACKING_TUTORIAL_COMPLETE_1] = "tutorial_complete_1",
		[TRACKING_TUTORIAL_COMPLETE_2] = "tutorial_complete_2",
		[TRACKING_TUTORIAL_COMPLETE_3] = "tutorial_complete_3",
		[TRACKING_TUTORIAL_COMPLETE_4] = "tutorial_complete_4",
		[TRACKING_USER_LEVELUP] = "user_levelup",
		[TRACKING_ROLE_LOGOUT] = "role_logout",
		[TRACKING_PURCHASE_FIRST] = "purchase_first",
		[TRACKING_PURCHASE_CLICK] = "purchase_click",
		[TRACKING_PURCHASE_CLICK_MONTHLYCARD] = "purchase_click_monthlycard",
		[TRACKING_PURCHASE_CLICK_GIFTBAG] = "purchase_click_giftbag",
		[TRACKING_PURCHASE_CLICK_DIAMOND] = "purchase_click_diamond",
		[TRACKING_2D_RETENTION] = "2d_retention",
		[TRACKING_7D_RETENTION] = "7d_retention",
		[TRACKING_BUILD_SHIP] = "construct",
		[TRACKING_SHIP_INTENSIFY] = "strengthen",
		[TRACKING_SHIP_LEVEL_UP] = "levelup",
		[TRACKING_SHIP_HIGHEST_LEVEL] = "character_Max_level",
		[TRACKING_CUBE_ADD] = "cube_acquisition",
		[TRACKING_CUBE_CONSUME] = "cube_Consumption",
		[TRACKING_USER_LEVEL_THIRTY] = "level_30",
		[TRACKING_USER_LEVEL_FORTY] = "level_40",
		[TRACKING_PROPOSE_SHIP] = "married",
		[TRACKING_REMOULD_SHIP] = "remodeled",
		[TRACKING_HARD_CHAPTER] = "hard_clear",
		[TRACKING_KILL_BOSS] = "stage_laps",
		[TRACKING_HIGHEST_CHAPTER] = "stage",
		[TRACKING_FIRST_PASS_3_4] = "3-4_clear",
		[TRACKING_FIRST_PASS_4_4] = "4-4_clear",
		[TRACKING_FIRST_PASS_5_4] = "5-4_clear",
		[TRACKING_FIRST_PASS_6_4] = "6-4_clear",
		[TRACKING_FIRST_PASS_12_4] = "12-4_clear",
		[TRACKING_FIRST_PASS_13_1] = "13-1_clear",
		[TRACKING_FIRST_PASS_13_2] = "13-2_clear",
		[TRACKING_FIRST_PASS_13_3] = "13-3_clear",
		[TRACKING_FIRST_PASS_13_4] = "13-4_clear",
		[TRACKING_CLASS_LEVEL_UP_8] = "auditoriumLV_8",
		[TRACKING_CLASS_LEVEL_UP_9] = "auditoriumLV_9",
		[TRACKING_CLASS_LEVEL_UP_10] = "auditoriumLV_10"
	}
end

function var0_0.Tracking(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg0_2.mapping[arg1_2]

	if var0_2 == nil then
		return
	end

	if arg1_2 == TRACKING_USER_LEVELUP then
		originalPrint("tracking lvl:" .. arg3_2)

		local var1_2 = AiriUserEvent.New(var0_2)

		var1_2:AddParam("lvl", arg3_2)
		var1_2:AddParam("user_id", arg2_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var1_2)
	elseif arg1_2 == TRACKING_PURCHASE_CLICK then
		local var2_2 = AiriUserEvent.New(var0_2)

		var2_2:AddParam("user_id", arg2_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var2_2)
	elseif arg1_2 == TRACKING_PURCHASE_FIRST then
		originalPrint("order id : " .. arg3_2)

		local var3_2 = AiriUserEvent.New(var0_2)

		var3_2:AddParam("user_id", arg2_2)
		var3_2:AddParam("order_id", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var3_2)
	elseif arg1_2 == TRACKING_2D_RETENTION or arg1_2 == TRACKING_7D_RETENTION then
		local var4_2 = AiriUserEvent.New(var0_2)

		var4_2:AddParam("user_id", arg2_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var4_2)
	elseif arg1_2 == TRACKING_BUILD_SHIP then
		local var5_2 = AiriUserEvent.New(var0_2)

		var5_2:AddParam("user_id", arg2_2)
		var5_2:AddParam("Cons_Num", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var5_2)
	elseif arg1_2 == TRACKING_SHIP_INTENSIFY then
		local var6_2 = AiriUserEvent.New(var0_2)

		var6_2:AddParam("user_id", arg2_2)
		var6_2:AddParam("Cost_Num", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var6_2)
	elseif arg1_2 == TRACKING_SHIP_LEVEL_UP then
		local var7_2 = AiriUserEvent.New(var0_2)

		var7_2:AddParam("user_id", arg2_2)
		var7_2:AddParam("Lvup_Num", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var7_2)
	elseif arg1_2 == TRACKING_SHIP_HIGHEST_LEVEL then
		local var8_2 = AiriUserEvent.New(var0_2)

		var8_2:AddParam("user_id", arg2_2)
		var8_2:AddParam("Ship_Max_level", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var8_2)
	elseif arg1_2 == TRACKING_CUBE_ADD then
		local var9_2 = AiriUserEvent.New(var0_2)

		var9_2:AddParam("user_id", arg2_2)
		var9_2:AddParam("Aqui_Num", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var9_2)
	elseif arg1_2 == TRACKING_CUBE_CONSUME then
		local var10_2 = AiriUserEvent.New(var0_2)

		var10_2:AddParam("user_id", arg2_2)
		var10_2:AddParam("Consum_Num", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var10_2)
	elseif arg1_2 == TRACKING_PROPOSE_SHIP then
		local var11_2 = AiriUserEvent.New(var0_2)

		var11_2:AddParam("user_id", arg2_2)
		var11_2:AddParam("Married_Id", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var11_2)
	elseif arg1_2 == TRACKING_REMOULD_SHIP then
		local var12_2 = AiriUserEvent.New(var0_2)

		var12_2:AddParam("user_id", arg2_2)
		var12_2:AddParam("Remodel_Id", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var12_2)
	elseif arg1_2 == TRACKING_HARD_CHAPTER then
		local var13_2 = AiriUserEvent.New(var0_2)

		var13_2:AddParam("user_id", arg2_2)
		var13_2:AddParam("Clear_Stage_Id", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var13_2)
	elseif arg1_2 == TRACKING_HIGHEST_CHAPTER then
		local var14_2 = AiriUserEvent.New(var0_2)

		var14_2:AddParam("user_id", arg2_2)
		var14_2:AddParam("Clear_Stage_Id", arg3_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var14_2)
	else
		local var15_2 = AiriUserEvent.New(var0_2)

		var15_2:AddParam("user_id", arg2_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var15_2)
	end
end

return var0_0
