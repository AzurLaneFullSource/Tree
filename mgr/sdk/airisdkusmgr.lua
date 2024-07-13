local var0_0 = {}
local var1_0 = AiriUSSdkMgr.inst
local var2_0 = AiriUSSdkMgr.AiriSDKInst
local var3_0 = AiriUSSdkMgr.AiriSdkDataInst

AIRI_PLATFORM_FACEBOOK = "facebook"
AIRI_PLATFORM_TWITTER = "twitter"
AIRI_PLATFORM_YOSTAR = "yostar"
AIRI_PLATFORM_APPLE = "apple"
AIRI_PLATFORM_AMAZON = "amazon"
AIRI_PLATFORM_GPS = "gps"
AIRI_SDK_INITED = false
var0_0.OnAiriBuying = -1
var0_0.BuyingLimit = 60

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

function var0_0.LoginWithSocial(arg0_8, arg1_8, arg2_8)
	pg.UIMgr.GetInstance():LoadingOn()

	if arg0_8 == AIRI_PLATFORM_FACEBOOK then
		var1_0:LoginWithFB()
	elseif arg0_8 == AIRI_PLATFORM_TWITTER then
		var1_0:LoginWithTW()
	elseif arg0_8 == AIRI_PLATFORM_YOSTAR then
		var1_0:LoginWithSDKAccount(arg1_8, arg2_8)
	elseif arg0_8 == AIRI_PLATFORM_APPLE then
		var1_0:LoginWithApple()
	elseif arg0_8 == AIRI_PLATFORM_AMAZON then
		var1_0:LoginWithAmazon()
	end
end

function var0_0.LoginWithTranscode(arg0_9, arg1_9)
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:LoginWithTranscode(arg0_9, arg1_9)
end

function var0_0.TranscodeRequest()
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:TranscodeRequest()
end

function var0_0.AiriBuy(arg0_11, arg1_11, arg2_11)
	var0_0.OnAiriBuying = Time.realtimeSinceStartup

	if arg1_11 == "audit" then
		var1_0:NewBuy(arg0_11, Airisdk.BuyServerTag.audit, arg2_11)
	elseif arg1_11 == "preAudit" then
		var1_0:NewBuy(arg0_11, Airisdk.BuyServerTag.preAudit, arg2_11)
	elseif arg1_11 == "production" then
		var1_0:NewBuy(arg0_11, Airisdk.BuyServerTag.production, arg2_11)
	elseif arg1_11 == "test" then
		var1_0:NewBuy(arg0_11, Airisdk.BuyServerTag.test, arg2_11)
	end
end

function var0_0.LinkSocial(arg0_12, arg1_12, arg2_12)
	var0_0.SetAiriTimeout()

	if arg0_12 == AIRI_PLATFORM_FACEBOOK then
		var1_0:LinkSocial(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0_12 == AIRI_PLATFORM_TWITTER then
		var1_0:LinkSocial(Airisdk.LoginPlatform.TWITTER)
	elseif arg0_12 == AIRI_PLATFORM_YOSTAR then
		var1_0:LinkSocial(Airisdk.LoginPlatform.YOSTAR, arg1_12, arg2_12)
	elseif arg0_12 == AIRI_PLATFORM_APPLE then
		var1_0:LinkSocial(Airisdk.LoginPlatform.APPLE)
	elseif arg0_12 == AIRI_PLATFORM_AMAZON then
		var1_0:LinkSocial(Airisdk.LoginPlatform.AMAZON)
	end
end

function var0_0.UnlinkSocial(arg0_13)
	var0_0.SetAiriTimeout()

	if arg0_13 == AIRI_PLATFORM_FACEBOOK then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0_13 == AIRI_PLATFORM_TWITTER then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.TWITTER)
	elseif arg0_13 == AIRI_PLATFORM_APPLE then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.APPLE)
	elseif arg0_13 == AIRI_PLATFORM_AMAZON then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.AMAZON)
	elseif arg0_13 == AIRI_PLATFORM_GPS then
		var1_0:UnlinkSocial(Airisdk.LoginPlatform.GOOGLEPLAY)
	end
end

function var0_0.IsSocialLink(arg0_14)
	if not var0_0.GetIsPlatform() then
		return false
	end

	if arg0_14 == AIRI_PLATFORM_FACEBOOK then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0_14 == AIRI_PLATFORM_TWITTER then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.TWITTER)
	elseif arg0_14 == AIRI_PLATFORM_YOSTAR then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.YOSTAR)
	elseif arg0_14 == AIRI_PLATFORM_APPLE then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.APPLE)
	elseif arg0_14 == AIRI_PLATFORM_AMAZON then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.AMAZON)
	elseif arg0_14 == AIRI_PLATFORM_GPS then
		return var1_0:CheckPlatformLink(Airisdk.LoginPlatform.GOOGLEPLAY)
	end

	return false
end

function var0_0.GetSocialName(arg0_15)
	if arg0_15 == AIRI_PLATFORM_FACEBOOK then
		return var1_0.loginRet.FACEBOOK_NAME
	elseif arg0_15 == AIRI_PLATFORM_TWITTER then
		return var1_0.loginRet.TWITTER_NAME
	elseif arg0_15 == AIRI_PLATFORM_YOSTAR then
		return var1_0.loginRet.SDK_NAME
	elseif arg0_15 == AIRI_PLATFORM_APPLE then
		return var1_0.loginRet.APPLE_ID
	elseif arg0_15 == AIRI_PLATFORM_AMAZON then
		return var1_0.loginRet.AMAZON_NAME
	elseif arg0_15 == AIRI_PLATFORM_GPS then
		return var1_0.loginRet.GOOGLE_PLAY_GAME_NAME
	end

	return ""
end

function var0_0.SetBirth(arg0_16)
	pg.UIMgr.GetInstance():LoadingOn()
	var1_0:SetBirth(arg0_16)
end

function var0_0.GetIsBirthSet()
	return var1_0:IsBirthSet()
end

function var0_0.ClearAccountCache()
	var1_0:ClearAccountCache()
end

function var0_0.GameShare(arg0_19, arg1_19)
	var1_0:SystemShare(arg0_19, arg1_19)
end

function var0_0.VerificationCodeReq(arg0_20)
	var1_0:VerificationCodeReq(arg0_20)

	AIRI_LAST_GEN_TIME = Time.realtimeSinceStartup
end

function var0_0.OpenYostarHelp()
	local var0_21 = getProxy(PlayerProxy):getData()
	local var1_21 = getProxy(UserProxy):getData()
	local var2_21 = getProxy(ServerProxy):getLastServer(var1_21.uid)
	local var3_21 = pg.TimeMgr.GetInstance():STimeDescS(var0_21.registerTime, "%Y-%m-%d %H:%M:%S")
	local var4_21 = math.modf(var0_21.rmb / 100)

	originalPrint("uid:" .. var0_21.id .. ",name:" .. var0_21.name .. ",level" .. var0_21.level .. ",serverId:" .. var2_21.id .. " - " .. var2_21.name .. ",rmb:" .. var4_21 .. ",createTime:" .. var3_21)
	var1_0:OpenHelp(tostring(var0_21.id), var0_21.name, tostring(var2_21.id .. " - " .. var2_21.name), var4_21, var3_21)
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
	local var0_26 = var1_0.channelUID

	originalPrint("channelUID : " .. var0_26)

	return var0_26
end

function var0_0.UserEventUpload(arg0_27)
	if var0_0.GetIsPlatform() then
		var1_0:UserEventUpload(arg0_27)
	end
end

function var0_0.ShowSurvey(arg0_28, arg1_28)
	if var0_0.GetIsPlatform() then
		local var0_28 = getProxy(PlayerProxy):getData()

		var2_0:UserEventUpload(arg0_28, tostring(var0_28.id), arg1_28)
	end
end

function var0_0.Survey(arg0_29)
	Application.OpenURL(arg0_29)
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
	print("US do nothing")
end

function AiriInitResult(arg0_39)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_39.R_CODE) then
		AIRI_SDK_INITED = true

		OnAppPauseForSDK(false)
		AiriGoLogin()
	end
end

function AiriGoLogin(arg0_40)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LOGIN, {
		loginPlatform = arg0_40
	})
	gcAll()
end

function AiriLogin(arg0_41)
	pg.UIMgr.GetInstance():LoadingOff()

	local function var0_41()
		local var0_42 = User.New({
			type = 1,
			arg1 = PLATFORM_AIRIUS,
			arg2 = arg0_41.UID,
			arg3 = arg0_41.ACCESS_TOKEN
		})

		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var0_42
		})
	end

	if var0_0.AiriYoStarPassMigrateHandler(arg0_41) then
		return
	end

	if var0_0.AiriResultCodeHandler(arg0_41.R_CODE) then
		var0_41()
	else
		if var0_0.AiriPGSResultCodeHandler(arg0_41.R_CODE, function()
			var0_41()
		end) then
			return
		end

		if arg0_41.R_CODE:ToInt() == 100233 then
			local var1_41 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_41 = tonumber(string.sub(arg0_41.R_DELETETIME, 1, string.len(arg0_41.R_DELETETIME) - 3))

			if var1_41 < var2_41 then
				local var3_41 = pg.TimeMgr.GetInstance():CTimeDescC(var2_41, "%Y-%m-%d %H:%M:%S")

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					content = i18n("box_account_reborn_content", var3_41),
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

function AiriTranscodeResult(arg0_45)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_45.R_CODE) then
		pg.m02:sendNotification(GAME.ON_GET_TRANSCODE, {
			transcode = arg0_45.MIGRATIONCODE
		})
	end
end

function AiriBuyResult(arg0_46)
	var0_0.OnAiriBuying = -1

	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_46.R_CODE) then
		getProxy(ShopsProxy):removeWaitTimer()
		pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
			payId = arg0_46.EXTRADATA,
			bsId = arg0_46.ORDERID
		})
	else
		getProxy(ShopsProxy):removeWaitTimer()
		pg.m02:sendNotification(GAME.CHARGE_FAILED, {
			payId = arg0_46.EXTRADATA
		})
	end
end

function SetBirthResult(arg0_47)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_47.R_CODE) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("set_birth_success"))
	end
end

function LinkSocialResult(arg0_48)
	var0_0.EndAiriTimeout()

	if var0_0.AiriResultCodeHandler(arg0_48.R_CODE) then
		pg.m02:sendNotification(GAME.ON_SOCIAL_LINKED)
	end
end

function UnlinkSocialResult(arg0_49)
	var0_0.EndAiriTimeout()

	if var0_0.AiriResultCodeHandler(arg0_49.R_CODE) then
		pg.m02:sendNotification(GAME.ON_SOCIAL_UNLINKED)
	elseif var0_0.AiriPGSResultCodeHandler(arg0_49.R_CODE) then
		return
	end
end

function VerificationCodeResult(arg0_50)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0_0.AiriResultCodeHandler(arg0_50.R_CODE) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("verification_code_req_tip2")
		})
	end
end

function OnAppPauseForSDK(arg0_51)
	if not AIRI_SDK_INITED then
		return
	end

	if arg0_51 then
		var2_0:OnPause()
	else
		var2_0:OnResume()
	end
end

function AccountDeleteResult(arg0_52, arg1_52, arg2_52, arg3_52, arg4_52)
	pg.UIMgr.GetInstance():LoadingOff()

	local var0_52 = {
		ToInt = function()
			return arg0_52
		end
	}

	if var0_0.AiriResultCodeHandler(var0_52) then
		local var1_52 = tonumber(string.sub(arg3_52, 1, string.len(arg3_52) - 3))
		local var2_52 = pg.TimeMgr.GetInstance():CTimeDescC(var1_52, "%Y-%m-%d %H:%M:%S")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = i18n("box_account_del_success_content", var2_52),
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

function AccountRebornResult(arg0_56, arg1_56)
	pg.UIMgr.GetInstance():LoadingOff()

	local var0_56 = {
		ToInt = function()
			return arg0_56
		end
	}

	if var0_0.AiriResultCodeHandler(var0_56) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tip_account_del_reborn"))
	end
end

function BindYostarPassResult(arg0_58, arg1_58)
	local var0_58 = {
		ToInt = function()
			return arg0_58
		end
	}

	if var0_0.AiriResultCodeHandler(var0_58) then
		pg.TipsMgr.GetInstance():ShowTips("Bind Success.")
	end
end

function OnYoStarMessageReceivedRespone(arg0_60, arg1_60, arg2_60, arg3_60)
	warning("OnYoStarMessageReceivedRespone")
end

function var0_0.AiriResultCodeHandler(arg0_61)
	local var0_61 = arg0_61:ToInt()
	local var1_61 = ":" .. var0_61

	if var0_61 == 0 then
		return true
	else
		local var2_61 = {
			100233,
			100201,
			100202,
			100203,
			100204,
			100205,
			100206,
			100214
		}

		if table.contains(var2_61, var0_61) then
			return false
		end

		if var0_61 == 100110 then
			var0_0.ClearAccountCache()
		end

		originalPrint("SDK Error Code:" .. var0_61)

		local var3_61 = i18n("new_airi_error_code_" .. var0_61)

		if string.find(var3_61, "UndefinedLanguage") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("new_airi_error_code_other") .. var1_61)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_61 .. var1_61)
		end
	end

	return false
end

function var0_0.AiriPGSResultCodeHandler(arg0_62, arg1_62)
	local var0_62 = arg0_62:ToInt()

	originalPrint("AiriPGSResultCodeHandler", tostring(var0_62))

	if var0_62 == 100201 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist2"),
			onYes = function()
				var0_0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0_62 == 100202 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist1"),
			onYes = function()
				var0_0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0_62 == 100203 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist3"),
			onYes = function()
				var0_0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0_62 == 100204 then
		arg1_62()

		return true
	elseif var0_62 == 100205 then
		return true
	elseif var0_62 == 100206 then
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
	elseif var0_62 == 100214 then
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

function var0_0.AiriYoStarPassMigrateHandler(arg0_69)
	local var0_69 = {
		0,
		100204,
		100206
	}

	if table.contains(var0_69, arg0_69.R_CODE:ToInt()) and arg0_69.SHOW_MIGRATE_PAGE == 1 then
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
