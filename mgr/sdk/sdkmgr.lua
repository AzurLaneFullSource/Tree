pg = pg or {}
pg.SdkMgr = singletonClass("SdkMgr")

local var0_0 = pg.SdkMgr

function var0_0.Ctor(arg0_1)
	if PLATFORM_CODE == PLATFORM_CH then
		arg0_1.instance = require("Mgr.Sdk.BiliSDKMgr")
	elseif PLATFORM_CODE == PLATFORM_JP then
		arg0_1.instance = require("Mgr.Sdk.YoStarMgr")

		arg0_1.instance.InitJP()
	elseif PLATFORM_CODE == PLATFORM_KR then
		arg0_1.instance = require("Mgr.Sdk.TxwyKrSDKMgr")
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0_1.instance = require("Mgr.Sdk.YoStarMgr")

		arg0_1.instance.InitUS()
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
	local var0_21 = arg0_21:Get("GetChannelUID")

	if var0_21 == "" then
		var0_21 = PLATFORM_LOCAL
	end

	return var0_21
end

function var0_0.GetLoginType(arg0_22)
	local var0_22 = Application.persistentDataPath .. "/server_config.txt"

	if PathMgr.FileExists(var0_22) then
		return LoginType.PLATFORM_INNER
	end

	if string.match(NetConst.GATEWAY_HOST, "^10%.0") then
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

function var0_0.CheckAudit(arg0_31)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_31:Get("CheckAudit")
	else
		return false
	end
end

function var0_0.CheckPreAudit(arg0_32)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_32:Get("CheckPreAudit")
	else
		return false
	end
end

function var0_0.CheckPretest(arg0_33)
	return arg0_33:Get("CheckPretest")
end

function var0_0.CheckGoogleSimulator(arg0_34)
	return arg0_34:Get("CheckGoogleSimulator")
end

function var0_0.CheckWorldTest(arg0_35)
	if PLATFORM_CODE == PLATFORM_CH then
		return arg0_35:Get("CheckWorldTest")
	else
		return false
	end
end

function var0_0.OnAppPauseForSDK(arg0_36, arg1_36)
	arg0_36:Call("OnAppPauseForSDK", arg1_36)
end

function var0_0.UserEventUpload(arg0_37, arg1_37)
	arg0_37:Call("UserEventUpload", arg1_37)
end

function var0_0.GameShare(arg0_38, arg1_38, arg2_38)
	arg0_38:Call("GameShare", arg1_38, arg2_38)
end

local function var1_0()
	function var0_0.YoStarLoginSDK(arg0_40)
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			arg0_40:Call("Login")
		end
	end

	function var0_0.YoStarPay(arg0_41, arg1_41, arg2_41, arg3_41)
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			arg0_41:Call("Pay", arg1_41, arg2_41, arg3_41)
		end
	end

	function var0_0.GameShare(arg0_42, arg1_42, arg2_42)
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			arg0_42:Call("SystemShare", arg1_42, arg2_42)
		end
	end

	function var0_0.YostarOpenAiHelp(arg0_43)
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			arg0_43:Call("ShowAihelp")
		end
	end

	function var0_0.OnAppPauseForSDK(arg0_44, arg1_44)
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			arg0_44:Call("OnAppPauseForSDK", arg1_44)
		end
	end

	function var0_0.YoStarShowSurvey(arg0_45, arg1_45, arg2_45)
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			return arg0_45:Call("ShowSurvey", arg1_45, arg2_45)
		end
	end

	function var0_0.YoStarCheckCanBuy(arg0_46)
		if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			return arg0_46:Get("CheckYoStarCanBuy")
		end
	end

	function var0_0.YoStarCheckHadAccountCache(arg0_47)
		if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			return arg0_47:Get("CheckHadAccountCache")
		end
	end

	function var0_0.YoStarShowUserCenter(arg0_48)
		if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			return arg0_48:Get("ShowUserCenter")
		end
	end

	function var0_0.YoStarRoleInfoUpload(arg0_49)
		if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			return arg0_49:Get("RoleInfoUpload")
		end
	end

	function var0_0.YoStarShowSwitchAccount(arg0_50)
		if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			return arg0_50:Get("ShowSwitchAccount")
		end
	end

	function var0_0.YoStarShowAccountCenter(arg0_51)
		if PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			return arg0_51:Get("ShowAccountCenter")
		end
	end

	function var0_0.UserEventUpload(arg0_52, arg1_52)
		arg0_52:Call("UserEventUpload", arg1_52)
	end
end

if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
	var1_0()
end

function var0_0.UserCenter(arg0_53)
	arg0_53:Call("UserCenter")
end

function var0_0.BugReport(arg0_54)
	arg0_54:Call("BugReport")
end

function var0_0.StoreReview(arg0_55)
	arg0_55:Call("StoreReview")
end

function var0_0.QueryWithProduct(arg0_56)
	arg0_56:Call("QueryWithProduct")
end

function var0_0.QueryPendingTransaction(arg0_57)
	arg0_57:Call("QueryPendingTransaction")
end

function var0_0.ShareImg(arg0_58, arg1_58, arg2_58)
	arg0_58:Call("ShareImg", arg1_58, arg2_58)
end

function var0_0.SwitchAccount(arg0_59)
	arg0_59:Call("SwitchAccount")
end

function var0_0.EventTrack(arg0_60, arg1_60)
	arg0_60:Call("EventTrack", arg1_60)
end

function var0_0.EventTrack(arg0_61, arg1_61)
	arg0_61:Call("EventTrack", arg1_61)
end

function var0_0.IsBindFaceBook(arg0_62)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_62:Get("IsBindFaceBook")
	end
end

function var0_0.IsBindApple(arg0_63)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_63:Get("IsBindApple")
	end
end

function var0_0.IsBindGoogle(arg0_64)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_64:Get("IsBindGoogle")
	end
end

function var0_0.IsBindPhone(arg0_65)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_65:Get("IsBindPhone")
	end
end

function var0_0.IsBindGameCenter(arg0_66)
	if PLATFORM_CODE == PLATFORM_CHT then
		return false
	end
end

function var0_0.CanTriggerDeepLinking(arg0_67)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_67:Get("CanTriggerDeepLinking")
	else
		return false
	end
end

function var0_0.TriggerDeepLinking(arg0_68)
	arg0_68:Call("TriggerDeepLinking")
end

function var0_0.BindSocial(arg0_69, arg1_69)
	if arg1_69 == 1 then
		arg0_69:BindFaceBook()
	elseif arg1_69 == 2 then
		arg0_69:BindGoogle()
	elseif arg1_69 == 3 then
		arg0_69:BindPhone()
	elseif arg1_69 == 4 then
		-- block empty
	elseif arg1_69 == 5 then
		arg0_69:BindApple()
	end
end

function var0_0.UnbindSocial(arg0_70, arg1_70)
	if arg1_70 == 1 then
		arg0_70:UnBindFaceBook()
	elseif arg1_70 == 2 then
		arg0_70:UnBindGoogle()
	elseif arg1_70 == 3 then
		arg0_70:UnBindPhone()
	elseif arg1_70 == 4 then
		-- block empty
	end
end

function var0_0.BindFaceBook(arg0_71)
	arg0_71:Call("BindFaceBook")
end

function var0_0.BindApple(arg0_72)
	arg0_72:Call("BindApple")
end

function var0_0.BindGoogle(arg0_73)
	arg0_73:Call("BindGoogle")
end

function var0_0.BindPhone(arg0_74)
	arg0_74:Call("BindPhone")
end

function var0_0.UnBindFaceBook(arg0_75)
	arg0_75:Call("UnBindFaceBook")
end

function var0_0.UnBindGoogle(arg0_76)
	arg0_76:Call("UnBindGoogle")
end

function var0_0.UnBindPhone(arg0_77)
	arg0_77:Call("UnBindPhone")
end

function var0_0.ShowLicence(arg0_78)
	arg0_78:Call("ShowLicence")
end

function var0_0.ShowPrivate(arg0_79)
	arg0_79:Call("ShowPrivate")
end

function var0_0.OpenMiniProgram(arg0_80)
	arg0_80:Call("OpenMiniProgram")
end

function var0_0.GetProduct(arg0_81, arg1_81)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_81:Get("GetProduct", arg1_81)
	end
end

function var0_0.GetDeviceId(arg0_82)
	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		return arg0_82:Get("GetDeviceId")
	elseif PLATFORM_CODE == PLATFORM_KR then
		return arg0_82:Get("GetDeviceModel")
	elseif PLATFORM_CODE == PLATFORM_CHT then
		return SystemInfo.deviceUniqueIdentifier
	else
		return ""
	end
end

function InLoginScene()
	local function var0_83()
		return getProxy(UserProxy):GetLoginedFlag()
	end

	if pg.SdkMgr.GetInstance():IsInLoginScene() and not var0_83() then
		return true
	end

	return false
end

function var0_0.GetPlatformCode(arg0_85, arg1_85)
	if PLATFORM_CODE == PLATFORM_CHT then
		return arg0_85:Get("GetPackageCode", arg1_85)
	else
		return nil
	end
end

function var0_0.IgnorePlatform(arg0_86, arg1_86)
	local var0_86 = arg0_86.pcode

	if var0_86 and arg1_86 and #arg1_86 > 0 and _.any(arg1_86, function(arg0_87)
		return tostring(arg0_87) == var0_86
	end) then
		return true
	end

	return false
end
