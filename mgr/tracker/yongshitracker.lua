local var0 = class("YongshiTracker")

function var0.Ctor(arg0)
	arg0.mapping = {}
	arg0.mapping[TRACKING_ROLE_CREATE] = "role_create"
	arg0.mapping[TRACKING_ROLE_LOGIN] = "role_login"
	arg0.mapping[TRACKING_TUTORIAL_COMPLETE_1] = "tutorial_complete_1"
	arg0.mapping[TRACKING_TUTORIAL_COMPLETE_2] = "tutorial_complete_2"
	arg0.mapping[TRACKING_TUTORIAL_COMPLETE_3] = "tutorial_complete_3"
	arg0.mapping[TRACKING_TUTORIAL_COMPLETE_4] = "tutorial_complete_4"
	arg0.mapping[TRACKING_USER_LEVELUP] = "user_levelup"
	arg0.mapping[TRACKING_ROLE_LOGOUT] = "role_logout"
	arg0.mapping[TRACKING_PURCHASE_FIRST] = "purchase_first"
	arg0.mapping[TRACKING_PURCHASE_CLICK] = "purchase_click"
	arg0.mapping[TRACKING_PURCHASE_CLICK_MONTHLYCARD] = "purchase_click_monthlycard"
	arg0.mapping[TRACKING_PURCHASE_CLICK_GIFTBAG] = "purchase_click_giftbag"
	arg0.mapping[TRACKING_PURCHASE_CLICK_DIAMOND] = "purchase_click_diamond"
	arg0.mapping[TRACKING_2D_RETENTION] = "2d_retention"
	arg0.mapping[TRACKING_7D_RETENTION] = "7d_retention"
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
	elseif arg1 == TRACKING_ROLE_LOGIN then
		local var5 = AiriUserEvent.New(var0)

		var5:AddParam("user_id", arg2)
		var5:AddParam("airi_uid", pg.SdkMgr.GetInstance().airi_uid)
		pg.SdkMgr.GetInstance():UserEventUpload(var5)
	else
		local var6 = AiriUserEvent.New(var0)

		var6:AddParam("user_id", arg2)
		pg.SdkMgr.GetInstance():UserEventUpload(var6)
	end
end

return var0
