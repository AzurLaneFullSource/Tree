local var0 = class("AiriLoginPanelView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "AiriLoginPanelView"
end

function var0.OnLoaded(arg0)
	return
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.OnInit(arg0)
	arg0.airijpPanel = arg0._tf
	arg0.airiLoginBtn = arg0:findTF("airi_login", arg0.airijpPanel)
	arg0.clearTranscodeBtn = arg0:findTF("clear_transcode", arg0.airijpPanel)
	arg0.jpLoginCon = arg0:findTF("jp_login_btns", arg0.airijpPanel)
	arg0.appleLoginBtn = arg0:findTF("apple_login", arg0.jpLoginCon)
	arg0.amazonLoginBtn = arg0:findTF("amazon_login", arg0.jpLoginCon)
	arg0.twitterLoginBtn = arg0:findTF("twitter_login", arg0.jpLoginCon)
	arg0.transcodeLoginBtn = arg0:findTF("transcode_login", arg0.jpLoginCon)
	arg0.touristLoginBtn = arg0:findTF("tourist_login", arg0.jpLoginCon)
	arg0.yostarLoginBtn = arg0:findTF("yostar_login", arg0.jpLoginCon)
	arg0.firstAlertWin = arg0:findTF("empty_alert", arg0.airijpPanel)
	arg0.appleToggleTf = arg0:findTF("window/content_bg/apple_toggle", arg0.firstAlertWin)
	arg0.amazonToggleTf = arg0:findTF("window/content_bg/amazon_toggle", arg0.firstAlertWin)
	arg0.twitterToggleTf = arg0:findTF("window/content_bg/twitter_toggle", arg0.firstAlertWin)
	arg0.transcodeToggleTf = arg0:findTF("window/content_bg/transcode_toggle", arg0.firstAlertWin)
	arg0.touristToggleTf = arg0:findTF("window/content_bg/tourist_toggle", arg0.firstAlertWin)
	arg0.yostarToggleTf = arg0:findTF("window/content_bg/yostar_toggle", arg0.firstAlertWin)
	arg0.alertCloseBtn = arg0:findTF("window/top/btnBack", arg0.firstAlertWin)
	arg0.alertCancelBtn = arg0:findTF("window/button_container/custom_button_2", arg0.firstAlertWin)
	arg0.alertSureBtn = arg0:findTF("window/button_container/custom_button_1", arg0.firstAlertWin)
	arg0.enLoginCon = arg0:findTF("en_login_btns", arg0.airijpPanel)
	arg0.twitterLoginBtn_en = arg0:findTF("twitter_login_en", arg0.enLoginCon)
	arg0.facebookLoginBtn_en = arg0:findTF("facebook_login_en", arg0.enLoginCon)
	arg0.yostarLoginBtn_en = arg0:findTF("yostar_login_en", arg0.enLoginCon)
	arg0.appleLoginBtn_en = arg0:findTF("apple_login_en", arg0.enLoginCon)
	arg0.amazonLoginBtn_en = arg0:findTF("amazon_login_en", arg0.enLoginCon)

	setActive(arg0.clearTranscodeBtn, not LOCK_CLEAR_ACCOUNT)
	setActive(arg0.twitterLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0.transcodeLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0.touristLoginBtn, false)
	setActive(arg0.yostarLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0.appleLoginBtn, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "1")
	setActive(arg0.appleToggleTf, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "1")
	setActive(arg0.amazonLoginBtn, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "3")
	setActive(arg0.amazonToggleTf, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0.firstAlertWin, false)
	end

	setActive(arg0.twitterLoginBtn_en, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0.facebookLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3")
	setActive(arg0.yostarLoginBtn_en, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0.appleLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "1")
	setActive(arg0.amazonLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "3")
	arg0:InitEvent()
end

function var0.InitEvent(arg0)
	local function var0()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.firstAlertWin, arg0.airijpPanel)
		setActive(arg0.firstAlertWin, false)
	end

	local function var1()
		if not pg.SdkMgr.GetInstance():CheckHadAccountCache() then
			setActive(arg0.firstAlertWin, true)
			pg.UIMgr.GetInstance():BlurPanel(arg0.firstAlertWin)

			return true
		end

		return false
	end

	onButton(arg0, arg0.airiLoginBtn, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)

		if getProxy(SettingsProxy):CheckNeedUserAgreement() then
			arg0.event:emit(LoginMediator.ON_LOGIN_PROCESS)
		elseif not var1() then
			pg.SdkMgr.GetInstance():AiriLoginSDK()
		end
	end)
	onButton(arg0, arg0.clearTranscodeBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("clear_transcode_cache_confirm"),
			onYes = function()
				ClearAccountCache()

				local var0 = getProxy(SettingsProxy)

				var0:deleteUserAreement()
				var0:clearAllReadHelp()
				arg0.event:emit(LoginMediator.ON_LOGIN_PROCESS)
				pg.TipsMgr.GetInstance():ShowTips(i18n("clear_transcode_cache_success"))
			end,
			onNo = function()
				return
			end
		})
	end)
	onButton(arg0, arg0.appleLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0, arg0.amazonLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0, arg0.twitterLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0, arg0.yostarLoginBtn, function()
		arg0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW,
			LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN
		})
	end)
	onButton(arg0, arg0.transcodeLoginBtn, function()
		arg0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.TRANSCODE_ALERT_VIEW,
			LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN
		})
	end)
	onButton(arg0, arg0.touristLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithDevice()
	end)
	onButton(arg0, arg0.twitterLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0, arg0.facebookLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(arg0, arg0.yostarLoginBtn_en, function()
		arg0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW,
			LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN
		})
	end)
	onButton(arg0, arg0.appleLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0, arg0.amazonLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_AMAZON)
	end)
	var1()
	onButton(arg0, arg0.alertCloseBtn, function()
		var0()
	end)
	onButton(arg0, arg0.alertCancelBtn, function()
		var0()
	end)
	onButton(arg0, arg0.alertSureBtn, function()
		local var0 = getToggleState(arg0.twitterToggleTf)
		local var1 = getToggleState(arg0.transcodeToggleTf)
		local var2 = getToggleState(arg0.touristToggleTf)
		local var3 = getToggleState(arg0.appleToggleTf)
		local var4 = getToggleState(arg0.amazonToggleTf)
		local var5 = getToggleState(arg0.yostarToggleTf)

		if var0 then
			pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_TWITTER)
		elseif var1 then
			arg0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
				LoginSceneConst.DEFINE.TRANSCODE_ALERT_VIEW,
				LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
				LoginSceneConst.DEFINE.PRESS_TO_LOGIN
			})
		elseif var2 then
			pg.SdkMgr.GetInstance():LoginWithDevice()
		elseif var3 then
			pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_APPLE)
		elseif var4 then
			pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_AMAZON)
		elseif var5 then
			arg0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
				LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW,
				LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
				LoginSceneConst.DEFINE.PRESS_TO_LOGIN
			})
		end

		var0()
	end)

	if PLATFORM_CODE == PLATFORM_JP then
		local var2 = pg.SdkMgr.GetInstance():GetChannelUID() == "3" and arg0.amazonToggleTf or arg0.twitterToggleTf

		triggerToggle(var2, true)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
