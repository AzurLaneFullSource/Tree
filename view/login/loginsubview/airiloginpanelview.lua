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
	arg0_4.airiLoginBtn = arg0_4._tf:Find("airi_login")
	arg0_4.clearTranscodeBtn = arg0_4._tf:Find("clear_transcode")
	arg0_4.jpLoginCon = arg0_4._tf:Find("jp_login_btns")
	arg0_4.jpYoStarLoginBtn = arg0_4.jpLoginCon:Find("yostar_login")
	arg0_4.jpTransBtn = arg0_4.jpLoginCon:Find("yostar_trans")
	arg0_4.usLoginCon = arg0_4._tf:Find("en_login_btns")
	arg0_4.usYoStarLoginBtn = arg0_4.usLoginCon:Find("yostar_login")
	arg0_4.usTransBtn = arg0_4.usLoginCon:Find("yostar_trans")
	arg0_4.usLogOutBtn = arg0_4.usLoginCon:Find("yostar_logout")

	setActive(arg0_4.clearTranscodeBtn, false)
	setText(arg0_4.jpYoStarLoginBtn:Find("Text"), i18n("yostar_login_btn"))
	setText(arg0_4.jpTransBtn:Find("Text"), i18n("yostar_trans_btn"))
	setActive(arg0_4.jpYoStarLoginBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0_4.jpTransBtn, PLATFORM_CODE == PLATFORM_JP)
	setActive(arg0_4.usLoginCon, PLATFORM_CODE == PLATFORM_US)
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

	if PLATFORM_CODE == PLATFORM_JP then
		onButton(arg0_5, arg0_5.jpYoStarLoginBtn, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
			pg.SdkMgr.GetInstance():YoStarLoginSDK()
		end)
		onButton(arg0_5, arg0_5.jpTransBtn, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
			Application.OpenURL("https://migration.yostar.co.jp?pid=JP-AZURLANE")
		end)
	elseif PLATFORM_CODE == PLATFORM_US then
		onButton(arg0_5, arg0_5.usTransBtn, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
			Application.OpenURL("https://migration.yo-star.com/?pid=US-AZURLANE")
		end)
		onButton(arg0_5, arg0_5.usLogOutBtn, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
			pg.SdkMgr.GetInstance():YoStarShowSwitchAccount()
		end)
	end

	arg0_5:RefreshUI(false)
	triggerButton(arg0_5.airiLoginBtn)
end

function var0_0.RefreshUI(arg0_12, arg1_12)
	setActive(arg0_12.usLogOutBtn, arg1_12)
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
