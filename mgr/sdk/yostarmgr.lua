local var0_0 = {}
local var1_0 = YoStarSDKMgr.inst

var0_0.YOSTAR_SDK_INITED = false
var0_0.OnYoStarPaying = -1
var0_0.BuyingLimit = 60
var0_0.isCache = false
var0_0.DeviceID = "-1"
var0_0.isAudit = false
var0_0.isPreAudit = false
var0_0.isPretest = false
var0_0.isGoogleSimulator = false
var0_0.isRelease = false
var0_0.LoginPlatform = PLATFORM_YOSTARJP
var0_0.SDK_PID_TEST = "JP-AZURLANE-TEST"
var0_0.SDK_PID_RELEASE = "JP-AZURLANE"
var0_0.SDK_SERVER_URL = "https://jp-sdk-api.yostarplat.com"
var0_0.SDK_TRANS_URL = "https://migration.yostar.co.jp?pid=JP-AZURLANE"
var0_0.LOGIN_RET = nil

function var0_0.InitJP()
	var0_0.isAudit = NetConst.GATEWAY_PORT == 20001 and NetConst.GATEWAY_HOST == "blhxjpauditapi.azurlane.jp"
	var0_0.isPreAudit = NetConst.GATEWAY_PORT == 30001 and NetConst.GATEWAY_HOST == "blhxjpauditapi.azurlane.jp" or NetConst.GATEWAY_PORT == 30101 and NetConst.GATEWAY_HOST == "blhxjpauditapi.azurlane.jp"
	var0_0.isPretest = IsUnityEditor or var0_0.isPreAudit
	var0_0.isGoogleSimulator = NetConst.GATEWAY_PORT == 4001 and NetConst.GATEWAY_HOST == "business.azurlane.jp"
	var0_0.isRelease = NetConst.GATEWAY_PORT == 80 and NetConst.GATEWAY_HOST == "blhxjploginapi.azurlane.jp"
	var0_0.LoginPlatform = PLATFORM_YOSTARJP
	var0_0.SDK_PID_TEST = "JP-AZURLANE-TEST"
	var0_0.SDK_PID_RELEASE = "JP-AZURLANE"
	var0_0.SDK_SERVER_URL = "https://jp-sdk-api.yostarplat.com"
	var0_0.SDK_TRANS_URL = "https://migration.yostar.co.jp?pid=JP-AZURLANE"
end

function var0_0.InitUS()
	var0_0.isAudit = NetConst.GATEWAY_PORT == 20001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
	var0_0.isPreAudit = NetConst.GATEWAY_PORT == 30001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
	var0_0.isPretest = IsUnityEditor or var0_0.isPreAudit
	var0_0.isGoogleSimulator = NetConst.GATEWAY_PORT == 50001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
	var0_0.isRelease = NetConst.GATEWAY_PORT == 80 and NetConst.GATEWAY_HOST == "blhxusgate.yo-star.com"
	var0_0.LoginPlatform = PLATFORM_YOSTARUS
	var0_0.SDK_PID_TEST = "US-AZURLANE-TEST"
	var0_0.SDK_PID_RELEASE = "US-AZURLANE"
	var0_0.SDK_SERVER_URL = "http://en-sdk-api.yostarplat.com"
	var0_0.SDK_TRANS_URL = "https://migration.yo-star.com/?pid=US-AZURLANE"
end

function var0_0.CheckAudit()
	return NetConst.getwayType == 1
end

function var0_0.CheckPreAudit()
	return var0_0.isPreAudit
end

function var0_0.CheckPretest()
	return var0_0.isPretest
end

function var0_0.CheckGoogleSimulator()
	return NetConst.getwayType == 2
end

function var0_0.CheckRelease()
	return NetConst.getwayType == 0
end

function var0_0.CheckBiz()
	return NetConst.getwayType == 3
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
	if IsUnityEditor then
		onInit_YoStar({
			R_CODE = 0
		})
	end
end

function var0_0.EnterServer()
	var0_0.RoleInfoUpload()
end

function var0_0.Survey(arg0_15)
	Application.OpenURL(arg0_15)
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

function var0_0.OnAppPauseForSDK(arg0_19)
	if not var0_0.YOSTAR_SDK_INITED then
		return
	end

	if arg0_19 then
		var1_0:OnPause()
	else
		var1_0:OnResume()
	end
end

function var0_0.YoStarGoLogin(arg0_20)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LOGIN, {
		loginPlatform = arg0_20
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

;(function()
	function var0_0.Init(arg0_24)
		pg.UIMgr.GetInstance():LoadingOn()

		if var0_0.GetIsPlatform() then
			var1_0.pid = (var0_0.CheckRelease() or var0_0.CheckAudit()) and var0_0.SDK_PID_RELEASE or var0_0.SDK_PID_TEST
			var1_0.gameServerUrl = var0_0.SDK_SERVER_URL

			var1_0:Init()
		end
	end

	function var0_0.Login()
		if var0_0.GetIsPlatform() then
			if var0_0.LoginPlatform == PLATFORM_YOSTARUS and var0_0.LOGIN_RET ~= nil and var0_0.YoStarRetCodeHandler(var0_0.LOGIN_RET) then
				local var0_25 = User.New({
					type = 1,
					arg1 = var0_0.LoginPlatform,
					arg2 = var0_0.LOGIN_RET.LOGIN_UID,
					arg3 = var0_0.LOGIN_RET.LOGIN_TOKEN
				})

				pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
					user = var0_25
				})

				var0_0.LOGIN_RET = nil

				return
			end

			pg.UIMgr.GetInstance():LoadingOn()
			var1_0:Login()
		end
	end

	function var0_0.SetBirthday()
		if var0_0.GetIsPlatform() then
			var1_0:SetBirthday()
		end
	end

	function var0_0.ShowUserCenter()
		if var0_0.GetIsPlatform() then
			var1_0:ShowUserCenter()
		end
	end

	function var0_0.Pay(arg0_28, arg1_28, arg2_28)
		if var0_0.GetIsPlatform() then
			pg.UIMgr.GetInstance():LoadingOn()

			var0_0.OnYoStarPaying = Time.realtimeSinceStartup

			var1_0:Pay(arg0_28, arg1_28, arg2_28)
		end
	end

	function var0_0.ShowAihelp()
		if var0_0.GetIsPlatform() then
			var1_0:ShowAihelp()
		end
	end

	function var0_0.UserEventUpload(arg0_30)
		if var0_0.GetIsPlatform() then
			var1_0:UserEventUpload(arg0_30)
		end
	end

	function var0_0.RoleInfoUpload()
		if var0_0.GetIsPlatform() then
			local var0_31 = getProxy(PlayerProxy):getData()
			local var1_31 = getProxy(UserProxy):getData()
			local var2_31 = getProxy(ServerProxy):getLastServer(var1_31.uid)
			local var3_31 = tostring(var2_31.id .. " - " .. var2_31.name)
			local var4_31 = tostring(var0_31.id)
			local var5_31 = var0_31.name
			local var6_31 = {
				(tostring(var0_31.rmb))
			}
			local var7_31 = YoStarRoleInfo.New(var3_31, var4_31, var5_31, var6_31)

			var1_0:RoleInfoUpload(var7_31)
		end
	end

	function var0_0.ShowSurvey(arg0_32, arg1_32)
		if var0_0.GetIsPlatform() then
			local var0_32 = getProxy(PlayerProxy):getData()

			var1_0:ShowSurvey(arg0_32, tostring(var0_32.id), arg1_32)
		end
	end

	function var0_0.ShowAgreement(arg0_33)
		if var0_0.GetIsPlatform() then
			var1_0:ShowSurvey(arg0_33)
		end
	end

	function var0_0.ShowSwitchAccount()
		if var0_0.GetIsPlatform() then
			var1_0:ShowSwitchAccount()
		end
	end

	function var0_0.SystemShare(arg0_35, arg1_35)
		if var0_0.GetIsPlatform() then
			var1_0:SystemShare(arg0_35, arg1_35)
		end
	end

	function var0_0.ShareImage(arg0_36)
		if var0_0.GetIsPlatform() then
			var1_0:ShareImage(arg0_36)
		end
	end

	function var0_0.ShareUrl(arg0_37, arg1_37)
		if var0_0.GetIsPlatform() then
			var1_0:ShareUrl(arg0_37, arg1_37)
		end
	end

	function var0_0.ShowNetworkTest(arg0_38)
		if var0_0.GetIsPlatform() then
			var1_0:ShowNetworkTest(arg0_38)
		end
	end

	function var0_0.ShowWebView(arg0_39, arg1_39)
		if var0_0.GetIsPlatform() then
			var1_0:ShowWebView(arg0_39, arg1_39)
		end
	end

	function var0_0.RequestStoreReview()
		if var0_0.GetIsPlatform() then
			var1_0:RequestStoreReview()
		end
	end

	function var0_0.QueryErrorMsg(arg0_41)
		if var0_0.GetIsPlatform() then
			return var1_0:QueryErrorMsg(arg0_41)
		end
	end

	function var0_0.QuerySkuDetails(arg0_42)
		if var0_0.GetIsPlatform() then
			var1_0:QuerySkuDetails()
		end
	end

	function var0_0.QueryTextLegality(arg0_43)
		if var0_0.GetIsPlatform() then
			var1_0:QueryTextLegality(arg0_43)
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

	function var0_0.BuildLocalNotification(arg0_47, arg1_47, arg2_47, arg3_47)
		if var0_0.GetIsPlatform() then
			var1_0:BuildLocalNotification(arg0_47, arg1_47, arg2_47, arg3_47)
		end
	end

	function var0_0.DeleteLocalNotification(arg0_48)
		if var0_0.GetIsPlatform() then
			var1_0:DeleteLocalNotification(arg0_48)
		end
	end
end)()
;(function()
	function onInit_YoStar(arg0_50)
		pg.UIMgr.GetInstance():LoadingOff()

		if var0_0.YoStarRetCodeHandler(arg0_50) then
			var0_0.YOSTAR_SDK_INITED = true

			var0_0.FetchDeviceTrackingID()
			var0_0.YoStarGoLogin()
		end
	end

	function onLogin_YoStar(arg0_51)
		pg.UIMgr.GetInstance():LoadingOff()

		if var0_0.LoginPlatform == PLATFORM_YOSTARJP then
			if var0_0.YoStarRetCodeHandler(arg0_51) then
				local var0_51 = User.New({
					type = 1,
					arg1 = var0_0.LoginPlatform,
					arg2 = arg0_51.LOGIN_UID,
					arg3 = arg0_51.LOGIN_TOKEN
				})

				pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
					user = var0_51
				})
			end
		elseif var0_0.LoginPlatform == PLATFORM_YOSTARUS then
			if var0_0.LOGIN_RET == nil then
				var0_0.LOGIN_RET = arg0_51

				pg.m02:sendNotification(GAME.PLATFORM_LOGIN_WAIT_DONE, {
					isLoginSuccess = var0_0.YoStarRetCodeHandler(arg0_51)
				})
			else
				var0_0.LOGIN_RET = arg0_51

				if var0_0.YoStarRetCodeHandler(arg0_51) then
					local var1_51 = User.New({
						type = 1,
						arg1 = var0_0.LoginPlatform,
						arg2 = arg0_51.LOGIN_UID,
						arg3 = arg0_51.LOGIN_TOKEN
					})

					pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
						user = var1_51
					})

					var0_0.LOGIN_RET = nil
				end
			end
		end
	end

	function onLogout_YoStar(arg0_52)
		if var0_0.YoStarRetCodeHandler(arg0_52) then
			var0_0.LOGIN_RET = nil

			if not pg.proxyRegister then
				pg.m02:sendNotification(GAME.PLATFORM_LOGIN_WAIT_DONE, {
					isLoginSuccess = false
				})

				return
			end

			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 0
			})
		end
	end

	function onPay_YoStar(arg0_53)
		var0_0.OnYoStarPaying = -1

		pg.UIMgr.GetInstance():LoadingOff()

		if var0_0.YoStarRetCodeHandler(arg0_53) then
			getProxy(ShopsProxy):removeWaitTimer()
			pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
				payId = arg0_53.EXTRA_DATA,
				bsId = arg0_53.ORDER_ID
			})
		else
			getProxy(ShopsProxy):removeWaitTimer()
			pg.m02:sendNotification(GAME.CHARGE_FAILED, {
				payId = arg0_53.EXTRA_DATA
			})
		end
	end

	function onSystemShare_YoStar(arg0_54)
		if var0_0.YoStarRetCodeHandler(arg0_54) then
			-- block empty
		end
	end

	function onDeleteAccount_YoStar(arg0_55)
		if var0_0.YoStarRetCodeHandler(arg0_55) then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 0
			})
		end
	end

	function onClearSDKCache_YoStar(arg0_56)
		if var0_0.YoStarRetCodeHandler(arg0_56) then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 0
			})
		end
	end

	function onQuerySkuDetails_YoStar(arg0_57)
		if var0_0.YoStarRetCodeHandler(arg0_57) then
			-- block empty
		end
	end

	function onUserSurvey_YoStar(arg0_58)
		if var0_0.YoStarRetCodeHandler(arg0_58) then
			-- block empty
		end
	end

	function onSwitchServer_YoStar(arg0_59)
		return
	end

	function onQueryTextLegality_YoStar(arg0_60)
		if var0_0.YoStarRetCodeHandler(arg0_60) then
			-- block empty
		end
	end

	function onPushMsgReceive_YoStar(arg0_61)
		if var0_0.YoStarRetCodeHandler(arg0_61) then
			-- block empty
		end
	end

	function onUniversalLink_YoStar(arg0_62)
		if var0_0.YoStarRetCodeHandler(arg0_62) then
			-- block empty
		end
	end

	function onDeviceTrackingID_YoStar(arg0_63)
		if var0_0.YoStarRetCodeHandler(arg0_63) then
			var0_0.DeviceID = arg0_63.DATA
		end
	end

	function onLocalNotification_YoStar(arg0_64)
		if var0_0.YoStarRetCodeHandler(arg0_64) then
			-- block empty
		end
	end

	function onSetBirthday_YoStar(arg0_65)
		if var0_0.YoStarRetCodeHandler(arg0_65) then
			-- block empty
		end
	end
end)()

function var0_0.YoStarRetCodeHandler(arg0_66)
	local var0_66 = arg0_66.R_CODE

	if var0_66 == 0 then
		return true
	else
		local var1_66 = "SDK Error Code:" .. var0_66

		originalPrint(var1_66)

		local var2_66 = var0_0.QueryErrorMsg(var0_66)

		if var2_66 and string.len(var2_66) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(var2_66)
		else
			pg.TipsMgr.GetInstance():ShowTips(var1_66)
		end
	end

	return false
end

return var0_0
