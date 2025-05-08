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
	arg0_4.jpYoStarLoginBtn = arg0_4:findTF("yostar_login", arg0_4.jpLoginCon)
	arg0_4.jpTransBtn = arg0_4:findTF("yostar_trans", arg0_4.jpLoginCon)
	arg0_4.enLoginCon = arg0_4:findTF("en_login_btns", arg0_4.airijpPanel)
	arg0_4.twitterLoginBtn_en = arg0_4:findTF("twitter_login_en", arg0_4.enLoginCon)
	arg0_4.facebookLoginBtn_en = arg0_4:findTF("facebook_login_en", arg0_4.enLoginCon)
	arg0_4.yostarLoginBtn_en = arg0_4:findTF("yostar_login_en", arg0_4.enLoginCon)
	arg0_4.appleLoginBtn_en = arg0_4:findTF("apple_login_en", arg0_4.enLoginCon)
	arg0_4.amazonLoginBtn_en = arg0_4:findTF("amazon_login_en", arg0_4.enLoginCon)

	setActive(arg0_4.clearTranscodeBtn, false)
	setText(arg0_4:findTF("Text", arg0_4.jpYoStarLoginBtn), i18n("yostar_login_btn"))
	setText(arg0_4:findTF("Text", arg0_4.jpTransBtn), i18n("yostar_trans_btn"))
	setActive(arg0_4.jpYoStarLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0_4.jpTransBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0_4.twitterLoginBtn_en, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0_4.facebookLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3")
	setActive(arg0_4.yostarLoginBtn_en, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0_4.appleLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "1")
	setActive(arg0_4.amazonLoginBtn_en, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "3")
	arg0_4:InitEvent()
end

function var0_0.InitEvent(arg0_5)
	onButton(arg0_5, arg0_5.airiLoginBtn, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		pg.SdkMgr.GetInstance():YoStarLoginSDK()
	end)
	onButton(arg0_5, arg0_5.clearTranscodeBtn, function()
		return
	end)
	onButton(arg0_5, arg0_5.jpYoStarLoginBtn, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		pg.SdkMgr.GetInstance():YoStarLoginSDK()
	end)
	onButton(arg0_5, arg0_5.jpTransBtn, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		Application.OpenURL("https://migration.yostar.co.jp?pid=JP-AZURLANE")
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
	triggerButton(arg0_5.airiLoginBtn)
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
