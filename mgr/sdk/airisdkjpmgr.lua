local var0_0 = {}
local var1_0 = AiriJPSdkMgr.inst
local var2_0 = AiriJPSdkMgr.AiriSDKInst
local var3_0 = AiriJPSdkMgr.AiriSdkDataInst

AIRI_PLATFORM_FACEBOOK = "facebook"
AIRI_PLATFORM_TWITTER = "twitter"
AIRI_PLATFORM_YOSTAR = "yostar"
AIRI_PLATFORM_APPLE = "apple"
AIRI_PLATFORM_AMAZON = "amazon"
AIRI_PLATFORM_GPS = "gps"
AIRI_SDK_INITED = false
var0_0.OnAiriBuying = -1
var0_0.BuyingLimit = 60
var0_0.isCache = false

function var0_0.CheckAudit()
	return NetConst.GATEWAY_PORT == 20001 and NetConst.GATEWAY_HOST == "blhxjpauditapi.azurlane.jp"
end

function var0_0.CheckPreAudit()
	local var0_2 = NetConst.GATEWAY_PORT == 30001 and NetConst.GATEWAY_HOST == "blhxjpauditapi.azurlane.jp"
	local var1_2 = NetConst.GATEWAY_PORT == 30101 and NetConst.GATEWAY_HOST == "blhxjpauditapi.azurlane.jp"

	return var0_2 or var1_2
end

function var0_0.CheckPretest()
	return IsUnityEditor or var0_0.CheckPreAudit()
end

function var0_0.CheckGoogleSimulator()
	return NetConst.GATEWAY_PORT == 4001 and NetConst.GATEWAY_HOST == "business.azurlane.jp"
end

function var0_0.GoSDkLoginScene()
	var1_0:GoLoginScene()
	var0_0.AiriInit()
end

function var0_0.AiriInit(arg0_6)
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:InitSdk()
	print("CSharpVersion:" .. tostring(CSharpVersion))
end

function var0_0.AiriLogin()
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:Login()
end

function var0_0.LoginWithDevice()
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:LoginWithDevice()
end

function var0_0.LoginWithSocial(arg0_9, arg1_9, arg2_9)
	pg.UIMgr.GetInstance():LoadingOn()

	if arg0_9 == AIRI_PLATFORM_FACEBOOK then
		var1_0:LoginWithFB()
	elseif arg0_9 == AIRI_PLATFORM_TWITTER then
		var1_0:LoginWithTW()
	elseif arg0_9 == AIRI_PLATFORM_YOSTAR then
		var1_0:LoginWithSDKAccount(arg1_9, arg2_9)
	elseif arg0_9 == AIRI_PLATFORM_APPLE then
		var1_0:LoginWithApple()
	elseif arg0_9 == AIRI_PLATFORM_AMAZON then
		var1_0:LoginWithAmazon()
	end
end

function var0_0.LoginWithTranscode(arg0_10, arg1_10)
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:LoginWithTranscode(arg0_10, arg1_10)
end

function var0_0.TranscodeRequest()
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:TranscodeRequest()
end

function var0_0.AiriBuy(arg0_12, arg1_12, arg2_12)
	var0_0.OnAiriBuying = Time.realtimeSinceStartup

	if arg1_12 == "audit" then
		var1_0:NewBuy(arg0_12, Airisdk.BuyServerTag.audit, arg2_12)
	elseif arg1_12 == "preAudit" then
		var1_0:NewBuy(arg0_12, Airisdk.BuyServerTag.preAudit, arg2_12)
	elseif arg1_12 == "production" then
		var1_0:NewBuy(arg0_12, Airisdk.BuyServerTag.production, arg2_12)
	elseif arg1_12 == "test" then
		var1_0:NewBuy(arg0_12, Airisdk.BuyServerTag.test, arg2_12)
	end
end

function var0_0.LinkSocial(arg0_13, arg1_13, arg2_13)
	var0_0.SetAiriTimeout()

	if arg0_13 == AIRI_PLATFORM_FACEBOOK then
		var1_0:LinkSocial(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0_13 == AIRI_PLATFORM_TWITTER then
		var1_0:LinkSocial(Airisdk.LoginPlatform.TWITTER)
	elseif arg0_13 == AIRI_PLATFORM_YOSTAR then
		var1_0:LinkSocial(Airisdk.LoginPlatform.YOSTAR, arg1_13, arg2_13)
	elseif arg0_13 == AIRI_PLATFORM_APPLE then
		var1_0:LinkSocial(Airisdk.LoginPlatform.APPLE)
	elseif arg0_13 == AIRI_PLATFORM_AMAZON then
		var1_0:LinkSocial(Airisdk.LoginPlatform.AMAZON)
	end
end

function var0_0.UnlinkSocial(arg0_14)
	var0_0.SetAiriTimeout()

	if arg0_14 == AIRI_PLATFORM_FACEBOOK then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0_14 == AIRI_PLATFORM_TWITTER then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.TWITTER)
	elseif arg0_14 == AIRI_PLATFORM_APPLE then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.APPLE)
	elseif arg0_14 == AIRI_PLATFORM_AMAZON then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.AMAZON)
	elseif arg0_14 == AIRI_PLATFORM_GPS then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.GOOGLEPLAY)
	end
end

function var0_0.IsSocialLink(arg0_15)
	if not var0_0.GetIsPlatform() then
		return false
	end

	if arg0_15 == AIRI_PLATFORM_FACEBOOK then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0_15 == AIRI_PLATFORM_TWITTER then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.TWITTER)
	elseif arg0_15 == AIRI_PLATFORM_YOSTAR then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.YOSTAR)
	elseif arg0_15 == AIRI_PLATFORM_APPLE then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.APPLE)
	elseif arg0_15 == AIRI_PLATFORM_AMAZON then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.AMAZON)
	elseif arg0_15 == AIRI_PLATFORM_GPS then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.GOOGLEPLAY)
	end

	return false
end

function var0_0.GetSocialName(arg0_16)
	if arg0_16 == AIRI_PLATFORM_FACEBOOK then
		return var1_0.loginRet.FACEBOOK_NAME
	elseif arg0_16 == AIRI_PLATFORM_TWITTER then
		return var1_0.loginRet.TWITTER_NAME
	elseif arg0_16 == AIRI_PLATFORM_YOSTAR then
		return var1_0.loginRet.SDK_NAME
	elseif arg0_16 == AIRI_PLATFORM_APPLE then
		return var1_0.loginRet.APPLE_ID
	elseif arg0_16 == AIRI_PLATFORM_AMAZON then
		return var1_0.loginRet.AMAZON_NAME
	elseif arg0_16 == AIRI_PLATFORM_GPS then
		return var1_0.loginRet.GOOGLE_PLAY_GAME_NAME
	end

	return ""
end

function var0_0.SetBirth(arg0_17)
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:SetBirth(arg0_17)
end

function var0_0.GetIsBirthSet()
	return var1_0:IsBirthSet()
end

function var0_0.ClearAccountCache()
	var1_0:ClearAccountCache()
end

function var0_0.GameShare(arg0_20, arg1_20)
	var1_0:SystemShare(arg0_20, arg1_20)
end

function var0_0.VerificationCodeReq(arg0_21)
	var1_0:VerificationCodeReq(arg0_21)

	AIRI_LAST_GEN_TIME = Time.realtimeSinceStartup
end

function var0_0.OpenYostarHelp()
	var2_0:OpenHelpShift()
end

function var0_0.GetYostarUid()
	return var1_0.loginRet.UID
end

function var0_0.GetDeviceId()
	return var2_0:GetDeviceID()
end

function var0_0.GetLoginType()
	return var1_0.loginType
end

function var0_0.GetIsPlatform()
	return var1_0.isPlatform
end

function var0_0.GetChannelUID()
	local var0_27 = var1_0.channelUID

	originalPrint("channelUID : " .. var0_27)

	return var0_27
end

function var0_0.GetTransCode()
	if IsUnityEditor then
		return "NULL"
	else
		return var1_0.loginRet.MIGRATIONCODE
	end
end

function var0_0.UserEventUpload(arg0_29)
	if var0_0.GetIsPlatform() then
		var1_0:UserEventUpload(arg0_29)
	end
end

function var0_0.ShowSurvey(arg0_30, arg1_30)
	if var0_0.GetIsPlatform() then
		local var0_30 = getProxy(PlayerProxy):getData()

		var2_0:UserEventUpload(arg0_30, tostring(var0_30.id), arg1_30)
	end
end

function var0_0.Survey(arg0_31)
	Application.OpenURL(arg0_31)
end

function var0_0.OnAndoridBackPress()
	PressBack()
end

function var0_0.BindCPU()
	return
end

function var0_0.CheckAiriCanBuy()
	if var0_0.OnAiriBuying == -1 or Time.realtimeSinceStartup - var0_0.OnAiriBuying > var0_0.BuyingLimit then
		return true
	else
		return false
	end
end

function var0_0.CheckHadAccountCache()
	if var0_0.GetIsPlatform() then
		return var1_0:CheckHadAccountCache() or var0_0.isCache
	else
		return true
	end
end

function var0_0.AccountDelete()
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:AccountDeleteReq()
end

function var0_0.AccountReborn()
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:AccountRebornReq()
end

function var0_0.ConfirmLinkGooglePlayGame()
	var1_0:ConfirmLinkGooglePlayGame()
end

function var0_0.ConfirmUnLinkGooglePlayGame()
	var1_0:ConfirmUnLinkGooglePlayGame()
end

function var0_0.BindYostarPass()
	var1_0:BindYostarPassReq()
end

function GoLoginScene()
	print("JP do nothing")
end

function AiriInitResult(arg0_42)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_42.R_CODE) then
		AIRI_SDK_INITED = true

		OnAppPauseForSDK(false)
		AiriGoLogin()
	end
end

function AiriGoLogin(arg0_43)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LOGIN, {
		loginPlatform = arg0_43
	})
	gcAll()
end

function AiriLogin(arg0_44)
	pg.UIMgr.GetInstance():LoadingOff()

	local function var0_44()
		local var0_45 = User.New({
			type = 1,
			arg1 = PLATFORM_AIRIJP,
			arg2 = arg0_44.UID,
			arg3 = arg0_44.ACCESS_TOKEN
		})

		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var0_45
		})
	end

	if var0_0.AiriYoStarPassMigrateHandler(arg0_44) then
		return
	end

	if var0_0.AiriResultCodeHandler(arg0_44.R_CODE) then
		var0_44()

		var0_0.isCache = true
	else
		if var0_0.AiriPGSResultCodeHandler(arg0_44.R_CODE, function()
			var0_44()

			var0_0.isCache = true
		end) then
			return
		end

		if arg0_44.R_CODE:ToInt() == 100233 then
			local var1_44 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_44 = tonumber(string.sub(arg0_44.R_DELETETIME, 1, string.len(arg0_44.R_DELETETIME) - 3))

			if var1_44 < var2_44 then
				local var3_44 = pg.TimeMgr.GetInstance():CTimeDescC(var2_44, "%Y-%m-%d %H:%M:%S")

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					content = i18n("box_account_reborn_content", var3_44),
					weight = LayerWeightConst.TOP_LAYER,
					onYes = function()
						var0_0.AccountReborn()
					end
				})
			end
		else
			originalPrint("AiriLogin failed")
		end
	end
end

function AiriTranscodeResult(arg0_48)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_48.R_CODE) then
		pg.m02:sendNotification(GAME.ON_GET_TRANSCODE, {
			transcode = arg0_48.MIGRATIONCODE
		})
	end
end

function AiriBuyResult(arg0_49)
	var0_0.OnAiriBuying = -1

	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_49.R_CODE) then
		getProxy(ShopsProxy):removeWaitTimer()
		pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
			payId = arg0_49.EXTRADATA,
			bsId = arg0_49.ORDERID
		})
	else
		getProxy(ShopsProxy):removeWaitTimer()
		pg.m02:sendNotification(GAME.CHARGE_FAILED, {
			payId = arg0_49.EXTRADATA
		})
	end
end

function SetBirthResult(arg0_50)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_50.R_CODE) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("set_birth_success"))
	end
end

function LinkSocialResult(arg0_51)
	var0_0.EndAiriTimeout()

	if var0_0.AiriResultCodeHandler(arg0_51.R_CODE) then
		pg.m02:sendNotification(GAME.ON_SOCIAL_LINKED)
	end
end

function UnlinkSocialResult(arg0_52)
	var0_0.EndAiriTimeout()

	if var0_0.AiriResultCodeHandler(arg0_52.R_CODE) then
		pg.m02:sendNotification(GAME.ON_SOCIAL_UNLINKED)
	elseif var0_0.AiriPGSResultCodeHandler(arg0_52.R_CODE) then
		return
	end
end

function VerificationCodeResult(arg0_53)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_53.R_CODE) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("verification_code_req_tip2")
		})
	end
end

function OnAppPauseForSDK(arg0_54)
	if not AIRI_SDK_INITED then
		return
	end

	if arg0_54 then
		var2_0:OnPause()
	else
		var2_0:OnResume()
	end
end

function AccountDeleteResult(arg0_55, arg1_55, arg2_55, arg3_55, arg4_55)
	pg.UIMgr.GetInstance():LoadingOff()

	local var0_55 = {
		ToInt = function()
			return arg0_55
		end
	}

	if var0_0.AiriResultCodeHandler(var0_55) then
		local var1_55 = tonumber(string.sub(arg3_55, 1, string.len(arg3_55) - 3))
		local var2_55 = pg.TimeMgr.GetInstance():CTimeDescC(var1_55, "%Y-%m-%d %H:%M:%S")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = i18n("box_account_del_success_content", var2_55),
			weight = LayerWeightConst.TOP_LAYER,
			onYes = function()
				pg.m02:sendNotification(GAME.LOGOUT, {
					code = 0
				})
			end,
			onClose = function()
				pg.m02:sendNotification(GAME.LOGOUT, {
					code = 0
				})
			end
		})
	end
end

function AccountRebornResult(arg0_59, arg1_59)
	pg.UIMgr.GetInstance():LoadingOff()

	local var0_59 = {
		ToInt = function()
			return arg0_59
		end
	}

	if var0_0.AiriResultCodeHandler(var0_59) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tip_account_del_reborn"))
	end
end

function BindYostarPassResult(arg0_61, arg1_61)
	local var0_61 = {
		ToInt = function()
			return arg0_61
		end
	}

	if var0_0.AiriResultCodeHandler(var0_61) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("new_airi_error_code_0"))
	end
end

function OnYoStarMessageReceivedRespone(arg0_63, arg1_63, arg2_63, arg3_63)
	warning("OnYoStarMessageReceivedRespone")
end

function var0_0.AiriResultCodeHandler(arg0_64)
	local var0_64 = arg0_64:ToInt()
	local var1_64 = ":" .. var0_64

	if var0_64 == 0 then
		return true
	else
		local var2_64 = {
			100233,
			100201,
			100202,
			100203,
			100204,
			100205,
			100206,
			100214
		}

		if table.contains(var2_64, var0_64) then
			return false
		end

		if var0_64 == 100110 then
			var0_0.ClearAccountCache()
		end

		originalPrint("SDK Error Code:" .. var0_64)

		local var3_64 = var2_0:GetSDKRecommendedErrorMsg(var0_64, Airisdk.LanguageType.MSG_JP)

		if var3_64 and string.len(var3_64) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(var3_64)
		else
			local var4_64 = i18n("new_airi_error_code_" .. var0_64)

			if string.find(var4_64, "UndefinedLanguage") then
				pg.TipsMgr.GetInstance():ShowTips(i18n("new_airi_error_code_other") .. var1_64)
			else
				pg.TipsMgr.GetInstance():ShowTips(var4_64 .. var1_64)
			end
		end
	end

	return false
end

function var0_0.AiriPGSResultCodeHandler(arg0_65, arg1_65)
	local var0_65 = arg0_65:ToInt()

	originalPrint("AiriPGSResultCodeHandler", tostring(var0_65))

	if var0_65 == 100201 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist2"),
			onYes = function()
				var0_0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0_65 == 100202 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist1"),
			onYes = function()
				var0_0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0_65 == 100203 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist3"),
			onYes = function()
				var0_0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0_65 == 100204 then
		arg1_65()

		return true
	elseif var0_65 == 100205 then
		return true
	elseif var0_65 == 100206 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("pgs_login_tip"),
			onYes = function()
				pg.m02:sendNotification(GAME.ON_SOCIAL_LINKED)
			end,
			onClose = function()
				pg.m02:sendNotification(GAME.ON_SOCIAL_LINKED)
			end
		})

		return true
	elseif var0_65 == 100214 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_unbind_tip2"),
			onYes = function()
				var0_0.ConfirmUnLinkGooglePlayGame()
			end
		})

		return true
	else
		return false
	end
end

function var0_0.AiriYoStarPassMigrateHandler(arg0_72)
	local var0_72 = {
		0,
		100204,
		100206
	}

	if table.contains(var0_72, arg0_72.R_CODE:ToInt()) and arg0_72.SHOW_MIGRATE_PAGE == 1 then
		var0_0.BindYostarPass()

		return true
	else
		return false
	end
end

var0_0.ON_AIRI_LOADING = false

function var0_0.SetAiriTimeout()
	pg.UIMgr.GetInstance():LoadingOn()

	var0_0.ON_AIRI_LOADING = true

	onDelayTick(function()
		if var0_0.ON_AIRI_LOADING then
			pg.UIMgr.GetInstance():LoadingOff()

			var0_0.ON_AIRI_LOADING = false
		end
	end, 15)
end

function var0_0.EndAiriTimeout()
	var0_0.ON_AIRI_LOADING = false

	pg.UIMgr.GetInstance():LoadingOff()
end

return var0_0
