local var0 = class("AiriJPTracker")

function var0.Ctor(arg0)
	arg0.mapping = {
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

function var0.Tracking(arg0, arg1, arg2, arg3)
	local var0 = arg0.mapping[arg1]

	if var0 == nil then
		return
	end

	if arg1 == TRACKING_USER_LEVELUP then
		originalPrint("tracking lvl:" .. arg3)

		local var1 = AiriUserEvent.New(var0)

		var1:AddParam("lvl", arg3)
		var1:AddParam("user_id", arg2)
		pg.SdkMgr.GetInstance():UserEventUpload(var1)
	elseif arg1 == TRACKING_PURCHASE_CLICK then
		local var2 = AiriUserEvent.New(var0)

		var2:AddParam("user_id", arg2)
		pg.SdkMgr.GetInstance():UserEventUpload(var2)
	elseif arg1 == TRACKING_PURCHASE_FIRST then
		originalPrint("order id : " .. arg3)

		local var3 = AiriUserEvent.New(var0)

		var3:AddParam("user_id", arg2)
		var3:AddParam("order_id", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var3)
	elseif arg1 == TRACKING_2D_RETENTION or arg1 == TRACKING_7D_RETENTION then
		local var4 = AiriUserEvent.New(var0)

		var4:AddParam("user_id", arg2)
		pg.SdkMgr.GetInstance():UserEventUpload(var4)
	elseif arg1 == TRACKING_BUILD_SHIP then
		local var5 = AiriUserEvent.New(var0)

		var5:AddParam("user_id", arg2)
		var5:AddParam("Cons_Num", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var5)
	elseif arg1 == TRACKING_SHIP_INTENSIFY then
		local var6 = AiriUserEvent.New(var0)

		var6:AddParam("user_id", arg2)
		var6:AddParam("Cost_Num", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var6)
	elseif arg1 == TRACKING_SHIP_LEVEL_UP then
		local var7 = AiriUserEvent.New(var0)

		var7:AddParam("user_id", arg2)
		var7:AddParam("Lvup_Num", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var7)
	elseif arg1 == TRACKING_SHIP_HIGHEST_LEVEL then
		local var8 = AiriUserEvent.New(var0)

		var8:AddParam("user_id", arg2)
		var8:AddParam("Ship_Max_level", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var8)
	elseif arg1 == TRACKING_CUBE_ADD then
		local var9 = AiriUserEvent.New(var0)

		var9:AddParam("user_id", arg2)
		var9:AddParam("Aqui_Num", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var9)
	elseif arg1 == TRACKING_CUBE_CONSUME then
		local var10 = AiriUserEvent.New(var0)

		var10:AddParam("user_id", arg2)
		var10:AddParam("Consum_Num", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var10)
	elseif arg1 == TRACKING_PROPOSE_SHIP then
		local var11 = AiriUserEvent.New(var0)

		var11:AddParam("user_id", arg2)
		var11:AddParam("Married_Id", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var11)
	elseif arg1 == TRACKING_REMOULD_SHIP then
		local var12 = AiriUserEvent.New(var0)

		var12:AddParam("user_id", arg2)
		var12:AddParam("Remodel_Id", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var12)
	elseif arg1 == TRACKING_HARD_CHAPTER then
		local var13 = AiriUserEvent.New(var0)

		var13:AddParam("user_id", arg2)
		var13:AddParam("Clear_Stage_Id", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var13)
	elseif arg1 == TRACKING_HIGHEST_CHAPTER then
		local var14 = AiriUserEvent.New(var0)

		var14:AddParam("user_id", arg2)
		var14:AddParam("Clear_Stage_Id", arg3)
		pg.SdkMgr.GetInstance():UserEventUpload(var14)
	else
		local var15 = AiriUserEvent.New(var0)

		var15:AddParam("user_id", arg2)
		pg.SdkMgr.GetInstance():UserEventUpload(var15)
	end
end

return var0
