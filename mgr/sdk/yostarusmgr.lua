local var0_0 = {}
local var1_0 = YoStarSDKMgr.inst

function var0_0.CheckAudit()
	return NetConst.GATEWAY_PORT == 20001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
end

function var0_0.CheckPreAudit()
	return NetConst.GATEWAY_PORT == 30001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
end

function var0_0.CheckPretest()
	return IsUnityEditor or var0_0.CheckPreAudit()
end

function var0_0.CheckGoogleSimulator()
	return NetConst.GATEWAY_PORT == 50001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
end

function var0_0.CheckRelease()
	return NetConst.GATEWAY_PORT == 80 and NetConst.GATEWAY_HOST == "blhxusgate.yo-star.com"
end

function var0_0.GetLoginType()
	return var1_0.loginType
end

function var0_0.GetIsPlatform()
	return var1_0.isPlatform
end

function var0_0.GetChannelUID()
	return var1_0.channelUID
end

function var0_0.GoSDkLoginScene()
	var1_0:GoLoginScene()
	var0_0.Init()
end

function GoLoginScene()
	return
end

function var0_0.EnterServer()
	var0_0.RoleInfoUpload()
end

function var0_0.Survey(arg0_12)
	Application.OpenURL(arg0_12)
end

function var0_0.OnAndoridBackPress()
	PressBack()
end

function var0_0.BindCPU()
	return
end

function var0_0.CheckYoStarCanBuy()
	if var0_0.OnYoStarPaying == -1 or Time.realtimeSinceStartup - var0_0.OnYoStarPaying > var0_0.BuyingLimit then
		return true
	else
		return false
	end
end

function var0_0.OnAppPauseForSDK(arg0_16)
	if not var0_0.YOSTAR_SDK_INITED then
		return
	end

	if arg0_16 then
		var1_0:OnPause()
	else
		var1_0:OnResume()
	end
end

function var0_0.YoStarGoLogin(arg0_17)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LOGIN, {
		loginPlatform = arg0_17
	})
	gcAll()
end

function var0_0.GetDeviceId()
	return var0_0.DeviceID
end

function var0_0.CheckHadAccountCache()
	if var0_0.GetIsPlatform() then
		return var0_0.CheckUserCacheExist() or var0_0.isCache
	else
		return true
	end
end

var0_0.YOSTAR_SDK_INITED = false
var0_0.OnYoStarPaying = -1
var0_0.BuyingLimit = 60
var0_0.isCache = false
var0_0.DeviceID = "-1"
var0_0.LoginPlatform = PLATFORM_YOSTARUS
var0_0.SDK_PID_TEST = ""
var0_0.SDK_PID_RELEASE = ""
var0_0.SDK_SERVER_URL = ""
var0_0.SDK_TRANS_URL = ""

;(function()
	function var0_0.Init(arg0_21)
		pg.UIMgr.GetInstance():LoadingOn()

		if var0_0.GetIsPlatform() then
			var1_0.pid = (var0_0.CheckRelease() or var0_0.CheckAudit()) and var0_0.SDK_PID_RELEASE or var0_0.SDK_PID_TEST
			var1_0.gameServerUrl = var0_0.SDK_SERVER_URL

			var1_0:Init()
		end
	end

	function var0_0.Login()
		if var0_0.GetIsPlatform() then
			pg.UIMgr.GetInstance():LoadingOn()
			var1_0:Login()
		end
	end

	function var0_0.ShowUserCenter()
		if var0_0.GetIsPlatform() then
			var1_0:ShowUserCenter()
		end
	end

	function var0_0.Pay(arg0_24, arg1_24, arg2_24)
		if var0_0.GetIsPlatform() then
			pg.UIMgr.GetInstance():LoadingOn()

			var0_0.OnYoStarPaying = Time.realtimeSinceStartup

			var1_0:Pay(arg0_24, arg1_24, arg2_24)
		end
	end

	function var0_0.ShowAihelp()
		if var0_0.GetIsPlatform() then
			var1_0:ShowAihelp()
		end
	end

	function var0_0.UserEventUpload(arg0_26)
		if var0_0.GetIsPlatform() then
			var1_0:UserEventUpload(arg0_26)
		end
	end

	function var0_0.RoleInfoUpload()
		if var0_0.GetIsPlatform() then
			local var0_27 = getProxy(PlayerProxy):getData()
			local var1_27 = getProxy(UserProxy):getData()
			local var2_27 = getProxy(ServerProxy):getLastServer(var1_27.uid)
			local var3_27 = tostring(var2_27.id .. " - " .. var2_27.name)
			local var4_27 = tostring(var0_27.id)
			local var5_27 = var0_27.name
			local var6_27 = {
				var0_27.rmb
			}
			local var7_27 = YoStarRoleInfo.New(var3_27, var4_27, var5_27, var6_27)

			var1_0:RoleInfoUpload(var7_27)
		end
	end

	function var0_0.ShowSurvey(arg0_28, arg1_28)
		if var0_0.GetIsPlatform() then
			local var0_28 = getProxy(PlayerProxy):getData()

			var1_0:ShowSurvey(arg0_28, tostring(var0_28.id), arg1_28)
		end
	end

	function var0_0.ShowAgreement(arg0_29)
		if var0_0.GetIsPlatform() then
			var1_0:ShowSurvey(arg0_29)
		end
	end

	function var0_0.ShowSwitchAccount()
		if var0_0.GetIsPlatform() then
			var1_0:ShowSwitchAccount()
		end
	end

	function var0_0.SystemShare(arg0_31, arg1_31)
		if var0_0.GetIsPlatform() then
			var1_0:SystemShare(arg0_31, arg1_31)
		end
	end

	function var0_0.ShareImage(arg0_32)
		if var0_0.GetIsPlatform() then
			var1_0:ShareImage(arg0_32)
		end
	end

	function var0_0.ShareUrl(arg0_33, arg1_33)
		if var0_0.GetIsPlatform() then
			var1_0:ShareUrl(arg0_33, arg1_33)
		end
	end

	function var0_0.ShowNetworkTest(arg0_34)
		if var0_0.GetIsPlatform() then
			var1_0:ShowNetworkTest(arg0_34)
		end
	end

	function var0_0.ShowWebView(arg0_35, arg1_35)
		if var0_0.GetIsPlatform() then
			var1_0:ShowWebView(arg0_35, arg1_35)
		end
	end

	function var0_0.RequestStoreReview()
		if var0_0.GetIsPlatform() then
			var1_0:RequestStoreReview()
		end
	end

	function var0_0.QueryErrorMsg(arg0_37)
		if var0_0.GetIsPlatform() then
			return var1_0:QueryErrorMsg()
		end
	end

	function var0_0.QuerySkuDetails(arg0_38)
		if var0_0.GetIsPlatform() then
			var1_0:QuerySkuDetails()
		end
	end

	function var0_0.QueryTextLegality(arg0_39)
		if var0_0.GetIsPlatform() then
			var1_0:QueryTextLegality(arg0_39)
		end
	end

	function var0_0.ShowAccountCenter()
		if var0_0.GetIsPlatform() then
			var1_0:ShowAccountCenter()
		end
	end

	function var0_0.FetchDeviceTrackingID()
		if var0_0.GetIsPlatform() then
			var1_0:FetchDeviceTrackingID()
		end
	end

	function var0_0.CheckUserCacheExist()
		if var0_0.GetIsPlatform() then
			var1_0:CheckUserCacheExist()
		end
	end
end)()
;(function()
	function onInit_YoStar(arg0_44)
		pg.UIMgr.GetInstance():LoadingOff()

		if var0_0.YoStarRetCodeHandler(arg0_44) then
			var0_0.YOSTAR_SDK_INITED = true

			var0_0.FetchDeviceTrackingID()
			var0_0.YoStarGoLogin()
		end
	end

	function onLogin_YoStar(arg0_45)
		pg.UIMgr.GetInstance():LoadingOff()

		if var0_0.YoStarRetCodeHandler(arg0_45) then
			local var0_45 = User.New({
				type = 1,
				arg1 = var0_0.LoginPlatform,
				arg2 = arg0_45.LOGIN_UID,
				arg3 = arg0_45.LOGIN_TOKEN
			})

			pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
				user = var0_45
			})
		end
	end

	function onLogout_YoStar(arg0_46)
		if var0_0.YoStarRetCodeHandler(arg0_46) then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 0
			})
		end
	end

	function onPay_YoStar(arg0_47)
		var0_0.OnYoStarPaying = -1

		pg.UIMgr.GetInstance():LoadingOff()

		if var0_0.YoStarRetCodeHandler(arg0_47) then
			getProxy(ShopsProxy):removeWaitTimer()
			pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
				payId = arg0_47.EXTRA_DATA,
				bsId = arg0_47.ORDER_ID
			})
		else
			getProxy(ShopsProxy):removeWaitTimer()
			pg.m02:sendNotification(GAME.CHARGE_FAILED, {
				payId = arg0_47.EXTRA_DATA
			})
		end
	end

	function onSystemShare_YoStar(arg0_48)
		if var0_0.YoStarRetCodeHandler(arg0_48) then
			-- block empty
		end
	end

	function onDeleteAccount_YoStar(arg0_49)
		if var0_0.YoStarRetCodeHandler(arg0_49) then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 0
			})
		end
	end

	function onClearSDKCache_YoStar(arg0_50)
		if var0_0.YoStarRetCodeHandler(arg0_50) then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 0
			})
		end
	end

	function onQuerySkuDetails_YoStar(arg0_51)
		if var0_0.YoStarRetCodeHandler(arg0_51) then
			-- block empty
		end
	end

	function onUserSurvey_YoStar(arg0_52)
		if var0_0.YoStarRetCodeHandler(arg0_52) then
			-- block empty
		end
	end

	function onSwitchServer_YoStar(arg0_53)
		return
	end

	function onQueryTextLegality_YoStar(arg0_54)
		if var0_0.YoStarRetCodeHandler(arg0_54) then
			-- block empty
		end
	end

	function onPushMsgReceive_YoStar(arg0_55)
		if var0_0.YoStarRetCodeHandler(arg0_55) then
			-- block empty
		end
	end

	function onUniversalLink_YoStar(arg0_56)
		if var0_0.YoStarRetCodeHandler(arg0_56) then
			-- block empty
		end
	end

	function onDeviceTrackingID_YoStar(arg0_57)
		if var0_0.YoStarRetCodeHandler(arg0_57) then
			var0_0.DeviceID = arg0_57.DATA
		end
	end
end)()

function var0_0.YoStarRetCodeHandler(arg0_58)
	local var0_58 = arg0_58.R_CODE

	if var0_58 == 0 then
		return true
	else
		local var1_58 = "SDK Error Code:" .. var0_58

		originalPrint(var1_58)

		local var2_58 = var0_0.QueryErrorMsg(var0_58)

		if var2_58 and string.len(var2_58) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(var2_58)
		else
			pg.TipsMgr.GetInstance():ShowTips(var1_58)
		end
	end

	return false
end

return var0_0
