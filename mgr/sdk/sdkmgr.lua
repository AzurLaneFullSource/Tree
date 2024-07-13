pg = pg or {}
pg.SdkMgr = singletonClass("SdkMgr")

local var0_0 = pg.SdkMgr

function var0_0.Ctor(arg0_1)
	if PLATFORM_CODE == PLATFORM_CH then
		arg0_1.instance = require("Mgr.Sdk.BiliSDKMgr")
	elseif PLATFORM_CODE == PLATFORM_JP then
		arg0_1.instance = require("Mgr.Sdk.AiriSDKJPMgr")
	elseif PLATFORM_CODE == PLATFORM_KR then
		arg0_1.instance = require("Mgr.Sdk.TxwyKrSDKMgr")
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0_1.instance = require("Mgr.Sdk.AiriSDKUSMgr")
	elseif PLATFORM_CODE == PLATFORM_CHT then
		arg0_1.instance = require("Mgr.Sdk.YongshiSdkMgr")
	end

	arg0_1.pcode = arg0_1:GetPlatformCode(Application.identifier)
end

function var0_0.Call(arg0_2, arg1_2, ...)
	assert(arg0_2.instance)

	if arg0_2.instance[arg1_2] then
		arg0_2.instance[arg1_2](...)
	end
end

function var0_0.Get(arg0_3, arg1_3, ...)
	assert(arg0_3.instance)
	assert(arg0_3.instance[arg1_3], "func should exist " .. arg1_3)

	return arg0_3.instance[arg1_3](...)
end

function EnterMultiWindow(arg0_4)
	originalPrint(".......EnterMultiWindow")
end

function ExitMultiWindow(arg0_5)
	originalPrint(".......ExitMultiWindow")
end

function var0_0.InitSDK(arg0_6)
	arg0_6:Call("InitSDK")
end

function var0_0.GoSDkLoginScene(arg0_7)
	arg0_7:Call("GoSDkLoginScene")
end

function var0_0.LoginSdk(arg0_8, arg1_8)
	arg0_8:Call("LoginSdk", arg1_8)
end

function var0_0.TryLoginSdk(arg0_9)
	arg0_9:Call("TryLoginSdk")
end

function var0_0.CreateRole(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10)
	arg0_10:Call("CreateRole", arg1_10, arg2_10, arg3_10, arg4_10, arg5_10)
end

function var0_0.EnterServer(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11, arg7_11)
	arg0_11:Call("EnterServer", arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11, arg7_11)
end

function var0_0.ChooseServer(arg0_12, arg1_12, arg2_12)
	arg0_12:Call("ChooseServer", arg1_12, arg2_12)
end

function var0_0.SdkGateWayLogined(arg0_13)
	arg0_13:Call("SdkGateWayLogined")
end

function var0_0.SdkLoginGetaWayFailed(arg0_14)
	arg0_14:Call("SdkLoginGetaWayFailed")
end

function var0_0.SdkLevelUp(arg0_15)
	arg0_15:Call("SdkLevelUp")
end

function var0_0.SdkPay(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16, arg5_16, arg6_16, arg7_16, arg8_16, arg9_16, arg10_16)
	arg0_16:Call("SdkPay", arg1_16, arg2_16, arg3_16, arg4_16, arg5_16, arg6_16, arg7_16, arg8_16, arg9_16, arg10_16)
end

function var0_0.LogoutSDK(arg0_17, arg1_17)
	arg0_17:Call("LogoutSDK", arg1_17)
end

function var0_0.BindCPU(arg0_18)
	arg0_18:Call("BindCPU")
end

function var0_0.OnAndoridBackPress(arg0_19)
	arg0_19:Call("OnAndoridBackPress")
end

function var0_0.DeleteAccount(arg0_20)
	arg0_20:Call("DeleteAccount")
end

function var0_0.GetChannelUID(arg0_21)
	return arg0_21:Get("GetChannelUID")
end

function var0_0.GetLoginType(arg0_22)
	local var0_22 = Application.persistentDataPath .. "/server_config.txt"

	if PathMgr.FileExists(var0_22) then
		return LoginType.PLATFORM_INNER
	end

	return arg0_22:Get("GetLoginType")
end

function var0_0.GetIsPlatform(arg0_23)
	return arg0_23:Get("GetIsPlatform")
end

function var0_0.EnterLoginScene(arg0_24)
	arg0_24.inLoginScene = true
end

function var0_0.ExitLoginScene(arg0_25)
	arg0_25.inLoginScene = false
end

function var0_0.IsInLoginScene(arg0_26)
	return arg0_26.inLoginScene
end

function var0_0.IsYunPackage(arg0_27)
	return PLATFORM_CODE == PLATFORM_CH and arg0_27:GetChannelUID() == "yun"
end

function var0_0.Service(arg0_28)
	arg0_28:Call("Service")
end

function var0_0.Survey(arg0_29, arg1_29)
	arg0_29:Call("Survey", arg1_29)
end

function var0_0.IsHuaweiPackage(arg0_30)
	return PLATFORM_CODE == PLATFORM_CH and arg0_30:Get("IsHuaweiPackage")
end

function var0_0.IsAUPackage(arg0_31)
	return PLATFORM_CODE == PLATFORM_JP and arg0_31:GetChannelUID() == "2"
end

function var0_0.GetYostarUid(arg0_32)
	return arg0_32:Get("GetYostarUid")
end

function var0_0.GetYostarTransCode(arg0_33)
	return arg0_33:Get("GetTransCode")
end

function var0_0.CheckAudit(arg0_34)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_34:Get("CheckAudit")
	else
		return false
	end
end

function var0_0.CheckPreAudit(arg0_35)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_35:Get("CheckPreAudit")
	else
		return false
	end
end

function var0_0.CheckPretest(arg0_36)
	return arg0_36:Get("CheckPretest")
end

function var0_0.CheckGoogleSimulator(arg0_37)
	return arg0_37:Get("CheckGoogleSimulator")
end

function var0_0.CheckWorldTest(arg0_38)
	if PLATFORM_CODE == PLATFORM_CH then
		return arg0_38:Get("CheckWorldTest")
	else
		return false
	end
end

function var0_0.AiriLoginSDK(arg0_39)
	arg0_39:Call("AiriLogin")
end

function var0_0.TranscodeRequest(arg0_40)
	arg0_40:Call("TranscodeRequest")
end

function var0_0.LoginWithTranscode(arg0_41, arg1_41, arg2_41)
	arg0_41:Call("LoginWithTranscode", arg1_41, arg2_41)
end

function var0_0.LoginWithSocial(arg0_42, arg1_42, arg2_42, arg3_42)
	arg0_42:Call("LoginWithSocial", arg1_42, arg2_42, arg3_42)
end

function var0_0.LoginWithDevice(arg0_43)
	arg0_43:Call("LoginWithDevice")
end

function var0_0.AiriBuy(arg0_44, arg1_44, arg2_44, arg3_44)
	arg0_44:Call("AiriBuy", arg1_44, arg2_44, arg3_44)
end

function var0_0.LinkSocial(arg0_45, arg1_45, arg2_45, arg3_45)
	arg0_45:Call("LinkSocial", arg1_45, arg2_45, arg3_45)
end

function var0_0.UnlinkSocial(arg0_46, arg1_46)
	arg0_46:Call("UnlinkSocial", arg1_46)
end

function var0_0.IsSocialLink(arg0_47, arg1_47)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_47:Get("IsSocialLink", arg1_47)
	else
		return false
	end
end

function var0_0.GetSocialName(arg0_48, arg1_48)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_48:Get("GetSocialName", arg1_48)
	else
		return "none"
	end
end

function var0_0.GetIsBirthSet(arg0_49)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_49:Get("GetIsBirthSet")
	end

	return true
end

function var0_0.SetBirth(arg0_50, arg1_50)
	arg0_50:Call("SetBirth", arg1_50)
end

function var0_0.ClearAccountCache(arg0_51)
	arg0_51:Call("ClearAccountCache")
end

function var0_0.GameShare(arg0_52, arg1_52, arg2_52)
	arg0_52:Call("GameShare", arg1_52, arg2_52)
end

function var0_0.VerificationCodeReq(arg0_53, arg1_53)
	arg0_53:Call("VerificationCodeReq", arg1_53)
end

function var0_0.OpenYostarHelp(arg0_54)
	arg0_54:Call("OpenYostarHelp")
end

function var0_0.OnAppPauseForSDK(arg0_55, arg1_55)
	arg0_55:Call("OnAppPauseForSDK", arg1_55)
end

function var0_0.UserEventUpload(arg0_56, arg1_56)
	arg0_56:Call("UserEventUpload", arg1_56)
end

function var0_0.ShowSurvey(arg0_57, arg1_57, arg2_57)
	return arg0_57:Call("ShowSurvey", arg1_57, arg2_57)
end

function var0_0.CheckAiriCanBuy(arg0_58)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0_58:Get("CheckAiriCanBuy")
	else
		return true
	end
end

function var0_0.CheckHadAccountCache(arg0_59)
	if PLATFORM_CODE == PLATFORM_JP then
		return arg0_59:Get("CheckHadAccountCache")
	else
		return true
	end
end

function var0_0.AccountDelete(arg0_60)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0_60:Get("AccountDelete")
	else
		return true
	end
end

function var0_0.AccountReborn(arg0_61)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0_61:Get("AccountReborn")
	else
		return true
	end
end

function var0_0.ConfirmLinkGooglePlayGame(arg0_62)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0_62:Get("ConfirmLinkGooglePlayGame")
	else
		return true
	end
end

function var0_0.ConfirmUnLinkGooglePlayGame(arg0_63)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0_63:Get("ConfirmUnLinkGooglePlayGame")
	else
		return true
	end
end

function var0_0.BindYostarPass(arg0_64)
	if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
		return arg0_64:Get("BindYostarPass")
	else
		return true
	end
end

AIRI_LAST_GEN_TIME = 0
AIRI_GEN_LIMIT_TIME = 30

function GetAiriGenCodeTimeRemain()
	local var0_65 = Time.realtimeSinceStartup - AIRI_LAST_GEN_TIME

	if var0_65 > AIRI_GEN_LIMIT_TIME or AIRI_LAST_GEN_TIME == 0 then
		return 0
	else
		return math.floor(AIRI_GEN_LIMIT_TIME - var0_65)
	end
end

function var0_0.UserCenter(arg0_66)
	arg0_66:Call("UserCenter")
end

function var0_0.BugReport(arg0_67)
	arg0_67:Call("BugReport")
end

function var0_0.StoreReview(arg0_68)
	arg0_68:Call("StoreReview")
end

function var0_0.QueryWithProduct(arg0_69)
	arg0_69:Call("QueryWithProduct")
end

function var0_0.ShareImg(arg0_70, arg1_70, arg2_70)
	arg0_70:Call("ShareImg", arg1_70, arg2_70)
end

function var0_0.SwitchAccount(arg0_71)
	arg0_71:Call("SwitchAccount")
end

function var0_0.CompletedTutorial(arg0_72)
	arg0_72:Call("CompletedTutorial")
end

function var0_0.UnlockAchievement(arg0_73)
	arg0_73:Call("UnlockAchievement")
end

function var0_0.IsBindFaceBook(arg0_74)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_74:Get("IsBindFaceBook")
	end
end

function var0_0.IsBindApple(arg0_75)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_75:Get("IsBindApple")
	end
end

function var0_0.IsBindGoogle(arg0_76)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_76:Get("IsBindGoogle")
	end
end

function var0_0.IsBindPhone(arg0_77)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_77:Get("IsBindPhone")
	end
end

function var0_0.IsBindGameCenter(arg0_78)
	if PLATFORM_CODE == PLATFORM_CHT then
		return false
	end
end

function var0_0.CanTriggerDeepLinking(arg0_79)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_79:Get("CanTriggerDeepLinking")
	else
		return false
	end
end

function var0_0.TriggerDeepLinking(arg0_80)
	arg0_80:Call("TriggerDeepLinking")
end

function var0_0.BindSocial(arg0_81, arg1_81)
	if arg1_81 == 1 then
		arg0_81:BindFaceBook()
	elseif arg1_81 == 2 then
		arg0_81:BindGoogle()
	elseif arg1_81 == 3 then
		arg0_81:BindPhone()
	elseif arg1_81 == 4 then
		-- block empty
	elseif arg1_81 == 5 then
		arg0_81:BindApple()
	end
end

function var0_0.UnbindSocial(arg0_82, arg1_82)
	if arg1_82 == 1 then
		arg0_82:UnBindFaceBook()
	elseif arg1_82 == 2 then
		arg0_82:UnBindGoogle()
	elseif arg1_82 == 3 then
		arg0_82:UnBindPhone()
	elseif arg1_82 == 4 then
		-- block empty
	end
end

function var0_0.BindFaceBook(arg0_83)
	arg0_83:Call("BindFaceBook")
end

function var0_0.BindApple(arg0_84)
	arg0_84:Call("BindApple")
end

function var0_0.BindGoogle(arg0_85)
	arg0_85:Call("BindGoogle")
end

function var0_0.BindPhone(arg0_86)
	arg0_86:Call("BindPhone")
end

function var0_0.UnBindFaceBook(arg0_87)
	arg0_87:Call("UnBindFaceBook")
end

function var0_0.UnBindGoogle(arg0_88)
	arg0_88:Call("UnBindGoogle")
end

function var0_0.UnBindPhone(arg0_89)
	arg0_89:Call("UnBindPhone")
end

function var0_0.ShowLicence(arg0_90)
	arg0_90:Call("ShowLicence")
end

function var0_0.ShowPrivate(arg0_91)
	arg0_91:Call("ShowPrivate")
end

function var0_0.GetProduct(arg0_92, arg1_92)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_92:Get("GetProduct", arg1_92)
	end
end

function var0_0.GetDeviceId(arg0_93)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_93:Get("GetDeviceId")
	elseif PLATFORM_CODE == PLATFORM_KR then
		return arg0_93:Get("GetDeviceModel")
	elseif PLATFORM_CODE == PLATFORM_CHT then
		return SystemInfo.deviceUniqueIdentifier
	else
		return ""
	end
end

function InLoginScene()
	local function var0_94()
		return getProxy(UserProxy):GetLoginedFlag()
	end

	if pg.SdkMgr.GetInstance():IsInLoginScene() and not var0_94() then
		return true
	end

	return false
end

function var0_0.GetPlatformCode(arg0_96, arg1_96)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_96:Get("GetPackageCode", arg1_96)
	else
		return nil
	end
end

function var0_0.IgnorePlatform(arg0_97, arg1_97)
	local var0_97 = arg0_97.pcode

	if var0_97 and arg1_97 and #arg1_97 > 0 and _.any(arg1_97, function(arg0_98)
		return tostring(arg0_98) == var0_97
	end) then
		return true
	end

	return false
end
