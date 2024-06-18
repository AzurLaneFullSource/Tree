local var0_0 = class("AiriLoginPanelView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "AiriLoginPanelView"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.OnInit(arg0_4)
	arg0_4.airijpPanel = arg0_4._tf
	arg0_4.airiLoginBtn = arg0_4:findTF("airi_login", arg0_4.airijpPanel)
	arg0_4.clearTranscodeBtn = arg0_4:findTF("clear_transcode", arg0_4.airijpPanel)
	arg0_4.jpLoginCon = arg0_4:findTF("jp_login_btns", arg0_4.airijpPanel)
	arg0_4.appleLoginBtn = arg0_4:findTF("apple_login", arg0_4.jpLoginCon)
	arg0_4.amazonLoginBtn = arg0_4:findTF("amazon_login", arg0_4.jpLoginCon)
	arg0_4.twitterLoginBtn = arg0_4:findTF("twitter_login", arg0_4.jpLoginCon)
	arg0_4.transcodeLoginBtn = arg0_4:findTF("transcode_login", arg0_4.jpLoginCon)
	arg0_4.touristLoginBtn = arg0_4:findTF("tourist_login", arg0_4.jpLoginCon)
	arg0_4.yostarLoginBtn = arg0_4:findTF("yostar_login", arg0_4.jpLoginCon)
	arg0_4.firstAlertWin = arg0_4:findTF("empty_alert", arg0_4.airijpPanel)
	arg0_4.appleToggleTf = arg0_4:findTF("window/content_bg/apple_toggle", arg0_4.firstAlertWin)
	arg0_4.amazonToggleTf = arg0_4:findTF("window/content_bg/amazon_toggle", arg0_4.firstAlertWin)
	arg0_4.twitterToggleTf = arg0_4:findTF("window/content_bg/twitter_toggle", arg0_4.firstAlertWin)
	arg0_4.transcodeToggleTf = arg0_4:findTF("window/content_bg/transcode_toggle", arg0_4.firstAlertWin)
	arg0_4.touristToggleTf = arg0_4:findTF("window/content_bg/tourist_toggle", arg0_4.firstAlertWin)
	arg0_4.yostarToggleTf = arg0_4:findTF("window/content_bg/yostar_toggle", arg0_4.firstAlertWin)
	arg0_4.alertCloseBtn = arg0_4:findTF("window/top/btnBack", arg0_4.firstAlertWin)
	arg0_4.alertCancelBtn = arg0_4:findTF("window/button_container/custom_button_2", arg0_4.firstAlertWin)
	arg0_4.alertSureBtn = arg0_4:findTF("window/button_container/custom_button_1", arg0_4.firstAlertWin)
	arg0_4.enLoginCon = arg0_4:findTF("en_login_btns", arg0_4.airijpPanel)
	arg0_4.twitterLoginBtn_en = arg0_4:findTF("twitter_login_en", arg0_4.enLoginCon)
	arg0_4.facebookLoginBtn_en = arg0_4:findTF("facebook_login_en", arg0_4.enLoginCon)
	arg0_4.yostarLoginBtn_en = arg0_4:findTF("yostar_login_en", arg0_4.enLoginCon)
	arg0_4.appleLoginBtn_en = arg0_4:findTF("apple_login_en", arg0_4.enLoginCon)
	arg0_4.amazonLoginBtn_en = arg0_4:findTF("amazon_login_en", arg0_4.enLoginCon)

	setActive(arg0_4.clearTranscodeBtn, not LOCK_CLEAR_ACCOUNT)
	setActive(arg0_4.twitterLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0_4.transcodeLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0_4.touristLoginBtn, false)
	setActive(arg0_4.yostarLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0_4.appleLoginBtn, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "1")
	setActive(arg0_4.appleToggleTf, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "1")
	setActive(arg0_4.amazonLoginBtn, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "3")
	setActive(arg0_4.amazonToggleTf, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_4.firstAlertWin, false)
	end

	setActive(arg0_4.twitterLoginBtn_en, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0_4.facebookLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3")
	setActive(arg0_4.yostarLoginBtn_en, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0_4.appleLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "1")
	setActive(arg0_4.amazonLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "3")
	arg0_4:InitEvent()
end

function var0_0.InitEvent(arg0_5)
	local function var0_5()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_5.firstAlertWin, arg0_5.airijpPanel)
		setActive(arg0_5.firstAlertWin, false)
	end

	local function var1_5()
		if not pg.SdkMgr.GetInstance():CheckHadAccountCache() then
			setActive(arg0_5.firstAlertWin, true)
			pg.UIMgr.GetInstance():BlurPanel(arg0_5.firstAlertWin)

			return true
		end

		return false
	end

	onButton(arg0_5, arg0_5.airiLoginBtn, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)

		if getProxy(SettingsProxy):CheckNeedUserAgreement() then
			arg0_5.event:emit(LoginMediator.ON_LOGIN_PROCESS)
		elseif not var1_5() then
			pg.SdkMgr.GetInstance():AiriLoginSDK()
		end
	end)
	onButton(arg0_5, arg0_5.clearTranscodeBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("clear_transcode_cache_confirm"),
			onYes = function()
				ClearAccountCache()

				local var0_10 = getProxy(SettingsProxy)

				var0_10:deleteUserAreement()
				var0_10:clearAllReadHelp()
				arg0_5.event:emit(LoginMediator.ON_LOGIN_PROCESS)
				pg.TipsMgr.GetInstance():ShowTips(i18n("clear_transcode_cache_success"))
			end,
			onNo = function()
				return
			end
		})
	end)
	onButton(arg0_5, arg0_5.appleLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0_5, arg0_5.amazonLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0_5, arg0_5.twitterLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0_5, arg0_5.yostarLoginBtn, function()
		arg0_5:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW,
			LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN
		})
	end)
	onButton(arg0_5, arg0_5.transcodeLoginBtn, function()
		arg0_5:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.TRANSCODE_ALERT_VIEW,
			LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN
		})
	end)
	onButton(arg0_5, arg0_5.touristLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginWithDevice()
	end)
	onButton(arg0_5, arg0_5.twitterLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0_5, arg0_5.facebookLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(arg0_5, arg0_5.yostarLoginBtn_en, function()
		arg0_5:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW,
			LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN
		})
	end)
	onButton(arg0_5, arg0_5.appleLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0_5, arg0_5.amazonLoginBtn_en, function()
		pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_AMAZON)
	end)
	var1_5()
	onButton(arg0_5, arg0_5.alertCloseBtn, function()
		var0_5()
	end)
	onButton(arg0_5, arg0_5.alertCancelBtn, function()
		var0_5()
	end)
	onButton(arg0_5, arg0_5.alertSureBtn, function()
		local var0_25 = getToggleState(arg0_5.twitterToggleTf)
		local var1_25 = getToggleState(arg0_5.transcodeToggleTf)
		local var2_25 = getToggleState(arg0_5.touristToggleTf)
		local var3_25 = getToggleState(arg0_5.appleToggleTf)
		local var4_25 = getToggleState(arg0_5.amazonToggleTf)
		local var5_25 = getToggleState(arg0_5.yostarToggleTf)

		if var0_25 then
			pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_TWITTER)
		elseif var1_25 then
			arg0_5:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
				LoginSceneConst.DEFINE.TRANSCODE_ALERT_VIEW,
				LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
				LoginSceneConst.DEFINE.PRESS_TO_LOGIN
			})
		elseif var2_25 then
			pg.SdkMgr.GetInstance():LoginWithDevice()
		elseif var3_25 then
			pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_APPLE)
		elseif var4_25 then
			pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_AMAZON)
		elseif var5_25 then
			arg0_5:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
				LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW,
				LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
				LoginSceneConst.DEFINE.PRESS_TO_LOGIN
			})
		end

		var0_5()
	end)

	if PLATFORM_CODE == PLATFORM_JP then
		local var2_5 = pg.SdkMgr.GetInstance():GetChannelUID() == "3" and arg0_5.amazonToggleTf or arg0_5.twitterToggleTf

		triggerToggle(var2_5, true)
	end
end

function var0_0.OnDestroy(arg0_26)
	return
end

return var0_0
