local var0_0 = class("AiriUSTracker")

var0_0.DEV_TOKEN = "2KtJzaeLzGnPUhtOY4-LYw"
var0_0.ANDROID_LINK_ID = "DE31AE06D3CE21EE3A9E1A1BCEB506E1"
var0_0.IOS_LINK_ID = "F7FE029D3F957A107D358D2BB93CA7E2"

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
	arg0_1.mapping[TRACKING_PURCHASE] = "purchase"
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
	elseif arg1_2 ~= TRACKING_PURCHASE then
		local var5_2 = AiriUserEvent.New(var0_2)

		var5_2:AddParam("user_id", arg2_2)
		pg.SdkMgr.GetInstance():UserEventUpload(var5_2)
	end

	if pg.SdkMgr.GetInstance():GetChannelUID() == "0" then
		if arg1_2 == TRACKING_PURCHASE_CLICK then
			local var6_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

			arg0_2:YS_S2S(var0_0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click", "", tostring(var6_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1_2 == TRACKING_PURCHASE_CLICK_MONTHLYCARD then
			local var7_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

			arg0_2:YS_S2S(var0_0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click_monthlycard", "", tostring(var7_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1_2 == TRACKING_PURCHASE_CLICK_DIAMOND then
			local var8_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

			arg0_2:YS_S2S(var0_0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click_diamond", "", tostring(var8_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1_2 == TRACKING_PURCHASE_CLICK_GIFTBAG then
			local var9_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

			arg0_2:YS_S2S(var0_0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click_giftbag", "", tostring(var9_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1_2 == TRACKING_PURCHASE then
			local var10_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

			arg0_2:YS_S2S(var0_0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase", "", tostring(var10_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		end
	elseif arg1_2 == TRACKING_PURCHASE_CLICK then
		local var11_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

		YS2S.S2S(var0_0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click", "", tostring(var11_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1_2 == TRACKING_PURCHASE_CLICK_MONTHLYCARD then
		local var12_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

		YS2S.S2S(var0_0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click_monthlycard", "", tostring(var12_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1_2 == TRACKING_PURCHASE_CLICK_DIAMOND then
		local var13_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

		YS2S.S2S(var0_0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click_diamond", "", tostring(var13_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1_2 == TRACKING_PURCHASE_CLICK_GIFTBAG then
		local var14_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

		YS2S.S2S(var0_0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click_giftbag", "", tostring(var14_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1_2 == TRACKING_PURCHASE then
		local var15_2 = arg0_2:transMoney(pg.pay_data_display[arg3_2].money)

		YS2S.S2S(var0_0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase", "", tostring(var15_2), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	end

	originalPrint("track done.")
end

function var0_0.YS_S2S(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, arg6_3, arg7_3)
	local var0_3 = pg.SdkMgr.GetInstance():GetChannelUID() == "0"
	local var1_3 = "https://www.googleadservices.com/pagead/conversion/app/1.0?"
	local var2_3 = {
		dev_token = arg1_3,
		link_id = arg2_3
	}

	var2_3.app_event_type = "custom"
	var2_3.app_event_name = arg3_3

	if arg4_3 then
		var2_3.app_event_data = arg4_3
	end

	var2_3.rdid = arg6_3

	if var0_3 then
		var2_3.id_type = "advertisingid"
	else
		var2_3.id_type = "idfa"
	end

	var2_3.lat = "0"
	var2_3.app_version = Application.version
	var2_3.os_version = SystemInfo.operatingSystem
	var2_3.sdk_version = "1.9.5r6"
	var2_3.timestamp = arg7_3 .. ".000001"
	var2_3.value = arg5_3
	var2_3.currency_code = "USD"

	for iter0_3, iter1_3 in pairs(var2_3) do
		var1_3 = var1_3 .. iter0_3 .. "=" .. iter1_3 .. "&"
	end

	local var3_3 = string.sub(var1_3, 1, -2)

	originalPrint(var1_3)
	VersionMgr.Inst:WebRequest(var3_3, function(arg0_4, arg1_4)
		originalPrint("code:" .. arg0_4 .. " content:" .. arg1_4)
	end)
end

function var0_0.transMoney(arg0_5, arg1_5)
	return string.format("%.2f", arg1_5 / 100)
end

return var0_0
