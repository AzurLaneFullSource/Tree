pg = pg or {}
pg.SdkMgr = singletonClass("SdkMgr")

local var0 = pg.SdkMgr

function var0.Ctor(arg0)
	if PLATFORM_CODE == PLATFORM_CH then
		arg0.instance = require("Mgr.Sdk.BiliSDKMgr")
	elseif PLATFORM_CODE == PLATFORM_JP then
		arg0.instance = require("Mgr.Sdk.AiriSDKJPMgr")
	elseif PLATFORM_CODE == PLATFORM_KR then
		arg0.instance = require("Mgr.Sdk.TxwyKrSDKMgr")
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0.instance = require("Mgr.Sdk.AiriSDKUSMgr")
	elseif PLATFORM_CODE == PLATFORM_CHT then
		arg0.instance = require("Mgr.Sdk.YongshiSdkMgr")
	end

	arg0.pcode = arg0:GetPlatformCode(Application.identifier)
end

function var0.Call(arg0, arg1, ...)
	assert(arg0.instance)

	if arg0.instance[arg1] then
		arg0.instance[arg1](...)
	end
end

function var0.Get(arg0, arg1, ...)
	assert(arg0.instance)
	assert(arg0.instance[arg1], "func should exist " .. arg1)

	return arg0.instance[arg1](...)
end

function EnterMultiWindow(arg0)
	originalPrint(".......EnterMultiWindow")
end

function ExitMultiWindow(arg0)
	originalPrint(".......ExitMultiWindow")
end

function var0.InitSDK(arg0)
	arg0:Call("InitSDK")
end

function var0.GoSDkLoginScene(arg0)
	arg0:Call("GoSDkLoginScene")
end

function var0.LoginSdk(arg0, arg1)
	arg0:Call("LoginSdk", arg1)
end

function var0.TryLoginSdk(arg0)
	arg0:Call("TryLoginSdk")
end

function var0.CreateRole(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0:Call("CreateRole", arg1, arg2, arg3, arg4, arg5)
end

function var0.EnterServer(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	arg0:Call("EnterServer", arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end

function var0.ChooseServer(arg0, arg1, arg2)
	arg0:Call("ChooseServer", arg1, arg2)
end

function var0.SdkGateWayLogined(arg0)
	arg0:Call("SdkGateWayLogined")
end

function var0.SdkLoginGetaWayFailed(arg0)
	arg0:Call("SdkLoginGetaWayFailed")
end

function var0.SdkLevelUp(arg0)
	arg0:Call("SdkLevelUp")
end

function var0.SdkPay(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
	arg0:Call("SdkPay", arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
end

function var0.LogoutSDK(arg0, arg1)
	arg0:Call("LogoutSDK", arg1)
end

function var0.BindCPU(arg0)
	arg0:Call("BindCPU")
end

function var0.OnAndoridBackPress(arg0)
	arg0:Call("OnAndoridBackPress")
end

function var0.DeleteAccount(arg0)
	arg0:Call("DeleteAccount")
end

function var0.GetChannelUID(arg0)
	return arg0:Get("GetChannelUID")
end

function var0.GetLoginType(arg0)
	local var0 = Application.persistentDataPath .. "/server_config.txt"

	if PathMgr.FileExists(var0) then
		return LoginType.PLATFORM_INNER
	end

	return arg0:Get("GetLoginType")
end

function var0.GetIsPlatform(arg0)
	return arg0:Get("GetIsPlatform")
end

function var0.EnterLoginScene(arg0)
	arg0.inLoginScene = true
end

function var0.ExitLoginScene(arg0)
	arg0.inLoginScene = false
end

function var0.IsInLoginScene(arg0)
	return arg0.inLoginScene
end

function var0.IsYunPackage(arg0)
	return PLATFORM_CODE == PLATFORM_CH and arg0:GetChannelUID() == "yun"
end

function var0.Service(arg0)
	arg0:Call("Service")
end

function var0.Survey(arg0, arg1)
	arg0:Call("Survey", arg1)
end

function var0.IsHuaweiPackage(arg0)
	return PLATFORM_CODE == PLATFORM_CH and arg0:Get("IsHuaweiPackage")
end

function var0.IsAUPackage(arg0)
	return PLATFORM_CODE == PLATFORM_JP and arg0:GetChannelUID() == "2"
end

function var0.GetYostarUid(arg0)
	return arg0:Get("GetYostarUid")
end

function var0.GetYostarTransCode(arg0)
	return arg0:Get("GetTransCode")
end

function var0.CheckAudit(arg0)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0:Get("CheckAudit")
	else
		return false
	end
end

function var0.CheckPreAudit(arg0)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0:Get("CheckPreAudit")
	else
		return false
	end
end

function var0.CheckPretest(arg0)
	return arg0:Get("CheckPretest")
end

function var0.CheckGoogleSimulator(arg0)
	return arg0:Get("CheckGoogleSimulator")
end

function var0.CheckWorldTest(arg0)
	if PLATFORM_CODE == PLATFORM_CH then
		return arg0:Get("CheckWorldTest")
	else
		return false
	end
end

function var0.AiriLoginSDK(arg0)
	arg0:Call("AiriLogin")
end

function var0.TranscodeRequest(arg0)
	arg0:Call("TranscodeRequest")
end

function var0.LoginWithTranscode(arg0, arg1, arg2)
	arg0:Call("LoginWithTranscode", arg1, arg2)
end

function var0.LoginWithSocial(arg0, arg1, arg2, arg3)
	arg0:Call("LoginWithSocial", arg1, arg2, arg3)
end

function var0.LoginWithDevice(arg0)
	arg0:Call("LoginWithDevice")
end

function var0.AiriBuy(arg0, arg1, arg2, arg3)
	arg0:Call("AiriBuy", arg1, arg2, arg3)
end

function var0.LinkSocial(arg0, arg1, arg2, arg3)
	arg0:Call("LinkSocial", arg1, arg2, arg3)
end

function var0.UnlinkSocial(arg0, arg1)
	arg0:Call("UnlinkSocial", arg1)
end

function var0.IsSocialLink(arg0, arg1)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0:Get("IsSocialLink", arg1)
	else
		return false
	end
end

function var0.GetSocialName(arg0, arg1)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0:Get("GetSocialName", arg1)
	else
		return "none"
	end
end

function var0.GetIsBirthSet(arg0)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0:Get("GetIsBirthSet")
	end

	return true
end

function var0.SetBirth(arg0, arg1)
	arg0:Call("SetBirth", arg1)
end

function var0.ClearAccountCache(arg0)
	arg0:Call("ClearAccountCache")
end

function var0.GameShare(arg0, arg1, arg2)
	arg0:Call("GameShare", arg1, arg2)
end

function var0.VerificationCodeReq(arg0, arg1)
	arg0:Call("VerificationCodeReq", arg1)
end

function var0.OpenYostarHelp(arg0)
	arg0:Call("OpenYostarHelp")
end

function var0.OnAppPauseForSDK(arg0, arg1)
	arg0:Call("OnAppPauseForSDK", arg1)
end

function var0.UserEventUpload(arg0, arg1)
	arg0:Call("UserEventUpload", arg1)
end

function var0.ShowSurvey(arg0, arg1, arg2)
	return arg0:Call("ShowSurvey", arg1, arg2)
end

function var0.CheckAiriCanBuy(arg0)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0:Get("CheckAiriCanBuy")
	else
		return true
	end
end

function var0.CheckHadAccountCache(arg0)
	if PLATFORM_CODE == PLATFORM_JP then
		return arg0:Get("CheckHadAccountCache")
	else
		return true
	end
end

function var0.AccountDelete(arg0)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0:Get("AccountDelete")
	else
		return true
	end
end

function var0.AccountReborn(arg0)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0:Get("AccountReborn")
	else
		return true
	end
end

function var0.ConfirmLinkGooglePlayGame(arg0)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0:Get("ConfirmLinkGooglePlayGame")
	else
		return true
	end
end

function var0.ConfirmUnLinkGooglePlayGame(arg0)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0:Get("ConfirmUnLinkGooglePlayGame")
	else
		return true
	end
end

function var0.BindYostarPass(arg0)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0:Get("BindYostarPass")
	else
		return true
	end
end

AIRI_LAST_GEN_TIME = 0
AIRI_GEN_LIMIT_TIME = 30

function GetAiriGenCodeTimeRemain()
	local var0 = Time.realtimeSinceStartup - AIRI_LAST_GEN_TIME

	if var0 > AIRI_GEN_LIMIT_TIME or AIRI_LAST_GEN_TIME == 0 then
		return 0
	else
		return math.floor(AIRI_GEN_LIMIT_TIME - var0)
	end
end

function var0.UserCenter(arg0)
	arg0:Call("UserCenter")
end

function var0.BugReport(arg0)
	arg0:Call("BugReport")
end

function var0.StoreReview(arg0)
	arg0:Call("StoreReview")
end

function var0.QueryWithProduct(arg0)
	arg0:Call("QueryWithProduct")
end

function var0.ShareImg(arg0, arg1, arg2)
	arg0:Call("ShareImg", arg1, arg2)
end

function var0.SwitchAccount(arg0)
	arg0:Call("SwitchAccount")
end

function var0.CompletedTutorial(arg0)
	arg0:Call("CompletedTutorial")
end

function var0.UnlockAchievement(arg0)
	arg0:Call("UnlockAchievement")
end

function var0.IsBindFaceBook(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0:Get("IsBindFaceBook")
	end
end

function var0.IsBindApple(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0:Get("IsBindApple")
	end
end

function var0.IsBindGoogle(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0:Get("IsBindGoogle")
	end
end

function var0.IsBindPhone(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0:Get("IsBindPhone")
	end
end

function var0.IsBindGameCenter(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return false
	end
end

function var0.CanTriggerDeepLinking(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0:Get("CanTriggerDeepLinking")
	else
		return false
	end
end

function var0.TriggerDeepLinking(arg0)
	arg0:Call("TriggerDeepLinking")
end

function var0.BindSocial(arg0, arg1)
	if arg1 == 1 then
		arg0:BindFaceBook()
	elseif arg1 == 2 then
		arg0:BindGoogle()
	elseif arg1 == 3 then
		arg0:BindPhone()
	elseif arg1 == 4 then
		-- block empty
	elseif arg1 == 5 then
		arg0:BindApple()
	end
end

function var0.UnbindSocial(arg0, arg1)
	if arg1 == 1 then
		arg0:UnBindFaceBook()
	elseif arg1 == 2 then
		arg0:UnBindGoogle()
	elseif arg1 == 3 then
		arg0:UnBindPhone()
	elseif arg1 == 4 then
		-- block empty
	end
end

function var0.BindFaceBook(arg0)
	arg0:Call("BindFaceBook")
end

function var0.BindApple(arg0)
	arg0:Call("BindApple")
end

function var0.BindGoogle(arg0)
	arg0:Call("BindGoogle")
end

function var0.BindPhone(arg0)
	arg0:Call("BindPhone")
end

function var0.UnBindFaceBook(arg0)
	arg0:Call("UnBindFaceBook")
end

function var0.UnBindGoogle(arg0)
	arg0:Call("UnBindGoogle")
end

function var0.UnBindPhone(arg0)
	arg0:Call("UnBindPhone")
end

function var0.ShowLicence(arg0)
	arg0:Call("ShowLicence")
end

function var0.ShowPrivate(arg0)
	arg0:Call("ShowPrivate")
end

function var0.GetProduct(arg0, arg1)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0:Get("GetProduct", arg1)
	end
end

function var0.GetDeviceId(arg0)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0:Get("GetDeviceId")
	elseif PLATFORM_CODE == PLATFORM_KR then
		return arg0:Get("GetDeviceModel")
	elseif PLATFORM_CODE == PLATFORM_CHT then
		return SystemInfo.deviceUniqueIdentifier
	else
		return ""
	end
end

function InLoginScene()
	local function var0()
		return getProxy(UserProxy):GetLoginedFlag()
	end

	if pg.SdkMgr.GetInstance():IsInLoginScene() and not var0() then
		return true
	end

	return false
end

function var0.GetPlatformCode(arg0, arg1)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0:Get("GetPackageCode", arg1)
	else
		return nil
	end
end

function var0.IgnorePlatform(arg0, arg1)
	local var0 = arg0.pcode

	if var0 and arg1 and #arg1 > 0 and _.any(arg1, function(arg0)
		return tostring(arg0) == var0
	end) then
		return true
	end

	return false
end
