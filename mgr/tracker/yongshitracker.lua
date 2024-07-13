local var0_0 = class("YongshiTracker")

function var0_0.Ctor(arg0_1)
	arg0_1.mapping = {}
	arg0_1.mapping[TRACKING_ROLE_CREATE] = "role_create"
	arg0_1.mapping[TRACKING_ROLE_LOGIN] = "role_login"
	arg0_1.mapping[TRACKING_TUTORIAL_COMPLETE_1] = "tutorial_complete_1"
	arg0_1.mapping[TRACKING_TUTORIAL_COMPLETE_2] = "tutorial_complete_2"
	arg0_1.mapping[TRACKING_TUTORIAL_COMPLETE_3] = "tutorial_complete_3"
	arg0_1.mapping[TRACKING_TUTORIAL_COMPLETE_4] = "tutorial_complete_4"
	arg0_1.mapping[TRACKING_USER_LEVELUP] = "user_levelup"
	arg0_1.mapping[TRACKING_ROLE_LOGOUT] = "role_logout"
	arg0_1.mapping[TRACKING_PURCHASE_FIRST] = "purchase_first"
	arg0_1.mapping[TRACKING_PURCHASE_CLICK] = "purchase_click"
	arg0_1.mapping[TRACKING_PURCHASE_CLICK_MONTHLYCARD] = "purchase_click_monthlycard"
	arg0_1.mapping[TRACKING_PURCHASE_CLICK_GIFTBAG] = "purchase_click_giftbag"
	arg0_1.mapping[TRACKING_PURCHASE_CLICK_DIAMOND] = "purchase_click_diamond"
	arg0_1.mapping[TRACKING_2D_RETENTION] = "2d_retention"
	arg0_1.mapping[TRACKING_7D_RETENTION] = "7d_retention"
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
	elseif arg1_2 == TRACKING_ROLE_LOGIN then
		local var5_2 = AiriUserEvent.New(var0_2)

		var5_2:AddParam("user_id", arg2_2)
		var5_2:AddParam("airi_uid", pg.SdkMgr.GetInstance().airi_uid)
		pg.SdkMgr.GetInstance():UserEventUpload(var5_2)
	else
		local var6_2 = AiriUserEvent.New(var0_2)

		var6_2:AddParam("user_id", arg2_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var6_2)
	end
end

return var0_0
