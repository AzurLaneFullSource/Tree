local var0 = class("AiriUSTracker")

var0.DEV_TOKEN = "2KtJzaeLzGnPUhtOY4-LYw"
var0.ANDROID_LINK_ID = "DE31AE06D3CE21EE3A9E1A1BCEB506E1"
var0.IOS_LINK_ID = "F7FE029D3F957A107D358D2BB93CA7E2"

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
	arg0.mapping[TRACKING_PURCHASE] = "purchase"
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
	elseif arg1 ~= TRACKING_PURCHASE then
		local var5 = AiriUserEvent.New(var0)

		var5:AddParam("user_id", arg2)
		pg.SdkMgr.GetInstance():UserEventUpload(var5)
	end

	if pg.SdkMgr.GetInstance():GetChannelUID() == "0" then
		if arg1 == TRACKING_PURCHASE_CLICK then
			local var6 = arg0:transMoney(pg.pay_data_display[arg3].money)

			arg0:YS_S2S(var0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click", "", tostring(var6), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1 == TRACKING_PURCHASE_CLICK_MONTHLYCARD then
			local var7 = arg0:transMoney(pg.pay_data_display[arg3].money)

			arg0:YS_S2S(var0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click_monthlycard", "", tostring(var7), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1 == TRACKING_PURCHASE_CLICK_DIAMOND then
			local var8 = arg0:transMoney(pg.pay_data_display[arg3].money)

			arg0:YS_S2S(var0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click_diamond", "", tostring(var8), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1 == TRACKING_PURCHASE_CLICK_GIFTBAG then
			local var9 = arg0:transMoney(pg.pay_data_display[arg3].money)

			arg0:YS_S2S(var0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase_click_giftbag", "", tostring(var9), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		elseif arg1 == TRACKING_PURCHASE then
			local var10 = arg0:transMoney(pg.pay_data_display[arg3].money)

			arg0:YS_S2S(var0.DEV_TOKEN, "DE31AE06D3CE21EE3A9E1A1BCEB506E1", "Azur Lane (Android) S2S_purchase", "", tostring(var10), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
		end
	elseif arg1 == TRACKING_PURCHASE_CLICK then
		local var11 = arg0:transMoney(pg.pay_data_display[arg3].money)

		YS2S.S2S(var0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click", "", tostring(var11), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1 == TRACKING_PURCHASE_CLICK_MONTHLYCARD then
		local var12 = arg0:transMoney(pg.pay_data_display[arg3].money)

		YS2S.S2S(var0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click_monthlycard", "", tostring(var12), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1 == TRACKING_PURCHASE_CLICK_DIAMOND then
		local var13 = arg0:transMoney(pg.pay_data_display[arg3].money)

		YS2S.S2S(var0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click_diamond", "", tostring(var13), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1 == TRACKING_PURCHASE_CLICK_GIFTBAG then
		local var14 = arg0:transMoney(pg.pay_data_display[arg3].money)

		YS2S.S2S(var0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase_click_giftbag", "", tostring(var14), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	elseif arg1 == TRACKING_PURCHASE then
		local var15 = arg0:transMoney(pg.pay_data_display[arg3].money)

		YS2S.S2S(var0.DEV_TOKEN, "F7FE029D3F957A107D358D2BB93CA7E2", "Azur Lane (iOS) S2S_purchase", "", tostring(var15), pg.SdkMgr.GetInstance():GetDeviceId(), tostring(pg.TimeMgr.GetInstance():GetServerTime()))
	end

	originalPrint("track done.")
end

function var0.YS_S2S(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0 = pg.SdkMgr.GetInstance():GetChannelUID() == "0"
	local var1 = "https://www.googleadservices.com/pagead/conversion/app/1.0?"
	local var2 = {
		dev_token = arg1,
		link_id = arg2
	}

	var2.app_event_type = "custom"
	var2.app_event_name = arg3

	if arg4 then
		var2.app_event_data = arg4
	end

	var2.rdid = arg6

	if var0 then
		var2.id_type = "advertisingid"
	else
		var2.id_type = "idfa"
	end

	var2.lat = "0"
	var2.app_version = Application.version
	var2.os_version = SystemInfo.operatingSystem
	var2.sdk_version = "1.9.5r6"
	var2.timestamp = arg7 .. ".000001"
	var2.value = arg5
	var2.currency_code = "USD"

	for iter0, iter1 in pairs(var2) do
		var1 = var1 .. iter0 .. "=" .. iter1 .. "&"
	end

	local var3 = string.sub(var1, 1, -2)

	originalPrint(var1)
	VersionMgr.Inst:WebRequest(var3, function(arg0, arg1)
		originalPrint("code:" .. arg0 .. " content:" .. arg1)
	end)
end

function var0.transMoney(arg0, arg1)
	return string.format("%.2f", arg1 / 100)
end

return var0
