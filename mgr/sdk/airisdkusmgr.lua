local var0 = {}
local var1 = AiriUSSdkMgr.inst
local var2 = AiriUSSdkMgr.AiriSDKInst
local var3 = AiriUSSdkMgr.AiriSdkDataInst

AIRI_PLATFORM_FACEBOOK = "facebook"
AIRI_PLATFORM_TWITTER = "twitter"
AIRI_PLATFORM_YOSTAR = "yostar"
AIRI_PLATFORM_APPLE = "apple"
AIRI_PLATFORM_AMAZON = "amazon"
AIRI_PLATFORM_GPS = "gps"
AIRI_SDK_INITED = false
var0.OnAiriBuying = -1
var0.BuyingLimit = 60

function var0.CheckAudit()
	return NetConst.GATEWAY_PORT == 20001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
end

function var0.CheckPreAudit()
	return NetConst.GATEWAY_PORT == 30001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
end

function var0.CheckPretest()
	return IsUnityEditor or var0.CheckPreAudit()
end

function var0.CheckGoogleSimulator()
	return NetConst.GATEWAY_PORT == 50001 and NetConst.GATEWAY_HOST == "audit.us.yo-star.com"
end

function var0.GoSDkLoginScene()
	var1:GoLoginScene()
	var0.AiriInit()
end

function var0.AiriInit(arg0)
	pg.UIMgr.GetInstance():LoadingOn()
	var1:InitSdk()
	print("CSharpVersion:" .. tostring(CSharpVersion))
end

function var0.AiriLogin()
	pg.UIMgr.GetInstance():LoadingOn()
	var1:Login()
end

function var0.LoginWithSocial(arg0, arg1, arg2)
	pg.UIMgr.GetInstance():LoadingOn()

	if arg0 == AIRI_PLATFORM_FACEBOOK then
		var1:LoginWithFB()
	elseif arg0 == AIRI_PLATFORM_TWITTER then
		var1:LoginWithTW()
	elseif arg0 == AIRI_PLATFORM_YOSTAR then
		var1:LoginWithSDKAccount(arg1, arg2)
	elseif arg0 == AIRI_PLATFORM_APPLE then
		var1:LoginWithApple()
	elseif arg0 == AIRI_PLATFORM_AMAZON then
		var1:LoginWithAmazon()
	end
end

function var0.LoginWithTranscode(arg0, arg1)
	pg.UIMgr.GetInstance():LoadingOn()
	var1:LoginWithTranscode(arg0, arg1)
end

function var0.TranscodeRequest()
	pg.UIMgr.GetInstance():LoadingOn()
	var1:TranscodeRequest()
end

function var0.AiriBuy(arg0, arg1, arg2)
	var0.OnAiriBuying = Time.realtimeSinceStartup

	if arg1 == "audit" then
		var1:NewBuy(arg0, Airisdk.BuyServerTag.audit, arg2)
	elseif arg1 == "preAudit" then
		var1:NewBuy(arg0, Airisdk.BuyServerTag.preAudit, arg2)
	elseif arg1 == "production" then
		var1:NewBuy(arg0, Airisdk.BuyServerTag.production, arg2)
	elseif arg1 == "test" then
		var1:NewBuy(arg0, Airisdk.BuyServerTag.test, arg2)
	end
end

function var0.LinkSocial(arg0, arg1, arg2)
	var0.SetAiriTimeout()

	if arg0 == AIRI_PLATFORM_FACEBOOK then
		var1:LinkSocial(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0 == AIRI_PLATFORM_TWITTER then
		var1:LinkSocial(Airisdk.LoginPlatform.TWITTER)
	elseif arg0 == AIRI_PLATFORM_YOSTAR then
		var1:LinkSocial(Airisdk.LoginPlatform.YOSTAR, arg1, arg2)
	elseif arg0 == AIRI_PLATFORM_APPLE then
		var1:LinkSocial(Airisdk.LoginPlatform.APPLE)
	elseif arg0 == AIRI_PLATFORM_AMAZON then
		var1:LinkSocial(Airisdk.LoginPlatform.AMAZON)
	end
end

function var0.UnlinkSocial(arg0)
	var0.SetAiriTimeout()

	if arg0 == AIRI_PLATFORM_FACEBOOK then
		var1:UnlinkSocial(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0 == AIRI_PLATFORM_TWITTER then
		var1:UnlinkSocial(Airisdk.LoginPlatform.TWITTER)
	elseif arg0 == AIRI_PLATFORM_APPLE then
		var1:UnlinkSocial(Airisdk.LoginPlatform.APPLE)
	elseif arg0 == AIRI_PLATFORM_AMAZON then
		var1:UnlinkSocial(Airisdk.LoginPlatform.AMAZON)
	elseif arg0 == AIRI_PLATFORM_GPS then
		var1:UnlinkSocial(Airisdk.LoginPlatform.GOOGLEPLAY)
	end
end

function var0.IsSocialLink(arg0)
	if not var0.GetIsPlatform() then
		return false
	end

	if arg0 == AIRI_PLATFORM_FACEBOOK then
		return var1:CheckPlatformLink(Airisdk.LoginPlatform.FACEBOOK)
	elseif arg0 == AIRI_PLATFORM_TWITTER then
		return var1:CheckPlatformLink(Airisdk.LoginPlatform.TWITTER)
	elseif arg0 == AIRI_PLATFORM_YOSTAR then
		return var1:CheckPlatformLink(Airisdk.LoginPlatform.YOSTAR)
	elseif arg0 == AIRI_PLATFORM_APPLE then
		return var1:CheckPlatformLink(Airisdk.LoginPlatform.APPLE)
	elseif arg0 == AIRI_PLATFORM_AMAZON then
		return var1:CheckPlatformLink(Airisdk.LoginPlatform.AMAZON)
	elseif arg0 == AIRI_PLATFORM_GPS then
		return var1:CheckPlatformLink(Airisdk.LoginPlatform.GOOGLEPLAY)
	end

	return false
end

function var0.GetSocialName(arg0)
	if arg0 == AIRI_PLATFORM_FACEBOOK then
		return var1.loginRet.FACEBOOK_NAME
	elseif arg0 == AIRI_PLATFORM_TWITTER then
		return var1.loginRet.TWITTER_NAME
	elseif arg0 == AIRI_PLATFORM_YOSTAR then
		return var1.loginRet.SDK_NAME
	elseif arg0 == AIRI_PLATFORM_APPLE then
		return var1.loginRet.APPLE_ID
	elseif arg0 == AIRI_PLATFORM_AMAZON then
		return var1.loginRet.AMAZON_NAME
	elseif arg0 == AIRI_PLATFORM_GPS then
		return var1.loginRet.GOOGLE_PLAY_GAME_NAME
	end

	return ""
end

function var0.SetBirth(arg0)
	pg.UIMgr.GetInstance():LoadingOn()
	var1:SetBirth(arg0)
end

function var0.GetIsBirthSet()
	return var1:IsBirthSet()
end

function var0.ClearAccountCache()
	var1:ClearAccountCache()
end

function var0.GameShare(arg0, arg1)
	var1:SystemShare(arg0, arg1)
end

function var0.VerificationCodeReq(arg0)
	var1:VerificationCodeReq(arg0)

	AIRI_LAST_GEN_TIME = Time.realtimeSinceStartup
end

function var0.OpenYostarHelp()
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = getProxy(UserProxy):getData()
	local var2 = getProxy(ServerProxy):getLastServer(var1.uid)
	local var3 = pg.TimeMgr.GetInstance():STimeDescS(var0.registerTime, "%Y-%m-%d %H:%M:%S")
	local var4 = math.modf(var0.rmb / 100)

	originalPrint("uid:" .. var0.id .. ",name:" .. var0.name .. ",level" .. var0.level .. ",serverId:" .. var2.id .. " - " .. var2.name .. ",rmb:" .. var4 .. ",createTime:" .. var3)
	var1:OpenHelp(tostring(var0.id), var0.name, tostring(var2.id .. " - " .. var2.name), var4, var3)
end

function var0.GetYostarUid()
	return var1.loginRet.UID
end

function var0.GetDeviceId()
	return var2:GetDeviceID()
end

function var0.GetLoginType()
	return var1.loginType
end

function var0.GetIsPlatform()
	return var1.isPlatform
end

function var0.GetChannelUID()
	local var0 = var1.channelUID

	originalPrint("channelUID : " .. var0)

	return var0
end

function var0.UserEventUpload(arg0)
	if var0.GetIsPlatform() then
		var1:UserEventUpload(arg0)
	end
end

function var0.ShowSurvey(arg0, arg1)
	if var0.GetIsPlatform() then
		local var0 = getProxy(PlayerProxy):getData()

		var2:UserEventUpload(arg0, tostring(var0.id), arg1)
	end
end

function var0.Survey(arg0)
	Application.OpenURL(arg0)
end

function var0.OnAndoridBackPress()
	PressBack()
end

function var0.BindCPU()
	return
end

function var0.CheckAiriCanBuy()
	if var0.OnAiriBuying == -1 or Time.realtimeSinceStartup - var0.OnAiriBuying > var0.BuyingLimit then
		return true
	else
		return false
	end
end

function var0.AccountDelete()
	pg.UIMgr.GetInstance():LoadingOn()
	var1:AccountDeleteReq()
end

function var0.AccountReborn()
	pg.UIMgr.GetInstance():LoadingOn()
	var1:AccountRebornReq()
end

function var0.ConfirmLinkGooglePlayGame()
	var1:ConfirmLinkGooglePlayGame()
end

function var0.ConfirmUnLinkGooglePlayGame()
	var1:ConfirmUnLinkGooglePlayGame()
end

function var0.BindYostarPass()
	var1:BindYostarPassReq()
end

function GoLoginScene()
	print("US do nothing")
end

function AiriInitResult(arg0)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		AIRI_SDK_INITED = true

		OnAppPauseForSDK(false)
		AiriGoLogin()
	end
end

function AiriGoLogin(arg0)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LOGIN, {
		loginPlatform = arg0
	})
	gcAll()
end

function AiriLogin(arg0)
	pg.UIMgr.GetInstance():LoadingOff()

	local function var0()
		local var0 = User.New({
			type = 1,
			arg1 = PLATFORM_AIRIUS,
			arg2 = arg0.UID,
			arg3 = arg0.ACCESS_TOKEN
		})

		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var0
		})
	end

	if var0.AiriYoStarPassMigrateHandler(arg0) then
		return
	end

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		var0()
	else
		if var0.AiriPGSResultCodeHandler(arg0.R_CODE, function()
			var0()
		end) then
			return
		end

		if arg0.R_CODE:ToInt() == 100233 then
			local var1 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2 = tonumber(string.sub(arg0.R_DELETETIME, 1, string.len(arg0.R_DELETETIME) - 3))

			if var1 < var2 then
				local var3 = pg.TimeMgr.GetInstance():CTimeDescC(var2, "%Y-%m-%d %H:%M:%S")

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					content = i18n("box_account_reborn_content", var3),
					weight = LayerWeightConst.TOP_LAYER,
					onYes = function()
						var0.AccountReborn()
					end
				})
			end
		else
			originalPrint("AiriLogin failed")
		end
	end
end

function AiriTranscodeResult(arg0)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		pg.m02:sendNotification(GAME.ON_GET_TRANSCODE, {
			transcode = arg0.MIGRATIONCODE
		})
	end
end

function AiriBuyResult(arg0)
	var0.OnAiriBuying = -1

	pg.UIMgr.GetInstance():LoadingOff()

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		getProxy(ShopsProxy):removeWaitTimer()
		pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
			payId = arg0.EXTRADATA,
			bsId = arg0.ORDERID
		})
	else
		getProxy(ShopsProxy):removeWaitTimer()
		pg.m02:sendNotification(GAME.CHARGE_FAILED, {
			payId = arg0.EXTRADATA
		})
	end
end

function SetBirthResult(arg0)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("set_birth_success"))
	end
end

function LinkSocialResult(arg0)
	var0.EndAiriTimeout()

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		pg.m02:sendNotification(GAME.ON_SOCIAL_LINKED)
	end
end

function UnlinkSocialResult(arg0)
	var0.EndAiriTimeout()

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		pg.m02:sendNotification(GAME.ON_SOCIAL_UNLINKED)
	elseif var0.AiriPGSResultCodeHandler(arg0.R_CODE) then
		return
	end
end

function VerificationCodeResult(arg0)
	pg.UIMgr.GetInstance():LoadingOff()

	if var0.AiriResultCodeHandler(arg0.R_CODE) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("verification_code_req_tip2")
		})
	end
end

function OnAppPauseForSDK(arg0)
	if not AIRI_SDK_INITED then
		return
	end

	if arg0 then
		var2:OnPause()
	else
		var2:OnResume()
	end
end

function AccountDeleteResult(arg0, arg1, arg2, arg3, arg4)
	pg.UIMgr.GetInstance():LoadingOff()

	local var0 = {
		ToInt = function()
			return arg0
		end
	}

	if var0.AiriResultCodeHandler(var0) then
		local var1 = tonumber(string.sub(arg3, 1, string.len(arg3) - 3))
		local var2 = pg.TimeMgr.GetInstance():CTimeDescC(var1, "%Y-%m-%d %H:%M:%S")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = i18n("box_account_del_success_content", var2),
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

function AccountRebornResult(arg0, arg1)
	pg.UIMgr.GetInstance():LoadingOff()

	local var0 = {
		ToInt = function()
			return arg0
		end
	}

	if var0.AiriResultCodeHandler(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tip_account_del_reborn"))
	end
end

function BindYostarPassResult(arg0, arg1)
	local var0 = {
		ToInt = function()
			return arg0
		end
	}

	if var0.AiriResultCodeHandler(var0) then
		pg.TipsMgr.GetInstance():ShowTips("Bind Success.")
	end
end

function OnYoStarMessageReceivedRespone(arg0, arg1, arg2, arg3)
	warning("OnYoStarMessageReceivedRespone")
end

function var0.AiriResultCodeHandler(arg0)
	local var0 = arg0:ToInt()
	local var1 = ":" .. var0

	if var0 == 0 then
		return true
	else
		local var2 = {
			100233,
			100201,
			100202,
			100203,
			100204,
			100205,
			100206,
			100214
		}

		if table.contains(var2, var0) then
			return false
		end

		if var0 == 100110 then
			var0.ClearAccountCache()
		end

		originalPrint("SDK Error Code:" .. var0)

		local var3 = i18n("new_airi_error_code_" .. var0)

		if string.find(var3, "UndefinedLanguage") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("new_airi_error_code_other") .. var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3 .. var1)
		end
	end

	return false
end

function var0.AiriPGSResultCodeHandler(arg0, arg1)
	local var0 = arg0:ToInt()

	originalPrint("AiriPGSResultCodeHandler", tostring(var0))

	if var0 == 100201 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist2"),
			onYes = function()
				var0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0 == 100202 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist1"),
			onYes = function()
				var0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0 == 100203 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_login_binding_exist3"),
			onYes = function()
				var0.ConfirmLinkGooglePlayGame()
			end
		})

		return true
	elseif var0 == 100204 then
		arg1()

		return true
	elseif var0 == 100205 then
		return true
	elseif var0 == 100206 then
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
	elseif var0 == 100214 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_unbind_tip2"),
			onYes = function()
				var0.ConfirmUnLinkGooglePlayGame()
			end
		})

		return true
	else
		return false
	end
end

function var0.AiriYoStarPassMigrateHandler(arg0)
	local var0 = {
		0,
		100204,
		100206
	}

	if table.contains(var0, arg0.R_CODE:ToInt()) and arg0.SHOW_MIGRATE_PAGE == 1 then
		var0.BindYostarPass()

		return true
	else
		return false
	end
end

var0.ON_AIRI_LOADING = false

function var0.SetAiriTimeout()
	pg.UIMgr.GetInstance():LoadingOn()

	var0.ON_AIRI_LOADING = true

	onDelayTick(function()
		if var0.ON_AIRI_LOADING then
			pg.UIMgr.GetInstance():LoadingOff()

			var0.ON_AIRI_LOADING = false
		end
	end, 15)
end

function var0.EndAiriTimeout()
	var0.ON_AIRI_LOADING = false

	pg.UIMgr.GetInstance():LoadingOff()
end

return var0
